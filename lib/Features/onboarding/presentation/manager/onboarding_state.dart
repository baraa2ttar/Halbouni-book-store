enum OnboardingGender { male, female, notSpecified }
enum OnboardingSubmitStatus { initial, loading, success, failure }

class OnboardingState {
  final int pageIndex;
  final OnboardingGender? gender;
  final int? ageIndex;
  final List<String> interests;
  final bool isCompleting;
  final OnboardingSubmitStatus submitStatus;
  final String? submitErrorMessage;

  const OnboardingState({
    this.pageIndex = 0,
    this.gender,
    this.ageIndex,
    this.interests = const [],
    this.isCompleting = false,
    this.submitStatus = OnboardingSubmitStatus.initial,
    this.submitErrorMessage,
  });

  OnboardingState copyWith({
    int? pageIndex,
    OnboardingGender? gender,
    bool clearGender = false,
    int? ageIndex,
    bool clearAgeIndex = false,
    List<String>? interests,
    bool? isCompleting,
    OnboardingSubmitStatus? submitStatus,
    String? submitErrorMessage,
    bool clearSubmitErrorMessage = false,
  }) {
    return OnboardingState(
      pageIndex: pageIndex ?? this.pageIndex,
      gender: clearGender ? null : (gender ?? this.gender),
      ageIndex: clearAgeIndex ? null : (ageIndex ?? this.ageIndex),
      interests: interests ?? this.interests,
      isCompleting: isCompleting ?? this.isCompleting,
      submitStatus: submitStatus ?? this.submitStatus,
      submitErrorMessage: clearSubmitErrorMessage
          ? null
          : (submitErrorMessage ?? this.submitErrorMessage),
    );
  }
}

