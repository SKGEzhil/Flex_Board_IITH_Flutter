import 'package:get/get.dart';
import 'package:lost_flutter/utils/server_utils.dart';

import '../globals.dart';
import '../models.dart';
import '../utils/shared_prefs.dart';
import 'network_connectivity_controller.dart';

class PostListController extends GetxController {

  List<Post> items = <Post>[].obs;
  List<Post> result = <Post>[].obs;
  List<UserDetails> knownUsers = <UserDetails>[].obs;
  Post notificationPost = Post(
    id: '',
    rollNo: '',
    name: '',
    subject: '',
    tags: [''],
    date: '',
    image: '', content: '', cabFrom: '', cabTo: '', cabDate: '', profilePic: '',
  );
  final serverUtils = ServerUtils();
  final sharedPrefs = SharedPrefs();
  final NetworkController networkController = Get.put(NetworkController());

  Future<void> fetchData() async {
    if(isConnected){
      print('GETTING POSTS');
      items = await serverUtils.getPosts();

      sharedPrefs.storePosts(items);
    } else {
      print('GETTING POSTS FROM SHARED PREFS');
      items = await sharedPrefs.getPosts();
    }
    result = items;
    result.forEach((element) {print('Element');});
    update();

  }

  Future<Post> notificationHandler(postId, type) async {
    if(type == 'reply'){
      final posts = await sharedPrefs.getPosts();
      notificationPost = posts.where((element) => element.id == postId).first;
      return notificationPost;
    } else {
      final posts = await serverUtils.getPosts();
      notificationPost = posts.where((element) => element.id == postId).first;
      return notificationPost;
    }
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
    print('PostListController onInit');
    fetchData();
  }



}