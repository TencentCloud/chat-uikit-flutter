// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:exif/exif.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_message_calling_message/tencent_cloud_chat_message_calling_message.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageExifInfo {
  final double width;
  final double height;
  final bool isRotate;

  ImageExifInfo({
    required this.height,
    required this.isRotate,
    required this.width,
  });
}

/// Extensions on [Uri]
extension UriX on Uri {
  /// Return the URI adding the http scheme if it is missing
  Uri get withScheme {
    if (hasScheme) return this;
    return Uri.parse('http://${toString()}');
  }
}

class TencentCloudChatUtils {
  /// This function checks if the given text is not null and not empty.
  /// Returns the text if it's not null and not empty, otherwise returns null.
  /// Example: checkString("Hello") returns "Hello".
  static String? checkString(String? text) {
    return (text != null && text.isNotEmpty) ? text : null;
  }

  /// This function checks if the given text is not null, not empty, and does not contain spaces.
  /// Returns the text if it meets the conditions, otherwise returns null.
  /// Example: checkStringWithoutSpace("Hello World") returns null.
  static String? checkStringWithoutSpace(String? text) {
    if (text == null || text.trim().isEmpty || text.contains(' ')) {
      return null;
    }
    return text;
  }

  /// This function returns the MIME type based on the given file extension.
  /// Example: getFileType("pdf") returns "application/pdf".
  static String getFileType(String fileType) {
    switch (fileType) {
      case "3gp":
        return "video/3gpp";
      case "torrent":
        return "application/x-bittorrent";
      case "kml":
        return "application/vnd.google-earth.kml+xml";
      case "gpx":
        return "application/gpx+xml";
      case "asf":
        return "video/x-ms-asf";
      case "avi":
        return "video/x-msvideo";
      case "bin":
      case "class":
      case "exe":
        return "application/octet-stream";
      case "bmp":
        return "image/bmp";
      case "c":
        return "text/plain";
      case "conf":
        return "text/plain";
      case "cpp":
        return "text/plain";
      case "doc":
        return "application/msword";
      case "docx":
        return "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
      case "xls":
      case "csv":
        return "application/vnd.ms-excel";
      case "xlsx":
        return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
      case "gif":
        return "image/gif";
      case "gtar":
        return "application/x-gtar";
      case "gz":
        return "application/x-gzip";
      case "h":
        return "text/plain";
      case "htm":
        return "text/html";
      case "html":
        return "text/html";
      case "jar":
        return "application/java-archive";
      case "java":
        return "text/plain";
      case "jpeg":
        return "image/jpeg";
      case "jpg":
        return "image/jpeg";
      case "js":
        return "application/x-javascript";
      case "log":
        return "text/plain";
      case "m3u":
        return "audio/x-mpegurl";
      case "m4a":
        return "audio/mp4a-latm";
      case "m4b":
        return "audio/mp4a-latm";
      case "m4p":
        return "audio/mp4a-latm";
      case "m4u":
        return "video/vnd.mpegurl";
      case "m4v":
        return "video/x-m4v";
      case "mov":
        return "video/quicktime";
      case "mp2":
        return "audio/x-mpeg";
      case "mp3":
        return "audio/x-mpeg";
      case "mp4":
        return "video/mp4";
      case "mpc":
        return "application/vnd.mpohun.certificate";
      case "mpe":
        return "video/mpeg";
      case "mpeg":
        return "video/mpeg";
      case "mpg":
        return "video/mpeg";
      case "mpg4":
        return "video/mp4";
      case "mpga":
        return "audio/mpeg";
      case "msg":
        return "application/vnd.ms-outlook";
      case "ogg":
        return "audio/ogg";
      case "pdf":
        return "application/pdf";
      case "png":
        return "image/png";
      case "pps":
        return "application/vnd.ms-powerpoint";
      case "ppt":
        return "application/vnd.ms-powerpoint";
      case "pptx":
        return "application/vnd.openxmlformats-officedocument.presentationml.presentation";
      case "prop":
        return "text/plain";
      case "rc":
        return "text/plain";
      case "rmvb":
        return "audio/x-pn-realaudio";
      case "rtf":
        return "application/rtf";
      case "sh":
        return "text/plain";
      case "tar":
        return "application/x-tar";
      case "tgz":
        return "application/x-compressed";
      case "txt":
        return "text/plain";
      case "wav":
        return "audio/x-wav";
      case "wma":
        return "audio/x-ms-wma";
      case "wmv":
        return "audio/x-ms-wmv";
      case "wps":
        return "application/vnd.ms-works";
      case "xml":
        return "text/plain";
      case "z":
        return "application/x-compress";
      case "zip":
        return "application/x-zip-compressed";
      default:
        return "*/*";
    }
  }

