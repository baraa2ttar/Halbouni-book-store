// import 'package:adv/core/exports/ui_exports.dart';
//
// class AppGeneralInfo extends StatelessWidget {
//   final String? appTopBarText;
//   final String? title;
//   final String? subTitle;
//   final String? iconPath;
//   final String? buttonText;
//   final VoidCallback? onTap;
//   final double? iconWidth;
//   final bool showButton;
//   final bool showTopBar;
//   final bool showSubtitle;
//   final double? buttonHeight;
//
//   const AppGeneralInfo({
//     super.key,
//     this.appTopBarText,
//     this.title,
//     this.subTitle,
//     this.iconPath,
//     this.buttonText,
//     this.onTap,
//     this.iconWidth,
//     this.buttonHeight,
//     this.showButton = true,
//     this.showTopBar = true,
//     this.showSubtitle = true,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         if (showTopBar)
//           AppTopBar(appBarText: appTopBarText ?? "Patient Details"),
//         SizedBox(height: context.h(120)),
//         Container(
//           padding: EdgeInsets.all(50.sp),
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: AppColor.emptyContainerColor,
//           ),
//           child: Center(
//             child: SvgPicture.asset(iconPath ?? AppAssets.fileIcon,
//                 width: iconWidth),
//           ),
//         ),
//         SizedBox(height: context.h(30)),
//         Text(
//           title ?? AppStrings.emptyDetails,
//           style: AppTextStyles.headline(context).copyWith(
//             fontSize: 18.sp,
//           ),
//           textAlign: TextAlign.center,
//         ),
//         SizedBox(height: context.h(10)),
//         if (showSubtitle) ...[
//           Text(
//             subTitle ?? AppStrings.emptyDetails,
//             style: AppTextStyles.subtitle(context).copyWith(),
//             textAlign: TextAlign.center,
//           )
//         ],
//         if (showButton) ...[
//           SizedBox(height: context.h(30)),
//           AppButton(
//             buttonWidth: context.w(270),
//             buttonHeight: buttonHeight ?? context.h(54),
//             buttonText: buttonText ?? "Add Tests",
//             textStyle: AppTextStyles.buttonText(context).copyWith(
//               fontSize: context.sp(18),
//             ),
//             borderRadius: 6.r,
//             onTap: onTap ?? () => Get.toNamed(Routes.patientDetails),
//           ),
//         ],
//       ],
//     );
//   }
// }
