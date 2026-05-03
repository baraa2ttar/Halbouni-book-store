enum OnboardingGender { male, female, notSpecified }

class OnboardingState {
  final int pageIndex;
  final OnboardingGender? gender;
  final int? ageIndex;
  final List<String> interests;
  final bool isCompleting;

  const OnboardingState({
    this.pageIndex = 0,
    this.gender,
    this.ageIndex,
    this.interests = const [],
    this.isCompleting = false,
  });

  OnboardingState copyWith({
    int? pageIndex,
    OnboardingGender? gender,
    bool clearGender = false,
    int? ageIndex,
    bool clearAgeIndex = false,
    List<String>? interests,
    bool? isCompleting,
  }) {
    return OnboardingState(
      pageIndex: pageIndex ?? this.pageIndex,
      gender: clearGender ? null : (gender ?? this.gender),
      ageIndex: clearAgeIndex ? null : (ageIndex ?? this.ageIndex),
      interests: interests ?? this.interests,
      isCompleting: isCompleting ?? this.isCompleting,
    );
  }
}

