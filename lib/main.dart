import 'package:adv/Features/Home/domain/entities/book_entity.dart';
import 'package:adv/Features/splash/presentation/views/splash_view.dart';
import 'package:adv/core/constant/app_constants.dart';
import 'package:adv/core/exports/main_exports.dart';
import 'package:adv/core/routing/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(BookEntityAdapter());
 await Hive.openBox<BookEntity>(kFeaturedBox);
 await Hive.openBox<BookEntity>(kNewestBox);
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: AppSize.designSize,
      minTextAdapt: true,
      builder: (context, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
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
    );
  }
}

