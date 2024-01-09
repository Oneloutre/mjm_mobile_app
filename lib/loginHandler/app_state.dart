import 'package:shared_preferences/shared_preferences.dart';

class AppState {
  static bool _isAuthenticated = false;

  static bool get isAuthenticated => _isAuthenticated;

  static Future<void> setAuthenticated(bool value) async {
    _isAuthenticated = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', value);
  }
  static set isAuthenticated(bool value) {
    _isAuthenticated = value;
  }
  static Future<void> loadAuthenticated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
  }

}