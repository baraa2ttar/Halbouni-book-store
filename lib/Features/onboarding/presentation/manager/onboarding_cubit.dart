import 'package:adv/Features/profile/domain/repos/profile_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repos/onboarding_repo.dart';
import '../../domain/use_cases/complete_onboarding_use_case.dart';
import '../views/pages/age_selection_page.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final CompleteOnboardingUseCase _completeOnboarding;
  final OnboardingRepo _onboardingRepo;
  final ProfileRepo? _profileRepo;

  OnboardingCubit(
    this._completeOnboarding,
    this._onboardingRepo, {
    ProfileRepo? profileRepo,
    bool isRecovery = false,
    bool recoveryNeedsAge = false,
    bool recoveryNeedsInterests = false,
  })  : _profileRepo = profileRepo,
        super(
          OnboardingState(
            isRecovery: isRecovery,
            recoveryNeedsAge: recoveryNeedsAge,
            recoveryNeedsInterests: recoveryNeedsInterests,
          ),
        );

  Future<void> initialize() async {
    if (state.isRecovery) {
      await hydrateFromProfile();
    } else {
      await restoreDraft();
    }
  }

  Future<void> restoreDraft() async {
    final pending = await _onboardingRepo.loadPendingProfile();
    if (isClosed) return;
    emit(
      state.copyWith(
        interests: pending.interests,
        gender: _genderFromString(pending.gender),
        ageIndex: pending.ageIndex,
      ),
    );
  }

  Future<void> hydrateFromProfile() async {
    final profileRepo = _profileRepo;
    if (profileRepo == null) {
      emit(
        state.copyWith(
          isHydrating: false,
          profileHydrated: false,
          hydrateErrorMessage: 'Profile is not available.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isHydrating: true,
        clearHydrateErrorMessage: true,
      ),
    );
    final result = await profileRepo.fetchProfile();
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          isHydrating: false,
          profileHydrated: false,
          hydrateErrorMessage: failure.message,
        ),
      ),
      (profile) {
        final ageIndex = profile.ageRange == null
            ? null
            : AgeSelectionPage.ageRanges.indexOf(profile.ageRange!);
        final parsedAgeIndex =
            (ageIndex != null && ageIndex >= 0) ? ageIndex : null;
        final parsedGender = _genderFromString(profile.gender);
        emit(
          state.copyWith(
            isHydrating: false,
            profileHydrated: true,
            clearHydrateErrorMessage: true,
            interests: profile.interests,
            gender: parsedGender,
            clearGender: parsedGender == null,
            ageIndex: parsedAgeIndex,
            clearAgeIndex: parsedAgeIndex == null,
          ),
        );
      },
    );
  }

  void setPageIndex(int index) => emit(state.copyWith(pageIndex: index));

  void setGender(OnboardingGender gender) {
    emit(state.copyWith(gender: gender));
    _onboardingRepo.savePendingDraft(gender: _genderToString(gender));
  }

  void setAgeIndex(int index) {
    emit(state.copyWith(ageIndex: index));
    _onboardingRepo.savePendingDraft(
      ageIndex: index,
      ageRange: _ageRangeFromIndex(index),
    );
  }

  void toggleInterest(String interest) {
    if (state.submitStatus == OnboardingSubmitStatus.loading) return;
    final next = List<String>.from(state.interests);
    if (next.contains(interest)) {
      next.remove(interest);
    } else {
      if (next.length >= 4) return;
      next.add(interest);
    }
    emit(
      state.copyWith(
        interests: next,
        submitStatus: OnboardingSubmitStatus.initial,
        clearSubmitErrorMessage: true,
      ),
    );
    _onboardingRepo.savePendingDraft(interests: next);
  }

  bool get canContinueFromInterests => state.interests.length == 4;

  Future<void> submitInterests() async {
    if (state.submitStatus == OnboardingSubmitStatus.loading) return;
    if (state.isRecovery && !state.profileHydrated) {
      emit(
        state.copyWith(
          submitStatus: OnboardingSubmitStatus.failure,
          submitErrorMessage:
              'Could not load your profile. Go back and try again.',
        ),
      );
      return;
    }

    if (state.interests.length != 4) {
      emit(
        state.copyWith(
          submitStatus: OnboardingSubmitStatus.failure,
          submitErrorMessage: 'Please select exactly 4 interests.',
        ),
      );
      return;
    }

    // Interests/gender/age are already persisted locally as a draft via
    // toggleInterest/setGender/setAgeIndex as the user made each choice.
    // There's no account yet, so there's nowhere to send them — send the
    // user to sign up instead of silently "completing" onboarding as a
    // guest with data that never reaches the backend.
    if (!_onboardingRepo.isSignedIn) {
      emit(
        state.copyWith(
          submitStatus: OnboardingSubmitStatus.needsAuth,
          clearSubmitErrorMessage: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        submitStatus: OnboardingSubmitStatus.loading,
        clearSubmitErrorMessage: true,
      ),
    );
    final result = await _onboardingRepo.saveUserProfile(
      interests: state.interests,
      gender: _genderToString(state.gender),
      ageRange: _ageRangeFromIndex(state.ageIndex),
    );
    await result.fold(
      (failure) async {
        emit(
          state.copyWith(
            submitStatus: OnboardingSubmitStatus.failure,
            submitErrorMessage: failure.message,
          ),
        );
      },
      (_) async {
        await complete();
        emit(
          state.copyWith(
            submitStatus: OnboardingSubmitStatus.success,
            clearSubmitErrorMessage: true,
          ),
        );
      },
    );
  }

  Future<void> complete() async {
    if (state.isCompleting) return;
    emit(state.copyWith(isCompleting: true));
    try {
      await _completeOnboarding();
    } finally {
      emit(state.copyWith(isCompleting: false));
    }
  }

  String? _genderToString(OnboardingGender? gender) {
    return switch (gender) {
      OnboardingGender.male => 'male',
      OnboardingGender.female => 'female',
      OnboardingGender.notSpecified => 'not_specified',
      null => null,
    };
  }

  OnboardingGender? _genderFromString(String? value) {
    return switch (value) {
      'male' => OnboardingGender.male,
      'female' => OnboardingGender.female,
      'not_specified' => OnboardingGender.notSpecified,
      _ => null,
    };
  }

  String? _ageRangeFromIndex(int? index) {
    if (index == null) return null;
    if (index < 0 || index >= AgeSelectionPage.ageRanges.length) return null;
    return AgeSelectionPage.ageRanges[index];
  }
}
