
import 'package:adv/core/exports/main_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constant/app_assets.dart';
import '../../../../core/constant/app_colors.dart';

class CardGoogle extends StatelessWidget {
  final String ? imagePath;
  final String label;
  final Color backGroundColor ;
  final VoidCallback? onTap;
  final double width;
  final double height;
  final TextStyle? textStyle;

  const CardGoogle({
    super.key,
    this.imagePath,
    required this.label,
    this.onTap,
    this.width = 300,
    this.height = 65,
    this.textStyle,
    required this.backGroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child:Container(

        height: context.h(65),
        width:width,
        decoration: BoxDecoration(
            color: backGroundColor,
            borderRadius : BorderRadius.circular(25),
            border: Border.all(color: AppColor.primaryColor,width: 0.5)

        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(imagePath!= null)
            Image.asset(
              imagePath!,
              width: 30.w,
              height: 30.w,
            ),
            Text(label)
          ],
        ),

      )
    );
  }
}
