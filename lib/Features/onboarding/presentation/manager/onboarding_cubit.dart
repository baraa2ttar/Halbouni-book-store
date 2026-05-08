import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repos/onboarding_repo.dart';
import '../../domain/use_cases/complete_onboarding_use_case.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final CompleteOnboardingUseCase _completeOnboarding;
  final OnboardingRepo _onboardingRepo;
  OnboardingCubit(this._completeOnboarding, this._onboardingRepo)
      : super(const OnboardingState());

  void setPageIndex(int index) => emit(state.copyWith(pageIndex: index));

  void setGender(OnboardingGender gender) => emit(state.copyWith(gender: gender));

  void setAgeIndex(int index) => emit(state.copyWith(ageIndex: index));

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
    emit(
      state.copyWith(
        submitStatus: OnboardingSubmitStatus.loading,
        clearSubmitErrorMessage: true,
      ),
    );
    final result =
        await _onboardingRepo.updateUserInterests(interests: state.interests);
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
}

