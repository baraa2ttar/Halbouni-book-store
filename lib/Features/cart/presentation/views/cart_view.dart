import 'package:adv/Features/cart/presentation/views/cart_view_body.dart';
import 'package:adv/core/exports/main_exports.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: Colors.white,
        foregroundColor: AppColor.titleColor,
        elevation: 0,
      ),
      body: const CartViewBody(),
    );
  }
}
