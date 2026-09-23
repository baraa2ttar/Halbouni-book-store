import 'package:adv/Features/auth/domain/repos/auth_repo.dart';
import 'package:adv/Features/Home/domain/entities/product_entity.dart';
import 'package:adv/Features/Home/domain/repos/home_repo.dart';
import 'package:adv/Features/profile/domain/entities/profile_entity.dart';
import 'package:adv/Features/profile/domain/repos/profile_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(
    this._profileRepo,
    this._homeRepo,
    this._authRepo,
  ) : super(const ProfileInitial());

  final ProfileRepo _profileRepo;
  final HomeRepo _homeRepo;
  final AuthRepo _authRepo;

  Future<void> loadProfile() async {
    emit(const ProfileLoading());
    final profileResult = await _profileRepo.fetchProfile();
    await profileResult.fold(
      (failure) async => emit(ProfileFailure(failure.message)),
      (profile) async {
        final categoriesResult = await _homeRepo.fetchCategories();
        // Profile interests are stored as category names — map them to ids.
        final interestIds = categoriesResult.fold(
          (_) => <String, String>{},
          (categories) => {
            for (final category in categories)
              category.name.trim().toLowerCase(): category.id,
          },
        );

        final booksByCategory = <String, List<ProductEntity>>{};
        for (final category in profile.interests) {
          final categoryId = interestIds[category.trim().toLowerCase()];
          if (categoryId == null) continue;
          final booksResult =
              await _homeRepo.fetchProductsByCategory(categoryId: categoryId);
          booksResult.fold(
            (_) {},
            (books) => booksByCategory[category] = books.take(6).toList(),
          );
        }
        emit(ProfileLoaded(profile: profile, booksByCategory: booksByCategory));
      },
    );
  }

  Future<void> signOut() async {
    emit(const ProfileSigningOut());
    final result = await _authRepo.signOut();
    result.fold(
      (failure) => emit(ProfileFailure(failure.message)),
      (_) => emit(const ProfileSignedOut()),
    );
  }
}
