import 'package:adv/Features/cart/data/models/cart_item_model.dart';
import 'package:adv/Features/cart/presentation/manager/cart_cubit/cart_cubit.dart';
import 'package:adv/Features/orders/presentation/manager/checkout_cubit/checkout_cubit.dart';
import 'package:adv/core/exports/ui_exports.dart';
import 'package:adv/core/routing/app_router.dart';
import 'package:adv/core/widgets/custom_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.white,
        foregroundColor: AppColor.titleColor,
        elevation: 0,
      ),
      body: session == null
          ? _buildSignInRequired(context)
          : BlocBuilder<CartCubit, CartState>(
              builder: (context, cartState) {
                if (cartState is! CartLoaded || cartState.items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Your cart is empty'),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () => context.go(AppRouter.kHomeView),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColor.primaryColor,
                          ),
                          child: const Text('Browse books'),
                        ),
                      ],
                    ),
                  );
                }

                final items = cartState.items;
                final total = items.fold<double>(
                  0,
                  (sum, item) => sum + item.price * item.quantity,
                );

                return BlocConsumer<CheckoutCubit, CheckoutState>(
                  listener: (context, state) {
                    if (state is CheckoutFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                    if (state is CheckoutSuccess) {
                      context.read<CartCubit>().loadCart();
                      _showSuccessDialog(context, state.order.id);
                    }
                  },
                  builder: (context, checkoutState) {
                    final isLoading = checkoutState is CheckoutLoading;

                    return Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.all(context.horizontalPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order summary',
                                  style: AppTextStyles.titleText(context),
                                ),
                                const SizedBox(height: 16),
                                ...items.map((item) => _OrderLineItem(item: item)),
                                const Divider(height: 32),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total',
                                      style: AppTextStyles.textStyle20.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '\$${total.toStringAsFixed(2)}',
                                      style: AppTextStyles.textStyle20.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                TextField(
                                  controller: _notesController,
                                  enabled: !isLoading,
                                  maxLines: 3,
                                  decoration: const InputDecoration(
                                    labelText: 'Delivery notes (optional)',
                                    border: OutlineInputBorder(),
                                    alignLabelWithHint: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(24),
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
                            child: SizedBox(
                              width: double.infinity,
                              child: CustomButton(
                                text: isLoading ? 'Placing order...' : 'Place order',
                                backgroundColor: AppColor.primaryColor,
                                textColor: Colors.white,
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        context.read<CheckoutCubit>().placeOrder(
                                              items: items,
                                              total: total,
                                              notes: _notesController.text,
                                            );
                                      },
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
    );
  }

  Widget _buildSignInRequired(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.horizontalPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline, size: 64, color: AppColor.greyColor),
            const SizedBox(height: 16),
            const Text(
              'Sign in to complete your order',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.push(AppRouter.kAuthSignIn),
              style: FilledButton.styleFrom(
                backgroundColor: AppColor.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Sign in'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String orderId) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Order placed!'),
          content: Text(
            'Your order has been submitted and will appear in the admin dashboard.\n\nOrder ID: ${orderId.substring(0, 8)}...',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.go(AppRouter.kHomeView);
              },
              child: const Text('Back to home'),
            ),
          ],
        );
      },
    );
  }
}

class _OrderLineItem extends StatelessWidget {
  const _OrderLineItem({required this.item});

  final CartItemModel item;

  @override
  Widget build(BuildContext context) {
    final lineTotal = item.price * item.quantity;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
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
                Text(
                  'Qty: ${item.quantity} × \$${item.price.toStringAsFixed(2)}',
                  style: TextStyle(color: AppColor.darkGreyColor, fontSize: context.fs(13)),
                ),
              ],
            ),
          ),
          Text(
            '\$${lineTotal.toStringAsFixed(2)}',
            style: AppTextStyles.textStyle16.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
