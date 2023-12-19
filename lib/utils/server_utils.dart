
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lost_flutter/globals.dart';
import 'package:lost_flutter/page_builder.dart';
import 'package:lost_flutter/pages/home.dart';
import 'package:lost_flutter/utils/shared_prefs.dart';

import '../models.dart';
import '../pages/get_started.dart';

class ServerUtils {

  final endPoint = 'http://65.0.8.179';
  // final endPoint = 'http://localhost:5000';
  // final endPoint = 'http://10.0.2.2:5000';

  Future<void> login(roll_no, password, fcm_token, context) async {

    final network_error_snackBar = ErrorSnackBar('Network error',);
    final wrong_credentials_snackBar = ErrorSnackBar('Please check your credentials',);

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
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const PageBuilder(),
              ));
          SharedPrefs().setRollNo(roll_no);
          roll_no_ = roll_no;
          username = await getUsername(roll_no);
          SharedPrefs().setUsername(username);
          SharedPrefs().setFirstLaunch();
          SharedPrefs().setAuthToken(response.body);
          print("Login successful, TOKEN: ${await SharedPrefs().getAuthToken()}");
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(wrong_credentials_snackBar as SnackBar);
        print('POST request failed with status: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(network_error_snackBar as SnackBar);
      print('Error sending POST request: $error');
    }
  }

  Future<void> register(name, roll_no, email, password, fcmToken, context) async {
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
        if (response.body != 'failed') {
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => const Home(),
          //     ));
          // SharedPrefs().setRollNo(roll_no);
          // roll_no_ = roll_no;
          // username = name;
          // SharedPrefs().setUsername(username);
          // SharedPrefs().setFirstLaunch();
          // SharedPrefs().setAuthToken(response.body);

          await SharedPrefs().setAuthToken(response.body);
          int isRegisterationSuccessful = await loginWithToken(response.body, roll_no, name);
          if (isRegisterationSuccessful == 1) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const PageBuilder(),
                ));
          }

        }
      } else {
        print('POST request failed with status: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      print('Error sending POST request: $error');
    }
  }

  Future<int> loginWithToken(token, roll_no, name) async {
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
          roll_no_ = roll_no;
          SharedPrefs().setRollNo(roll_no_);
          username = name;
          SharedPrefs().setUsername(username);
          SharedPrefs().setFirstLaunch();
          return 1;
        }
        return 0;
      } else {
        print('POST request failed with status: ${response.statusCode}');
        print('Response: ${response.body}');
        return 0;
      }
    } catch (error) {
      print('Error sending POST request: $error');
      return 2;
    }
  }

  Future<void> createPost(roll_no, subject, content, image, context) async {
    final String url =
        '$endPoint/create_post'; // replace with your API endpoint

    Map<String, String> headers = {
      'Content-Type':
      'application/json', // adjust the content type based on your API
    };

    Map<String, dynamic> body = {
      'roll_no': roll_no,
      'subject': subject,
      'content': content,
      'image': image,
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
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const PageBuilder(),
              ));
        }
      } else {
        print('POST request failed with status: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      print('Error sending POST request: $error');
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
      print('Response data: ${response.body}');

      // Your JSON data as a string
      String jsonString = response.body;

      // Decode the JSON string into a List of maps
      List<dynamic> jsonList = jsonDecode(jsonString);

      // Convert each map to a Post object
      List<Post> posts = jsonList.map((json) => Post.fromJson(json)).toList();

      // Access the data in Dart objects
      posts.forEach((post) {
        print('Post ID: ${post.id}');
        print('Roll No: ${post.rollNo}');
        print('Name: ${post.name}');
        print('Subject: ${post.subject}');
        print('Content: ${post.content}');
        print('Image: ${post.image}');
        print('Replies: ${post.replies}');
        print('\n');
      });

      return posts;

    } else {
      // Handle errors
      print('Error: ${response.statusCode}');
      return [];
    }
  }

  Future<void> uploadImage(_image) async {
    if (_image == null) {
      // Handle case when no image is selected
      return;
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
        post_image_link = responseBody;
        print('Response: $responseBody');
      } else {
        // Handle error
        print('Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error during image upload: $error');
    }
  }

  Future<void> addReply(roll_no, reply, post_id, context) async {
    final String url =
        '$endPoint/add_reply'; // replace with your API endpoint

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
        if (response.body == 'success') {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Home(),
              ));
        }
      } else {
        print('POST request failed with status: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      print('Error sending POST request: $error');
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

  Future<String> getUsername(roll_no) async {
    final String url =
        '$endPoint/get_username'; // replace with your API endpoint

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
        return response.body;
      } else {
        print('POST request failed with status: ${response.statusCode}');
        print('Response: ${response.body}');
        return "";
      }
    } catch (error) {
      print('Error sending POST request: $error');
      return "";
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



  SnackBar ErrorSnackBar(error_message) {
    return SnackBar(
      content: Text('$error_message'),
      elevation: 0,
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
