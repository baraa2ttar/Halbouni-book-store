import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../Features/Auth/data/repos/auth_repo_impl.dart';
import '../../Features/Auth/domain/repos/auth_repo.dart';
import '../../Features/Auth/presentation/manager/auth_cubit/auth_cubit.dart';
import '../../Features/Home/data/repos/home_repo_impl.dart';
import '../../Features/onboarding/data/datasources/onboarding_local_data_source.dart';
import '../../Features/onboarding/data/repos/onboarding_repo_impl.dart';
import '../../Features/onboarding/domain/repos/onboarding_repo.dart';
import '../../Features/onboarding/domain/use_cases/complete_onboarding_use_case.dart';
import '../../Features/onboarding/domain/use_cases/is_onboarding_completed_use_case.dart';
import 'api_service.dart';
final getIt = GetIt.instance;

Dio _createDio() {
  final dio = Dio();
  dio.options
    ..connectTimeout = const Duration(seconds: 20)
    ..receiveTimeout = const Duration(seconds: 30)
    ..sendTimeout = const Duration(seconds: 20);
  return dio;
}

void setupServiceLocator() {
  getIt.registerSingleton<ApiService>(ApiService(_createDio()));

  getIt.registerLazySingleton<AuthRepo>(() => AuthRepoImpl());
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt.get<AuthRepo>()));

  getIt.registerLazySingleton<HomeRepoImpl>(
    () => HomeRepoImpl(supabase: Supabase.instance.client),
  );

  getIt.registerLazySingleton<OnboardingLocalDataSource>(
    () => OnboardingLocalDataSource(),
  );
  getIt.registerLazySingleton<OnboardingRepo>(
    () {
      SupabaseClient? client;
      try {
        client = Supabase.instance.client;
      } catch (_) {}
      return OnboardingRepoImpl(
        getIt.get<OnboardingLocalDataSource>(),
        client,
      );
    },
  );
  getIt.registerLazySingleton<IsOnboardingCompletedUseCase>(
    () => IsOnboardingCompletedUseCase(getIt.get<OnboardingRepo>()),
  );
  getIt.registerLazySingleton<CompleteOnboardingUseCase>(
    () => CompleteOnboardingUseCase(getIt.get<OnboardingRepo>()),
  );
}


