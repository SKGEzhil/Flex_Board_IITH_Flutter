
import 'dart:convert';

class Post {
  late String id;
  late String rollNo;
  late String name;
  late String subject;
  late String content;
  late String image;
  late List<String> replies;
  late String date;

  Post({
    required this.id,
    required this.rollNo,
    required this.name,
    required this.subject,
    required this.content,
    required this.image,
    required this.replies,
    required this.date,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id']['\$oid'],
      rollNo: json['roll_no'],
      name: json['name'],
      subject: json['subject'],
      content: json['content'],
      image: json['image'],
      replies: List<String>.from(json['replies']),
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": {
      "\$oid": id,
    },
    "roll_no": rollNo,
    "name": name,
    "subject": subject,
    "content": content,
    "image": image,
    "replies": List<dynamic>.from(replies.map((x) => x)),
    "date": date,
  };

}

class Reply {
  late String rollNo;
  late String name;
  late String reply;
  late String post_id;

  Reply({
    required this.rollNo,
    required this.name,
    required this.reply,
    required this.post_id,
  });

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
      rollNo: json['roll_no'],
      name: json['name'],
      reply: json['reply'],
      post_id: json['post_id'],
    );
  }
}

class seenPosts {
  List<String> seenPostsFromJson(String str) => List<String>.from(json.decode(str).map((x) => x));
  String seenPostsToJson(List<String> data) => json.encode(List<dynamic>.from(data.map((x) => x)));
}