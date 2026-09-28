import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repos/onboarding_repo.dart';
import '../../domain/use_cases/complete_onboarding_use_case.dart';
import '../views/pages/age_selection_page.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final CompleteOnboardingUseCase _completeOnboarding;
  final OnboardingRepo _onboardingRepo;
  OnboardingCubit(this._completeOnboarding, this._onboardingRepo)
      : super(const OnboardingState());

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
