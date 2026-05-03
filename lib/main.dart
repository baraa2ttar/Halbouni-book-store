import 'dart:async';

import 'package:adv/Features/Home/data/repos/home_repo_impl.dart';
import 'package:adv/Features/Home/domain/entities/book_entity.dart';
import 'package:adv/Features/Home/domain/use_cases/fetch_featured_books_use_case.dart';
import 'package:adv/Features/Home/presentation/manager/featured_books_cubit/featured_books_cubit.dart';
import 'package:adv/core/constant/app_constants.dart';
import 'package:adv/core/exports/main_exports.dart';
import 'package:adv/core/routing/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'Features/Home/domain/use_cases/fetch_newest_books_use_case.dart';
import 'Features/Home/presentation/manager/newest_books_cubit/newest_books_cubit.dart';
import 'core/services/setup_service_locator.dart';
import 'core/services/simple_bloc_observer.dart';

Future<void> _openHiveBoxes() async {
  const timeout = Duration(seconds: 12);
  await Hive.openBox<BookEntity>(kFeaturedBox).timeout(timeout);
  await Hive.openBox<BookEntity>(kNewestBox).timeout(timeout);
}

Future<void> _initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(BookEntityAdapter());
  try {
    await _openHiveBoxes();
  } catch (e, st) {
    debugPrint('Hive open failed, clearing boxes and retrying once: $e\n$st');
    try {
      await Hive.deleteBoxFromDisk(kFeaturedBox);
    } catch (_) {}
    try {
      await Hive.deleteBoxFromDisk(kNewestBox);
    } catch (_) {}
    await _openHiveBoxes();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await _initHive();
  } catch (e, st) {
    debugPrint('Hive init failed — continuing without local cache: $e\n$st');
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
              FetchNewestBooksUseCase(
                  getIt.get<HomeRepoImpl>()

              ),
            );
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

              title: 'Graduation',
              theme: ThemeData(
                scaffoldBackgroundColor: AppColor.whiteColor,
                // Avoid google_fonts runtime download on first frame (can hang offline / bad DNS).
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
