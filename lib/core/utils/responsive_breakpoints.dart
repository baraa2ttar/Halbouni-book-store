import 'package:responsive_framework/responsive_framework.dart';

/// Screen width breakpoints for the three layout tiers.
abstract final class ResponsiveBreakpoints {
  static const double mobileMax = 599;
  static const double tabletMin = 600;
  static const double tabletMax = 1023;
  static const double laptopMin = 1024;

  static const String mobile = MOBILE;
  static const String tablet = TABLET;
  static const String laptop = DESKTOP;
}

enum AppLayoutType { mobile, tablet, laptop }
