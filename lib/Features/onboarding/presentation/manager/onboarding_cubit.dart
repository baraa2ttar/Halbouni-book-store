import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/complete_onboarding_use_case.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final CompleteOnboardingUseCase _completeOnboarding;
  OnboardingCubit(this._completeOnboarding) : super(const OnboardingState());

  void setPageIndex(int index) => emit(state.copyWith(pageIndex: index));

  void setGender(OnboardingGender gender) => emit(state.copyWith(gender: gender));

  void setAgeIndex(int index) => emit(state.copyWith(ageIndex: index));

  void toggleInterest(String interest) {
    final next = List<String>.from(state.interests);
    if (next.contains(interest)) {
      next.remove(interest);
    } else {
      if (next.length >= 4) return;
      next.add(interest);
    }
    emit(state.copyWith(interests: next));
  }

  bool get canContinueFromInterests => state.interests.length == 4;

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

