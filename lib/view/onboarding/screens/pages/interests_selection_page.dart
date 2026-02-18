// import 'package:flutter/material.dart';
// import 'package:adv/core/exports/ui_exports.dart';
// import 'package:adv/view/onboarding/controller/onboarding_controller.dart';
// import 'package:adv/view/onboarding/screens/widgets/card_googl.dart';
// import 'package:adv/models/genre.dart';
//
// class InterestsSelectionPage extends StatelessWidget {
//   final OnboardingController controller;
//
//   const InterestsSelectionPage({super.key, required this.controller});
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
//               value: 1.0, // Progress value (0.0 to 1.0) - 4th page out of 4
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
//                   "What are your interests?",
//                   style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.grey[800],
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   "Select up to 4 categories to personalize your book recommendations",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w400,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 GetBuilder<OnboardingController>(
//                   builder:
//                       (controller) => Text(
//                         "${controller.selectedInterests.length}/4 selected",
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                           color:
//                               controller.selectedInterests.length == 4
//                                   ? AppColor.primaryColor
//                                   : Colors.grey[600],
//                         ),
//                       ),
//                 ),
//               ],
//             ),
//
//             SizedBox(height: 30),
//
//             // Interests Grid
//             Expanded(
//               child: GetBuilder<OnboardingController>(
//                 builder:
//                     (controller) => GridView.builder(
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         crossAxisSpacing: 12,
//                         mainAxisSpacing: 12,
//                         childAspectRatio: 2.5,
//                       ),
//                       itemCount: controller.bookGenres.length,
//                       itemBuilder: (context, index) {
//                         final genre = controller.bookGenres[index];
//                         final isSelected = controller.selectedInterests
//                             .contains(genre);
//                         final canSelect =
//                             controller.selectedInterests.length < 4 ||
//                             isSelected;
//
//                         return _buildInterestCard(
//                           controller: controller,
//                           genre: genre,
//                           isSelected: isSelected,
//                           canSelect: canSelect,
//                         );
//                       },
//                     ),
//               ),
//             ),
//
//             SizedBox(height: 20),
//
//             // Continue Button
//             GetBuilder<OnboardingController>(
//               builder:
//                   (controller) => CardGoogle(
//                     label: "Continue",
//                     backGroundColor:
//                         controller.canContinue
//                             ? AppColor.primaryColor
//                             : Colors.grey[400]!,
//                     onTap:
//                         controller.canContinue
//                             ? controller.navigateToNextPage
//                             : null,
//                   ),
//             ),
//             SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInterestCard({
//     required OnboardingController controller,
//     required Genre genre,
//     required bool isSelected,
//     required bool canSelect,
//   }) {
//     return GestureDetector(
//       onTap: canSelect ? () => controller.toggleInterest(genre) : null,
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 200),
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         decoration: BoxDecoration(
//           color:
//               isSelected
//                   ? AppColor.primaryColor.withOpacity(0.1)
//                   : Colors.white,
//           border: Border.all(
//             color:
//                 isSelected
//                     ? AppColor.primaryColor
//                     : (canSelect ? Colors.grey[300]! : Colors.grey[200]!),
//             width: isSelected ? 2.0 : 1.0,
//           ),
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 1,
//               blurRadius: 4,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Genre Icon
//             Container(
//               width: 24,
//               height: 24,
//               decoration: BoxDecoration(
//                 color: isSelected ? AppColor.primaryColor : Colors.grey[100],
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: Icon(
//                 genre.icon,
//                 color: isSelected ? Colors.white : Colors.grey[600],
//                 size: 14,
//               ),
//             ),
//
//             SizedBox(width: 8),
//
//             // Genre Name
//             Expanded(
//               child: Text(
//                 genre.name,
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color:
//                       isSelected
//                           ? AppColor.primaryColor
//                           : (canSelect ? Colors.grey[800] : Colors.grey[400]),
//                 ),
//                 textAlign: TextAlign.center,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//
//             // Selection Indicator
//             if (isSelected)
//               Container(
//                 width: 16,
//                 height: 16,
//                 decoration: BoxDecoration(
//                   color: AppColor.primaryColor,
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(Icons.check, color: Colors.white, size: 10),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
