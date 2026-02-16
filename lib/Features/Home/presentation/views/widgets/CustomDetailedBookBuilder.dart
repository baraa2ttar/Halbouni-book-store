
import '../../../../../core/exports/ui_exports.dart';
import 'custom_detailed_book_item.dart';

class CustomDetailedBookBuilder extends StatelessWidget {
  const CustomDetailedBookBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: CustomDetailedBookItem(),
        );
      },
    );
  }
}
