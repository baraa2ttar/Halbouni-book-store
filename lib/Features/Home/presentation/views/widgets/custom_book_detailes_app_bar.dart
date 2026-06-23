import 'package:go_router/go_router.dart';

import '../../../../../core/exports/ui_exports.dart';
import '../../../../../core/routing/app_router.dart';

class CustomBookDetailesAppBar extends StatelessWidget {
  const CustomBookDetailesAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => GoRouter.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
        IconButton(
          onPressed: () => GoRouter.of(context).push(AppRouter.kCartView),
          icon: const Icon(Icons.shopping_cart_outlined),
        ),
      ],
    );
  }
}

