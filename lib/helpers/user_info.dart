import 'package:shared_preferences/shared_preferences.dart';

class UserInfo {
  Future setToken(String value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("token", value);
  }

  Future<String?> getToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("token");
  }

  Future setUserID(int value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setInt("userID", value);
  }

  Future<int?> getUserID() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt("userID");
  }
  
  Future setNama(String value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("nama", value);
  }

  Future<String?> getNama() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("nama");
  }

  Future setEmail(String value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("email", value);
  }

  Future<String?> getEmail() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("email");
  }
  Future logout() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}