import 'package:adv/Features/Home/domain/entities/product_entity.dart';

import '../../../../../core/exports/main_exports.dart';
import 'custom_list_view_item.dart';

class FeaturedBooksListView extends StatefulWidget {
  const FeaturedBooksListView({
    super.key,
    required this.books,
    this.isLoadingMore = false,
    this.onLoadMore,
  });

  final List<ProductEntity> books;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;

  @override
  State<FeaturedBooksListView> createState() => _FeaturedBooksListViewState();
}

class _FeaturedBooksListViewState extends State<FeaturedBooksListView> {
  static const double _loadMoreThreshold = 0.7;

  late final ScrollController _controller;
  bool _thresholdPassed = false;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FeaturedBooksListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.books.length != widget.books.length && widget.books.isEmpty) {
      _thresholdPassed = false;
    }
  }

  void _onScroll() {
    if (!mounted) return;
    if (widget.onLoadMore == null) return;
    if (widget.isLoadingMore) return;
    if (!_controller.hasClients) return;

    final position = _controller.position;
    final max = position.maxScrollExtent;
    if (max <= 0) return;

    final ratio = position.pixels / max;
    final passed = ratio >= _loadMoreThreshold;

    if (passed && !_thresholdPassed) {
      _thresholdPassed = true;
      widget.onLoadMore!.call();
    } else if (!passed && _thresholdPassed && ratio < 0.6) {
      // Allow triggering again if user scrolls back enough.
      _thresholdPassed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: ListView.builder(
        controller: _controller,
        itemCount: widget.books.length + (widget.isLoadingMore ? 1 : 0),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (index >= widget.books.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: CustomListViewItem(
              image: widget.books[index].imageUrl,
            ),
          );
        },
      ),
    );
  }
}

