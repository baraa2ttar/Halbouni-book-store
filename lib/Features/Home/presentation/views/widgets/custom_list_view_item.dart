
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/exports/main_exports.dart';

class CustomListViewItem extends StatelessWidget {
  const CustomListViewItem({super.key, required this.image});

  final String image ;

  @override
  Widget build(BuildContext context) {
    final hasImage = image.trim().isNotEmpty;

    return AspectRatio(
      aspectRatio: 2.7/4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: hasImage
            ? CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                errorWidget: (context, url, error) =>
                    Image.asset(AppAssets.book3, fit: BoxFit.cover),
              )
            : Image.asset(AppAssets.book3, fit: BoxFit.cover),
      )
    );
  }
}
