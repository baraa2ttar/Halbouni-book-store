import 'package:adv/Features/Auth/domain/entities/auth_entity.dart';
import 'package:adv/Features/Auth/domain/repos/auth_repo.dart';
import 'package:adv/Features/onboarding/domain/repos/onboarding_repo.dart';
import 'package:adv/Features/profile/domain/repos/profile_repo.dart';
import 'package:adv/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepoImpl implements AuthRepo {
  AuthRepoImpl({
    SupabaseClient? client,
    ProfileRepo? profileRepo,
    OnboardingRepo? onboardingRepo,
  })  : _client = client ?? Supabase.instance.client,
        _profileRepo = profileRepo,
        _onboardingRepo = onboardingRepo;

  final SupabaseClient _client;
  final ProfileRepo? _profileRepo;
  final OnboardingRepo? _onboardingRepo;

  @override
  Future<Either<Failure, AuthEntity>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
      final user = response.user;
      if (user == null) {
        return left(ServerFailure('Sign in succeeded but user was not returned'));
      }
      await _ensureProfile(user);
      await _syncOnboardingProfile();
      return right(_mapSessionUser(user, response.session));
    } on AuthException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email.trim(),
        password: password,
      );
      final user = response.user;
      if (user == null) {
        return left(ServerFailure('Sign up succeeded but user was not returned'));
      }
      await _ensureProfile(user);
      await _syncOnboardingProfile();
      return right(_mapSessionUser(user, response.session));
    } on AuthException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _client.auth.signOut();
      return right(null);
    } on AuthException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  Future<void> _ensureProfile(User user) async {
    final profileRepo = _profileRepo;
    if (profileRepo == null) return;
    await profileRepo.ensureProfile(
      userId: user.id,
      email: user.email ?? '',
    );
  }

  Future<void> _syncOnboardingProfile() async {
    await _onboardingRepo?.syncPendingProfile();
  }

  AuthEntity _mapSessionUser(User user, Session? session) {
    return AuthEntity(
      id: user.id,
      email: user.email ?? '',
      accessToken: session?.accessToken,
      userMetadata: _normalizeMetadata(user.userMetadata),
    );
  }

  /// Ensures numeric values use [num.toDouble] where applicable so later UI/business parsing does not rely on loose `num` coercion.
  Map<String, dynamic> _normalizeMetadata(Map<String, dynamic>? raw) {
    if (raw == null || raw.isEmpty) return const {};

    final out = <String, dynamic>{};
    for (final entry in raw.entries) {
      final v = entry.value;
      if (v is num) {
        out[entry.key] = v.toDouble();
      } else if (v is Map) {
        out[entry.key] = _normalizeMetadata(
          Map<String, dynamic>.from(v.map((k, val) => MapEntry(k.toString(), val))),
        );
      } else if (v is List) {
        out[entry.key] = _normalizeMetadataList(v);
      } else {
        out[entry.key] = v;
      }
    }
    return out;
  }

  List<dynamic> _normalizeMetadataList(List<dynamic> list) {
    return list.map((e) {
      if (e is num) return e.toDouble();
      if (e is Map) {
        return _normalizeMetadata(
          Map<String, dynamic>.from(e.map((k, val) => MapEntry(k.toString(), val))),
        );
      }
      if (e is List) return _normalizeMetadataList(e);
      return e;
    }).toList();
  }
}
