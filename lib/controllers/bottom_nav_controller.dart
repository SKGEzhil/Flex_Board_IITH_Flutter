import 'package:get/get.dart';

class BottomNavController extends GetxController {
  var currentIndex = 0.obs;
  var isShow = true.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  void changeShow(bool show) {
    isShow.value = show;
  }
}