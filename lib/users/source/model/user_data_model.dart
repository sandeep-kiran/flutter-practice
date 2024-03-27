import 'package:first_app/users/utils/user_utils.dart';

class UserData {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String photo;
  final String dob;
  final String gender;

  const UserData({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.photo,
    required this.dob,
    required this.gender,
  });

  factory UserData.fromJson(Map map) => UserData.toMap(map);

  factory UserData.toMap(Map map) => UserData(
        id: map["user_id"] ?? 0,
        name: map["name"] ?? getFirstLetterFromEmail(map["email"]),
        email: map["email"] ?? "",
        phone: map["phoneNumber"] ?? "",
        photo: map["profileUrl"] ?? "",
        dob: map["dob"] ?? "",
        gender: map["gender"] ?? "",
      );

  static String getFirstLetterFromEmail(String email) {
    return email.split("@").first;
  }

  static saveUserData(UserData user) {
    UserClass.userId(user.id ?? 0);
    UserClass.userEmail(user.email);
    UserClass.usePhoneNumber(user.phone);
    UserClass.userGender(user.gender);
    UserClass.userName(user.name);
    UserClass.userPhoto(user.photo);
    UserClass.saveUserDataInSharedPreferences();
  }

  UserData copy({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? photo,
    String? dob,
    String? gender,
  }) =>
      UserData(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        photo: photo ?? this.photo,
        dob: dob ?? this.dob,
        gender: gender ?? this.gender,
      );
}
