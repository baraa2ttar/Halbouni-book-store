import 'package:adv/Features/profile/domain/entities/profile_entity.dart';
import 'package:adv/Features/profile/domain/repos/profile_repo.dart';
import 'package:adv/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepoImpl implements ProfileRepo {
  ProfileRepoImpl({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<Either<Failure, ProfileEntity>> fetchProfile() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        return left(ServerFailure('You must be signed in to view your profile'));
      }

      final data = await _client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (data == null) {
        return right(
          ProfileEntity(
            id: user.id,
            email: user.email ?? '',
          ),
        );
      }

      return right(_mapProfile(data, user.email ?? ''));
    } on PostgrestException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveProfile({
    required List<String> interests,
    String? gender,
    String? ageRange,
  }) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        return left(ServerFailure('No authenticated user found'));
      }

      await _client.from('profiles').upsert({
        'id': user.id,
        'email': user.email,
        'interests': interests,
        if (gender != null) 'gender': gender,
        if (ageRange != null) 'age_range': ageRange,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      });
      return right(null);
    } on PostgrestException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> ensureProfile({
    required String userId,
    required String email,
  }) async {
    try {
      await _client.from('profiles').upsert({
        'id': userId,
        'email': email,
      });
      return right(null);
    } on PostgrestException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  ProfileEntity _mapProfile(Map<String, dynamic> data, String fallbackEmail) {
    final rawInterests = data['interests'];
    final interests = rawInterests is List
        ? rawInterests.map((e) => e.toString()).toList()
        : <String>[];

    return ProfileEntity(
      id: data['id'] as String,
      email: (data['email'] as String?) ?? fallbackEmail,
      interests: interests,
      gender: data['gender'] as String?,
      ageRange: data['age_range'] as String?,
    );
  }
}