  static String getMessageSummary(
      {V2TimMessage? message, int? messageReceiveOption, int? unreadCount, String? draftText, bool needStatus = true}) {
    String text = "";

    if (message != null) {
      switch (message.elemType) {
        case MessageElemType.V2TIM_ELEM_TYPE_TEXT:
          if (message.textElem != null) {
            text = message.textElem!.text ?? "";
          }
          break;
        case MessageElemType.V2TIM_ELEM_TYPE_CUSTOM:
          final (String lineOne, String? lineTwo, IconData? _) = handleCustomMessage(message);
          text = lineTwo != null ? "$lineOne: $lineTwo" : lineOne;
          break;
        case MessageElemType.V2TIM_ELEM_TYPE_SOUND:
          text = "[${tL10n.audio}]";
          break;
        case MessageElemType.V2TIM_ELEM_TYPE_FACE:
          text = '[${tL10n.sticker}]';
          break;
        case MessageElemType.V2TIM_ELEM_TYPE_FILE:
          text = '[${tL10n.file}]';
          break;
        case MessageElemType.V2TIM_ELEM_TYPE_GROUP_TIPS:
          text = "[${tL10n.groupTips}]${buildGroupTipsText(message.groupTipsElem)}";
          break;
        case MessageElemType.V2TIM_ELEM_TYPE_IMAGE:
          text = '[${tL10n.image}]';
          break;
        case MessageElemType.V2TIM_ELEM_TYPE_VIDEO:
          text = '[${tL10n.video}]';
          break;
        case MessageElemType.V2TIM_ELEM_TYPE_LOCATION:
          text = '[${tL10n.location}]';
          break;
        case MessageElemType.V2TIM_ELEM_TYPE_MERGER:
          text = '[${tL10n.chatHistory}]';
          break;
        default:
          text = "";
      }
      if (message.status == 4 && needStatus) {
        text = tL10n.messageDeleted;
      }
      if (message.status == 6 && needStatus) {
        text = tL10n.messageRecalled;
      }
      if (messageReceiveOption != 0) {
        if (unreadCount != null) {
          if (unreadCount > 0) {
            text = "[${tL10n.unreadCount(unreadCount)}]$text";
          }
        }
      }
      if (TencentCloudChatUtils.checkString(draftText) != null) {
        text = "";
      }
    }

    return text;
  }

  static bool isVoteMessage(V2TimMessage message) {
    bool isVoteMessage = false;
    V2TimCustomElem? custom = message.customElem;

    if (custom != null) {
      String? data = custom.data;
      if (data != null && data.isNotEmpty) {
        try {
          Map<String, dynamic> mapData = json.decode(data);
          if (mapData["businessID"] == "group_poll") {
            isVoteMessage = true;
          }
        } catch (err) {
          // err
        }
      }
    }
    return isVoteMessage;
  }

