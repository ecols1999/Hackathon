class User {
  final String uid;

  User({this.uid});
}

class UserData {
  String uid;
  String name;
  String age;
  String phoneNumber;
  String profileImage;

  UserData(
      {this.uid, this.age, this.phoneNumber, this.name, this.profileImage});
}
