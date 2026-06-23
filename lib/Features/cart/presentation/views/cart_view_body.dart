import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/app_assets.dart';
import '../../../../core/constant/app_text_styles.dart';
import '../../../../core/exports/main_exports.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../data/models/cart_item_model.dart';
import '../manager/cart_cubit/cart_cubit.dart';

class CartViewBody extends StatelessWidget {
  const CartViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state is CartLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is CartFailure) {
          return Center(child: Text(state.message));
        }
        if (state is CartLoaded) {
          final items = state.items;
          if (items.isEmpty) {
            return const Center(
              child: Text(
                "Your cart is empty",
                style: AppTextStyles.textStyle20,
              ),
            );
          }

          final total = items.fold<double>(
            0,
            (sum, item) => sum + item.price * item.quantity,
          );

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return _CartItemTile(item: items[index]);
                  },
                ),
              ),
              _BottomTotalBar(total: total),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _CartItemTile extends StatelessWidget {
  const _CartItemTile({required this.item});

  final CartItemModel item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 70,
              height: 100,
              child: CachedNetworkImage(
                imageUrl: item.imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                errorWidget: (_, __, ___) =>
                    Image.asset(AppAssets.book3, fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppTextStyles.textStyle16,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: AppTextStyles.textStyle14.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () {
                  context.read<CartCubit>().changeQuantity(item.id, -1);
                },
              ),
              Text('${item.quantity}', style: AppTextStyles.textStyle16),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () {
                  context.read<CartCubit>().changeQuantity(item.id, 1);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BottomTotalBar extends StatelessWidget {
  const _BottomTotalBar({required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Total: \$${total.toStringAsFixed(2)}',
                style: AppTextStyles.textStyle20.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            CustomButton(
              text: 'Checkout',
              backgroundColor: AppColor.primaryColor,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
