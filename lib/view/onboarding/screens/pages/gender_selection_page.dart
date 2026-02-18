// import 'package:flutter/material.dart';
// import 'package:adv/core/exports/ui_exports.dart';
// import 'package:adv/view/onboarding/controller/onboarding_controller.dart';
// import 'package:adv/view/onboarding/screens/widgets/card_googl.dart';
//
// class GenderSelectionPage extends StatelessWidget {
//   final OnboardingController controller;
//
//   const GenderSelectionPage({super.key, required this.controller});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: Container(
//           width: 180,
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(25),
//             child: LinearProgressIndicator(
//               value: 0.25, // Progress value (0.0 to 1.0) - 2nd page out of 4
//               minHeight: 8.0,
//               backgroundColor: Colors.grey[300],
//               valueColor: AlwaysStoppedAnimation<Color>(AppColor.primaryColor),
//             ),
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Header Section
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "What's your gender?",
//                   style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.grey[800],
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   "This helps us personalize your experience",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w400,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//
//             SizedBox(height: 40),
//
//             // Gender Options
//             Expanded(
//               child: Column(
//                 children: [
//                   _buildGenderCard(
//                     controller: controller,
//                     gender: Gender.male,
//                     title: "Male",
//                     subtitle: "I am male",
//                     icon: Icons.person,
//                   ),
//
//                   SizedBox(height: 16),
//
//                   _buildGenderCard(
//                     controller: controller,
//                     gender: Gender.female,
//                     title: "Female",
//                     subtitle: "I am female",
//                     icon: Icons.person_outline,
//                   ),
//
//                   SizedBox(height: 16),
//
//                   _buildGenderCard(
//                     controller: controller,
//                     gender: Gender.notSpecified,
//                     title: "Prefer not to say",
//                     subtitle: "Skip this question",
//                     icon: Icons.help_outline,
//                   ),
//                 ],
//               ),
//             ),
//
//             // Continue Button
//             CardGoogle(
//               label: "Continue",
//               backGroundColor: AppColor.primaryColor,
//               onTap: controller.navigateToNextPage,
//             ),
//             SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGenderCard({
//     required OnboardingController controller,
//     required Gender gender,
//     required String title,
//     required String subtitle,
//     required IconData icon,
//   }) {
//     final isSelected = controller.selectedGender == gender;
//
//     return GestureDetector(
//       onTap: () => controller.setGender(gender),
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 200),
//         padding: EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color:
//               isSelected
//                   ? AppColor.primaryColor.withOpacity(0.1)
//                   : Colors.white,
//           border: Border.all(
//             color: isSelected ? AppColor.primaryColor : Colors.grey[300]!,
//             width: isSelected ? 2.0 : 1.0,
//           ),
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 1,
//               blurRadius: 8,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             // Icon Container
//             Container(
//               width: 50,
//               height: 50,
//               decoration: BoxDecoration(
//                 color: isSelected ? AppColor.primaryColor : Colors.grey[100],
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(
//                 icon,
//                 color: isSelected ? Colors.white : Colors.grey[600],
//                 size: 24,
//               ),
//             ),
//
//             SizedBox(width: 16),
//
//             // Text Content
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                       color:
//                           isSelected ? AppColor.primaryColor : Colors.grey[800],
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     subtitle,
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w400,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // Selection Indicator
//             Container(
//               width: 24,
//               height: 24,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: isSelected ? AppColor.primaryColor : Colors.grey[400]!,
//                   width: 2,
//                 ),
//                 color: isSelected ? AppColor.primaryColor : Colors.transparent,
//               ),
//               child:
//                   isSelected
//                       ? Icon(Icons.check, color: Colors.white, size: 16)
//                       : null,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
