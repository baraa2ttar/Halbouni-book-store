// import 'package:adv/core/exports/main_exports.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/material.dart';
// import '../../../models/genre.dart';
//
// enum Gender { male, female, notSpecified }
//
// class OnboardingController extends GetxController {
//   final PageController pageController = PageController();
//   static const String _genderPrefKey = 'selected_gender';
//
//   Gender? selectedGender;
//   int? selectedAgeIndex;
//   static const String _agePrefKey = 'selected_age';
//
//   List<Genre> selectedInterests = [];
//   static const String _interestsPrefKey = 'selected_interests';
//
//   final ageRanges = [
//     '18 - 24',
//     '25 - 29',
//     '30 - 34',
//     '35 - 39',
//     '40 - 44',
//     '45 - 49',
//     '50 - 54',
//     '55+',
//   ];
//   final List<Genre> bookGenres = [
//     Genre(name: "Romance", icon: Icons.favorite),
//     Genre(name: "Fantasy", icon: Icons.auto_awesome),
//     Genre(name: "Sci-Fi", icon: Icons.rocket_launch),
//     Genre(name: "Horror", icon: Icons.psychology),
//     Genre(name: "Thriller", icon: Icons.movie),
//     Genre(name: "Comedy", icon: Icons.sentiment_very_satisfied),
//     Genre(name: "Action", icon: Icons.flash_on),
//     Genre(name: "Food", icon: Icons.restaurant),
//     Genre(name: "Adventure", icon: Icons.explore),
//     Genre(name: "Psychology", icon: Icons.psychology),
//     Genre(name: "Biography", icon: Icons.person),
//     Genre(name: "Travel", icon: Icons.public),
//     Genre(name: "Children's", icon: Icons.child_care),
//   ];
//
//   @override
//   void onInit() {
//     super.onInit();
//     _loadSavedGender();
//     _loadSavedAge();
//     _loadSavedInterests();
//   }
//
//   Future<void> _loadSavedGender() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final String? saved = prefs.getString(_genderPrefKey);
//     if (saved != null) {
//       switch (saved) {
//         case 'male':
//           selectedGender = Gender.male;
//           break;
//         case 'female':
//           selectedGender = Gender.female;
//           break;
//         case 'notSpecified':
//           selectedGender = Gender.notSpecified;
//           break;
//       }
//       update();
//     }
//   }
//
//   Future<void> _loadSavedAge() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final int? saved = prefs.getInt(_agePrefKey);
//     if (saved != null && saved < ageRanges.length) {
//       selectedAgeIndex = saved;
//       update();
//     }
//   }
//
//   Future<void> _loadSavedInterests() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final List<String>? saved = prefs.getStringList(_interestsPrefKey);
//     if (saved != null) {
//       selectedInterests =
//           saved
//               .map(
//                 (name) => bookGenres.firstWhere((genre) => genre.name == name),
//               )
//               .toList();
//       update();
//     }
//   }
//
//   Future<void> setGender(Gender gender) async {
//     selectedGender = gender;
//     update();
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_genderPrefKey, gender.name);
//   }
//
//   Future<void> setAge(int ageIndex) async {
//     selectedAgeIndex = ageIndex;
//     update();
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setInt(_agePrefKey, ageIndex);
//   }
//
//   void toggleInterest(Genre interest) {
//     if (selectedInterests.contains(interest)) {
//       selectedInterests.remove(interest);
//     } else if (selectedInterests.length < 4) {
//       selectedInterests.add(interest);
//     }
//     update();
//     _saveInterests();
//   }
//
//   Future<void> _saveInterests() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setStringList(
//       _interestsPrefKey,
//       selectedInterests.map((genre) => genre.name).toList(),
//     );
//   }
//
//   bool get canContinue => selectedInterests.length == 4;
//
//   navigateToNextPage() {
//     final double? current = pageController.page;
//     if (current != null) {
//       final int currentIndex = current.round();
//       if (currentIndex >= 3) {
//         Get.offAllNamed(Routes.signUp);
//         return;
//       }
//     }
//     pageController.nextPage(
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }
//
//   skipOnboarding() {
//     Get.offAllNamed(Routes.signUp);
//   }
// }
