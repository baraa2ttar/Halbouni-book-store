import 'package:adv/core/constant/app_sizes.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter/material.dart';

extension SizeExtensions on BuildContext {

  double w(double width) => (width / AppSize.designSize.width) * MediaQuery.of(this).size.width;
  double h(double height) => (height / AppSize.designSize.height) * MediaQuery.of(this).size.height;

  double sp(double fontSize) {
    final scaleFactor = MediaQuery.of(this).size.width / AppSize.designSize.width;
    final cappedScale = scaleFactor.clamp(0.9, 1.2);
    return fontSize * cappedScale;
  }

  double fs(double fontSize) {
    final screenWidth = MediaQuery.of(this).size.width;
    if (screenWidth >= 1200) return fontSize * 1.1;
    if (screenWidth >= 800) return fontSize * 1.05;
    return fontSize;
  }

  double pw(double padding) => w(padding);
  double ph(double padding) => h(padding);

   double get keyboardHeight => MediaQuery.of(this).viewInsets.bottom;


  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;


  bool get isPortrait => MediaQuery.of(this).orientation == Orientation.portrait;
  bool get isLandscape => MediaQuery.of(this).orientation == Orientation.landscape;


  bool get isMobile => ResponsiveBreakpoints.of(this).isMobile;
  bool get isTablet => ResponsiveBreakpoints.of(this).isTablet;
  bool get isDesktop => ResponsiveBreakpoints.of(this).isDesktop;
  bool get isLargeDesktop => ResponsiveBreakpoints.of(this).equals('LARGE_DESKTOP');
  bool get is4K => ResponsiveBreakpoints.of(this).equals('4K');



  bool isBigScreen(BuildContext context) =>
      ResponsiveBreakpoints.of(context).isTablet ||
      ResponsiveBreakpoints.of(context).isDesktop ||
      ResponsiveBreakpoints.of(context).equals('LARGE_DESKTOP') ||
      ResponsiveBreakpoints.of(this).equals('4K');
}


Widget responsiveBuilder(BuildContext context, Widget? child) {
  return ResponsiveBreakpoints.builder(
    child: child!,
    breakpoints: const [
      Breakpoint(start: 0, end: 450, name: MOBILE),
      Breakpoint(start: 451, end: 800, name: TABLET),
      Breakpoint(start: 801, end: 1200, name: DESKTOP),
      Breakpoint(start: 1201, end: 1920, name: 'LARGE_DESKTOP'),
      Breakpoint(start: 1921, end: double.infinity, name: '4K'),
    ],
  );
}