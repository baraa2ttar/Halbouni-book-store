import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_text_styles.dart';
import '../../../../../core/exports/main_exports.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: 40,right: 10,bottom: 10),
      child: Row(
        children: [
          Image.asset(AppAssets.appLogo,height: 30.h,width: 30.w,),
          SizedBox(width: 10,),
          Text("Halbouni Book Store",
          style:
          AppTextStyles.headlineAppColor(context)
          // TextStyle(color: AppColor.primaryColor,
          // fontSize: 20
          // ),


            ),
          const Spacer(),
          IconButton(onPressed: (){}, icon: const Icon(FontAwesomeIcons.magnifyingGlass,size: 20,)),
          IconButton(onPressed: (){}, icon: const Icon(Icons.notifications,size: 26,)),

        ],
      ),
    );
  }
}
