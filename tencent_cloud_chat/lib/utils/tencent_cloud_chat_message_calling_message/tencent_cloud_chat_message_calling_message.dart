import 'dart:convert';

import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';

enum CallProtocolType {
  unknown,
  send,
  accept,
  reject,
  cancel,
  hangup,
  timeout,
  lineBusy,
  switchToAudio,
  switchToAudioConfirm
}

enum CallStreamMediaType { unknown, audio, video }

enum CallParticipantType { unknown, c2c, group, }

enum CallParticipantRole { unknown, caller, callee }

enum CallMessageDirection { incoming, outcoming }

class CallingMessage {
  V2TimMessage? v2timMessage;
  bool isCallingSignal = false;
  Map? _signalingJsonData;
  Map? _callJsonData;
  /// Inviter
  /// invitor
  String? inviter;

  /// Invitees
  /// list of invitee
  List<String>? inviteeList;

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

  String? groupID;

  String _callerId = '';

  /// command for invitation
  String? cmd;

  CallProtocolType _protocolType = CallProtocolType.unknown;
  CallStreamMediaType _streamMediaType = CallStreamMediaType.unknown;
  CallParticipantType _participantType = CallParticipantType.unknown;
  CallParticipantRole _participantRole = CallParticipantRole.unknown;
  CallMessageDirection _direction = CallMessageDirection.outcoming;

  CallStreamMediaType get streamMediaType => _streamMediaType;
  CallParticipantType get participantType => _participantType;
  CallMessageDirection get direction => _direction;

  /// Is call excluded from history messages
  String? excludeFromHistoryMessage;

  /// Returns a CallingMessage data from V2TimMessage
  ///
  /// This function is used to get CallingMessage data from custom element in message
  static CallingMessage? getCallMessage(V2TimMessage v2timMessage) {
    CallingMessage callingMessage = CallingMessage();
    callingMessage.v2timMessage = v2timMessage;
    final customElem = v2timMessage!.customElem;
    try {
      if (customElem?.data != null) {
        final customMessage = jsonDecode(customElem!.data!);
        callingMessage._fromJSON(customMessage);
        return callingMessage;
      }
      return null;
    } catch (err) {
      return null;
    }
  }

  /// convert calling message data from json
  _fromJSON(json) {
    _signalingJsonData = jsonDecode(json["data"]);
    _callJsonData = _signalingJsonData!["data"];
    actionType = json["actionType"];
    timeout = json["timeout"];
    inviter = json["inviter"];
    inviteeList = List<String>.from(json["inviteeList"]);
    inviteID = json["inviteID"];
    groupID = json["groupID"];

    String businessID = _signalingJsonData!["businessID"];
    if (businessID != null && businessID == "av_call") {
      isCallingSignal = true;
    }

    _parseProtocolType();
    _parseStreamMediaType();
    _parseParticipantType();
    _parseCallerId();
    _parseParticipantRole();
    _parseDirection();

    try {
      excludeFromHistoryMessage = _callJsonData!['excludeFromHistoryMessage'];
    } catch (e) {
      excludeFromHistoryMessage = null;
    }
  }

  void _parseProtocolType() {
    if (_signalingJsonData == null) {
      _protocolType = CallProtocolType.unknown;
    }

    switch (actionType) {
      case 1: // invite
        if (_callJsonData != null) {
          cmd = _callJsonData!["cmd"];
          if (cmd != null) {
            if (cmd == 'switchToAudio') {
              _protocolType = CallProtocolType.switchToAudio;
            } else if (cmd == 'hangup') {
              _protocolType = CallProtocolType.hangup;
            } else if (cmd == 'videoCall') {
              _protocolType = CallProtocolType.send;
            } else if (cmd == 'audioCall') {
              _protocolType = CallProtocolType.send;
            } else {
              _protocolType = CallProtocolType.unknown;
            }
          } else {
            _protocolType = CallProtocolType.unknown;
          }
        } else {
          var callEnd = _signalingJsonData!['call_end'];
          if (callEnd != null) {
            _protocolType = CallProtocolType.hangup;
          } else {
            _protocolType = CallProtocolType.send;
          }
        }
        break;
      case 2:
        _protocolType = CallProtocolType.cancel;
        break;
      case 3:
        final data = _signalingJsonData!['data'];
        if (data != null) {
          final cmd = data['cmd'];
          if (cmd != null) {
            if (cmd == 'switchToAudio') {
              _protocolType = CallProtocolType.switchToAudioConfirm;
            } else {
              _protocolType = CallProtocolType.accept;
            }
          } else {
            _protocolType = CallProtocolType.accept;
          }
        } else {
          _protocolType = CallProtocolType.accept;
        }
        break;
      case 4:
        if (_signalingJsonData!['line_busy'] != null) {
          _protocolType = CallProtocolType.lineBusy;
        } else {
          _protocolType = CallProtocolType.reject;
        }
        break;
      case 5:
        _protocolType = CallProtocolType.timeout;
        break;
      default:
        _protocolType = CallProtocolType.unknown;
        break;
    }
  }

  _parseStreamMediaType() {
    _streamMediaType = CallStreamMediaType.unknown;
    if (_protocolType == CallProtocolType.unknown) {
      _streamMediaType = CallStreamMediaType.unknown;
      return;
    }

    final callType = _signalingJsonData!['call_type'];
    if (callType != null) {
      if (callType == 1) {
        _streamMediaType = CallStreamMediaType.audio;
      } else if (callType == 2) {
        _streamMediaType = CallStreamMediaType.video;
      }
    }

    if (_protocolType == CallProtocolType.send) {
      final data = _signalingJsonData!['data'];
      if (data != null) {
        final cmd = data['cmd'];
        if (cmd != null) {
          if (cmd == 'audioCall') {
            _streamMediaType = CallStreamMediaType.audio;
          } else if (cmd == 'videoCall') {
            _streamMediaType = CallStreamMediaType.video;
          }
        }
      }
    } else if (_protocolType == CallProtocolType.switchToAudio || _protocolType == CallProtocolType.switchToAudioConfirm) {
      _streamMediaType = CallStreamMediaType.video;
    }
  }

