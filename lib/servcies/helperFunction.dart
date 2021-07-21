import 'package:shared_preferences/shared_preferences.dart';

class HelpFunction {
  static String sharedPrefrenceUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPrefrenceUserNameKey = "USERNAMEKEY";
  static String sharedPrefrenceUserEmailKey = "USEREMAILKEY";
  static String sharedPrefrenceUserId = "USERIDKEY";
  
  static Future<bool> saveusersharedPrefrenceUserLoggedInKey(
      bool isUserLoggedin) async {
    SharedPreferences prefrence = await SharedPreferences.getInstance();
    return await prefrence.setBool(
        sharedPrefrenceUserLoggedInKey, isUserLoggedin);
  }

  static Future<bool> saveuserNamesharedPrefrence(String UserName) async {
    SharedPreferences prefrence = await SharedPreferences.getInstance();
    return await prefrence.setString(sharedPrefrenceUserNameKey, UserName);
  }

  static Future<bool> saveuserEmailsharedPrefrence(String UserEmail) async {
    SharedPreferences prefrence = await SharedPreferences.getInstance();
    return await prefrence.setString(sharedPrefrenceUserEmailKey, UserEmail);
  }

  static Future<bool> getusersharedPrefrenceUserLoggedInKey() async {
    SharedPreferences prefrence = await SharedPreferences.getInstance();
    return prefrence.getBool(sharedPrefrenceUserLoggedInKey);
  }

  static Future<String> getuserNamesharedPrefrence() async {
    SharedPreferences prefrence = await SharedPreferences.getInstance();
    return prefrence.getString(sharedPrefrenceUserNameKey);
  }

  static Future<String> getuserEmailsharedPrefrence() async {
    SharedPreferences prefrence = await SharedPreferences.getInstance();
    return prefrence.getString(sharedPrefrenceUserEmailKey);
  }

  static Future<bool> saveUserId(int id) async {
    SharedPreferences prefrence = await SharedPreferences.getInstance();
    return await prefrence.setInt(sharedPrefrenceUserId, id);
  }

  static Future<int> getUserId() async {
    SharedPreferences prefrence = await SharedPreferences.getInstance();
    return prefrence.getInt(sharedPrefrenceUserId);
  }
}
