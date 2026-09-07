import 'package:adv/core/extensions/size_extensions.dart';
import 'package:flutter/material.dart';

typedef ResponsiveWidgetBuilder = Widget Function(BuildContext context);

/// Picks one of three layouts based on [AppLayoutType] breakpoints.
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.laptop,
  });

  final ResponsiveWidgetBuilder mobile;
  final ResponsiveWidgetBuilder tablet;
  final ResponsiveWidgetBuilder laptop;

  @override
  Widget build(BuildContext context) {
    return switch (context.layoutType) {
      AppLayoutType.laptop => laptop(context),
      AppLayoutType.tablet => tablet(context),
      AppLayoutType.mobile => mobile(context),
    };
  }
}
