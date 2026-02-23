import 'package:adv/Features/search/views/widgets/search_view_body.dart';
import 'package:adv/core/exports/main_exports.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body:  SafeArea(child:
      SearchViewBody()
      ),
    );
  }
}
