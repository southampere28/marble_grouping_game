import 'package:get/get.dart';
import '../../app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    await Future.delayed(Duration(seconds: 3));
    Get.offNamed(AppRoutes.homePage);
  }
}
