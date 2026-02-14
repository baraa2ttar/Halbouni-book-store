import 'package:adv/core/exports/main_exports.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,

            title: 'Graduation',
            theme: ThemeData(
              scaffoldBackgroundColor: AppColor.whiteColor,
              fontFamily: 'Rubik',
              useMaterial3: true,
            ),
            builder: (context, child) => responsiveBuilder(context, child),
            initialRoute: Routes.splash,
            getPages: appPages,
          ),
        );
      },
    );
  }
}
