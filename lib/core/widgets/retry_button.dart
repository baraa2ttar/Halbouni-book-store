import 'package:adv/core/exports/ui_exports.dart';

/// A friendly "something went wrong" message with a Retry button.
///
/// Shared by the featured- and newest-list error states on the home screen.
/// Compact (`mainAxisSize.min`), so callers can place it inline (featured slot)
/// or wrap it in a [Center] to fill a remaining area (newest slot).
class RetryButton extends StatelessWidget {
  const RetryButton({
    super.key,
    required this.onRetry,
    this.message,
  });

  /// Called when the user taps Retry. The caller decides what to reload.
  final VoidCallback onRetry;

  /// Overrides the default friendly message.
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.cloud_off_outlined,
            size: 40,
            color: AppColor.darkGreyColor,
          ),
          const SizedBox(height: 12),
          Text(
            message ?? AppStrings.friendlyError,
            textAlign: TextAlign.center,
            style: AppTextStyles.textStyle14.copyWith(
              color: AppColor.darkGreyColor,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: onRetry,
            style: FilledButton.styleFrom(
              backgroundColor: AppColor.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text(AppStrings.retry),
          ),
        ],
      ),
    );
  }
}