  static bool isRobotMessage(V2TimMessage message) {
    bool res = false;
    if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_CUSTOM) {
      if (message.customElem != null) {
        if (message.customElem!.data != null) {
          var data = message.customElem!.data!;
          try {
            var jsonData = json.decode(data);
            var isChatbotPlugin = jsonData["chatbotPlugin"] ?? "";
            if (isChatbotPlugin.toString() == "1") {
              res = true;
            }
          } catch (err) {
            //err
          }
        }
      }
    }
    return res;
  }

  static String buildGroupTipsText(V2TimGroupTipsElem? tips) {
    String res = "";
    if (tips != null) {
      int type = tips.type;
      List<V2TimGroupChangeInfo?> groupChangeInfo = tips.groupChangeInfoList ?? [];
      List<V2TimGroupMemberChangeInfo?> memberChangeInfo = (tips.memberChangeInfoList ?? []);
      List<V2TimGroupMemberInfo?> memberList = (tips.memberList ?? []);
      V2TimGroupMemberInfo opMember = tips.opMember;

      String membersDisplayText = memberList
          .map((e) => TencentCloudChatUtils.getDisplayNameByV2TimGroupMemberInfo(
              TencentCloudChatUtils.v2TimGroupMemberInfo2V2TimGroupMemberFullInfo(e)))
          .join(",");
      String opMemberDisplayText = TencentCloudChatUtils.getDisplayNameByV2TimGroupMemberInfo(
          TencentCloudChatUtils.v2TimGroupMemberInfo2V2TimGroupMemberFullInfo(opMember));

      switch (type) {
        case 0:
          res = tL10n.unknownGroupTips;
          break;
        case 1:
          res = tL10n.memberJoinedGroup(membersDisplayText);
          break;
        case 2:
          res = tL10n.opInvitedToGroup(membersDisplayText, opMemberDisplayText);
          break;
        case 3:
          res = tL10n.memberLeftGroup(membersDisplayText);
          break;
        case 4:
          res = tL10n.opRemovedFromGroup(membersDisplayText, opMemberDisplayText);
          break;
        case 5:
          res = tL10n.opPromotedToAdmin(membersDisplayText, opMemberDisplayText);
          break;
        case 6:
          res = tL10n.opRevokedAdmin(membersDisplayText, opMemberDisplayText);
          break;
        case 7:
          res = tL10n.opChangedGroupInfo(
              groupChangeInfo.map((e) => buildGroupChangeInfoText(e)).join(","), opMemberDisplayText);
          break;
        case 9:
          res = tL10n.opChangedMemberInfo(
              memberChangeInfo.map((e) => buildGroupMemberChangeInfoText(e)).join(","), opMemberDisplayText);
          break;
      }
    }
    return res;
  }

  static final Map<String, Timer> _debounceTimers = {};
  static final Map<String, Timer> _throttleTimers = {};

  /// Debounce function that delays the execution of the [callback] function
  /// by the specified [duration].
  ///
  /// This function is useful when you want to make sure that a certain operation
  /// is not performed too frequently, for example, when listening to input events
  /// or making API calls.
  ///
  /// [callback]: The function to be executed after the debounce duration.
  /// [duration]: The duration to wait before executing the callback function.
  static void debounce(String key, Function() callback, {Duration duration = const Duration(milliseconds: 500)}) {
    _debounceTimers[key]?.cancel();
    _debounceTimers[key] = Timer(duration, callback);
  }

  static void launchLink({
    required String link,
  }) {
    launchUrl(
      Uri.parse(link).withScheme,
      mode: LaunchMode.externalApplication,
    );
  }

  static RegExp urlReg = RegExp(
      r"([hH][tT]{2}[pP]:\/\/|[hH][tT]{2}[pP][sS]:\/\/|[wW]{3}.|[wW][aA][pP].|[fF][tT][pP].|[fF][iI][lL][eE].)[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]");

  /// Throttle function that ensures the [callback] function is not called
  /// more often than the specified [duration].
  ///
  /// This function is useful when you want to limit the rate at which an
  /// operation is performed, for example, when listening to scroll events
  /// or updating the UI.
  ///
  /// [callback]: The function to be executed with a throttled rate.
  /// [duration]: The minimum duration between consecutive callback executions.
  static void throttle(String key, Function() callback, {Duration duration = const Duration(milliseconds: 500)}) {
    if (_throttleTimers[key] == null) {
      _throttleTimers[key] = Timer(duration, () {
        callback();
        _throttleTimers.remove(key);
      });
    }
  }

  static bool deepEqual(Object? previous, Object? next) {
    return const DeepCollectionEquality.unordered().equals(previous, next);
  }

  static String getMessageSenderName(V2TimMessage message) {
    return checkString(message.friendRemark) ?? checkString(message.nickName) ?? checkString(message.sender) ?? "";
  }

  static Future<ImageExifInfo?> getImageExifInfoByBuffer({
    required Uint8List fileBuffer,
  }) async {
    if (kIsWeb) {
      return null;
    }
    final data = await readExifFromBytes(fileBuffer);
    String? owidth = data["EXIF ExifImageWidth"]?.printable;
    String? oheight = data["EXIF ExifImageLength"]?.printable;
    bool isRotate = false;
    String? rotate = data["Image Orientation"]?.printable;
    if (owidth != null && oheight != null && rotate != null) {
      if (rotate.contains("90") || rotate.contains("270")) {
        isRotate = true;
      }
      if (isRotate) {
        (owidth, oheight) = (oheight, owidth);
      }
      return ImageExifInfo(height: double.parse(oheight), width: double.parse(owidth), isRotate: isRotate);
    }
    return null;
  }

  static addDataToStringFiled({
    required String key,
    required String value,
    required String currentString,
  }) {
    Map<String, String> currentObj;
    try {
      currentObj = json.decode(currentString);
    } catch (err) {
      currentObj = {};
    }
    currentObj[key] = value;
    currentString = json.encode(currentObj);

    return currentString;
  }

  static String getDisplayNameByV2TimGroupMemberInfo(
    V2TimGroupMemberFullInfo? info,
  ) {
    String res = "";
    if (info == null) {
      return "";
    }

    if (checkString(info.userID) == null) {
      return res;
    }
    if (checkString(info.friendRemark) != null) {
      return info.friendRemark!;
    }
    if (checkString(info.nameCard) != null) {
      return info.nameCard!;
    }
    if (checkString(info.nickName) != null) {
      return info.nickName!;
    }
    return info.userID;
  }

  static String buildGroupChangeInfoText(V2TimGroupChangeInfo? info) {
    if (info == null) {
      return "";
    }
    String res = "";
    int type = info.type ?? 0;
    switch (type) {
      case 0:
        res = "";
        break;
      case 1:
        res = tL10n.changedGroupNameTo(info.value ?? "empty");
        break;
      case 2:
        res = tL10n.changedGroupDescriptionTo(info.value ?? "empty");
        break;
      case 3:
        res = tL10n.changedGroupAnnouncementTo(info.value ?? "empty");
        break;
      case 4:
        res = tL10n.changedGroupAvatar;
        break;
      case 5:
        res = tL10n.transferredGroupOwnershipTo(info.value ?? "empty");
        break;
      case 6:
        res = tL10n.changedGroupCustomInfo;
        break;
      case 8:
        if (info.boolValue == true) {
          res = tL10n.enabledGroupMute;
        } else {
          res = tL10n.disabledGroupMute;
        }
        res = "";
        break;
      case 10:
        int value = info.intValue ?? 0;
        String conf = "";
        if (value == 0) {
          conf = tL10n.receiveMessages;
        } else if (value == 1) {
          conf = tL10n.doNotReceiveMessages;
        } else {
          conf = tL10n.receiveMessagesWhenOnlineOnly;
        }
        res = tL10n.changedGroupMessageReceptionTo(conf);
        break;
      case 11:
        int value = info.intValue ?? 2;
        String conf = "";
        if (value == 0) {
          conf = tL10n.disallowJoinGroup;
        } else if (value == 1) {
          conf = tL10n.joinGroupNeedApproval;
        } else {
          conf = tL10n.joinGroupDirectly;
        }
        res = tL10n.changedApplyToJoinGroupTo(conf);
        break;
      case 12:
        int value = info.intValue ?? 2;
        String conf = "";
        if (value == 0) {
          conf = tL10n.disallowInviting;
        } else if (value == 1) {
          conf = tL10n.requireApprovalForInviting;
        } else {
          conf = tL10n.joinDirectlyBeenInvited;
        }
        res = tL10n.changedInviteToJoinGroupTo(conf);
        break;
    }
    return res;
  }

  static String buildGroupMemberChangeInfoText(V2TimGroupMemberChangeInfo? info) {
    if (info == null) {
      return "";
    }
    String res = "";
    if (TencentCloudChatUtils.checkString(info.userID) != null) {
      int muteTime = info.muteTime ?? 0;
      String conf = "";
      if (muteTime == 0) {
        conf = tL10n.unmuted;
      } else {
        conf = tL10n.muteTime(muteTime);
      }
      res = "${info.userID} $conf";
    }
    return res;
  }

  static v2TimGroupMemberInfo2V2TimGroupMemberFullInfo(V2TimGroupMemberInfo? info) {
    return V2TimGroupMemberFullInfo.fromJson({
      "faceUrl": info?.faceUrl,
      "friendRemark": info?.friendRemark,
      "nameCard": info?.nameCard,
      "userID": info?.userID ?? "",
    });
  }

  /// Parses the given [jsonString] to extract the messageSender, messageAbstract, and messageID.
  ///
  /// The [jsonString] should be a JSON string with the following structure:
  /// {
  ///   "messageReply": {
  ///     "messageID": "144115216452519330-1698670328-3674128",
  ///     "messageAbstract": "hi, beauty",
  ///     "messageSender": "qwe2203",
  ///     "messageType": 1,
  ///     "version": 1
  ///   }
  /// }
  ///
  /// The function first checks if there is a "messageReply" key in the JSON object.
  /// If it exists, the function extracts the "messageSender", "messageAbstract", and "messageID" keys.
  ///
  /// If the JSON parsing fails or the relevant information is not found,
  /// all values (messageSender, messageAbstract, and messageID) will be returned as null.
  ///
  /// Returns a tuple containing the messageSender, messageAbstract, and messageID.
  static ({String? messageAbstract, String? messageID, String? messageSender, int? messageSeq, int? messageTimestamp})
      parseMessageReply(String? jsonString) {
    String? messageSender;
    String? messageAbstract;
    String? messageID;
    int? messageSeq;
    int? messageTimestamp;

    if (TencentCloudChatUtils.checkString(jsonString) != null) {
      try {
        Map<String, dynamic> jsonData = json.decode(jsonString!);
        Map<String, dynamic>? messageReply = jsonData["messageReply"];

        if (messageReply != null) {
          messageSender = messageReply["messageSender"] as String?;
          messageAbstract = messageReply["messageAbstract"] as String?;
          messageID = messageReply["messageID"] as String?;
          messageSeq = messageReply["messageSeq"] as int?;
          messageTimestamp = messageReply["messageTimestamp"] as int?;

          if (TencentCloudChatUtils.checkString(messageAbstract) != null) {
            final tryParseMessageAbstract = json.decode(messageAbstract!);
            final tryMessageAbstract = tryParseMessageAbstract["summary"];
            if (TencentCloudChatUtils.checkString(tryMessageAbstract) != null) {
              messageAbstract = tryMessageAbstract;
            }
          }
        }
        // ignore: empty_catches
      } catch (e) {}
    }

    return (
      messageSender: messageSender,
      messageAbstract: messageAbstract,
      messageID: messageID,
      messageTimestamp: messageTimestamp,
      messageSeq: messageSeq,
    );
  }

  static ({String character, int index, bool isAddText}) compareString(String oldText, String newText) {
    final isAddText = newText.length > oldText.length;
    final longerText = isAddText ? newText : oldText;
    final shorterText = isAddText ? oldText : newText;

    int diffIndex = -1;
    for (int i = 0; i < shorterText.length; i++) {
      if (longerText[i] != shorterText[i]) {
        diffIndex = i;
        break;
      }
    }

    if (diffIndex == -1) {
      diffIndex = shorterText.length;
    }

    String characters = longerText.substring(diffIndex, longerText.length - shorterText.length + diffIndex);

    return (
      character: characters,
      index: diffIndex,
      isAddText: isAddText,
    );
  }

  static (String, String?, IconData?) handleCustomMessage(V2TimMessage message) {
    final customElem = message.customElem;
    String lineOne = "[${tL10n.custom}]";
    String? lineTwo;
    IconData? icon;

    if (customElem?.data == "group_create") {
      lineOne = "Group chat created successfully!";
    }
    if (isVoteMessage(message)) {
      lineOne = "[${tL10n.poll}]";
    }
    if (isRobotMessage(message)) {
      lineOne = "[机器人消息]";
    }
    final callingMessage = CallingMessage.getCallMessage(customElem);
    if (callingMessage != null) {
      // If it's an end message
      final isCallEnd = CallingMessage.isCallEndExist(callingMessage);
      final isVoiceCall = callingMessage.callType == 1;

      String? callTime = "";

      if (isCallEnd) {
        callTime = CallingMessage.getShowTime(callingMessage.callEnd!);
      }

      lineTwo = isCallEnd ? tL10n.callDuration(callTime ?? "0") : CallingMessage.getActionType(callingMessage);

      lineOne = isVoiceCall ? tL10n.voiceCall : tL10n.videoCall;
      icon = isVoiceCall ? Icons.call : Icons.video_call_outlined;
    }
    if (lineOne == "[${tL10n.custom}]") {
      debugPrint(message.customElem!.toJson().toString());
    }
    return (lineOne, lineTwo, icon);
  }

  pertyPath() {
    return Pertypath();
  }
}

