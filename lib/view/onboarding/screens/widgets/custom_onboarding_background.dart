import 'package:adv/core/exports/ui_exports.dart';

class CustomOnboardingBackground extends StatelessWidget {
  final Widget child;
  final String? leftCircleImage;
  final String? rightCircleImage;

  const CustomOnboardingBackground({
    super.key,
    required this.child,
    this.leftCircleImage,
    this.rightCircleImage,
  });

  @override 
  Widget build(BuildContext context) {
    return SizedBox(height: 450.h,
      child: Stack(
          children: [
      
            if (leftCircleImage != null)
              Positioned(
                top: -60,
                left: -90,
                child: Image.asset(
                  leftCircleImage!,
                  width: 342.w,
                  height: 342.h,
                  fit: BoxFit.contain,
                ),
              ),
      
            
            if (rightCircleImage != null)
              Positioned(
                top: -60,
                right: -90,
                child: Image.asset(
                  rightCircleImage!,
                  width: 342.w,
                  height: 342.h,
                  fit: BoxFit.contain,
                ),
              ),
      
            Padding(
              padding: EdgeInsets.all(context.pw(16)),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: context.screenHeight,
                  minWidth: context.screenWidth,
                ),
                child: child,
              ),
            ),
          ],
        
      ),
    );
  }
}