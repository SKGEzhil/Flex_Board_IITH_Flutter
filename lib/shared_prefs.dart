import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
   SharedPreferences? _sharedPrefs;

  Future<int> checkFirstLaunch() async {
    _sharedPrefs = await SharedPreferences.getInstance();

    // Check if the 'firstLaunch' key exists
    bool firstLaunch = _sharedPrefs?.getBool('firstLaunch') ?? true;

    // Update the flag for subsequent launches
    if (firstLaunch) {
      print("first time");
      return 1;
    }
    else {
      print("not first time");
      return 0;
    }
  }

  Future<void> setFirstLaunch() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    await _sharedPrefs?.setBool('firstLaunch', false);
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

  // String getRollNo() => _sharedPrefs!.getString('roll_no') ?? '';

  Future<void> setUsername(String username) async{
    _sharedPrefs = await SharedPreferences.getInstance();
    await _sharedPrefs!.setString('username', username);
  }

   Future<String> getUsername() async{
     _sharedPrefs = await SharedPreferences.getInstance();
     final username = await _sharedPrefs!.getString('username') ?? '';
      return username;
   }


  // String getUsername() => _sharedPrefs!.getString('username') ?? '';

  // static Future<void> setPostImageLink(String post_image_link) async =>
  //     await _sharedPrefs!.setString('post_image_link', post_image_link);
  //
  // static String getPostImageLink() =>
  //     _sharedPrefs!.getString('post_image_link') ?? '';
}