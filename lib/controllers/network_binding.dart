import 'package:get/get.dart';
import 'package:lost_flutter/controllers/network_connectivity_controller.dart';


class NetworkBinding extends Bindings{

  // dependence injection attach our class.
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<NetworkController>(() => NetworkController());
  }

}