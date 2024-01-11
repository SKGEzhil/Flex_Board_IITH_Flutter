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