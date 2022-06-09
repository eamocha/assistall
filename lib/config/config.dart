import 'package:shared_preferences/shared_preferences.dart';

class Config{

  static get(String key, {defaultValue}) async {

    var prefs = await SharedPreferences.getInstance();

    var value =  prefs.get(key);

    return value ?? defaultValue;
  }

  static set(String key, String value) async {

    var prefs = await SharedPreferences.getInstance();

    return prefs.setString(key, value);
  }



}