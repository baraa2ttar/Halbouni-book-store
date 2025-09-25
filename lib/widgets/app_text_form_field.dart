import 'package:adv/core/exports/ui_exports.dart';

class AppTextFormField extends StatelessWidget {
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final TextStyle? inputTextStyle;
  final TextStyle? hintStyle;
  final String? hintText;
  final bool? isObscureText;
  final Widget? suffixIcon;
  final Color? backgroundColor;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final String? errorText;
  final bool isUnderlined;
  final Color? cursorColor;
  final Widget? prefixIcon;
  final Decoration? decoration;
  final Color? borderColor;


  const AppTextFormField({
    super.key,
    this.contentPadding,
    this.focusedBorder,
    this.enabledBorder,
    this.borderColor,
    this.inputTextStyle,
    this.hintStyle,
    this.hintText,
    this.isObscureText,
    this.suffixIcon,
    this.backgroundColor,
    this.controller,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.errorText,
    this.cursorColor,
    this.prefixIcon,
    this.decoration,
    this.isUnderlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: decoration,
        child:TextFormField(
      controller: controller,
      cursorColor: cursorColor,
      keyboardType: keyboardType,
      style: inputTextStyle ?? AppTextStyles.doctorNameText(context),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: contentPadding ??
            EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        focusedBorder: focusedBorder ?? (isUnderlined
            ? UnderlineInputBorder(
          borderSide: BorderSide(color: AppColor.whiteColor, width: 1.3),
        )
            : OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.primaryColor, width: 1.3),
          borderRadius: BorderRadius.circular(16.0),
        )),
        enabledBorder: enabledBorder ?? (isUnderlined
            ? UnderlineInputBorder(
          borderSide: BorderSide(color: AppColor.whiteColor),
        )
            : OutlineInputBorder(
          borderSide: BorderSide(color:borderColor?? AppColor.greyColor),
          borderRadius: BorderRadius.circular(16.0),
        )),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.3,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.3,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        hintStyle: hintStyle ?? AppTextStyles.hintText(context),
        hintText: hintText,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        fillColor: isUnderlined ? null : (backgroundColor ?? Colors.white),
        // backgroundColor ?? Colors.white,
        filled: !isUnderlined,
        // true,
        errorText: errorText
      ),
      obscureText: isObscureText ?? false,
      validator: validator,
      onChanged: onChanged,
    ));
  }
}