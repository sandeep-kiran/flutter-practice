import 'package:shared_preferences/shared_preferences.dart';

class UserClass {
  static int _id = 0;
  static String _name = "";
  static String _email = "";
  static String _phoneNumber = "";
  static String _photo = "";
  static String _dob = "";
  static String _gender = "";

  static int get id => _id;
  static String get name => _name;
  static String get email => _email;
  static String get phoneNumber => _phoneNumber;
  static String get photo => _photo;
  static String get dob => _dob;
  static String get gender => _gender;

  static void userId(int id) {
    _id = id;
  }

  static void userName(String name) {
    _name = name;
  }

  static void userEmail(String email) {
    _email = email;
  }

  static void usePhoneNumber(String phone) {
    _phoneNumber = phone;
  }

  static void userPhoto(String photo) {
    _photo = photo;
  }

  static void useDob(String dob) {
    _dob = dob;
  }

  static void userGender(String gender) {
    _gender = gender;
  }

  static saveUserDataInSharedPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("_id", id.toString());
    sharedPreferences.setString("_name", name);
    sharedPreferences.setString("_email", email);
    sharedPreferences.setString("_phoneNumber", phoneNumber);
    sharedPreferences.setString("_photo", photo);
    sharedPreferences.setString("_dob", dob);
    sharedPreferences.setString("_gender", gender);
  }

  static getTheValue(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(key) ?? "";
  }
}