class Pertypath {
  /// Gets the path to the current working directory.
  ///
  /// In the browser, this means the current URL, without the last file segment.
  String get current {
    // If the current working directory gets deleted out from under the program,
    // accessing it will throw an IO exception. In order to avoid transient
    // errors, if we already have a cached working directory, catch the error and
    // use that.
    Uri uri;
    try {
      uri = Uri.base;
    } on Exception {
      if (_current != null) return _current!;
      rethrow;
    }

    // Converting the base URI to a file path is pretty slow, and the base URI
    // rarely changes in practice, so we cache the result here.
    if (uri == _currentUriBase) return _current!;
    _currentUriBase = uri;

    if (p.Style.platform == p.Style.url) {
      _current = uri.resolve('.').toString();
    } else {
      final path = uri.toFilePath();
      // Remove trailing '/' or '\' unless it is the only thing left
      // (for instance the root on Linux).
      final lastIndex = path.length - 1;
      assert(path[lastIndex] == '/' || path[lastIndex] == '\\');
      _current = lastIndex == 0 ? path : path.substring(0, lastIndex);
    }
    return _current!;
  }

  /// The last value returned by [Uri.base].
  ///
  /// This is used to cache the current working directory.
  Uri? _currentUriBase;

  /// The last known value of the current working directory.
  ///
  /// This is cached because [current] is called frequently but rarely actually
  /// changes.
  String? _current;

