import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefMethods {
  static const String userIdKey = 'UserIdKey';
  static const String userNameKey = 'UserNameKey';
  static const String userEmailKey = 'UserEmailKey';
  static const String userImageKey = 'UserImageKey';

  static Future<bool> saveUserId(String userId) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.setString(userIdKey, userId);
  }

  static Future<bool> saveUserName(String userName) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.setString(userNameKey, userName);
  }

  static Future<bool> saveUserEmail(String userEmail) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.setString(userEmailKey, userEmail);
  }

  static Future<bool> saveUserImage(String userImage) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.setString(userImageKey, userImage);
  }

  static Future<String?> getUserId() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.getString(userIdKey);
  }

  static Future<String?> getUserName() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.getString(userNameKey);
  }

  static Future<String?> getUserEmail() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.getString(userEmailKey);
  }

  static Future<String?> getUserImage() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.getString(userImageKey);
  }
}
