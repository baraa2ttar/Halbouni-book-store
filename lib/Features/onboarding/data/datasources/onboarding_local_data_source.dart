import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/pending_onboarding_profile.dart';

class OnboardingLocalDataSource {
  static const _completedKey = 'onboarding_completed';
  static const _interestsKey = 'onboarding_pending_interests';
  static const _genderKey = 'onboarding_pending_gender';
  static const _ageRangeKey = 'onboarding_pending_age_range';
  static const _ageIndexKey = 'onboarding_pending_age_index';

  Future<bool> isCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_completedKey) ?? false;
  }

  Future<void> setCompleted(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_completedKey, value);
  }

  Future<void> savePendingProfile({
    List<String>? interests,
    String? gender,
    String? ageRange,
    int? ageIndex,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (interests != null) {
      await prefs.setStringList(_interestsKey, interests);
    }
    if (gender != null) {
      await prefs.setString(_genderKey, gender);
    }
    if (ageRange != null) {
      await prefs.setString(_ageRangeKey, ageRange);
    }
    if (ageIndex != null) {
      await prefs.setInt(_ageIndexKey, ageIndex);
    }
  }

  Future<PendingOnboardingProfile> loadPendingProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return PendingOnboardingProfile(
      interests: prefs.getStringList(_interestsKey) ?? const [],
      gender: prefs.getString(_genderKey),
      ageRange: prefs.getString(_ageRangeKey),
      ageIndex: prefs.getInt(_ageIndexKey),
    );
  }

  Future<void> clearPendingProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_interestsKey);
    await prefs.remove(_genderKey);
    await prefs.remove(_ageRangeKey);
    await prefs.remove(_ageIndexKey);
  }
}
