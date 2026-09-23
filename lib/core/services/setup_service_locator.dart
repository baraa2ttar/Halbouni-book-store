import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../Features/auth/data/repos/auth_repo_impl.dart';
import '../../Features/auth/domain/repos/auth_repo.dart';
import '../../Features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import '../../Features/Home/data/repos/home_repo_impl.dart';
import '../../Features/Home/domain/repos/home_repo.dart';
import '../../Features/cart/data/models/cart_item_model.dart';
import '../../Features/cart/data/repos/cart_repo_impl.dart';
import '../../Features/cart/domain/repos/cart_repo.dart';
import '../../Features/cart/presentation/manager/cart_cubit/cart_cubit.dart';
import '../../Features/orders/data/repos/orders_repo_impl.dart';
import '../../Features/orders/domain/repos/orders_repo.dart';
import '../../Features/orders/presentation/manager/checkout_cubit/checkout_cubit.dart';
import '../../Features/onboarding/data/datasources/onboarding_local_data_source.dart';
import '../../Features/onboarding/data/repos/onboarding_repo_impl.dart';
import '../../Features/onboarding/domain/repos/onboarding_repo.dart';
import '../../Features/onboarding/domain/use_cases/complete_onboarding_use_case.dart';
import '../../Features/onboarding/domain/use_cases/is_onboarding_completed_use_case.dart';
import '../../Features/profile/data/repos/profile_repo_impl.dart';
import '../../Features/profile/domain/repos/profile_repo.dart';
import '../../Features/profile/presentation/manager/profile_cubit/profile_cubit.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<ProfileRepo>(() => ProfileRepoImpl());
  getIt.registerLazySingleton<OnboardingLocalDataSource>(
    () => OnboardingLocalDataSource(),
  );
  getIt.registerLazySingleton<OnboardingRepo>(
    () => OnboardingRepoImpl(
      getIt.get<OnboardingLocalDataSource>(),
      getIt.get<ProfileRepo>(),
    ),
  );
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(
      profileRepo: getIt.get<ProfileRepo>(),
      onboardingRepo: getIt.get<OnboardingRepo>(),
    ),
  );
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt.get<AuthRepo>()));

  getIt.registerLazySingleton<HomeRepo>(
    () => HomeRepoImpl(supabase: Supabase.instance.client),
  );
  getIt.registerLazySingleton<HomeRepoImpl>(
    () => HomeRepoImpl(supabase: Supabase.instance.client),
  );
  getIt.registerLazySingleton<IsOnboardingCompletedUseCase>(
    () => IsOnboardingCompletedUseCase(getIt.get<OnboardingRepo>()),
  );
  getIt.registerLazySingleton<CompleteOnboardingUseCase>(
    () => CompleteOnboardingUseCase(getIt.get<OnboardingRepo>()),
  );

  getIt.registerLazySingleton<OrdersRepo>(() => OrdersRepoImpl());
  getIt.registerFactory<CheckoutCubit>(
    () => CheckoutCubit(getIt.get<OrdersRepo>(), getIt.get<CartRepo>()),
  );

  getIt.registerLazySingleton<CartRepo>(
    () => CartRepoImpl(box: getIt.get<Box<CartItemModel>>()),
  );
  getIt.registerLazySingleton<CartCubit>(
    () => CartCubit(getIt.get<CartRepo>()),
  );

  getIt.registerFactory<ProfileCubit>(
    () => ProfileCubit(
      getIt.get<ProfileRepo>(),
      getIt.get<HomeRepo>(),
      getIt.get<AuthRepo>(),
    ),
  );
}