import 'package:get/get.dart';

class LoadingController extends GetxController {

  var isLoading = false.obs;

  void startLoading() async {
    isLoading(true);
  }

  void stopLoading() async {
    isLoading(false);
  }

}
