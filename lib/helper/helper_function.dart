import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {

  //keys 
  static String userLoggedInKey = "ISLOGGEDIN";
  static String userNameKey= "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";



  //saving the data to SF




  //GETTING THE DATA FROM SF 

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);


  }
}