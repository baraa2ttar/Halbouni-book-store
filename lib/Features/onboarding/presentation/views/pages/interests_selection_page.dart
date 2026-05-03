import 'package:adv/Features/onboarding/presentation/models/genre.dart';
import 'package:adv/core/exports/ui_exports.dart';

import '../widgets/card_googl.dart';

class InterestsSelectionPage extends StatelessWidget {
  final List<String> selectedInterests;
  final ValueChanged<String> onToggle;
  final VoidCallback? onFinish;
  final bool isLoading;

  const InterestsSelectionPage({
    super.key,
    required this.selectedInterests,
    required this.onToggle,
    required this.onFinish,
    required this.isLoading,
  });

  static const bookGenres = <Genre>[
    Genre(name: "Romance", icon: Icons.favorite),
    Genre(name: "Fantasy", icon: Icons.auto_awesome),
    Genre(name: "Sci-Fi", icon: Icons.rocket_launch),
    Genre(name: "Horror", icon: Icons.psychology),
    Genre(name: "Thriller", icon: Icons.movie),
    Genre(name: "Comedy", icon: Icons.sentiment_very_satisfied),
    Genre(name: "Action", icon: Icons.flash_on),
    Genre(name: "Food", icon: Icons.restaurant),
    Genre(name: "Adventure", icon: Icons.explore),
    Genre(name: "Psychology", icon: Icons.psychology),
    Genre(name: "Biography", icon: Icons.person),
    Genre(name: "Travel", icon: Icons.public),
    Genre(name: "Children's", icon: Icons.child_care),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedCount = selectedInterests.length;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: SizedBox(
          width: 180,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: LinearProgressIndicator(
              value: 1.0,
              minHeight: 8.0,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation(AppColor.primaryColor),
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "What are your interests?",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Select up to 4 categories to personalize your book recommendations",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "$selectedCount/4 selected",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: selectedCount == 4
                        ? AppColor.primaryColor
                        : Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.5,
                ),
                itemCount: bookGenres.length,
                itemBuilder: (context, index) {
                  final genre = bookGenres[index];
                  final isSelected = selectedInterests.contains(genre.name);
                  final canSelect = selectedInterests.length < 4 || isSelected;

                  return _buildInterestCard(
                    genre: genre,
                    isSelected: isSelected,
                    canSelect: canSelect,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            CardGoogle(
              label: isLoading ? "Finishing..." : "Continue",
              backGroundColor:
                  onFinish != null ? AppColor.primaryColor : Colors.grey[400]!,
              onTap: isLoading ? null : onFinish,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInterestCard({
    required Genre genre,
    required bool isSelected,
    required bool canSelect,
  }) {
    return GestureDetector(
      onTap: canSelect ? () => onToggle(genre.name) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.primaryColor.withValues(alpha: 0.1)
              : Colors.white,
          border: Border.all(
            color: isSelected
                ? AppColor.primaryColor
                : (canSelect ? Colors.grey[300]! : Colors.grey[200]!),
            width: isSelected ? 2.0 : 1.0,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected ? AppColor.primaryColor : Colors.grey[100],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                genre.icon,
                color: isSelected ? Colors.white : Colors.grey[600],
                size: 14,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                genre.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? AppColor.primaryColor
                      : (canSelect ? Colors.grey[800] : Colors.grey[400]),
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected)
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColor.primaryColor),
                child: const Icon(Icons.check, color: Colors.white, size: 10),
              ),
          ],
        ),
      ),
    );
  }
}
