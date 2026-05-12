import 'package:adv/Features/Home/data/repos/home_repo_impl.dart';
import 'package:adv/Features/Home/domain/entities/product_entity.dart';
import 'package:adv/Features/Home/presentation/manager/product_details_cubit/product_details_cubit.dart';
import 'package:adv/Features/Home/presentation/views/widgets/book_details_view_body.dart';
import 'package:adv/core/exports/main_exports.dart';
import 'package:adv/core/services/setup_service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookDetailsView extends StatelessWidget {
  const BookDetailsView({
    super.key,
    required this.productId,
    this.productEntity,
  });

  final String productId;
  final ProductEntity? productEntity;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductDetailsCubit(getIt.get<HomeRepoImpl>()),
      child: BookDetailsViewBody(
        productId: productId,
        productEntity: productEntity,
      ),
    );
  }
}
