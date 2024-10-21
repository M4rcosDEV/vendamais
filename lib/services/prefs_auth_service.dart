import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsAuthService {
  static final String _key = 'user_credentials';

  static Future<void> save(String user, String pass) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(
      _key,
      jsonEncode({'user': user, 'pass': pass, 'isAuth': true}),
    );
  }

  static Future<bool> isAuth() async {
    var prefs = await SharedPreferences.getInstance();
    var jsonResult = prefs.getString(_key);
    if (jsonResult != null) {
      var mapUser = jsonDecode(jsonResult);
      return mapUser['isAuth'] ?? false;
    }
    return false;
  }

  static Future<void> logout() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove(_key);
  }
}
  