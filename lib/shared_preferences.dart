import 'package:shared_preferences/shared_preferences.dart';

const String keyToken = 'keyToken';

class SharedPreferenceStorage {
  static final SharedPreferenceStorage sharedPreferenceStorage =
      SharedPreferenceStorage._internal();

  factory SharedPreferenceStorage() {
    return sharedPreferenceStorage;
  }

  SharedPreferenceStorage._internal();

  saveToken(String cookieToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyToken, cookieToken);
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyToken) ?? '';
  }
}