  /// Gets the path separator for the current platform. This is `\` on Windows
  /// and `/` on other platforms (including the browser).
  String get separator => p.context.separator;

  /// Returns a new path with the given path parts appended to [current].
  ///
  /// Equivalent to [join()] with [current] as the first argument. Example:
  ///
  ///     p.absolute('path', 'to/foo'); // -> '/your/current/dir/path/to/foo'
  ///
  /// Does not [normalize] or [canonicalize] paths.
  String absolute(String part1,
          [String? part2,
          String? part3,
          String? part4,
          String? part5,
          String? part6,
          String? part7,
          String? part8,
          String? part9,
          String? part10,
          String? part11,
          String? part12,
          String? part13,
          String? part14,
          String? part15]) =>
      p.context.absolute(part1, part2, part3, part4, part5, part6, part7, part8, part9, part10, part11, part12, part13,
          part14, part15);

  /// Gets the part of [path] after the last separator.
  ///
  ///     p.basename('path/to/foo.dart'); // -> 'foo.dart'
  ///     p.basename('path/to');          // -> 'to'
  ///
  /// Trailing separators are ignored.
  ///
  ///     p.basename('path/to/'); // -> 'to'
  String basename(String path) => p.context.basename(path);

  /// Gets the part of [path] after the last separator, and without any trailing
  /// file extension.
  ///
  ///     p.basenameWithoutExtension('path/to/foo.dart'); // -> 'foo'
  ///
  /// Trailing separators are ignored.
  ///
  ///     p.basenameWithoutExtension('path/to/foo.dart/'); // -> 'foo'
  String basenameWithoutExtension(String path) => p.context.basenameWithoutExtension(path);

