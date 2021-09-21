import 'package:shared_preferences/shared_preferences.dart';

class Cached {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var value;

  static Future<String> getNamaUser() async {
    final SharedPreferences preferences = await _prefs;
    return preferences.getString("namauser");
  }



}