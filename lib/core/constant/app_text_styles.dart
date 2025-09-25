import 'package:adv/core/constant/app_colors.dart';
import 'package:adv/core/extensions/size_extensions.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle headline(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w500,
      color: AppColor.titleColor,
      fontSize: context.sp(28));

  static TextStyle subtitle(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w400,
      color: AppColor.darkGreyColor,
      fontSize: context.sp(14));

  static TextStyle doctorNameText(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w500,
      color: AppColor.titleColor,
      fontSize: context.sp(18));

  static TextStyle nameText(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w500,
      color: AppColor.whiteColor,
      fontSize: context.sp(16));

  static TextStyle greenText(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w400,
      color: AppColor.primaryColor,
      fontSize: context.sp(14));

  static TextStyle buttonText(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w500,
      color: AppColor.whiteColor,
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

  static TextStyle diagnosticsSection(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w400,
      height: 1.5,
      color: AppColor.blackColor,
      fontSize: context.sp(15));
  static TextStyle title(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w400,
      color: AppColor.darkGreyColor,
      fontSize: context.sp(16));

  static TextStyle headline24(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w500,
      color: AppColor.titleColor,
      fontSize: context.sp(24));

  static TextStyle headlineSize12(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w500,
      color: AppColor.darkGreyColor,
      fontSize: context.sp(12));
  static TextStyle headlineSize12ColorWh(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w500,
      color: AppColor.whiteColor,
      fontSize: context.sp(12));
  static TextStyle subtitleS12(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w400,
      color: AppColor.darkGreyColor,
      fontSize: context.sp(12));
  static TextStyle hintTextSize11(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w300,
      color: AppColor.darkGreyColor,
      fontSize: context.sp(11));
  static TextStyle hintTextSize12(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w300,
      color: AppColor.darkGreyColor,
      fontSize: context.sp(12));

  static TextStyle subtitleS12ColorWhite(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w400,
      color: AppColor.whiteColor,
      fontSize: context.sp(12));

  static TextStyle NameText(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w700,
      color: AppColor.titleColor,
      fontSize: context.sp(22));
  static TextStyle greenText700(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w700,
      color: AppColor.primaryColor,
      fontSize: context.sp(26));
  static TextStyle subtitleColorWSize16(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w400,
      color: AppColor.whiteColor,
      fontSize: context.sp(16));
  static TextStyle headlineSize20ColorWh(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w500,
      color: AppColor.whiteColor,
      fontSize: context.sp(20));

  static TextStyle CardTitle(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w500,
      color: AppColor.darkGreyColor,
      fontSize: context.sp(14));
  //ammar
  static TextStyle ListTitleStyle(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w300,
      color: AppColor.darkGreyColor,
      fontSize: context.sp(18));
  //ammar
  static TextStyle commentsnameStyle(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w400,
      color: AppColor.whiteColor,
      fontSize: context.sp(18));
  //ammar
  static TextStyle commentstyle(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w400,
      color: AppColor.whiteColor,
      fontSize: context.sp(14));
}