  /// Gets the part of [path] before the last separator.
  ///
  ///     p.dirname('path/to/foo.dart'); // -> 'path/to'
  ///     p.dirname('path/to');          // -> 'path'
  ///
  /// Trailing separators are ignored.
  ///
  ///     p.dirname('path/to/'); // -> 'path'
  ///
  /// If an absolute path contains no directories, only a root, then the root
  /// is returned.
  ///
  ///     p.dirname('/');  // -> '/' (posix)
  ///     p.dirname('c:\');  // -> 'c:\' (windows)
  ///
  /// If a relative path has no directories, then '.' is returned.
  ///
  ///     p.dirname('foo');  // -> '.'
  ///     p.dirname('');  // -> '.'
  String dirname(String path) => p.context.dirname(path);

  /// Gets the file extension of [path]: the portion of [basename] from the last
  /// `.` to the end (including the `.` itself).
  ///
  ///     p.extension('path/to/foo.dart');    // -> '.dart'
  ///     p.extension('path/to/foo');         // -> ''
  ///     p.extension('path.to/foo');         // -> ''
  ///     p.extension('path/to/foo.dart.js'); // -> '.js'
  ///
  /// If the file name starts with a `.`, then that is not considered the
  /// extension:
  ///
  ///     p.extension('~/.bashrc');    // -> ''
  ///     p.extension('~/.notes.txt'); // -> '.txt'
  ///
  /// Takes an optional parameter `level` which makes possible to return
  /// multiple extensions having `level` number of dots. If `level` exceeds the
  /// number of dots, the full extension is returned. The value of `level` must
  /// be greater than 0, else `RangeError` is thrown.
  ///
  ///     p.extension('foo.bar.dart.js', 2);   // -> '.dart.js
  ///     p.extension('foo.bar.dart.js', 3);   // -> '.bar.dart.js'
  ///     p.extension('foo.bar.dart.js', 10);  // -> '.bar.dart.js'
  ///     p.extension('path/to/foo.bar.dart.js', 2);  // -> '.dart.js'
  String extension(String path, [int level = 1]) => p.context.extension(path, level);

  /// Returns the root of [path], if it's absolute, or the empty string if it's
  /// relative.
  ///
  ///     // Unix
  ///     p.rootPrefix('path/to/foo'); // -> ''
  ///     p.rootPrefix('/path/to/foo'); // -> '/'
  ///
  ///     // Windows
  ///     p.rootPrefix(r'path\to\foo'); // -> ''
  ///     p.rootPrefix(r'C:\path\to\foo'); // -> r'C:\'
  ///     p.rootPrefix(r'\\server\share\a\b'); // -> r'\\server\share'
  ///
  ///     // URL
  ///     p.rootPrefix('path/to/foo'); // -> ''
  ///     p.rootPrefix('https://dart.dev/path/to/foo');
  ///       // -> 'https://dart.dev'
  String rootPrefix(String path) => p.context.rootPrefix(path);

  /// Returns `true` if [path] is an absolute path and `false` if it is a
  /// relative path.
  ///
  /// On POSIX systems, absolute paths start with a `/` (forward slash). On
  /// Windows, an absolute path starts with `\\`, or a drive letter followed by
  /// `:/` or `:\`. For URLs, absolute paths either start with a protocol and
  /// optional hostname (e.g. `https://dart.dev`, `file://`) or with a `/`.
  ///
  /// URLs that start with `/` are known as "root-relative", since they're
  /// relative to the root of the current URL. Since root-relative paths are still
  /// absolute in every other sense, [isAbsolute] will return true for them. They
  /// can be detected using [isRootRelative].
  bool isAbsolute(String path) => p.context.isAbsolute(path);

  /// Returns `true` if [path] is a relative path and `false` if it is absolute.
  /// On POSIX systems, absolute paths start with a `/` (forward slash). On
  /// Windows, an absolute path starts with `\\`, or a drive letter followed by
  /// `:/` or `:\`.
  bool isRelative(String path) => p.context.isRelative(path);

  /// Returns `true` if [path] is a root-relative path and `false` if it's not.
  ///
  /// URLs that start with `/` are known as "root-relative", since they're
  /// relative to the root of the current URL. Since root-relative paths are still
  /// absolute in every other sense, [isAbsolute] will return true for them. They
  /// can be detected using [isRootRelative].
  ///
  /// No POSIX and Windows paths are root-relative.
  bool isRootRelative(String path) => p.context.isRootRelative(path);

