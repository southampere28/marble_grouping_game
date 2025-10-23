import 'package:get/get.dart';
import 'package:marble_grouping_game/features/home/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}
