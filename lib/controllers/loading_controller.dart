import 'package:get/get.dart';

class LoadingController extends GetxController {

  /// Observables
  var isLoading = false.obs;

  /// To start loading
  void startLoading() async {
    isLoading(true);
  }

  /// To stop loading
  void stopLoading() async {
    isLoading(false);
  }

}
