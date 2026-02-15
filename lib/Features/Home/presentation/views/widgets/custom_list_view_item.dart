
import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/exports/main_exports.dart';

class CustomListViewItem extends StatelessWidget {
  const CustomListViewItem({super.key});

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: AspectRatio(
        aspectRatio: 2.7/4,
        child: Container(

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: Image.asset(AppAssets.book1).image,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
