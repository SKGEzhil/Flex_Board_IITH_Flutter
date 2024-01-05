
import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lost_flutter/controllers/cab_sharing_controller.dart';
import 'package:lost_flutter/controllers/loading_controller.dart';
import 'package:lost_flutter/controllers/google_auth_controller.dart';
import 'package:lost_flutter/controllers/post_list_controller.dart';
import 'package:lost_flutter/controllers/profile_controller.dart';
import 'package:lost_flutter/globals.dart';
import 'package:lost_flutter/page_builder.dart';
import 'package:lost_flutter/pages/home.dart';
import 'package:lost_flutter/pages/profile.dart';
import 'package:lost_flutter/utils/shared_prefs.dart';

import '../models.dart';
import '../pages/get_started.dart';
import 'package:get/get.dart';

class ServerUtils {

  final endPoint = 'http://65.0.8.179';
  // final endPoint = 'http://localhost:5000';
  // final endPoint = 'http://10.0.2.2:80';

  Future<String> login(roll_no, password, fcm_token, context) async {

    final networkErrorSnackbar = ErrorSnackBar('Network error', context);
    final serverErrorSnackbar = ErrorSnackBar('Server error', context);
    final wrongCredentialsSnackbar = ErrorSnackBar('Please check your credentials', context);
    final LoadingController loginController = Get.put(LoadingController());
    final ProfileController profileController = Get.put(ProfileController());

    final String url =
        '$endPoint/login'; // replace with your API endpoint

    Map<String, String> headers = {
      'Content-Type':
          'application/json', // adjust the content type based on your API
    };

    Map<String, dynamic> body = {
      'roll_no': roll_no,
      'fcm_token': fcm_token,
      'password': password,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('POST request successful');
        print('Response: ${response.body}');
        if (response.body != 'failed') {

          return response.body;

          // Navigator.of(context).pop();
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => const PageBuilder(),
          //     ));
          // SharedPrefs().setRollNo(roll_no);
          // roll_no_ = roll_no;
          // // username = await getUserDetails(roll_no);
          // final UserDetails userDetails = await getUserDetails(roll_no);
          // print('USER DETAILS: ${userDetails.name}');
          // username_ = userDetails.name;
          // profileController.current_profile_pic.value = userDetails.profilePic;
          // profileController.current_username.value = username_;
          // profileController.current_roll_no.value = roll_no;
          // SharedPrefs().setUsername(username_);
          // SharedPrefs().setProfilePic(userDetails.profilePic);
          // SharedPrefs().setFirstLaunch();
          // SharedPrefs().setAuthToken(response.body);
          // profileController.getUserDetails();
          // print("Login successful, TOKEN: ${await SharedPrefs().getAuthToken()}");
          // loginController.stopLoading();
        } else {
          loginController.stopLoading();
          ScaffoldMessenger.of(context).showSnackBar(wrongCredentialsSnackbar);
          return '';
        }
      } else {
        loginController.stopLoading();
        ScaffoldMessenger.of(context).showSnackBar(serverErrorSnackbar);
        print('POST request failed with status: ${response.statusCode}');
        print('Response: ${response.body}');
        return '';
      }
    } catch (error) {
      Navigator.pop(context);
      loginController.stopLoading();
      ScaffoldMessenger.of(context).showSnackBar(networkErrorSnackbar);
      print('Error sending POST request: $error');
      return '';
    }
  }

  Future<String> register(name, roll_no, email, password, fcmToken, context) async {

    final networkErrorSnackbar = ErrorSnackBar('Network error', context);
    final serverErrorSnackbar = ErrorSnackBar('Server error', context);
    final wrongCredentialsSnackbar = ErrorSnackBar('Please check your credentials', context);
    final alreadyRegistered = ErrorSnackBar('You have already registered.. Proceed to login', context);
    final invalidRollNo = ErrorSnackBar('Invalid Roll no', context);
    final invalidEmail = ErrorSnackBar('Invalid email', context);
    final LoadingController loginController = Get.put(LoadingController());
    final ProfileController profileController = Get.put(ProfileController());
    final String url =
        '$endPoint/register'; // replace with your API endpoint

    Map<String, String> headers = {
      'Content-Type':
      'application/json', // adjust the content type based on your API
    };

    Map<String, dynamic> body = {
      'name': name,
      'roll_no': roll_no,
      'email': email,
      'password': password,
      'fcm_token': fcmToken,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );



      if (response.statusCode == 200) {
        print('POST request successful');
        print('Response: ${response.body}');

        if (response.body == 'invalid_roll_no') {
          loginController.stopLoading();
          ScaffoldMessenger.of(context).showSnackBar(invalidRollNo);
          return '';
        }
        else if (response.body == 'invalid_email') {
          loginController.stopLoading();
          ScaffoldMessenger.of(context).showSnackBar(invalidEmail);
          return '';
        }

        if (response.body != 'failed' && response.body != 'invalid_roll_no' && response.body != 'invalid_email') {

          return response.body;

          // await SharedPrefs().setAuthToken(response.body);
          // bool isRegisterationSuccessful = await loginWithToken(response.body, roll_no, name);
          // if (isRegisterationSuccessful) {
          //   profileController.getUserDetails();
          //   loginController.stopLoading();
          //   Navigator.pushReplacement(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const PageBuilder(),
          //       ));
          // }
          // loginController.stopLoading();
        }
        else if(response.body == 'failed') {
          loginController.stopLoading();
          ScaffoldMessenger.of(context).showSnackBar(alreadyRegistered);
          return '';
        }

        return '';

      } else {
        print('POST request failed with status: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(serverErrorSnackbar);
        print('Response: ${response.body}');
        loginController.stopLoading();
        return '';
      }
    } catch (error) {
      print('Error sending POST request: $error');
      ScaffoldMessenger.of(context).showSnackBar(networkErrorSnackbar);
      loginController.stopLoading();
      return '';
    }
  }

  Future<bool> googleRegister(name, email, roll_no, pfp, fcmToken, context) async {

    final networkErrorSnackbar = ErrorSnackBar('Network error', context);
    final serverErrorSnackbar = ErrorSnackBar('Server error', context);
    final wrongCredentialsSnackbar = ErrorSnackBar('Please check your credentials', context);
    final alreadyRegistered = ErrorSnackBar('You have already registered.. Proceed to login', context);
    final invalidRollNo = ErrorSnackBar('Invalid Roll no', context);
    final invalidEmail = ErrorSnackBar('Invalid email', context);
    final LoadingController loadingController = Get.put(LoadingController());
    final GoogleAuthController googleAuthController = Get.put(GoogleAuthController());
    final ProfileController profileController = Get.put(ProfileController());
    final String url =
        '$endPoint/google_auth'; // replace with your API endpoint

    Map<String, String> headers = {
      'Content-Type':
      'application/json', // adjust the content type based on your API
    };

    Map<String, dynamic> body = {
      'name': name,
      'email': email,
      'roll_no': roll_no,
      'pfp': pfp,
      'fcm_token': fcmToken,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('POST request successful');
        print('Response: ${response.body}');

        if (response.body == 'invalid_roll_no') {
          loadingController.stopLoading();
          ScaffoldMessenger.of(context).showSnackBar(invalidRollNo);
          return false;
        }
        else if (response.body == 'invalid_email') {
          await googleAuthController.signOut();
          loadingController.stopLoading();
          ScaffoldMessenger.of(context).showSnackBar(invalidEmail);
          return false;
        } else if(response.body == 'native_login'){
          loadingController.stopLoading();
          ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar('Please ue native login', context));
          await googleAuthController.signOut();
          return false;

        }

        if(response.body == 'success'){
          SharedPrefs().setAuthMethod('google');
          return true;
        }
        return false;
      } else {
        // await registrationController.googleSignIn.signOut();
        await googleAuthController.signOut();
        print('POST request failed with status: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(serverErrorSnackbar);
        print('Response: ${response.body}');
        loadingController.stopLoading();
        return false;

      }
    } catch (error) {
      print('Error sending POST request: $error');
      ScaffoldMessenger.of(context).showSnackBar(networkErrorSnackbar);
      loadingController.stopLoading();
      return false;

    }
  }

  // Future<bool> googleLogin(roll_no, auth_token, context) async {
  //
  //   final networkErrorSnackbar = ErrorSnackBar('Network error', context);
  //   final serverErrorSnackbar = ErrorSnackBar('Server error', context);
  //   final wrongCredentialsSnackbar = ErrorSnackBar('Please check your credentials', context);
  //   final alreadyRegistered = ErrorSnackBar('You have already registered.. Proceed to login', context);
  //   final invalidRollNo = ErrorSnackBar('Invalid Roll no', context);
  //   final invalidEmail = ErrorSnackBar('Invalid email', context);
  //   final LoadingController loadingController = Get.put(LoadingController());
  //   final RegistrationController registrationController = Get.put(RegistrationController());
  //   final LoginController loginController = Get.put(LoginController());
  //   final ProfileController profileController = Get.put(ProfileController());
  //   final String url =
  //       '$endPoint/google_login'; // replace with your API endpoint
  //
  //   Map<String, String> headers = {
  //     'Content-Type':
  //     'application/json', // adjust the content type based on your API
  //   };
  //
  //   Map<String, dynamic> body = {
  //     'token': auth_token,
  //   };
  //
  //   try {
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: headers,
  //       body: jsonEncode(body),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       print('POST request successful');
  //       print('Response: ${response.body}');
  //
  //       if(response.body == 'success'){
  //         SharedPrefs().setAuthMethod('google');
  //         loadingController.stopLoading();
  //         return true;
  //
  //       } else if (response.body == 'native_login') {
  //         ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar('Please login using native method', context));
  //         loadingController.stopLoading();
  //         return false;
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar('Server Error', context));
  //         loadingController.stopLoading();
  //         return false;
  //       }
  //
  //     } else {
  //       print('POST request failed with status: ${response.statusCode}');
  //       ScaffoldMessenger.of(context).showSnackBar(serverErrorSnackbar);
  //       print('Response: ${response.body}');
  //       loadingController.stopLoading();
  //       return false;
  //     }
  //   } catch (error) {
  //     print('Error sending POST request: $error');
  //     ScaffoldMessenger.of(context).showSnackBar(networkErrorSnackbar);
  //     loadingController.stopLoading();
  //     return false;
  //   }
  // }


  Future<bool> validateRollNo(roll_no, context) async {

    final networkErrorSnackbar = ErrorSnackBar('Network error', context);
    final serverErrorSnackbar = ErrorSnackBar('Server error', context);
    final LoadingController loginController = Get.put(LoadingController());

    final String url =
        '$endPoint/validate_roll_no'; // replace with your API endpoint

    Map<String, String> headers = {
      'Content-Type':
      'application/json', // adjust the content type based on your API
    };

    Map<String, dynamic> body = {
      'roll_no': roll_no,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('POST request successful');
        print('Response: ${response.body}');

        if(response.body == 'invalid_roll_no'){
          ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar('Invalid Roll No', context));
          loginController.stopLoading();
          return false;
        } else{
          return true;
        }

      } else {
        loginController.stopLoading();
        ScaffoldMessenger.of(context).showSnackBar(serverErrorSnackbar);
        print('POST request failed with status: ${response.statusCode}');
        print('Response: ${response.body}');
        return false;
      }
    } catch (error) {
      Navigator.pop(context);
      loginController.stopLoading();
      ScaffoldMessenger.of(context).showSnackBar(networkErrorSnackbar);
      print('Error sending POST request: $error');
      return false;
    }
  }


  Future<bool> loginWithToken(token, roll_no, name) async {

    final String url =
        '$endPoint/token_auth'; // replace with your API endpoint

    Map<String, String> headers = {
      'Content-Type':
      'application/json', // adjust the content type based on your API
    };

    Map<String, dynamic> body = {
      'token': token,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('POST request successful');
        print('Response: ${response.body}');
        if (response.body == 'success') {
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => const Home(),
          //     ));


          // roll_no_ = roll_no;
          // SharedPrefs().setRollNo(roll_no_);
          // username_ = name;
          // SharedPrefs().setUsername(username_);
          // SharedPrefs().setFirstLaunch();
          return true;
        }
        return false;
      } else {
        print('POST request failed with status: ${response.statusCode}');
        print('Response: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Error sending POST request: $error');
      return false;
    }
  }

  Future<void> logout(roll_no, fcm_token, context) async {

    final networkErrorSnackbar = ErrorSnackBar('Network error', context);
    final serverErrorSnackbar = ErrorSnackBar('Server error', context);
    final wrongCredentialsSnackbar = ErrorSnackBar('Please check your credentials', context);
    final LoadingController loginController = Get.put(LoadingController());

    final String url =
        '$endPoint/logout'; // replace with your API endpoint

    Map<String, String> headers = {
      'Content-Type':
      'application/json', // adjust the content type based on your API
    };

    Map<String, dynamic> body = {
      'roll_no': roll_no,
      'fcm_token': fcm_token,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('POST request successful');
        print('Response: ${response.body}');
        if (response.body != 'failed') {

        }
      }
    } catch (error) {
      print('Network error: $error');
    }
  }

  Future<void> updateProfile(roll_no, pfp, name) async {
    final String url =
        '$endPoint/update_profile'; // replace with your API endpoint

    final ProfileController profileController = Get.put(ProfileController());

    Map<String, String> headers = {
      'Content-Type':
      'application/json', // adjust the content type based on your API
    };

    Map<String, dynamic> body = {
      'roll_no': roll_no,
      'name': name,
      'pfp': pfp,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('POST request successful');
        print('Response: ${response.body}');

      } else {
        print('POST request failed with status: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      print('Error sending POST request: $error');
    }
  }


  Future<void> createPost(roll_no, subject, content, image, List<String> tags, cab, context) async {
    final String url =
        '$endPoint/create_post'; // replace with your API endpoint
    final CabSharingController cabSharingController = Get.put(CabSharingController());
    final LoadingController loadingController = Get.put(LoadingController());
    final networkErrorSnackbar = ErrorSnackBar('Network error', context);
    final serverErrorSnackbar = ErrorSnackBar('Server error', context);
    final PostListController postListController = Get.put(PostListController());

    Map<String, String> headers = {
      'Content-Type':
      'application/json', // adjust the content type based on your API
    };

    Map<String, dynamic> body = {
      'roll_no': roll_no,
      'subject': subject,
      'content': content,
      'image': image,
      'tags': tags,
      'cab': cab,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('POST request successful');
        print('Response: ${response.body}');
        if (response.body == 'success') {
          post_image_link = "";
          cabSharingController.fromLocation.value = "From";
          cabSharingController.toLocation.value = "To";
          postListController.fetchData();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const PageBuilder(),
              ));
          loadingController.stopLoading();
        }
      } else {
        print('POST request failed with status: ${response.statusCode}');
        print('Response: ${response.body}');
        loadingController.stopLoading();
        ScaffoldMessenger.of(context).showSnackBar(serverErrorSnackbar);
      }
    } catch (error) {
      print('Error sending POST request: $error');
      loadingController.stopLoading();
      ScaffoldMessenger.of(context).showSnackBar(networkErrorSnackbar);
    }
  }

  Future<List<Post>> getPosts() async {
    // Replace the URL with the actual API endpoint you want to call
    var url = Uri.parse('$endPoint/get_posts');

    // Make the GET request
    var response = await http.get(url);

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Parse the JSON response
      // print('Response data: ${response.body}');

      // Your JSON data as a string
      String jsonString = response.body;

      // Decode the JSON string into a List of maps
      List<dynamic> jsonList = jsonDecode(jsonString);

      // Convert each map to a Post object
      List<Post> posts = jsonList.map((json) => Post.fromJson(json)).toList();

      // Access the data in Dart objects
      // posts.forEach((post) {
      //   print('Post ID: ${post.id}');
      //   print('Roll No: ${post.rollNo}');
      //   print('Name: ${post.name}');
      //   print('Subject: ${post.subject}');
      //   print('Content: ${post.content}');
      //   print('Image: ${post.image}');
      //   print('tags: ${post.tags}');
      //   print('Date: ${post.date}');
      //   print('Cab From: ${post.cabFrom}');
      //   print('Cab To: ${post.cabTo}');
      //   print('Cab Date: ${post.cabDate}');
      //   print('\n');
      // });

      return posts;

    } else {
      // Handle errors
      print('Error: ${response.statusCode}');
      return [];
    }
  }

  Future<String> uploadImage(_image, isPfp) async {
    if (_image == null) {
      // Handle case when no image is selected
      return '';
    }

    final url = '$endPoint/upload'; // Replace with your Flask server endpoint


    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        // Handle success
        print('Image uploaded successfully');
        final responseBody = await response.stream.bytesToString();
        print(responseBody);
        if (isPfp) {
          return responseBody;
        } else {
          post_image_link = responseBody;
          return responseBody;
        }
      } else {
        // Handle error
        print('Failed to upload image. Status code: ${response.statusCode}');
        return "";
      }
    } catch (error) {
      // Handle network or other errors
      print('Error during image upload: $error');
      return "";
    }
  }

  Future<void> addReply(roll_no, reply, post_id, context) async {
    final String url =
        '$endPoint/add_reply'; // replace with your API endpoint

    final LoadingController loadingController = Get.put(LoadingController());
    final networkErrorSnackbar = ErrorSnackBar('Network error', context);
    final serverErrorSnackbar = ErrorSnackBar('Server error', context);

    Map<String, String> headers = {
      'Content-Type':
      'application/json', // adjust the content type based on your API
    };

    Map<String, dynamic> body = {
      'roll_no': roll_no,
      'post_id': post_id,
      'reply': reply,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('POST request successful');
        print('Response: ${response.body}');
        loadingController.stopLoading();
      } else {
        print('POST request failed with status: ${response.statusCode}');
        print('Response: ${response.body}');
        loadingController.stopLoading();
        ScaffoldMessenger.of(context).showSnackBar(serverErrorSnackbar);
      }
    } catch (error) {
      print('Error sending POST request: $error');
      loadingController.stopLoading();
      ScaffoldMessenger.of(context).showSnackBar(networkErrorSnackbar);
    }
  }

  Future<List<Reply>> getReplies(post_id) async {
    final String url =
        '$endPoint/get_replies'; // replace with your API endpoint

    Map<String, String> headers = {
      'Content-Type':
      'application/json', // adjust the content type based on your API
    };

    Map<String, dynamic> body = {
      'post_id': post_id,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('POST request successful');
        print('Response: ${response.body}');
        if (response.body == 'success') {
          print("Got replies successfully");
        }

        // Parse the JSON response
        // Your JSON data as a string
        String jsonString = response.body;

        // Decode the JSON string into a List of maps
        List<dynamic> jsonList = jsonDecode(jsonString);

        // Convert each map to a Post object
        List<Reply> replies = jsonList.map((json) => Reply.fromJson(json)).toList();

        return replies;

      } else {
        print('POST request failed with status: ${response.statusCode}');
        print('Response: ${response.body}');
        return [];
      }
    } catch (error) {
      print('Error sending POST request: $error');
      return [];
    }
  }

  Future<UserDetails> getUserDetails(roll_no) async {
    final String url =
        '$endPoint/get_user_details'; // replace with your API endpoint

    Map<String, String> headers = {
      'Content-Type':
      'application/json', // adjust the content type based on your API
    };

    Map<String, dynamic> body = {
      'roll_no': roll_no,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('POST request successful');
        print('Respo0000nse: ${response.body}');
        // return response.body;

        final userJson = jsonDecode(response.body);
        print('USER DETAILS:');

        final UserDetails user = UserDetails(
          rollNo: userJson['roll_no'],
          name: userJson['name'],
          profilePic: userJson['pfp'],
        );

        print('USER DETAILS: ${user.name}');

        return user;

      } else {
        print('POST request failed with status: ${response.statusCode}');
        print('Response: ${response.body}');
        // return "";
        print('USER DETAILS:');
        return UserDetails(rollNo: '', name: '', profilePic: '');
      }
    } catch (error) {
      print('Error sending POST request: $error');
      print('USER DETAILS error:');
      // return "";
      return UserDetails(rollNo: '', name: '', profilePic: '');

    }
  }

  Future<List<String>> getSeenPosts(roll_no) async {
    final String url =
        '$endPoint/get_opened'; // replace with your API endpoint

    Map<String, String> headers = {
      'Content-Type':
      'application/json', // adjust the content type based on your API
    };

    Map<String, dynamic> body = {
      'roll_no': roll_no,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('POST request successful');
        print('Response: ${response.body}');


        List<String> posts = seenPosts().seenPostsFromJson(response.body);

        posts.forEach((element) {
          print(element);
        });

        return posts;

      } else {
        print('POST request failed with status: ${response.statusCode}');
        print('Response: ${response.body}');
        return [];
      }
    } catch (error) {
      print('Error sending POST request: $error');
      return [];
    }
  }

  Future<void> setSeenPosts(roll_no, post_id) async {
    final String url =
        '$endPoint/set_opened'; // replace with your API endpoint

    Map<String, String> headers = {
      'Content-Type':
      'application/json', // adjust the content type based on your API
    };

    Map<String, dynamic> body = {
      'roll_no': roll_no,
      'post_id': post_id,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('POST request successful');
        print('Response: ${response.body}');
      } else {
        print('POST request failed with status: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      print('Error sending POST request: $error');
    }
  }

  Future<void> sendNotification() async {
    // Replace the URL with the actual API endpoint you want to call
    var url = Uri.parse('$endPoint/send_notification');

    // Make the GET request
    var response = await http.get(url);

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Parse the JSON response
      print('DONE');

    } else {
      // Handle errors
      print('Error: ${response.statusCode}');
    }
  }

  Future<bool> isConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("Connected");
        return true;
      } else {
        print("Not connected");
        return false;
      }
    } on SocketException catch (_) {
      print("Not connected");
      return false;
    }
  }

  Future<List<Reply>> getAllReplies(roll_no) async {
    final String url =
        '$endPoint/get_all_replies'; // replace with your API endpoint

    Map<String, String> headers = {
      'Content-Type':
      'application/json', // adjust the content type based on your API
    };

    Map<String, dynamic> body = {
      'roll_no': roll_no
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('POST request successful');
        print('Response: ${response.body}');
        if (response.body == 'success') {
          print("Got replies successfully");
        }

        // Parse the JSON response
        // Your JSON data as a string
        String jsonString = response.body;

        // Decode the JSON string into a List of maps
        List<dynamic> jsonList = jsonDecode(jsonString);

        // Convert each map to a Post object
        List<Reply> replies = jsonList.map((json) => Reply.fromJson(json)).toList();

        return replies;

      } else {
        print('POST request failed with status: ${response.statusCode}');
        print('Response: ${response.body}');
        return [];
      }
    } catch (error) {
      print('Error sending POST request: $error');
      return [];
    }
  }



  SnackBar ErrorSnackBar(error_message, BuildContext context) {
    return SnackBar(
      content: Text('$error_message'),
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      // margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      dismissDirection: DismissDirection.down,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
      backgroundColor: Colors.red.shade300,
    );
  }

}
