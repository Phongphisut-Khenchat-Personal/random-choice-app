import 'package:get/get.dart';
import '../controllers/choice_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WheelController>(() => WheelController());
  }
}