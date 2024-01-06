import 'package:get/get.dart';
import 'package:lost_flutter/controllers/bottom_nav_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models.dart';

class SharedPrefs {
  SharedPreferences? _sharedPrefs;
  final BottomNavController bottomNavController = Get.put(BottomNavController());

  Future<void> setAuthMethod(authMethod) async {
    _sharedPrefs = await SharedPreferences.getInstance();
    await _sharedPrefs?.setString('auth_method', authMethod);
  }

  Future<String> getAuthMethod() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    final authMethod = _sharedPrefs!.getString('auth_method') ?? '';
    return authMethod;
  }

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
    await _sharedPrefs!.setString('auth_token', '');
    await _sharedPrefs!.setString('auth_method', '');
    await _sharedPrefs!.setString('seen_posts', '');
    await _sharedPrefs!.setString('draft_subject', '');
    await _sharedPrefs!.setString('draft_body', '');
    await _sharedPrefs!.setString('pfp', '');

    bottomNavController.changeIndex(0);
  }

  Future<void> init() async =>
      _sharedPrefs = await SharedPreferences.getInstance();

  Future<void> setRollNo(String rollNo) async {
    _sharedPrefs = await SharedPreferences.getInstance();
    await _sharedPrefs!.setString('roll_no', rollNo);
  }

  Future<String> getRollNo() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    final rollno = _sharedPrefs!.getString('roll_no') ?? '';
    return rollno;
  }

  Future<void> setUsername(String username) async {
    _sharedPrefs = await SharedPreferences.getInstance();
    await _sharedPrefs!.setString('username', username);
  }

  Future<String> getUsername() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    final username = _sharedPrefs!.getString('username') ?? '';
    return username;
  }

  Future<void> setProfilePic(String pfp) async {
    _sharedPrefs = await SharedPreferences.getInstance();
    await _sharedPrefs!.setString('pfp', pfp);
  }

  Future<String> getProfilePic() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    final pfp = _sharedPrefs!.getString('pfp') ?? '';
    return pfp;
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

  Future<void> storeSeenPosts(List<String> seenPosts) async {
    _sharedPrefs = await SharedPreferences.getInstance();
    final seenPostsJsonString = SeenPosts().seenPostsToJson(seenPosts);
    await _sharedPrefs!.setString('seen_posts', seenPostsJsonString);
  }

  Future<List<String>> getSeenPosts() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    final seenPostsList = SeenPosts().seenPostsFromJson(_sharedPrefs!.getString('seen_posts') ?? '').toList();
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
    final token = _sharedPrefs!.getString('auth_token') ?? '';
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
    final subject = _sharedPrefs!.getString('draft_subject') ?? '';
    final body = _sharedPrefs!.getString('draft_body') ?? '';
    PostDraft post = PostDraft(subject: subject, content: body);
    return post;
  }

}
