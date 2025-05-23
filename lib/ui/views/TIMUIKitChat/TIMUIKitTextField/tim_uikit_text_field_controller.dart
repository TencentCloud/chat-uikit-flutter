import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_full_info.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_group_member_full_info.dart';

enum ActionType { hideAllPanel, longPressToAt, setTextField, requestFocus, handleAtMember }

class TIMUIKitInputTextFieldController extends ChangeNotifier {
  TextEditingController? textEditingController = TextEditingController();
  ActionType? actionType;
  String? atUserName;
  String? atUserID;
  String inputText = "";
  V2TimGroupMemberFullInfo? groupMemberFullInfo;

  TIMUIKitInputTextFieldController([TextEditingController? controller]) {
    if (controller != null) {
      textEditingController = controller;
    }
  }

  /// text field unfocused and hide all panel
  hideAllPanel() {
    actionType = ActionType.hideAllPanel;
    notifyListeners();
  }

  longPressToAt(String? userName, String? userID) {
    actionType = ActionType.longPressToAt;
    atUserName = userName;
    atUserID = userID;
    notifyListeners();
  }

  setTextField(String text) {
    inputText = text;
    actionType = ActionType.setTextField;
    notifyListeners();
  }

  requestFocus() {
    actionType = ActionType.requestFocus;
    notifyListeners();
  }

  handleAtMember(V2TimGroupMemberFullInfo? memberInfo) {
    actionType = ActionType.handleAtMember;
    groupMemberFullInfo = memberInfo;
    notifyListeners();
  }
}
