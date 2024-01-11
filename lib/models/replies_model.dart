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
