import 'package:get/get.dart';
import 'package:lost_flutter/controllers/bottom_nav_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models.dart';

class SharedPrefs {
  SharedPreferences? _sharedPrefs;
  final BottomNavController bottomNavController = Get.put(BottomNavController());

  Future<int> checkFirstLaunch() async {
    _sharedPrefs = await SharedPreferences.getInstance();

    // Check if the 'firstLaunch' key exists
    bool firstLaunch = _sharedPrefs?.getBool('firstLaunch') ?? true;

    // Update the flag for subsequent launches
    if (firstLaunch) {
      print("first time");
      return 1;
    } else {
      print("not first time");
      return 0;
    }
  }

  Future<void> setFirstLaunch() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    await _sharedPrefs?.setBool('firstLaunch', false);
  }

  Future<void> logout() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    List<String> postListString = [];
    await _sharedPrefs?.setBool('firstLaunch', true);
    await _sharedPrefs!.setString('roll_no', '');
    await _sharedPrefs!.setString('username', '');
    await _sharedPrefs!.setStringList('posts', postListString);
    bottomNavController.changeIndex(0);
  }

  Future<void> init() async =>
      _sharedPrefs = await SharedPreferences.getInstance();

  Future<void> setRollNo(String roll_no) async {
    _sharedPrefs = await SharedPreferences.getInstance();
    await _sharedPrefs!.setString('roll_no', roll_no);
  }

  Future<String> getRollNo() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    final rollno = await _sharedPrefs!.getString('roll_no') ?? '';
    return rollno;
  }

  Future<void> setUsername(String username) async {
    _sharedPrefs = await SharedPreferences.getInstance();
    await _sharedPrefs!.setString('username', username);
  }

  Future<String> getUsername() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    final username = await _sharedPrefs!.getString('username') ?? '';
    return username;
  }

  Future<void> storePosts(List<Post> posts) async {
    _sharedPrefs = await SharedPreferences.getInstance();
    List<String> postListString =
        posts.map((post) => json.encode(post.toJson())).toList();
    postListString.forEach((element) async {
      print('element: $element');
    });
    await _sharedPrefs!.setStringList('posts', postListString);
  }

  Future<List<Post>> getPosts() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    List<String> postListString = _sharedPrefs!.getStringList('posts') ?? [];
    List<Post> posts =
        postListString.map((post) => Post.fromJson(json.decode(post))).toList();
    return posts;
  }

  Future<void> storeSeenPosts(List<String> seen_posts) async {
    _sharedPrefs = await SharedPreferences.getInstance();
    final seenPostsJsonString = seenPosts().seenPostsToJson(seen_posts);
    await _sharedPrefs!.setString('seen_posts', seenPostsJsonString);
  }

  Future<List<String>> getSeenPosts() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    final seenPostsList = seenPosts().seenPostsFromJson(_sharedPrefs!.getString('seen_posts') ?? '').toList();
    return seenPostsList;
  }


  // set auth token
  Future<void> setAuthToken(String token) async {
    _sharedPrefs = await SharedPreferences.getInstance();
    await _sharedPrefs!.setString('auth_token', token);
  }

  // get auth token
  Future<String> getAuthToken() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    final token = await _sharedPrefs!.getString('auth_token') ?? '';
    return token;
  }

  // set auth token
  Future<void> saveDraft(String subject, String body) async {
    _sharedPrefs = await SharedPreferences.getInstance();
    await _sharedPrefs!.setString('draft_subject', subject);
    await _sharedPrefs!.setString('draft_body', body);
  }

  Future<PostDraft> getDraft() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    final subject = await _sharedPrefs!.getString('draft_subject') ?? '';
    final body = await _sharedPrefs!.getString('draft_body') ?? '';
    PostDraft post = PostDraft(subject: subject, content: body);
    return post;
  }

}
