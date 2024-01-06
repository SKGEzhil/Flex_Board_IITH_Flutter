import 'package:get/get.dart';

class BottomNavController extends GetxController {

  /// Variables declaration
  var currentIndex = 0.obs;
  var isShow = true.obs;

  /// To change the current index of the bottom navigation bar
  void changeIndex(int index) {
    currentIndex.value = index;
  }

  /// To change the visibility of the bottom navigation bar
  void changeShow(bool show) {
    isShow.value = show;
  }
}