import 'package:adv/Features/Home/presentation/views/widgets/custom_detailed_book_item.dart';
import 'package:adv/Features/profile/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:adv/core/exports/ui_exports.dart';
import 'package:adv/core/routing/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        foregroundColor: AppColor.titleColor,
        elevation: 0,
      ),
      body: session == null ? _buildGuestBody(context) : _buildProfileBody(context),
    );
  }

  Widget _buildGuestBody(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.horizontalPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_outline, size: 72, color: AppColor.greyColor),
            SizedBox(height: context.ph(16)),
            Text(
              'Sign in to view your profile and favorite categories',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: context.fs(16), color: AppColor.titleColor),
            ),
            SizedBox(height: context.ph(24)),
            FilledButton(
              onPressed: () => context.push(AppRouter.kAuthSignIn),
              style: FilledButton.styleFrom(
                backgroundColor: AppColor.primaryColor,
                foregroundColor: Colors.white,
                minimumSize: Size(context.buttonWidth, 48),
              ),
              child: const Text('Sign in'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileBody(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSignedOut) {
          context.go(AppRouter.kAuthSignIn);
        } else if (state is ProfileFailure && state.message.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is ProfileInitial || state is ProfileLoading || state is ProfileSigningOut) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ProfileFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.message, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => context.read<ProfileCubit>().loadProfile(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        if (state is ProfileLoaded) {
          return _ProfileContent(state: state);
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.state});

  final ProfileLoaded state;

  @override
  Widget build(BuildContext context) {
    final profile = state.profile;

    return SingleChildScrollView(
      padding: EdgeInsets.all(context.horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProfileHeader(email: profile.email),
          SizedBox(height: context.ph(20)),
          if (profile.gender != null || profile.ageRange != null)
            _InfoRow(
              gender: profile.gender,
              ageRange: profile.ageRange,
            ),
          SizedBox(height: context.ph(24)),
          Text(
            'Favorite categories',
            style: AppTextStyles.titleText(context),
          ),
          SizedBox(height: context.ph(12)),
          if (profile.interests.isEmpty)
            Text(
              'No categories saved yet. Complete onboarding to pick your interests.',
              style: TextStyle(color: AppColor.darkGreyColor, fontSize: context.fs(14)),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: profile.interests
                  .map(
                    (interest) => Chip(
                      label: Text(interest),
                      backgroundColor: AppColor.primaryColor.withValues(alpha: 0.12),
                      labelStyle: TextStyle(
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                  .toList(),
            ),
          SizedBox(height: context.ph(28)),
          ...profile.interests.map((category) {
            final books = state.booksByCategory[category] ?? [];
            if (books.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.only(bottom: context.ph(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Books in $category',
                    style: AppTextStyles.textStyle18.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...books.map((product) => CustomDetailedBookItem(product: product)),
                ],
              ),
            );
          }),
          SizedBox(height: context.ph(12)),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => context.read<ProfileCubit>().signOut(),
              icon: const Icon(Icons.logout),
              label: const Text('Sign out'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColor.settingsRedColor,
                side: BorderSide(color: AppColor.settingsRedColor),
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ),
          SizedBox(height: context.ph(24)),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: AppColor.primaryColor.withValues(alpha: 0.15),
          child: Icon(Icons.person, size: 36, color: AppColor.primaryColor),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Account',
                style: AppTextStyles.titleText(context),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: TextStyle(color: AppColor.darkGreyColor, fontSize: context.fs(14)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({this.gender, this.ageRange});

  final String? gender;
  final String? ageRange;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (gender != null)
          _InfoChip(
            icon: Icons.wc,
            label: gender!.replaceAll('_', ' '),
          ),
        if (gender != null && ageRange != null) const SizedBox(width: 8),
        if (ageRange != null)
          _InfoChip(
            icon: Icons.cake_outlined,
            label: ageRange!,
          ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColor.lightColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColor.primaryColor),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: context.fs(13))),
        ],
      ),
    );
  }
}