  /// Joins the given path parts into a single path using the current platform's
  /// [separator]. Example:
  ///
  ///     p.join('path', 'to', 'foo'); // -> 'path/to/foo'
  ///
  /// If any part ends in a path separator, then a redundant separator will not
  /// be added:
  ///
  ///     p.join('path/', 'to', 'foo'); // -> 'path/to/foo'
  ///
  /// If a part is an absolute path, then anything before that will be ignored:
  ///
  ///     p.join('path', '/to', 'foo'); // -> '/to/foo'
  String join(String part1,
          [String? part2,
          String? part3,
          String? part4,
          String? part5,
          String? part6,
          String? part7,
          String? part8,
          String? part9,
          String? part10,
          String? part11,
          String? part12,
          String? part13,
          String? part14,
          String? part15,
          String? part16]) =>
      p.context.join(part1, part2, part3, part4, part5, part6, part7, part8, part9, part10, part11, part12, part13,
          part14, part15, part16);

  /// Joins the given path parts into a single path using the current platform's
  /// [separator]. Example:
  ///
  ///     p.joinAll(['path', 'to', 'foo']); // -> 'path/to/foo'
  ///
  /// If any part ends in a path separator, then a redundant separator will not
  /// be added:
  ///
  ///     p.joinAll(['path/', 'to', 'foo']); // -> 'path/to/foo'
  ///
  /// If a part is an absolute path, then anything before that will be ignored:
  ///
  ///     p.joinAll(['path', '/to', 'foo']); // -> '/to/foo'
  ///
  /// For a fixed number of parts, [join] is usually terser.
  String joinAll(Iterable<String> parts) => p.context.joinAll(parts);

  /// Splits [path] into its components using the current platform's [separator].
  ///
  ///     p.split('path/to/foo'); // -> ['path', 'to', 'foo']
  ///
  /// The path will *not* be normalized before splitting.
  ///
  ///     p.split('path/../foo'); // -> ['path', '..', 'foo']
  ///
  /// If [path] is absolute, the root directory will be the first element in the
  /// array. Example:
  ///
  ///     // Unix
  ///     p.split('/path/to/foo'); // -> ['/', 'path', 'to', 'foo']
  ///
  ///     // Windows
  ///     p.split(r'C:\path\to\foo'); // -> [r'C:\', 'path', 'to', 'foo']
  ///     p.split(r'\\server\share\path\to\foo');
  ///       // -> [r'\\server\share', 'foo', 'bar', 'baz']
  ///
  ///     // Browser
  ///     p.split('https://dart.dev/path/to/foo');
  ///       // -> ['https://dart.dev', 'path', 'to', 'foo']
  List<String> split(String path) => p.context.split(path);

  /// Canonicalizes [path].
  ///
  /// This is guaranteed to return the same path for two different input paths
  /// if and only if both input paths point to the same location. Unlike
  /// [normalize], it returns absolute paths when possible and canonicalizes
  /// ASCII case on Windows.
  ///
  /// Note that this does not resolve symlinks.
  ///
  /// If you want a map that uses path keys, it's probably more efficient to use a
  /// Map with [equals] and [hash] specified as the callbacks to use for keys than
  /// it is to canonicalize every key.
  String canonicalize(String path) => p.context.canonicalize(path);

  /// Normalizes [path], simplifying it by handling `..`, and `.`, and
  /// removing redundant path separators whenever possible.
  ///
  /// Note that this is *not* guaranteed to return the same result for two
  /// equivalent input paths. For that, see [canonicalize]. Or, if you're using
  /// paths as map keys use [equals] and [hash] as the key callbacks.
  ///
  ///     p.normalize('path/./to/..//file.text'); // -> 'path/file.txt'
  String normalize(String path) => p.context.normalize(path);

  /// Attempts to convert [path] to an equivalent relative path from the current
  /// directory.
  ///
  ///     // Given current directory is /root/path:
  ///     p.relative('/root/path/a/b.dart'); // -> 'a/b.dart'
  ///     p.relative('/root/other.dart'); // -> '../other.dart'
  ///
  /// If the [from] argument is passed, [path] is made relative to that instead.
  ///
  ///     p.relative('/root/path/a/b.dart', from: '/root/path'); // -> 'a/b.dart'
  ///     p.relative('/root/other.dart', from: '/root/path');
  ///       // -> '../other.dart'
  ///
  /// If [path] and/or [from] are relative paths, they are assumed to be relative
  /// to the current directory.
  ///
  /// Since there is no relative path from one drive letter to another on Windows,
  /// or from one hostname to another for URLs, this will return an absolute path
  /// in those cases.
  ///
  ///     // Windows
  ///     p.relative(r'D:\other', from: r'C:\home'); // -> 'D:\other'
  ///
  ///     // URL
  ///     p.relative('https://dart.dev', from: 'https://pub.dev');
  ///       // -> 'https://dart.dev'
  String relative(String path, {String? from}) => p.context.relative(path, from: from);

