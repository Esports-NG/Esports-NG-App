import 'dart:convert';
import 'package:e_sport/data/model/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static String isLogin = "App is Login";
  static String firstTimeAppOpen = " First Time Opening App";
  SharedPreferences? _preferences;
  SharedPref() {
    if (kDebugMode) {
      print("sharepref init");
    }
    init();
  }
  Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  void setUser(UserModel? user) {
    _preferences!.setString(isLogin, jsonEncode(user!.toUser()));
  }

  void logout() {
    _preferences!.setString(isLogin, "");
  }

  String read() {
    const key = "token";
    String value = _preferences!.getString(key)!;
    debugPrint('read: $value');
    return value.isEmpty ? "0" : value;
  }

  saveToken(String value) {
    _preferences!.setString("token", value);
  }

  UserModel? getUser() {
    var user = _preferences!.getString(isLogin);
    debugPrint("user value $user");

    if (user != null && user.isNotEmpty) {
      var json = jsonDecode(user);
      UserModel userValue = UserModel.fromJson(json);
      return userValue;
    } else {
      return null;
    }
  }

  void setFirstTimeOpen(bool value) {
    _preferences!.setBool(firstTimeAppOpen, value);
  }

  bool getFirstTimeOpen() {
    var value = _preferences!.getBool(firstTimeAppOpen);
    debugPrint("Am I a new UserModel?  $value");

    return value ?? true;
  }
}
