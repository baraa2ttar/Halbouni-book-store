import 'package:adv/core/exports/ui_exports.dart';

import '../widgets/card_googl.dart';

class AgeSelectionPage extends StatelessWidget {
  final int? selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onContinue;

  const AgeSelectionPage({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
    required this.onContinue,
  });

  static const ageRanges = [
    '18 - 24',
    '25 - 29',
    '30 - 34',
    '35 - 39',
    '40 - 44',
    '45 - 49',
    '50 - 54',
    '55+',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: SizedBox(
          width: 180,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: LinearProgressIndicator(
              value: 0.375,
              minHeight: 8.0,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation(AppColor.primaryColor),
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "choose your Age ",
                  maxLines: 1,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                ),
                const Text(
                  "This helps us recommend age-appropriate content",
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List.generate(ageRanges.length, (index) {
                    final isSelected = selectedIndex == index;
                    return GestureDetector(
                      onTap: () => onSelect(index),
                      child: Container(
                        width: 180,
                        height: 50,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColor.primaryColor : Colors.white,
                          border: Border.all(
                            color: AppColor.primaryColor,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            ageRanges[index],
                            style: TextStyle(
                              color: isSelected ? Colors.white : AppColor.primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const Spacer(),
          CardGoogle(
            label: "continue",
            backGroundColor: AppColor.primaryColor,
            onTap: onContinue,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
