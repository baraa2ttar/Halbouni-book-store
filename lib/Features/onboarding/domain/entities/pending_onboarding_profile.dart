class PendingOnboardingProfile {
  const PendingOnboardingProfile({
    this.interests = const [],
    this.gender,
    this.ageRange,
    this.ageIndex,
  });

  final List<String> interests;
  final String? gender;
  final String? ageRange;
  final int? ageIndex;

  bool get hasData =>
      interests.isNotEmpty || gender != null || ageRange != null;
}
