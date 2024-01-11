import 'dart:convert';

class SeenPosts {
  List<String> seenPostsFromJson(String str) => List<String>.from(json.decode(str).map((x) => x));
  String seenPostsToJson(List<String> data) => json.encode(List<dynamic>.from(data.map((x) => x)));
}
