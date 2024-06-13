// ignore_for_file: non_constant_identifier_names, no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:tencent_cloud_chat_sdk/models/v2_tim_custom_elem.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_full_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_extension.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:tencent_cloud_chat_vote_plugin/tencent_cloud_chat_vote_plugin.dart';

class TencentCloudChatVoteData {
  late String title;
  late TencentCloudChatVoteDataContent content;
  late TencentCloudChatVoteDataConfig config;
  TencentCloudChatVoteData({
    required this.title,
    required this.content,
    required this.config,
  });
  TencentCloudChatVoteData.fromJson(Map<String, dynamic> json) {
    title = json["title"] ?? "";
    content = TencentCloudChatVoteDataContent.fromJson(json["content"] ?? {});
    config = TencentCloudChatVoteDataConfig.fromJson(json['config'] ?? {});
  }
  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from({
      "title": title,
      "content": content.toJson(),
      "config": config.toJson(),
      "businessID": "group_poll",
    });
  }
}

class TencentCloudChatVoteDataContent {
  late List<TencentCloudChatVoteDataOptoin> option_list;
  String? original_msg_id = "";
  int? original_msg_seq = 0;
  TencentCloudChatVoteDataContent({
    required this.option_list,
    this.original_msg_id,
    this.original_msg_seq,
  });
  TencentCloudChatVoteDataContent.fromJson(Map<String, dynamic> json) {
    if (json['option_list'] != null) {
      option_list = List<TencentCloudChatVoteDataOptoin>.from([]);
      json['option_list'].forEach((v) {
        option_list.add(TencentCloudChatVoteDataOptoin.fromJson(v));
      });
    }
    original_msg_id = json['original_msg_id'];
    original_msg_seq = json['original_msg_seq'];
  }
  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from({
      "option_list": option_list.map((v) => v.toJson()).toList(),
      "original_msg_id": original_msg_id ?? "",
      "original_msg_seq": original_msg_seq ?? 0,
    });
  }
}

class TencentCloudChatVoteDataOptoin {
  late int index;
  late String option;
  TencentCloudChatVoteDataOptoin({
    required this.index,
    required this.option,
  });
  TencentCloudChatVoteDataOptoin.fromJson(Map<String, dynamic> json) {
    try {
      if (json["index"].runtimeType != int) {
        json["index"] = int.parse(json["index"]);
      }
      index = json["index"];
      option = json['option'];
    } catch (e) {
      print(e);
    }
  }
  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from({
      "index": index,
      "option": option,
    });
  }
}

class TencentCloudChatVoteDataConfig {
  late bool public;
  late bool allow_multi_vote;
  late bool anonymous;
  TencentCloudChatVoteDataConfig({
    required this.public,
    required this.allow_multi_vote,
    required this.anonymous,
  });
  TencentCloudChatVoteDataConfig.fromJson(Map<String, dynamic> json) {
    public = json["public"];
    allow_multi_vote = json["allow_multi_vote"];
    anonymous = json["anonymous"];
  }
  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from({
      "public": public,
      "allow_multi_vote": allow_multi_vote,
      "anonymous": anonymous,
    });
  }
}

class TencentCloudChatVoteLogic {
  late V2TimMessage msg;
  bool isVoting = false;
  bool isValidateVoteMessage = true;
  bool isFold = true;
  bool isFormSelf = true;
  bool isClose = false;
  int groupMemberCount = 0;
  bool isVoted = false;
  Map<int, bool> optionsBox = Map<int, bool>.from({});
  Map<String, V2TimGroupMemberFullInfo> groupInfos = Map<String, V2TimGroupMemberFullInfo>.from({});
  setGroupMemberCount(int count) {
    groupMemberCount = count;
  }

  setOptionsBox(int index) {
    if (!voteData.config.allow_multi_vote) {
      optionsBox.clear();
    }
    optionsBox[index] = true;
  }

  removeOptionsBox(int index) {
    optionsBox.remove(index);
  }

  List<V2TimMessageExtension> messageExts = [];
  late TencentCloudChatVoteData voteData;
  TencentCloudChatVoteLogic({
    required message,
  }) {
    msg = message;
    isValidateVoteMessage = _isValidateVoteMessage(message);
    Map<String, dynamic> data = _getVoteMapFromMessage(message);
    voteData = TencentCloudChatVoteData.fromJson(data);
    if (voteData.content.option_list.length > 3) {
      isFold = true;
    } else {
      isFold = false;
    }
  }
  setMessageExt(List<V2TimMessageExtension> msgExts) async {
    // 这里来过滤下那些不合法的key

    messageExts = msgExts.takeWhile((value) => value.extensionKey == 'closed' || (value.extensionKey.split("_").length == 2 && value.extensionValue.split("_").isNotEmpty)).toList();
    if (messageExts.isEmpty) {
      return;
    }
    List<String> userids = List<String>.from([]);
    for (var i = 0; i < messageExts.length; i++) {
      V2TimMessageExtension ext = messageExts[i];
      print(ext.toJson());
      if (ext.extensionKey == 'closed') {
        isClose = true;
      } else {
        String userid = ext.extensionKey.split("_").first;
        userids.add(userid);
        if (userid == TencentCloudChatVotePlugin.currentUser) {
          isVoted = true;
        }
      }
      print("isClose $isClose isVoted $isVoted");
    }
    // 这里获取下投票者的群成员信息
    if (msg.groupID != null && userids.isNotEmpty) {
      V2TimValueCallback<List<V2TimGroupMemberFullInfo>> getGroupInfosRes = await TencentImSDKPlugin.v2TIMManager.getGroupManager().getGroupMembersInfo(
            groupID: msg.groupID!,
            memberList: userids,
          );
      if (getGroupInfosRes.code == 0) {
        if (getGroupInfosRes.data != null) {
          if (getGroupInfosRes.data!.isNotEmpty) {
            List<V2TimGroupMemberFullInfo> _groupinfos = getGroupInfosRes.data!;
            for (var element in _groupinfos) {
              groupInfos[element.userID] = element;
            }
          }
        }
      }
    }
  }

  setIsClose(bool close) {
    isClose = close;
  }

  setIsVoting(bool voting) {
    isVoting = voting;
  }

  setIsFold(bool fold) {
    isFold = fold;
  }

  _getVoteMapFromMessage(V2TimMessage message) {
    Map<String, dynamic> data = Map<String, dynamic>.from({});
    if (isValidateVoteMessage) {
      data = json.decode(message.customElem!.data!);
    }
    return data;
  }

  bool _isValidateVoteMessage(V2TimMessage message) {
    bool isvote = false;
    V2TimCustomElem? custom = message.customElem;

    if (custom != null) {
      String? data = custom.data;
      if (data != null && data.isNotEmpty) {
        print(data);
        try {
          Map<String, dynamic> mapData = json.decode(data);
          if (mapData["businessID"] == "group_poll") {
            isvote = true;
            isFormSelf = message.isSelf ?? false;
          }
        } catch (err) {
          // err
        }
      }
    }
    return isvote;
  }
}
