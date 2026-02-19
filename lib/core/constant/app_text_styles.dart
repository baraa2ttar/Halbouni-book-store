import 'package:adv/core/constant/app_colors.dart';
import 'package:adv/core/extensions/size_extensions.dart';
import 'package:flutter/material.dart';

import 'app_constants.dart';

class AppTextStyles {
  static TextStyle headline(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w500,
      color: AppColor.titleColor,
      fontSize: context.sp(28));

  static TextStyle subtitle(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w400,
      color: AppColor.darkGreyColor,
      fontSize: context.sp(14));



  static TextStyle hintText(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w300,
      color: AppColor.darkGreyColor,
      fontSize: context.sp(16));

  static TextStyle titleText(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w500,
      height: 1.8,
      color: AppColor.blackColor,
      fontSize: context.sp(18));


  static TextStyle headlineSize12(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w500,
      color: AppColor.darkGreyColor,
      fontSize: context.sp(12));
  static TextStyle headlineSize12ColorWh(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w500,
      color: AppColor.whiteColor,
      fontSize: context.sp(12));

  static TextStyle headlineAppColor(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w500,
      color: AppColor.blackColor,
      fontSize: context.sp(18));

  static TextStyle subtitleS12(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w400,
      color: AppColor.darkGreyColor,
      fontSize: context.sp(12));

  static TextStyle subtitleS20(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w400,
      color: AppColor.darkGreyColor,
      fontFamily: kGtSectraFine,
      fontSize: context.sp(20));


  static TextStyle CardTitle(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w500,
      color: AppColor.darkGreyColor,
      fontSize: context.sp(14));

//////////////////////////////////

  static const textStyle20 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.normal,
    fontFamily: kGtSectraFine
  );
  static const textStyle30 = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w900,
    fontFamily: kGtSectraFine,
    letterSpacing: 1.2,
  );
  static const textStyle14 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static const textStyle16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static const textStyle18 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );


}
