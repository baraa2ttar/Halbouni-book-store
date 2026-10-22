import 'package:adv/Features/cart/presentation/views/cart_view_body.dart';
import 'package:adv/core/exports/main_exports.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text('My Cart'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: AppColor.titleColor,
        elevation: 0,
      ),
      body: const CartViewBody(),
    );
  }
}