  _parseCallerId() {
    if (_protocolType == CallProtocolType.unknown) {
      return;
    }

    final data = _signalingJsonData!['data'];
    if (data != null) {
      final inviter = data['inviter'];
      if (inviter != null) {
        _callerId = inviter as String;
      }
    }

    if (_callerId.isEmpty) {
      _callerId = TencentCloudChat.instance.dataInstance.basic.currentUser?.userID ?? '';
    }
  }

  _parseParticipantType() {
    if (_protocolType == CallProtocolType.unknown) {
      _participantType = CallParticipantType.unknown;
      return;
    }

    if (groupID != null && groupID!.isNotEmpty) {
      _participantType = CallParticipantType.group;
    } else {
      _participantType = CallParticipantType.c2c;
    }
  }

  _parseParticipantRole() {
    final loginUserId = TencentCloudChat.instance.dataInstance.basic.currentUser?.userID;

    if (_callerId == loginUserId) {
      _participantRole = CallParticipantRole.caller;
    } else {
      _participantRole = CallParticipantRole.callee;
    }
  }

  _parseDirection() {
    if (_participantRole == CallParticipantRole.caller) {
      _direction = CallMessageDirection.outcoming;
    } else {
      _direction = CallMessageDirection.incoming;
    }
  }

  String getContent() {
    String display = "";
    if (v2timMessage == null) {
      return '';
    }

    String showName = _getDisplayName();
    bool isCaller = _participantRole == CallParticipantRole.caller;
    if (_participantType == CallParticipantType.c2c) {
      // C2C shown: reject、cancel、hangup、timeout、line_busy
      if (_protocolType == CallProtocolType.reject) {
        display = isCaller ? tL10n.callRejectCaller : tL10n.callRejectCallee;
      } else if (_protocolType == CallProtocolType.cancel) {
        display = isCaller ? tL10n.callCancelCaller : tL10n.callCancelCallee;
      } else if (_protocolType == CallProtocolType.hangup)  {
        final showDuration = getShowTime(_signalingJsonData!['call_end']);
        display = "${tL10n.stopCallTip}$showDuration";
      } else if (_protocolType == CallProtocolType.timeout) {
        display = isCaller ? tL10n.callTimeoutCaller : tL10n.callTimeoutCallee;
      } else if (_protocolType == CallProtocolType.lineBusy) {
        display = isCaller ? tL10n.callLineBusyCaller : tL10n.callLineBusyCallee;
      } else if (_protocolType == CallProtocolType.send)  {
        display = tL10n.startCall;
      } else if (_protocolType == CallProtocolType.accept)   {
        display = tL10n.acceptCall;
      } else if (_protocolType == CallProtocolType.switchToAudio)  {
        display = tL10n.callingSwitchToAudio;
      } else if (_protocolType == CallProtocolType.switchToAudioConfirm)   {
        display = tL10n.callingSwitchToAudioAccept;
      } else {
        display = tL10n.invalidCommand;
      }
    } else if (_participantType == CallParticipantType.group)  {
      // Group shown: invite、cancel、hangup、timeout、line_busy
      if (_protocolType == CallProtocolType.send) {
        display = "\"${showName}\"${tL10n.groupCallSend}";
      } else if (_protocolType == CallProtocolType.cancel) {
          display = tL10n.groupCallEnd;
      } else if (_protocolType == CallProtocolType.hangup) {
          display = tL10n.groupCallEnd;
      } else if (_protocolType == CallProtocolType.timeout || _protocolType == CallProtocolType.lineBusy) {
        String mutableContent = "";
        if (inviteeList != null && inviteeList!.isNotEmpty) {
          for (String invitee in inviteeList!) {
            mutableContent += "\"${invitee}\"、";
          }
          if (mutableContent.isNotEmpty) {
            mutableContent = mutableContent.substring(0, mutableContent.length - 1);
          }
        }

        display = "$mutableContent${tL10n.groupCallNoAnswer}";
      } else if (_protocolType == CallProtocolType.reject)  {
        display = "$showName${tL10n.groupCallReject}";
      } else if (_protocolType == CallProtocolType.accept)  {
        display = "$showName${tL10n.groupCallAccept}";
      } else if (_protocolType == CallProtocolType.switchToAudio) {
        display = "$showName${tL10n.callingSwitchToAudio}";
      } else if (_protocolType == CallProtocolType.switchToAudioConfirm) {
        display = "$showName${tL10n.groupCallConfirmSwitchToAudio}";
      } else {
        display = tL10n.invalidCommand;
      }
    } else {
      display = tL10n.invalidCommand;
    }

    return display;
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

  String _getDisplayName()  {
    if (v2timMessage == null) {
      return '';
    }

    String displayName = "";
    if (v2timMessage!.nameCard != null && v2timMessage!.nameCard!.isNotEmpty) {
      displayName = v2timMessage!.nameCard!;
    } else if (v2timMessage!.friendRemark != null && v2timMessage!.friendRemark!.isNotEmpty) {
      displayName = v2timMessage!.friendRemark!;
    } else if (v2timMessage!.nickName != null && v2timMessage!.nickName!.isNotEmpty)  {
      displayName = v2timMessage!.nickName!;
    } else {
      displayName = v2timMessage!.sender!;
    }

    return displayName;
  }
}
