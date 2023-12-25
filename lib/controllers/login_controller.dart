import 'package:get/get.dart';

class LoginController extends GetxController {

  var isLoading = false.obs;

  void startLoading() async {
    isLoading(true);
  }

  void stopLoading() async {
    isLoading(false);
  }

}
