import 'package:adv/core/exports/main_exports.dart';

class CustomFadingWidget extends StatefulWidget {
  const CustomFadingWidget({super.key, required this.child});
final Widget child ;
  @override
  State<CustomFadingWidget> createState() => _CustomFadingWidgetState();
}

class _CustomFadingWidgetState extends State<CustomFadingWidget> with SingleTickerProviderStateMixin{
  late Animation animation ;
  late AnimationController animationController ;
  @override
  @override
  void initState() {
    // TODO: implement initState
    animationController = AnimationController(vsync: this,duration: const Duration(milliseconds: 800));
    animation = Tween<double>(begin:  .2,end: 0.8).animate(animationController);
    animationController.addListener((){
      setState(() {

      });
    });
animationController.repeat(reverse:true);
    super.initState();
  }
  Widget build(BuildContext context) {
    return Opacity(opacity:animation.value ,
    child: widget.child,
    );

  }
}
