import 'package:shared_preferences/shared_preferences.dart';

class Session_dokter {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var value;

  static Future<String> getPhone() async {
    final SharedPreferences preferences = await _prefs;
    return preferences.getString("phone");
  }

  static Future<String> getEmail() async {
    final SharedPreferences preferences = await _prefs;
    return preferences.getString("email");
  }

  static Future<String> getIDUser() async {
    final SharedPreferences preferences = await _prefs;
    return preferences.getString("iduser");
  }

  static Future<String> getAccnumber() async {
    final SharedPreferences preferences = await _prefs;
    return preferences.getString("accnumber");
  }

  static Future<int> getValue() async {
    final SharedPreferences preferences = await _prefs;
    return preferences.getInt("value");
  }

}