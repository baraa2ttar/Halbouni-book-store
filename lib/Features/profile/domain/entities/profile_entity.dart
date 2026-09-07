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
}
