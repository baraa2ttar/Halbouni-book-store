import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String email;
  final List<String> interests;
  final String? gender;
  final String? ageRange;

  const ProfileEntity({
    required this.id,
    required this.email,
    this.interests = const [],
    this.gender,
    this.ageRange,
  });

  @override
  List<Object?> get props => [id, email, interests, gender, ageRange];

  bool get hasInterests => interests.length == 4;

  bool get hasGender => gender != null && gender!.trim().isNotEmpty;

  bool get hasAgeRange => ageRange != null && ageRange!.trim().isNotEmpty;

  /// True when interests, gender, or age still need to be collected.
  bool get isIncomplete => !hasInterests || !hasGender || !hasAgeRange;
}
