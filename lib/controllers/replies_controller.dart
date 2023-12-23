import 'package:get/get.dart';

import '../globals.dart';
import '../models.dart';
import '../utils/server_utils.dart';

class RepliesController extends GetxController {
  var isOpened = false.obs;
  List<Reply> items = <Reply>[].obs;
  final serverUtils = ServerUtils();

  Future<void> fetchData() async {
    List<Reply> replies = await serverUtils
        .getAllReplies(roll_no_); // Wait for the future to complete
    items = replies;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }


}