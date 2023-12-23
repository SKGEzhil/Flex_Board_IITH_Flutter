import 'package:get/get.dart';
import 'package:lost_flutter/utils/server_utils.dart';

import '../models.dart';

class PostListController extends GetxController {

  List<Post> items = <Post>[].obs;
  List<Post> result = <Post>[].obs;
  final serverUtils = ServerUtils();

  Future<void> fetchData() async {
    List<Post> posts =
    await serverUtils.getPosts(); // Wait for the future to complete
    items = posts;
    result = items;
    update();
  }

  void filterSearchResults(String query) {
    print(query);

    if (query.isEmpty || query == '') {
      result = items;
      return;
    } else {
      result = items
          .where(
              (post) =>
              post.subject.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    update(); // This is important to update the UI
  }

  void filterTagResults(String query) {
    print(query);

    if (query.isEmpty) {
      result = items;
      return;
    } else {
      result = items
          .where(
              (post) =>
              post.tags.contains(query))
          .toList();
    }
    update(); // This is important to update the UI
  }

  void resetSearch() {
    result = items;
    update();
  }

  void userPosts(String roll_no) {
    result = items
        .where(
            (post) =>
        post.rollNo == roll_no)
        .toList();
    update();
  }

    @override
  void onInit() {
    super.onInit();
    fetchData();
  }



}