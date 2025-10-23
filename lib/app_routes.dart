import 'package:get/get.dart';
import 'package:marble_grouping_game/features/home/home_binding.dart';
import 'package:marble_grouping_game/features/home/home_page.dart';
import 'package:marble_grouping_game/features/splash/splash_binding.dart';
import 'package:marble_grouping_game/features/splash/splash_page.dart';

class AppRoutes {
  // variable name of routes
  static const initialRoute = splashPage;
  static const splashPage = '/splash-page';
  static const homePage = '/home-page';
  // ...

  // all routes
  static final routes = <GetPage>[
    GetPage(
      name: splashPage, 
      page: () => SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: homePage, 
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
  ];
}
