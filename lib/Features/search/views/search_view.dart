import 'package:adv/Features/Home/data/repos/home_repo_impl.dart';
import 'package:adv/Features/search/presentation/manager/search_cubit/search_cubit.dart';
import 'package:adv/Features/search/views/widgets/search_view_body.dart';
import 'package:adv/core/exports/main_exports.dart';
import 'package:adv/core/services/setup_service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(getIt.get<HomeRepoImpl>()),
      child: Scaffold(
        backgroundColor: AppColor.primaryColor,
        body: SafeArea(child: SearchViewBody()),
      ),
    );
  }
}
