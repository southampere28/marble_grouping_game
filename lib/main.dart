import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:marble_grouping_game/app_routes.dart';
import 'package:marble_grouping_game/utils/app_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double maxHeight = constraints.maxHeight;
      double maxWidth = constraints.maxWidth;

      return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AppSize.init(
              context,
              containerWidth: maxWidth,
              containerHeight: maxHeight,
            );
          });

          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Marble Group Game',
            initialRoute: AppRoutes.initialRoute,
            getPages: AppRoutes.routes,
            themeMode: ThemeMode.system,
          );
        },
      );
    });
  }
}
