import 'dart:async';

import 'package:adv/Features/Home/data/repos/home_repo_impl.dart';
import 'package:adv/Features/Home/domain/use_cases/fetch_featured_books_use_case.dart';
import 'package:adv/Features/Home/presentation/manager/featured_books_cubit/featured_books_cubit.dart';
import 'package:adv/core/constant/app_constants.dart';
import 'package:adv/core/exports/main_exports.dart';
import 'package:adv/core/utils/app_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'Features/Home/domain/use_cases/fetch_categories_use_case.dart';
import 'Features/Home/domain/use_cases/fetch_newest_books_use_case.dart';
import 'Features/Home/domain/use_cases/fetch_products_by_category_use_case.dart';
import 'Features/Home/presentation/manager/newest_books_cubit/newest_books_cubit.dart';
import 'Features/cart/data/models/cart_item_model.dart';
import 'Features/cart/presentation/manager/cart_cubit/cart_cubit.dart';
import 'core/services/setup_service_locator.dart';
import 'core/services/simple_bloc_observer.dart';

Future<void> _openCartBox() async {
  const timeout = Duration(seconds: 12);
  final cartBox = await Hive.openBox<CartItemModel>(kCartBox).timeout(timeout);
  getIt.registerSingleton<Box<CartItemModel>>(cartBox);
}

Future<void> _initSupabase() async {
  if (!AppConfig.isConfigured) return;
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );
}

Future<void> _initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CartItemModelAdapter());
  try {
    await _openCartBox();
  } catch (e, st) {
    debugPrint('Hive open failed, clearing cart box and retrying once: $e\n$st');
    try {
      await Hive.deleteBoxFromDisk(kCartBox);
    } catch (_) {}
    await _openCartBox();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.validate();

  try {
    await _initHive();
  } catch (e, st) {
    debugPrint('Hive init failed — continuing without local cart: $e\n$st');
  }

  try {
    await _initSupabase();
  } catch (e, st) {
    debugPrint('Supabase init failed: $e\n$st');
  }

  setupServiceLocator();
  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            return FeaturedBooksCubit(FetchFeaturedBooksUseCase(getIt.get<HomeRepoImpl>()))..fetchFeaturedBooks();
          },
        ),
        BlocProvider(
          create: (context) {
            return NewestBooksCubit(
              FetchNewestBooksUseCase(getIt.get<HomeRepoImpl>()),
              FetchProductsByCategoryUseCase(getIt.get<HomeRepoImpl>()),
              FetchCategoriesUseCase(getIt.get<HomeRepoImpl>()),
            )..fetchNewestBooks();
          },
        ),
        BlocProvider(
          create: (context) {
            return getIt.get<CartCubit>()..loadCart();
          },
        ),
      ],
      child: ScreenUtilInit(
        designSize: AppSize.designSize,
        minTextAdapt: true,
        builder: (context, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark,
            ),
            child: MaterialApp.router(
              routerConfig: AppRouter.router,
              debugShowCheckedModeBanner: false,

              title: 'Halbouni Book Store',
              theme: ThemeData(
                scaffoldBackgroundColor: AppColor.whiteColor,
                // App font. Fall back to the bundled assets/fonts/ if custom fonts are added later.
                fontFamily: 'Rubik',
                useMaterial3: true,
              ),
              builder: (context, child) => responsiveBuilder(context, child),
            ),
          );
        },
      ),
    );
  }
}