part of 'profile_cubit.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

final class ProfileLoaded extends ProfileState {
  const ProfileLoaded({
    required this.profile,
    required this.booksByCategory,
  });

  final ProfileEntity profile;
  final Map<String, List<ProductEntity>> booksByCategory;

  @override
  List<Object?> get props => [profile, booksByCategory];
}

final class ProfileSigningOut extends ProfileState {
  const ProfileSigningOut();
}

final class ProfileSignedOut extends ProfileState {
  const ProfileSignedOut();
}

final class ProfileFailure extends ProfileState {
  const ProfileFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
