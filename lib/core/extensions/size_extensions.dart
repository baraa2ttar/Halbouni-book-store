import 'package:adv/core/constant/app_sizes.dart';
import 'package:adv/core/utils/responsive_breakpoints.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart'
    as responsive_framework;

export 'package:adv/core/utils/responsive_breakpoints.dart';

extension SizeExtensions on BuildContext {
  double w(double width) =>
      (width / AppSize.designSize.width) * MediaQuery.of(this).size.width;
  double h(double height) =>
      (height / AppSize.designSize.height) * MediaQuery.of(this).size.height;

  double sp(double fontSize) {
    final scaleFactor =
        MediaQuery.of(this).size.width / AppSize.designSize.width;
    final cappedScale = scaleFactor.clamp(0.85, 1.25);
    return fontSize * cappedScale;
  }

  double fs(double fontSize) {
    return switch (layoutType) {
      AppLayoutType.laptop => fontSize * 1.15,
      AppLayoutType.tablet => fontSize * 1.05,
      AppLayoutType.mobile => fontSize,
    };
  }

  double pw(double padding) => w(padding);
  double ph(double padding) => h(padding);

  double get keyboardHeight => MediaQuery.of(this).viewInsets.bottom;

  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  bool get isPortrait =>
      MediaQuery.of(this).orientation == Orientation.portrait;
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;

  AppLayoutType get layoutType {
    final width = screenWidth;
    if (width >= ResponsiveBreakpoints.laptopMin) {
      return AppLayoutType.laptop;
    }
    if (width >= ResponsiveBreakpoints.tabletMin) {
      return AppLayoutType.tablet;
    }
    return AppLayoutType.mobile;
  }

  bool get isMobile => layoutType == AppLayoutType.mobile;
  bool get isTablet => layoutType == AppLayoutType.tablet;
  bool get isLaptop => layoutType == AppLayoutType.laptop;

  /// Laptop tier (kept for existing call sites).
  bool get isDesktop => isLaptop;
  bool get isLargeDesktop => isLaptop && screenWidth >= 1440;
  bool get is4K => isLaptop && screenWidth >= 1920;

  bool isBigScreen(BuildContext context) => !context.isMobile;

  double get horizontalPadding => switch (layoutType) {
    AppLayoutType.laptop => 48.0,
    AppLayoutType.tablet => 32.0,
    AppLayoutType.mobile => 24.0,
  };

  double get contentMaxWidth => switch (layoutType) {
    AppLayoutType.laptop => 520,
    AppLayoutType.tablet => 440,
    AppLayoutType.mobile => screenWidth,
  };

  double get buttonWidth {
    final maxWidth = switch (layoutType) {
      AppLayoutType.laptop => 420.0,
      AppLayoutType.tablet => 380.0,
      AppLayoutType.mobile => 340.0,
    };
    return (screenWidth - horizontalPadding * 2).clamp(260.0, maxWidth);
  }

  T responsiveValue<T>({
    required T mobile,
    required T tablet,
    required T laptop,
  }) {
    return switch (layoutType) {
      AppLayoutType.laptop => laptop,
      AppLayoutType.tablet => tablet,
      AppLayoutType.mobile => mobile,
    };
  }
}

Widget responsiveBuilder(BuildContext context, Widget? child) {
  return responsive_framework.ResponsiveBreakpoints.builder(
    child: child!,
    breakpoints: const [
      responsive_framework.Breakpoint(
        start: 0,
        end: ResponsiveBreakpoints.mobileMax,
        name: ResponsiveBreakpoints.mobile,
      ),
      responsive_framework.Breakpoint(
        start: ResponsiveBreakpoints.tabletMin,
        end: ResponsiveBreakpoints.tabletMax,
        name: ResponsiveBreakpoints.tablet,
      ),
      responsive_framework.Breakpoint(
        start: ResponsiveBreakpoints.laptopMin,
        end: double.infinity,
        name: ResponsiveBreakpoints.laptop,
      ),
    ],
  );
}