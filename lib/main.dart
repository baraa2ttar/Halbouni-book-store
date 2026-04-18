import 'package:adv/Features/Home/data/repos/home_repo_impl.dart';
import 'package:adv/Features/Home/domain/entities/book_entity.dart';
import 'package:adv/Features/Home/domain/use_cases/fetch_featured_books_use_case.dart';
import 'package:adv/Features/Home/presentation/manager/featured_books_cubit/featured_books_cubit.dart';
import 'package:adv/core/constant/app_constants.dart';
import 'package:adv/core/exports/main_exports.dart';
import 'package:adv/core/routing/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'Features/Home/domain/use_cases/fetch_newest_books_use_case.dart';
import 'Features/Home/presentation/manager/newest_books_cubit/newest_books_cubit.dart';
import 'core/services/setup_service_locator.dart';
import 'core/services/simple_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(BookEntityAdapter());
  setupServiceLocator();
  await Hive.openBox<BookEntity>(kFeaturedBox);
  await Hive.openBox<BookEntity>(kNewestBox);
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
                textTheme: GoogleFonts.montserratTextTheme(),
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
