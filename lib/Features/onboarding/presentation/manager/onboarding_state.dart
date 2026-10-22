enum OnboardingGender { male, female, notSpecified }
enum OnboardingSubmitStatus {
  initial,
  loading,
  success,
  failure,

  /// User picked 4 interests but has no account yet — UI must route to
  /// sign-up before anything can be persisted to the backend.
  needsAuth,
}

class OnboardingState {
  final int pageIndex;
  final OnboardingGender? gender;
  final int? ageIndex;
  final List<String> interests;
  final bool isCompleting;
  final OnboardingSubmitStatus submitStatus;
  final String? submitErrorMessage;
  final bool isRecovery;
  final bool recoveryNeedsAge;
  final bool recoveryNeedsInterests;
  final bool isHydrating;
  final bool profileHydrated;
  final String? hydrateErrorMessage;

  const OnboardingState({
    this.pageIndex = 0,
    this.gender,
    this.ageIndex,
    this.interests = const [],
    this.isCompleting = false,
    this.submitStatus = OnboardingSubmitStatus.initial,
    this.submitErrorMessage,
    this.isRecovery = false,
    this.recoveryNeedsAge = false,
    this.recoveryNeedsInterests = false,
    this.isHydrating = false,
    this.profileHydrated = false,
    this.hydrateErrorMessage,
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
    bool? isRecovery,
    bool? recoveryNeedsAge,
    bool? recoveryNeedsInterests,
    bool? isHydrating,
    bool? profileHydrated,
    String? hydrateErrorMessage,
    bool clearHydrateErrorMessage = false,
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
      isRecovery: isRecovery ?? this.isRecovery,
      recoveryNeedsAge: recoveryNeedsAge ?? this.recoveryNeedsAge,
      recoveryNeedsInterests:
          recoveryNeedsInterests ?? this.recoveryNeedsInterests,
      isHydrating: isHydrating ?? this.isHydrating,
      profileHydrated: profileHydrated ?? this.profileHydrated,
      hydrateErrorMessage: clearHydrateErrorMessage
          ? null
          : (hydrateErrorMessage ?? this.hydrateErrorMessage),
    );
  }
}

