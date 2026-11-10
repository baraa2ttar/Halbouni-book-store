import 'dart:async';

import 'package:adv/Features/cart/data/models/cart_item_model.dart';
import 'package:adv/Features/cart/presentation/manager/cart_cubit/cart_cubit.dart';
import 'package:adv/Features/orders/presentation/manager/checkout_cubit/checkout_cubit.dart';
import 'package:adv/core/exports/ui_exports.dart';
import 'package:adv/core/utils/currency_formatter.dart';
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
  final _notesFocusNode = FocusNode();
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();
    // Session can change while this screen is open (e.g. sign-in redirect
    // returns here) — rebuild so the signed-out prompt disappears.
    _authSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _notesFocusNode.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
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
                final subtotal = items.fold<double>(
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
                      _showSuccessDialog(
                        context,
                        state.order.id,
                        warning: state.warning,
                      );
                    }
                  },
                  builder: (context, checkoutState) {
                    final isLoading = checkoutState is CheckoutLoading;

                    return Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _SectionCard(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.notes_outlined,
                                            color: AppColor.primaryColor,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'Delivery Notes',
                                              style: AppTextStyles.textStyle16
                                                  .copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            tooltip: 'Edit notes',
                                            onPressed: isLoading
                                                ? null
                                                : () => _notesFocusNode
                                                    .requestFocus(),
                                            icon: Icon(
                                              Icons.edit_outlined,
                                              color: AppColor.darkGreyColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TextField(
                                        controller: _notesController,
                                        focusNode: _notesFocusNode,
                                        enabled: !isLoading,
                                        maxLines: 3,
                                        decoration: InputDecoration(
                                          hintText:
                                              'Add delivery notes (optional)',
                                          filled: true,
                                          fillColor: const Color(0xFFF7F7F7),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _SectionCard(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.payments_outlined,
                                        color: AppColor.primaryColor,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Payment Method: Pay on Delivery',
                                          style: AppTextStyles.textStyle16
                                              .copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _SectionCard(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Order summary',
                                        style: AppTextStyles.textStyle16
                                            .copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      ...items.map(
                                        (item) => _OrderLineItem(item: item),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8),
                                        child: Divider(height: 1),
                                      ),
                                      _AmountRow(
                                        label: 'Subtotal',
                                        value: subtotal,
                                      ),
                                      const SizedBox(height: 8),
                                      _AmountRow(
                                        label: 'TOTAL PAYMENT',
                                        value: subtotal,
                                        emphasize: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
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
                                text: isLoading
                                    ? 'Placing order...'
                                    : 'Place Order',
                                backgroundColor: AppColor.primaryColor,
                                textColor: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        context
                                            .read<CheckoutCubit>()
                                            .placeOrder(
                                              items: items,
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
    final redirect = Uri.encodeComponent(AppRouter.kCheckoutView);
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
              onPressed: () =>
                  context.push('${AppRouter.kAuthSignIn}?redirect=$redirect'),
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

  void _showSuccessDialog(BuildContext context, String orderId,
      {String? warning}) {
    final shortId =
        orderId.length >= 8 ? '${orderId.substring(0, 8)}...' : orderId;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Order placed!'),
          content: Text(
            'Your order has been submitted and will appear in the admin dashboard.\n\nOrder ID: $shortId'
            '${warning != null ? '\n\nNote: $warning' : ''}',
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _AmountRow extends StatelessWidget {
  const _AmountRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final double value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: emphasize
              ? AppTextStyles.textStyle16.copyWith(fontWeight: FontWeight.w800)
              : AppTextStyles.textStyle14.copyWith(color: AppColor.darkGreyColor),
        ),
        Text(
          formatSyp(value),
          style: emphasize
              ? AppTextStyles.textStyle16.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColor.primaryColor,
                )
              : AppTextStyles.textStyle14.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
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
                  'Qty: ${item.quantity} × ${formatSyp(item.price)}',
                  style: TextStyle(
                    color: AppColor.darkGreyColor,
                    fontSize: context.fs(13),
                  ),
                ),
              ],
            ),
          ),
          Text(
            formatSyp(lineTotal),
            style: AppTextStyles.textStyle16.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
