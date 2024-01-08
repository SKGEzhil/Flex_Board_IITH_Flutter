import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lost_flutter/controllers/cab_sharing_controller.dart';
import 'package:lost_flutter/controllers/loading_controller.dart';
import 'package:lost_flutter/controllers/google_auth_controller.dart';
import 'package:lost_flutter/controllers/post_list_controller.dart';
import 'package:lost_flutter/globals.dart';
import 'package:lost_flutter/page_builder.dart';
import 'package:lost_flutter/strings.dart';

import '../models.dart';
import 'package:get/get.dart';

class ServerUtils {

  /// Endpoint of the server (For testing purpose only)
  final endPoint = 'https://65.0.8.179';
  // final endPoint = 'http://localhost:5000';
  // final endPoint = 'http://10.0.2.2:80';

  /** SERVER OPERATIONS **/

  /// Sends a POST request to the server to login the user
  Future<String> login(rollNo, password, fcmToken, context) async {

    final LoadingController loadingController = Get.put(LoadingController());

    final String url = '$endPoint/login'; // replace with your API endpoint

    Map<String, String> headers = {
      'Content-Type':
          'application/json', // adjust the content type based on your API
    };

    Map<String, dynamic> body = {
      'roll_no': rollNo,
      'fcm_token': fcmToken,
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
        if(response.body == 'google_user') {
          loadingController.stopLoading();
          ScaffoldMessenger.of(context).showSnackBar(errorSnackBar(useGoogleLogin, context));
          return '';
        }
        if (response.body != 'failed') {
          return response.body;
        } else {
          loadingController.stopLoading();
          ScaffoldMessenger.of(context)
              .showSnackBar(errorSnackBar(wrongCredentials, context));
          return '';
        }
      } else {
        loadingController.stopLoading();
        ScaffoldMessenger.of(context)
            .showSnackBar(errorSnackBar(serverError, context));
        print('POST request failed with status: ${response.statusCode}');
        print('Response: ${response.body}');
        return '';
      }
    } catch (error) {
      Navigator.pop(context);
      loadingController.stopLoading();
      ScaffoldMessenger.of(context)
          .showSnackBar(errorSnackBar(networkError, context));
      print('Error sending POST request: $error');
      return '';
    }
  }

  /// Sends a POST request to the server to register the user
  Future<String> register(
      name, rollNo, email, password, fcmToken, context) async {

    final LoadingController loadingController = Get.put(LoadingController());

    final String url = '$endPoint/register'; // replace with your API endpoint

    Map<String, String> headers = {
      'Content-Type':
          'application/json', // adjust the content type based on your API
    };

    Map<String, dynamic> body = {
      'name': name,
      'roll_no': rollNo,
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
          loadingController.stopLoading();
          ScaffoldMessenger.of(context).showSnackBar(errorSnackBar(invalidRollNo, context));
          return '';
        } else if (response.body == 'invalid_email') {
          loadingController.stopLoading();
          ScaffoldMessenger.of(context).showSnackBar(errorSnackBar(invalidEmail, context));
          return '';
        }

        if (response.body != 'failed' &&
            response.body != 'invalid_roll_no' &&
            response.body != 'invalid_email') {
          return response.body;

        } else if (response.body == 'failed') {
          loadingController.stopLoading();
          ScaffoldMessenger.of(context).showSnackBar(errorSnackBar(alreadyRegistered, context));
          return '';
        }

        return '';
      } else {
        print('POST request failed with status: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(errorSnackBar(serverError, context));
        print('Response: ${response.body}');
        loadingController.stopLoading();
        return '';
      }
    } catch (error) {
      print('Error sending POST request: $error');
      ScaffoldMessenger.of(context).showSnackBar(errorSnackBar(networkError, context));
      loadingController.stopLoading();
      return '';
    }
  }

  /// Sends a POST request to the server to register the user using Google
  Future<bool> googleRegister(name, email, pfp, fcmToken, context) async {

    final LoadingController loadingController = Get.put(LoadingController());
    final GoogleAuthController googleAuthController =
    Get.put(GoogleAuthController());

    final String url =
        '$endPoint/google_auth'; // replace with your API endpoint

    Map<String, String> headers = {
      'Content-Type':
          'application/json', // adjust the content type based on your API
    };

    Map<String, dynamic> body = {
      'name': name,
      'email': email,
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
          ScaffoldMessenger.of(context).showSnackBar(errorSnackBar(invalidRollNo, context));
          return false;
        } else if (response.body == 'invalid_email') {
          await googleAuthController.signOut();
          loadingController.stopLoading();
          ScaffoldMessenger.of(context).showSnackBar(errorSnackBar(invalidEmail, context));
          return false;
        } else if (response.body == 'native_login') {
          loadingController.stopLoading();
          ScaffoldMessenger.of(context)
              .showSnackBar(errorSnackBar(useNativeLogin, context));
          await googleAuthController.signOut();
          return false;
        }

        if (response.body == 'success') {
          return true;
        }
        return false;
      } else {
        // await registrationController.googleSignIn.signOut();
        await googleAuthController.signOut();
        print('POST request failed with status: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(errorSnackBar(serverError, context));
        print('Response: ${response.body}');
        loadingController.stopLoading();
        return false;
      }
    } catch (error) {
      print('Error sending POST request: $error');
      ScaffoldMessenger.of(context).showSnackBar(errorSnackBar(networkError, context));
      loadingController.stopLoading();
      return false;
    }
  }

  /// Sends a POST request to the server to validate the roll no
  Future<bool> validateRollNo(rollNo, context) async {

    final LoadingController loadingController = Get.put(LoadingController());

    final String url =
        '$endPoint/validate_roll_no'; // replace with your API endpoint

    Map<String, String> headers = {
      'Content-Type':
          'application/json', // adjust the content type based on your API
    };

    Map<String, dynamic> body = {
      'roll_no': rollNo,
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
          ScaffoldMessenger.of(context)
              .showSnackBar(errorSnackBar('Invalid Roll No', context));
          loadingController.stopLoading();
          return false;
        } else {
          return true;
        }
      } else {
        loadingController.stopLoading();
        ScaffoldMessenger.of(context).showSnackBar(errorSnackBar(serverError, context));
        print('POST request failed with status: ${response.statusCode}');
        print('Response: ${response.body}');
        return false;
      }
    } catch (error) {
      Navigator.pop(context);
      loadingController.stopLoading();
      ScaffoldMessenger.of(context).showSnackBar(errorSnackBar(networkError, context));
      print('Error sending POST request: $error');
      return false;
    }
  }

  /// Sends a POST request to Authenticate user using token
  Future<bool> loginWithToken(token, rollNo, name) async {

    final String url = '$endPoint/token_auth'; // replace with your API endpoint

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

  /// Sends a POST request to the server to logout the user
  Future<void> logout(rollNo, fcmToken, context) async {

    final String url = '$endPoint/logout'; // replace with your API endpoint

    Map<String, String> headers = {
      'Content-Type':
          'application/json', // adjust the content type based on your API
    };

    Map<String, dynamic> body = {
      'roll_no': rollNo,
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
        if (response.body != 'failed') {}
      }
    } catch (error) {
      print('Network error: $error');
    }
  }

  /// Sends a POST request to the server to update the user profile
  Future<void> updateProfile(rollNo, pfp, name) async {

    final String url =
        '$endPoint/update_profile'; // replace with your API endpoint

    Map<String, String> headers = {
      'Content-Type':
          'application/json', // adjust the content type based on your API
    };

    Map<String, dynamic> body = {
      'roll_no': rollNo,
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

  /// Sends a POST request to the server to create a post
  Future<void> createPost(
      rollNo, subject, content, image, List<String> tags, cab, context) async {

    final LoadingController loadingController = Get.put(LoadingController());
    final PostListController postListController = Get.put(PostListController());
    final CabSharingController cabSharingController =
    Get.put(CabSharingController());

    final String url =
        '$endPoint/create_post'; // replace with your API endpoint

    Map<String, String> headers = {
      'Content-Type':
          'application/json', // adjust the content type based on your API
    };

    Map<String, dynamic> body = {
      'roll_no': rollNo,
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
        ScaffoldMessenger.of(context).showSnackBar(errorSnackBar(serverError, context));
      }
    } catch (error) {
      print('Error sending POST request: $error');
      loadingController.stopLoading();
      ScaffoldMessenger.of(context).showSnackBar(errorSnackBar(networkError, context));
    }
  }

  /// Sends a GET request to the server to get all the posts
  Future<List<Post>> getPosts() async {

    var url = Uri.parse('$endPoint/get_posts');

    // Make the GET request
    var response = await http.get(url);

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Parse the JSON response
      // Your JSON data as a string
      String jsonString = response.body;

      // Decode the JSON string into a List of maps
      List<dynamic> jsonList = jsonDecode(jsonString);

      // Convert each map to a Post object
      List<Post> posts = jsonList.map((json) => Post.fromJson(json)).toList();

      return posts;
    } else {
      // Handle errors
      print('Error: ${response.statusCode}');
      return [];
    }
  }

  /// Sends a POST request to the server to upload an image
  Future<String> uploadImage(image, isPfp) async {
    if (image == null) {
      // Handle case when no image is selected
      return '';
    }

    final url = '$endPoint/upload'; // Replace with your Flask server endpoint


    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('image', image!.path));

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

  /// Sends a POST request to the server to add a reply
  Future<void> addReply(rollNo, reply, postId, context) async {

    final LoadingController loadingController = Get.put(LoadingController());

    final String url = '$endPoint/add_reply';

    Map<String, String> headers = {
      'Content-Type':
          'application/json',
    };

    Map<String, dynamic> body = {
      'roll_no': rollNo,
      'post_id': postId,
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
        ScaffoldMessenger.of(context).showSnackBar(errorSnackBar(serverError, context));
      }
    } catch (error) {
      print('Error sending POST request: $error');
      loadingController.stopLoading();
      ScaffoldMessenger.of(context).showSnackBar(errorSnackBar(networkError, context));
    }
  }

  /// Sends a POST request to the server to get replies
  Future<List<Reply>> getReplies(postId) async {

    final String url =
        '$endPoint/get_replies';

    Map<String, String> headers = {
      'Content-Type':
          'application/json',
    };

    Map<String, dynamic> body = {
      'post_id': postId,
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
        List<Reply> replies =
            jsonList.map((json) => Reply.fromJson(json)).toList();

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

  /// Sends a POST request to the server to get user details
  Future<UserDetails> getUserDetails(rollNo) async {

    final String url =
        '$endPoint/get_user_details';

    Map<String, String> headers = {
      'Content-Type':
          'application/json',
    };

    Map<String, dynamic> body = {
      'roll_no': rollNo,
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

  /// Sends a POST request to the server to get seen post details
  Future<List<String>> getSeenPosts(rollNo) async {

    final String url = '$endPoint/get_opened';

    Map<String, String> headers = {
      'Content-Type':
          'application/json',
    };

    Map<String, dynamic> body = {
      'roll_no': rollNo,
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

        List<String> posts = SeenPosts().seenPostsFromJson(response.body);

        for (var element in posts) {
          print(element);
        }

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

  /// Sends a POST request to the server to set seen a post as seen
  Future<void> setSeenPosts(rollNo, postId) async {
    final String url = '$endPoint/set_opened';

    Map<String, String> headers = {
      'Content-Type':
          'application/json',
    };

    Map<String, dynamic> body = {
      'roll_no': rollNo,
      'post_id': postId,
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

  /// Check if the device is connected to the internet
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

  /// Sends a POST request to the server to get all the replies the user got
  Future<List<Reply>> getAllReplies(rollNo) async {

    final String url =
        '$endPoint/get_all_replies';

    Map<String, String> headers = {
      'Content-Type':
          'application/json',
    };

    Map<String, dynamic> body = {'roll_no': rollNo};

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
        List<Reply> replies =
            jsonList.map((json) => Reply.fromJson(json)).toList();

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

  /// SnackBar to show error messages
  SnackBar errorSnackBar(errorMessage, BuildContext context) {
    return SnackBar(
      content: Text('$errorMessage'),
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.down,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {},
      ),
      backgroundColor: Colors.red.shade300,
    );
  }
}
