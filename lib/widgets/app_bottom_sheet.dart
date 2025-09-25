import 'package:adv/core/exports/ui_exports.dart';
// For the first version (SafeArea, shadow, fixed height):
// dart
// Copy
// Edit
// CustomBottomSheet.show(
//   child: YourWidget(),
//   useSafeArea: true,
//   height: 350.h,
//   withShadow: true,
//   barrierColor: Colors.transparent,
// );
// 2. For the second version (scrollable, dark background):
// dart
// Copy
// Edit
// CustomBottomSheet.show(
//   child: YourWidget(),
//   isScrollControlled: true,
//   barrierColor: Colors.black.withOpacity(0.5),
// );


class CustomBottomSheet {
  static Future<T?> show<T>({
    required Widget child,
    bool useSafeArea = false,
    bool isScrollControlled = false,
    double? height,
    Color? barrierColor,
    Color backgroundColor = Colors.white,
    bool withShadow = false,
  }) {
    Widget content = Container(
      height: height,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical:19.h ),
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: withShadow
            ? [
                BoxShadow(
                  blurRadius: 25,
                  color: AppColor.blackColor.withOpacity(0.06),
                ),
              ]
            : null,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: child,
    );

    return Get.bottomSheet<T>(
      useSafeArea ? SafeArea(child: content) : content,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      barrierColor: barrierColor ?? Colors.black.withOpacity(0.5),
    );
  }
}

