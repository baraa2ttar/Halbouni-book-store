import 'package:adv/Features/onboarding/presentation/manager/onboarding_state.dart';
import 'package:adv/core/exports/ui_exports.dart';

import '../widgets/card_googl.dart';

class GenderSelectionPage extends StatelessWidget {
  final OnboardingGender? selectedGender;
  final ValueChanged<OnboardingGender> onSelect;
  final VoidCallback onContinue;

  const GenderSelectionPage({
    super.key,
    required this.selectedGender,
    required this.onSelect,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: SizedBox(
          width: 180,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: LinearProgressIndicator(
              value: 0.25,
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
                  "What's your gender?",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "This helps us personalize your experience",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Column(
                children: [
                  _buildGenderCard(
                    gender: OnboardingGender.male,
                    title: "Male",
                    subtitle: "I am male",
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 16),
                  _buildGenderCard(
                    gender: OnboardingGender.female,
                    title: "Female",
                    subtitle: "I am female",
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16),
                  _buildGenderCard(
                    gender: OnboardingGender.notSpecified,
                    title: "Prefer not to say",
                    subtitle: "Skip this question",
                    icon: Icons.help_outline,
                  ),
                ],
              ),
            ),
            CardGoogle(
              label: "Continue",
              backGroundColor: AppColor.primaryColor,
              onTap: onContinue,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderCard({
    required OnboardingGender gender,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = selectedGender == gender;

    return GestureDetector(
      onTap: () => onSelect(gender),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primaryColor.withValues(alpha: 0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? AppColor.primaryColor : Colors.grey[300]!,
            width: isSelected ? 2.0 : 1.0,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected ? AppColor.primaryColor : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey[600],
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColor.primaryColor : Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColor.primaryColor : Colors.grey[400]!,
                  width: 2,
                ),
                color: isSelected ? AppColor.primaryColor : Colors.transparent,
              ),
              child:
                  isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : null,
            ),
          ],
        ),
      ),
    );
  }
}
