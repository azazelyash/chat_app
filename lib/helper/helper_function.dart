import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  // Keys
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";

  // Saving Data to Shared Preferences

  // Getting the Data from Shared Preferences

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }
}
