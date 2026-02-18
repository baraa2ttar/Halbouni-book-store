import 'package:adv/core/exports/main_exports.dart';

import 'custom_book_detailes_app_bar.dart';

class BookDetailsViewBody extends StatelessWidget {
  const BookDetailsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          SafeArea(child: CustomBookDetailesAppBar())
        ],
      ),
    );
  }
}
