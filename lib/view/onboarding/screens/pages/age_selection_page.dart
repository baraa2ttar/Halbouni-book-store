// import 'package:flutter/material.dart';
// import 'package:adv/core/exports/ui_exports.dart';
// import 'package:adv/view/onboarding/controller/onboarding_controller.dart';
// import 'package:adv/view/onboarding/screens/widgets/card_googl.dart';
//
// class AgeSelectionPage extends StatelessWidget {
//   final OnboardingController controller;
//
//   const AgeSelectionPage({super.key, required this.controller});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         title: Container(
//           width: 180,
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(25),
//             child: LinearProgressIndicator(
//               value: 0.375, // Progress value (0.0 to 1.0) - 3rd page out of 4
//               minHeight: 8.0,
//               backgroundColor: Colors.grey[300],
//               valueColor: AlwaysStoppedAnimation<Color>(AppColor.primaryColor),
//             ),
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "choose your Age ",
//                   maxLines: 1,
//                   style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
//                 ),
//                 const Text(
//                   "This helps us recommend age-appropriate content",
//                   style: TextStyle(fontWeight: FontWeight.w400),
//                 ),
//                 const SizedBox(height: 20),
//                 Wrap(
//                   spacing: 8.0,
//                   runSpacing: 8.0,
//                   children: List.generate(controller.ageRanges.length, (index) {
//                     final isSelected = controller.selectedAgeIndex == index;
//                     return GestureDetector(
//                       onTap: () => controller.setAge(index),
//                       child: Container(
//                         width: 180,
//                         height: 50,
//                         decoration: BoxDecoration(
//                           color:
//                               isSelected ? AppColor.primaryColor : Colors.white,
//                           border: Border.all(
//                             color: AppColor.primaryColor,
//                             width: 1.0,
//                           ),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Center(
//                           child: Text(
//                             controller.ageRanges[index],
//                             style: TextStyle(
//                               color:
//                                   isSelected
//                                       ? Colors.white
//                                       : AppColor.primaryColor,
//                               fontWeight: FontWeight.w500,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   }),
//                 ),
//               ],
//             ),
//           ),
//           const Spacer(),
//
//           CardGoogle(
//             label: "continue",
//             backGroundColor: AppColor.primaryColor,
//             onTap: controller.navigateToNextPage,
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }
