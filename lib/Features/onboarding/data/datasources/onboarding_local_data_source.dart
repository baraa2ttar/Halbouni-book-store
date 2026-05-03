import 'package:shared_preferences/shared_preferences.dart';

class OnboardingLocalDataSource {
  static const _completedKey = 'onboarding_completed';

  Future<bool> isCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_completedKey) ?? false;
  }

  Future<void> setCompleted(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_completedKey, value);
  }
}

