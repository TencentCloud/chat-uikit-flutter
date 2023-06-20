import 'package:flutter/material.dart';
import 'package:tencent_im_base/tencent_im_base.dart';

enum ActionType {
  hideAllPanel,
  longPressToAt,
  setTextField,
  requestFocus,
  handleAtMember
}

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
