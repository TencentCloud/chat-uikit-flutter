import 'dart:convert';

import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';

enum CallProtocolType {
  send,
  cancel,
  accept,
  reject,
  busy,
  timeout,
  hangup,
  midway,
  end,
  unknown,
}

class CallingMessage {
  /// Inviter
  /// invitor
  String? inviter;

  /// Invitees
  /// list of invitee
  List<String>? inviteeList;

  int? callType;

  // 1: Inviter sends an invitation
  // 2: Inviter cancels the invitation
  // 3: Invitee accepts the invitation
  // 4: Invitee rejects the invitation
  // 5: Invitation timeout
  int? actionType;

  /// Invitation ID
  String? inviteID;

  /// Call duration
  int? timeout;

  /// Call room
  int? roomID;

  /// Call duration in seconds, value greater than 0 represents the call duration
  int? callEnd;

  /// Whether it is a group call
  bool? isGroup;

  /// command for invitation
  String? cmd;

  /// initial call ID
  String? initialCallId;

  /// Is call excluted from history messages
  String? excludeFromHistoryMessage;

  CallingMessage(
      {this.inviter,
      this.actionType,
      this.inviteID,
      this.inviteeList,
      this.timeout,
      this.roomID,
      this.callType,
      this.callEnd,
      this.isGroup,
      this.cmd,
      this.initialCallId,
      this.excludeFromHistoryMessage});

  /// convert calling message data from json
  CallingMessage.fromJSON(json) {
    final detailData = jsonDecode(json["data"]);
    final detailDataData = detailData["data"];
    actionType = json["actionType"];
    timeout = json["timeout"];
    inviter = json["inviter"];
    inviteeList = List<String>.from(json["inviteeList"]);
    inviteID = json["inviteID"];
    callType = detailData["call_type"];
    roomID = detailData["room_id"];
    callEnd = detailData["call_end"];
    isGroup = detailData["is_group"];
    cmd = detailDataData["cmd"];
    initialCallId = detailDataData['initialCallId'];
    try {
      excludeFromHistoryMessage = detailDataData['excludeFromHistoryMessage'];
    } catch (e) {
      excludeFromHistoryMessage = null;
    }
  }

  /// Returns a CallingMessage data from V2TimCustomElem
  ///
  /// [customElem] (optional) custom element represents calling message
  ///
  /// This function is used to get CallingMessage data from custom element in message
  static CallingMessage? getCallMessage(V2TimCustomElem? customElem) {
    try {
      if (customElem?.data != null) {
        final customMessage = jsonDecode(customElem!.data!);
        return CallingMessage.fromJSON(customMessage);
      }
      return null;
    } catch (err) {
      return null;
    }
  }

  /// Returns a CallProtocolType in Calling Message
  ///
  /// [callingMessage] (required) calling message data
  ///
  /// This function is used to get call protocal type (state) in callingMessage
  static CallProtocolType getCallProtocolType(CallingMessage callingMessage) {
    final actionType = callingMessage.actionType!;
    final cmd = callingMessage.cmd ?? '';
    final initialCallId = callingMessage.initialCallId;

    switch (actionType) {
      case 1:
        if (cmd == 'hangup') {
          if (callingMessage.excludeFromHistoryMessage == null) {
            return CallProtocolType.end;
          }
          return CallProtocolType.hangup;
        } else if (cmd == 'videoCall') {
          if (initialCallId != null) {
            return CallProtocolType.midway;
          }
          return CallProtocolType.send;
        } else if (cmd == 'audioCall') {
          if (initialCallId != null) {
            return CallProtocolType.midway;
          }
          return CallProtocolType.send;
        } else {
          return CallProtocolType.unknown;
        }
      case 2:
        return CallProtocolType.cancel;
      case 3:
        return CallProtocolType.accept;
      case 4:
        return CallProtocolType.reject;
      case 5:
        return CallProtocolType.timeout;
      default:
        return CallProtocolType.unknown;
    }
  }

  /// This function checks if calling message would be shown in group
  /// Returns bool value, returns false if invitation is not hung up or busy etc. , otherwise returns true
  static bool isShowInGroup(CallingMessage callingMessage) {
    final type = getCallProtocolType(callingMessage);
    if (type == CallProtocolType.hangup ||
        type == CallProtocolType.midway ||
        type == CallProtocolType.busy ||
        type == CallProtocolType.end) {
      return false;
    }
    return true;
  }

  /// This function is used to get calling message state text
  /// Returns the text according to calling message state
  static String getActionType(CallingMessage callingMessage) {
    final type = getCallProtocolType(callingMessage);
    switch (type) {
      case CallProtocolType.send:
        return tL10n.callInitiated;
      case CallProtocolType.cancel:
        return tL10n.callCancelled;
      case CallProtocolType.accept:
        return tL10n.callAccepted;
      case CallProtocolType.reject:
        return tL10n.callDeclined;
      case CallProtocolType.timeout:
        return tL10n.noAnswer;
      case CallProtocolType.busy:
        return tL10n.lineBusy;
      case CallProtocolType.hangup:
        return tL10n.callHungUp;
      case CallProtocolType.midway:
        return tL10n.callInProgress;
      case CallProtocolType.end:
        return tL10n.callEnded;
      case CallProtocolType.unknown:
        return tL10n.unknownCallStatus;
    }
  }

  /// This function checks if call has ended without canceling the call
  /// Returns if call is ended and exists
  static isCallEndExist(CallingMessage callMsg) {
    int? callEnd = callMsg.callEnd;
    int? actionType = callMsg.actionType;
    if (actionType == 2) return false;
    return callEnd == null
        ? false
        : callEnd > 0
            ? true
            : false;
  }

  /// This function checks if group call has ended without canceling the call
  /// Returns if group call is ended and exists
  static isGroupCallEndExist(CallingMessage callMsg) {
    final actionType = callMsg.actionType!;
    final cmd = callMsg.cmd ?? '';
    final inviteID = callMsg.inviteID;
    if (actionType == 1 && cmd == 'hangup' && callMsg.excludeFromHistoryMessage == null && inviteID != null) {
      return true;
    }
    return false;
  }

  /// Returns 2 digits of number
  /// Example: if passed 1, returns "01", if passed 10, returns "10"
  static String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  /// This function get time from passed seconds
  /// Return 2 digits formated minutes and seconds mm:ss
  static getShowTime(int seconds) {
    int secondsShow = seconds % 60;
    int minutesShow = seconds ~/ 60;
    return "${twoDigits(minutesShow)}:${twoDigits(secondsShow)}";
  }
}
