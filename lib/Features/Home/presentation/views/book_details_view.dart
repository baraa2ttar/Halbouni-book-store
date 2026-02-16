import 'package:adv/Features/Home/presentation/views/widgets/book_details_view_body.dart';
import 'package:adv/core/exports/main_exports.dart';

class BookDetailsView extends StatelessWidget {
  const BookDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BookDetailsViewBody(),
    );
  }
}
