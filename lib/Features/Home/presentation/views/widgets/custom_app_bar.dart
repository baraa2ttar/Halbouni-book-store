import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/exports/main_exports.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
      child: Row(
        children: [
          Image.asset(AppAssets.appLogo,height: 30.h,width: 30.w,)  ,
          const Spacer(),
          IconButton(onPressed: (){}, icon: const Icon(FontAwesomeIcons.magnifyingGlass,size: 20,)),
          IconButton(onPressed: (){}, icon: const Icon(Icons.notifications,size: 26,)),

        ],
      ),
    );
  }
}
