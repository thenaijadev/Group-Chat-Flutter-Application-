import 'package:shared_preferences/shared_preferences.dart';
import '../Services/Auth/auth_service.dart';
import '../Components/show_logout_dialog.dart';

class HelperFunctions {
  //Saving the data to shared preferences
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";

  // Getting the data from shared preferences
  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(userLoggedInKey);
  }

  static Future<String?> getUserNameSharedPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(userNameKey);
  }

  static Future<String?> getUserEmailSharedPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(userEmailKey);
  }

  static Future<bool?> setUSerLoggedInStatus(bool status) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setBool(userLoggedInKey, status);
  }

  static Future<bool?> saveUserNameSharedPreferences(String userName) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString(userNameKey, userName);
  }

  static Future<bool?> saveUserEmailSharedPreferences(String userEmail) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString(userEmailKey, userEmail);
  }

  static Future<bool?> removeUserLoggedInStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.remove(
      userLoggedInKey,
    );
  }

  static void logout(context) async {
    final shouldLogOut = await showLogoutDialog(context);
    if (shouldLogOut) {
      await AuthService.firebase().logOut();
      await AuthService.firebase().logOut();
      await HelperFunctions.setUSerLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSharedPreferences("");
      await HelperFunctions.saveUserNameSharedPreferences("");
      context.push("/login");
    }
  }

  //Getting the list of snapshots in the stream
}
