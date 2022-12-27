import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TUISettingModel extends ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final String keyTitle = "tencent_chat_uikit_";

  double? _keyboardHeight;
  double get keyboardHeight => _keyboardHeight ?? 0;
  set keyboardHeight(double value) {
    if(value > 40 && _keyboardHeight != value){
      _keyboardHeight = value;
      updateLocalSetting("${keyTitle}keyboardHeight", value.toString());
    }
  }

  updateLocalSetting(String key, String value) async {
    SharedPreferences prefs = await _prefs;
    prefs.setString(key, value);
  }

  init() async {
    SharedPreferences prefs = await _prefs;
    _keyboardHeight = double.parse(prefs.getString("${keyTitle}keyboardHeight") ?? "0");
  }
}