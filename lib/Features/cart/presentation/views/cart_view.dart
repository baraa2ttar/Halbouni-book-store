import 'package:adv/Features/cart/presentation/views/cart_view_body.dart';
import 'package:adv/core/exports/main_exports.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CartViewBody(),
    );
  }
}
