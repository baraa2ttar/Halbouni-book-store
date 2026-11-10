import '../../../../../core/exports/ui_exports.dart';

/// A collapsible product description for the book details page.
///
/// Shows a heading ("About this book" when [hasBookDetails] is true, otherwise
/// "Description") followed by the [description] text. When the text overflows
/// [maxCollapsedLines] lines it collapses to that many lines with an ellipsis
/// and a "Read more" toggle; expanding reveals the full text with "Show less".
///
/// Overflow is measured with [TextPainter] against the real available width
/// (never by character count), so the toggle only appears when the text truly
/// does not fit.
///
/// Renders nothing when [description] is null or empty/whitespace-only.
class CollapsibleDescription extends StatefulWidget {
  const CollapsibleDescription({
    super.key,
    required this.description,
    required this.hasBookDetails,
    this.maxCollapsedLines = 4,
  });

  final String? description;
  final bool hasBookDetails;
  final int maxCollapsedLines;

  @override
  State<CollapsibleDescription> createState() => _CollapsibleDescriptionState();
}

class _CollapsibleDescriptionState extends State<CollapsibleDescription> {
  bool _expanded = false;

  bool _overflows(String text, double maxWidth, TextStyle style) {
    if (maxWidth.isInfinite || maxWidth <= 0) return false;
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: widget.maxCollapsedLines,
    );
    try {
      painter.layout(maxWidth: maxWidth);
      return painter.didExceedMaxLines;
    } finally {
      painter.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.description;
    if (text == null || text.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final heading = widget.hasBookDetails
        ? AppStrings.aboutThisBook
        : AppStrings.descriptionHeading;

    // Inherit the ambient (theme) font so the measured style exactly matches
    // the rendered style; otherwise the toggle could appear/disappear wrongly.
    final bodyStyle = DefaultTextStyle.of(context).style.copyWith(
          fontSize: 14,
          height: 1.5,
          color: AppColor.darkGreyColor,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: AppTextStyles.textStyle16.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColor.titleColor,
          ),
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            final overflow = _overflows(text, constraints.maxWidth, bodyStyle);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: bodyStyle,
                  textAlign: TextAlign.start,
                  maxLines: _expanded ? null : widget.maxCollapsedLines,
                  overflow:
                      _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
                ),
                if (overflow)
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setState(() => _expanded = !_expanded),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(top: 4),
                        child: Text(
                          _expanded ? AppStrings.showLess : AppStrings.readMore,
                          style: AppTextStyles.textStyle14.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColor.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
