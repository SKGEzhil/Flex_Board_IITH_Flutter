import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lost_flutter/globals.dart';
import 'package:lost_flutter/home.dart';

import 'models.dart';

class ServerUtils {

  Future<void> login(roll_no, password, context) async {
    final String url =
        'http://localhost:5000/login'; // replace with your API endpoint

    Map<String, String> headers = {
      'Content-Type':
          'application/json', // adjust the content type based on your API
    };

    Map<String, dynamic> body = {
      'roll_no': roll_no,
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

  Future<void> createPost(roll_no, subject, content, image, context) async {
    final String url =
        'http://localhost:5000/create_post'; // replace with your API endpoint

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

  Future<List<Post>> getPosts() async {
    // Replace the URL with the actual API endpoint you want to call
    var url = Uri.parse('http://localhost:5000/get_posts');

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

    final url = 'http://localhost:5000/upload'; // Replace with your Flask server endpoint

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

}
