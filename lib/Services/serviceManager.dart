import 'dart:convert';
import 'package:medical_college/Services/apiData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ServiceManager {

  static String userID = '';
  static String tokenID = '';
  static String userBranchID = '';

  static String profileURL = '';
  static String userName = '';
  static String userEmail = '';
  static String userMobile = '';
  static String userDob = '';
  static String userAltMobile = '';
  static String designation = '';
  static bool isVerified = false;

  static String deliveryName = '';
  // static String deliveryAddress = '';

  static String userAddress = '';
  static String addressID = '';

  void setUser (String userID) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userID', userID);
  }

  void getUserID () async {
    final prefs = await SharedPreferences.getInstance();
    userID = prefs.getString('userID') ?? '';
    // getUserData();
  }

  void setToken (String userID) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('tokenID', userID);
  }

  void getTokenID () async {
    final prefs = await SharedPreferences.getInstance();
    tokenID = prefs.getString('tokenID') ?? '';
    if(tokenID != ''){
      getUserData();
    }
  }

  void setAddressID (String addressID) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('addressID', addressID);
  }

  void getAddressID () async {
    final prefs = await SharedPreferences.getInstance();
    addressID = prefs.getString('addressID') ?? '';
  }

  void removeAll() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userID');
    prefs.remove('tokenID');
    userID = '';
    tokenID = '';
  }

  void getUserData() async {
    String url = APIData.getLoggedInUserData;
    var res = await http.get(Uri.parse(url), headers: APIData.kHeader);
    if(res.statusCode == 200){
      var data = jsonDecode(res.body);
      userName = '${data['data']['first_name']} ${data['data']['first_name']} ${data['data']['last_name']}';
      userEmail = '${data['data']['email']}';
      // profileURL = '${data['data']['photo']}';
      userMobile = data['data']['mobile_no'] ?? '';
      userDob = data['data']['dob'] ?? '';
      designation = data['data']['designation_name'] ?? '';
    } else {
      // print('Status Code: ${res.statusCode}');
      // print(res.body);
    }
  }
}