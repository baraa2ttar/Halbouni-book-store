import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cart/presentation/manager/cart_cubit/cart_cubit.dart';
import '../../../../../core/exports/ui_exports.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../domain/entities/product_entity.dart';

class BooksActionButton extends StatelessWidget {
  const BooksActionButton({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: "\$${product.price.toStringAsFixed(2)}",
            backgroundColor: Colors.black,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(16),bottomLeft: Radius.circular(16)),
            textColor: Colors.white,
          ),
        ),
        Expanded(
          child: CustomButton(
            text: "Add to Cart",
            backgroundColor: AppColor.primaryColor,
            borderRadius: const BorderRadius.only(topRight: Radius.circular(16),bottomRight: Radius.circular(16)),
            textColor: Colors.white,
            onPressed: () async {
              await context.read<CartCubit>().addItem(product);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${product.name} added to cart!")),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
