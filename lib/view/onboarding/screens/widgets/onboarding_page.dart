// import 'package:adv/core/exports/ui_exports.dart';
// import 'package:adv/view/onboarding/controller/onboarding_controller.dart';
// import 'package:adv/view/onboarding/screens/widgets/custom_onboarding_background.dart';
//
// class OnboardingPage extends StatelessWidget {
//   final String image;
//   final String title;
//   final String circlePosition;
//   final String circleImage;
//   final void Function() onTapNext;
//   final void Function() onTapSkip;
//   const OnboardingPage({
//     super.key,
//     required this.image,
//     required this.title,
//     this.circlePosition = 'left',
//     required this.circleImage,
//     required this.onTapNext,
//     required this.onTapSkip,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomOnboardingBackground(
//       leftCircleImage: circlePosition == 'left' ? circleImage : null,
//       rightCircleImage: circlePosition == 'right' ? circleImage : null,
//       child: SingleChildScrollView(
//         physics: BouncingScrollPhysics(),
//         child: GetBuilder(
//             init: OnboardingController(),
//             builder: (controller) {
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(height: 91.h),
//                   ClipOval(
//                     child: Image.asset(
//                       image,
//                       width: 336.w,
//                       height: 336.h,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   SizedBox(height: 50.h),
//                   Text(
//                     title,
//                     style: AppTextStyles.headline(context),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 16.h),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 24.w),
//                     child: Text(
//                       "  ",
//                       style:
//                           AppTextStyles.subtitle(context).copyWith(height: 1.6),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   SizedBox(height: 40.h),
//                   AppButton(
//                     borderRadius: 10.r,
//                     buttonText: "getStarted",
//                     buttonHeight: 54.h,
//                     buttonWidth: 295.w,
//                     textStyle: AppTextStyles.headline(context),
//                     onTap: onTapNext,
//                   ),
//                   SizedBox(height: 16.h),
//                   TextButton(
//                       onPressed: onTapSkip,
//                       child: Text(
//                         "skip",
//                         style: AppTextStyles.subtitle(context)
//                             .copyWith(color: AppColor.darkGreyColor),
//                       )),
//                   SizedBox(height: 24.h),
//                 ],
//               );
//             }),
//       ),
//     );
//   }
// }
