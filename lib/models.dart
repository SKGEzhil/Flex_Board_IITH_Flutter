
import 'dart:convert';

class Post {
  late String id;
  late String rollNo;
  late String name;
  late String profilePic;
  late String subject;
  late String content;
  late String image;
  late List<String> tags;
  late String date;
  late String cabFrom;
  late String cabTo;
  late String cabDate;

  Post({
    required this.id,
    required this.rollNo,
    required this.name,
    required this.profilePic,
    required this.subject,
    required this.content,
    required this.image,
    required this.tags,
    required this.date,
    required this.cabFrom,
    required this.cabTo,
    required this.cabDate,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id']['\$oid'],
      rollNo: json['user_details']['roll_no'],
      name: json['user_details']['name'],
      profilePic: json['user_details']['pfp'],
      subject: json['subject'],
      content: json['content'],
      image: json['image'],
      tags: List<String>.from(json['tags']),
      cabFrom: json['cab']['from'],
      cabTo: json['cab']['to'],
      cabDate: json['cab']['time'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": {
      "\$oid": id,
    },
    " user_details": {
      "roll_no": rollNo,
      "name": name,
      "pfp": profilePic,
    },
    "name": name,
    "subject": subject,
    "content": content,
    "image": image,
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "date": date,
    "cab": {
      "from": cabFrom,
      "to": cabTo,
      "time": cabDate,
    },
  };

}

class Reply {
  late String rollNo;
  late String name;
  late String profilePic;
  late String reply;
  late String postId;
  late String date;

  Reply({
    required this.rollNo,
    required this.name,
    required this.reply,
    required this.postId,
    required this.date,
    required this.profilePic,
  });

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
      rollNo: json['user_details']['roll_no'],
      name: json['user_details']['name'],
      profilePic: json['user_details']['pfp'],
      reply: json['reply'],
      postId: json['post_id'],
      date: json['date'],
    );
  }
}

class SeenPosts {
  List<String> seenPostsFromJson(String str) => List<String>.from(json.decode(str).map((x) => x));
  String seenPostsToJson(List<String> data) => json.encode(List<dynamic>.from(data.map((x) => x)));
}

class PostDraft{
  late String subject;
  late String content;

  PostDraft({
    required this.subject,
    required this.content,
  });

}

class UserDetails {
  late String rollNo;
  late String name;
  late String profilePic;

  UserDetails({
    required this.rollNo,
    required this.name,
    required this.profilePic,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      rollNo: json['roll_no'],
      name: json['name'],
      profilePic: json['pfp '],
    );
  }

  Map<String, dynamic> toJson() => {
    "roll_no": rollNo,
    "name": name,
    "profile_pic": profilePic,
  };

}