  /// Returns `true` if [child] is a path beneath `parent`, and `false` otherwise.
  ///
  ///     p.isWithin('/root/path', '/root/path/a'); // -> true
  ///     p.isWithin('/root/path', '/root/other'); // -> false
  ///     p.isWithin('/root/path', '/root/path') // -> false
  bool isWithin(String parent, String child) => p.context.isWithin(parent, child);

  /// Returns `true` if [path1] points to the same location as [path2], and
  /// `false` otherwise.
  ///
  /// The [hash] function returns a hash code that matches these equality
  /// semantics.
  bool equals(String path1, String path2) => p.context.equals(path1, path2);

  /// Returns a hash code for [path] such that, if [equals] returns `true` for two
  /// paths, their hash codes are the same.
  ///
  /// Note that the same path may have different hash codes on different platforms
  /// or with different [current] directories.
  int hash(String path) => p.context.hash(path);

  /// Removes a trailing extension from the last part of [path].
  ///
  ///     p.withoutExtension('path/to/foo.dart'); // -> 'path/to/foo'
  String withoutExtension(String path) => p.context.withoutExtension(path);

  /// Returns [path] with the trailing extension set to [extension].
  ///
  /// If [path] doesn't have a trailing extension, this just adds [extension] to
  /// the end.
  ///
  ///     p.setExtension('path/to/foo.dart', '.js') // -> 'path/to/foo.js'
  ///     p.setExtension('path/to/foo.dart.js', '.map')
  ///       // -> 'path/to/foo.dart.map'
  ///     p.setExtension('path/to/foo', '.js') // -> 'path/to/foo.js'
  String setExtension(String path, String extension) => p.context.setExtension(path, extension);

  /// Returns the path represented by [uri], which may be a [String] or a [Uri].
  ///
  /// For POSIX and Windows styles, [uri] must be a `file:` URI. For the URL
  /// style, this will just convert [uri] to a string.
  ///
  ///     // POSIX
  ///     p.fromUri('file:///path/to/foo') // -> '/path/to/foo'
  ///
  ///     // Windows
  ///     p.fromUri('file:///C:/path/to/foo') // -> r'C:\path\to\foo'
  ///
  ///     // URL
  ///     p.fromUri('https://dart.dev/path/to/foo')
  ///       // -> 'https://dart.dev/path/to/foo'
  ///
  /// If [uri] is relative, a relative path will be returned.
  ///
  ///     p.fromUri('path/to/foo'); // -> 'path/to/foo'
  String fromUri(uri) => p.context.fromUri(uri);

  /// Returns the URI that represents [path].
  ///
  /// For POSIX and Windows styles, this will return a `file:` URI. For the URL
  /// style, this will just convert [path] to a [Uri].
  ///
  ///     // POSIX
  ///     p.toUri('/path/to/foo')
  ///       // -> Uri.parse('file:///path/to/foo')
  ///
  ///     // Windows
  ///     p.toUri(r'C:\path\to\foo')
  ///       // -> Uri.parse('file:///C:/path/to/foo')
  ///
  ///     // URL
  ///     p.toUri('https://dart.dev/path/to/foo')
  ///       // -> Uri.parse('https://dart.dev/path/to/foo')
  ///
  /// If [path] is relative, a relative URI will be returned.
  ///
  ///     p.toUri('path/to/foo') // -> Uri.parse('path/to/foo')
  Uri toUri(String path) => p.context.toUri(path);

  /// Returns a terse, human-readable representation of [uri].
  ///
  /// [uri] can be a [String] or a [Uri]. If it can be made relative to the
  /// current working directory, that's done. Otherwise, it's returned as-is. This
  /// gracefully handles non-`file:` URIs for [Style.posix] and [Style.windows].
  ///
  /// The returned value is meant for human consumption, and may be either URI-
  /// or path-formatted.
  ///
  ///     // POSIX at "/root/path"
  ///     p.prettyUri('file:///root/path/a/b.dart'); // -> 'a/b.dart'
  ///     p.prettyUri('https://dart.dev/'); // -> 'https://dart.dev'
  ///
  ///     // Windows at "C:\root\path"
  ///     p.prettyUri('file:///C:/root/path/a/b.dart'); // -> r'a\b.dart'
  ///     p.prettyUri('https://dart.dev/'); // -> 'https://dart.dev'
  ///
  ///     // URL at "https://dart.dev/root/path"
  ///     p.prettyUri('https://dart.dev/root/path/a/b.dart'); // -> r'a/b.dart'
  ///     p.prettyUri('file:///root/path'); // -> 'file:///root/path'
  String prettyUri(uri) => p.context.prettyUri(uri);
}
