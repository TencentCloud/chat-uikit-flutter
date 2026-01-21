import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
// import 'package:uuid/uuid.dart';
import 'package:wukongimfluttersdk/entity/channel.dart';
import 'package:wukongimfluttersdk/entity/conversation.dart';
import 'package:wukongimfluttersdk/entity/msg.dart';
import 'package:wukongimfluttersdk/type/const.dart';
// import 'package:wukongimfluttersdk/wkim.dart';

class WKHttpUtils {
  // static String apiURL = "https://api.githubim.com";
  // static String apiURL = "http://62.234.8.38:7090/v1";
  // static String apiURL = "http://175.27.245.108:15001";
  static String apiURL = "http://175.17.19.72:5001";
  static Dio? _dio;

  static String uid = "";
  static String token = "";

  /// Get Dio instance with trust all certificates configuration
  static Dio get dio {
    print('调用Dio 当前API地址: $apiURL');
    if (_dio == null) {
      final httpClient = HttpClient();
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) =>
              true; // Trust all certificates

      _dio = Dio(BaseOptions(
        baseUrl: apiURL,
        // 允许所有状态码，避免自动抛出异常
        validateStatus: (status) => true,
      ));
      (_dio!.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
          (client) => httpClient;
    }
    _dio!.options.baseUrl = apiURL;
    return _dio!;
  }

  static String getAvatarUrl(String uid) {
    return "$apiURL/users/$uid/avatar";
  }

  static String getGroupAvatarUrl(String gid) {
    return "$apiURL/groups/$gid/avatar";
  }

  static Future<int> login(String uid, String token) async {
    WKHttpUtils.uid = uid;
    WKHttpUtils.token = token;
    try {
      final response = await dio.post("/user/token", data: {
        'uid': uid,
        'token': token,
        'device_flag': 0,
        'device_level': 1
      });

      if (response.statusCode == HttpStatus.ok) {
        print('Login successful for response: ${response.data}');
      }
      return response.statusCode ?? HttpStatus.badRequest;
    } catch (e) {
      print('Login error: $e');
      return HttpStatus.internalServerError;
    }
  }

  static Future<String> getIP(String uid) async {
    try {
      final response = await dio.get('/route');
      if (response.statusCode == HttpStatus.ok) {
        return response.data['tcp_addr'] ?? '';
      }
    } catch (e) {
      print('Get IP error: $e');
    }
    return '';
  }

  static Future<void> syncConversation(String lastSsgSeqs, int msgCount,
      int version, Function(WKSyncConversation) back) async {
    try {
      // 检查是否已登录
      if (WKHttpUtils.uid.isEmpty) {
        print('请先登录');
        back(WKSyncConversation()..conversations = []);
        return;
      }

      final response = await dio.post('/conversation/sync', data: {
        "login_uid": WKHttpUtils.uid,
        "version": version,
        "last_msg_seqs": lastSsgSeqs,
        "msg_count": msgCount,
        "device_uuid": WKHttpUtils.uid,
      });

      WKSyncConversation conversation = WKSyncConversation();
      conversation.conversations = [];

      if (response.statusCode == HttpStatus.ok) {
        try {
          var list = response.data['conversations'];
          for (int i = 0; i < list.length; i++) {
            var json = list[i];
            WKSyncConvMsg convMsg = WKSyncConvMsg();
            convMsg.channelID = json['channel_id'];
            convMsg.channelType = json['channel_type'];
            convMsg.unread = json['unread'] ?? 0;
            convMsg.timestamp = json['timestamp'];
            convMsg.lastMsgSeq = json['last_msg_seq'];
            convMsg.lastClientMsgNO = json['last_client_msg_no'];
            convMsg.version = json['version'];
            var msgListJson = json['recents'] as List<dynamic>;
            List<WKSyncMsg> msgList = [];
            if (msgListJson.isNotEmpty) {
              for (int j = 0; j < msgListJson.length; j++) {
                var msgJson = msgListJson[j];
                msgList.add(getWKSyncMsg(msgJson));
              }
            }

            convMsg.recents = msgList;
            conversation.conversations!.add(convMsg);
          }
        } catch (e) {
          print('解析会话数据错误: $e');
        }
      } else {
        print('同步会话失败: HTTP ${response.statusCode}');
        if (response.data != null && response.data is Map) {
          print('错误信息: ${response.data['message'] ?? response.data}');
        }
      }
// 测试数据
      // for (var i = 0; i < 5000; i++) {
      //   WKSyncConvMsg convMsg = WKSyncConvMsg();
      //   convMsg.channelID =
      //       "${const Uuid().v4().toString().replaceAll("-", "")}5";
      //   convMsg.channelType = 1;
      //   convMsg.unread = 0;
      //   List<WKSyncMsg> msgList = [];
      //   for (int j = 0; j < 10; j++) {
      //     WKSyncMsg msg = WKSyncMsg();
      //     msg.channelID = convMsg.channelID;
      //     msg.messageID =
      //         "${const Uuid().v4().toString().replaceAll("-", "")}5";
      //     msg.channelType = 1;
      //     msg.clientMsgNO =
      //         "${const Uuid().v4().toString().replaceAll("-", "")}5";
      //     msgList.add(msg);
      //   }
      //   conversation.conversations!.add(convMsg);
      // }
      back(conversation);
    } catch (e) {
      print('同步会话错误: $e');
      back(WKSyncConversation()..conversations = []);
    }
  }

  static syncChannelMsg(
      String channelID,
      int channelType,
      int startMsgSeq,
      int endMsgSeq,
      int limit,
      int pullMode,
      Function(WKSyncChannelMsg) back) async {
    try {
      final response = await dio.post('/message/channel/sync', data: {
        "login_uid": WKHttpUtils.uid,
        "channel_id": channelID,
        "channel_type": channelType,
        "start_message_seq": startMsgSeq,
        "end_message_seq": endMsgSeq,
        "limit": limit,
        "pull_mode": pullMode
      });

      if (response.statusCode == HttpStatus.ok) {
        var data = response.data;
        WKSyncChannelMsg msg = WKSyncChannelMsg();
        msg.startMessageSeq = data['start_message_seq'];
        msg.endMessageSeq = data['end_message_seq'];
        msg.more = data['more'];
        var messages = data['messages'];

        List<WKSyncMsg> msgList = [];
        for (int i = 0; i < messages.length; i++) {
          dynamic json = messages[i];
          msgList.add(getWKSyncMsg(json));
        }
        print('同步channel消息数量：${msgList.length}');
        msg.messages = msgList;
        back(msg);
      }
    } catch (e) {
      print('Sync channel message error: $e');
      back(WKSyncChannelMsg());
    }
  }

  static WKSyncMsg getWKSyncMsg(dynamic json) {
    WKSyncMsg msg = WKSyncMsg();
    msg.channelID = json['channel_id'];
    msg.messageID = json['message_id'].toString();
    msg.channelType = json['channel_type'];
    msg.clientMsgNO = json['client_msg_no'];
    msg.messageSeq = json['message_seq'];
    msg.fromUID = json['from_uid'];
    msg.isDeleted = json['is_deleted'];
    msg.timestamp = json['timestamp'];
    //  msg.payload = json['payload'];

    // String payload = json['payload'];
    try {
      msg.payload = json['payload'];
      // msg.payload = jsonDecode(utf8.decode(base64Decode(payload)));
    } catch (e) {
      // print('异常了');
    }
    // 解析扩展
    var extraJson = json['message_extra'];
    if (extraJson != null) {
      var extra = getMsgExtra(extraJson);
      msg.messageExtra = extra;
    }
    return msg;
  }

  static WKSyncExtraMsg getMsgExtra(dynamic extraJson) {
    var extra = WKSyncExtraMsg();
    extra.messageID = extraJson['message_id'];
    extra.messageIdStr = extraJson['message_id_str'];
    extra.revoke = extraJson['revoke'] ?? 0;
    extra.revoker = extraJson['revoker'] ?? '';
    extra.readed = extraJson['readed'] ?? 0;
    extra.readedCount = extraJson['readed_count'] ?? 0;
    extra.isMutualDeleted = extraJson['is_mutual_deleted'] ?? 0;
    return extra;
  }

  static Future<void> getGroupInfo(String groupId) async {
    try {
      // 检查群ID是否有效
      if (groupId.isEmpty) {
        print('群ID不能为空');
        return;
      }

      // 检查是否已登录
      if (WKHttpUtils.uid.isEmpty) {
        print('请先登录');
        return;
      }

      final response = await dio.get('/groups/$groupId');

      if (response.statusCode == HttpStatus.ok) {
        var json = response.data;
        var channel = WKChannel(groupId, WKChannelType.group);
        channel.channelName = json['name'];
        channel.avatar = json['avatar'];
        TIMUIKitCore.getWKIMSDKInstance()
            .channelManager
            .addOrUpdateChannel(channel);
      } else {
        print('获取群信息失败: HTTP ${response.statusCode}');
        // 如果服务器返回了错误消息，打印出来
        if (response.data != null && response.data is Map) {
          print('错误信息: ${response.data['message'] ?? response.data}');
        }
      }
    } catch (e) {
      print('获取群信息错误: $e');
    }
  }

  static Future<void> getUserInfo(String uid) async {
    try {
      // 检查UID是否有效
      if (uid.isEmpty) {
        print('用户ID不能为空');
        return;
      }

      // 检查是否已登录
      if (WKHttpUtils.uid.isEmpty) {
        print('请先登录');
        return;
      }

      final response = await dio.get('/users/$uid');

      if (response.statusCode == HttpStatus.ok) {
        var json = response.data;
        var channel = WKChannel(uid, WKChannelType.personal);
        channel.channelName = json['name'];
        channel.avatar = json['avatar'];
        TIMUIKitCore.getWKIMSDKInstance()
            .channelManager
            .addOrUpdateChannel(channel);
      } else {
        print('获取用户信息失败: HTTP ${response.statusCode}');
        // 如果服务器返回了错误消息，打印出来
        if (response.data != null && response.data is Map) {
          print('错误信息: ${response.data['message'] ?? response.data}');
        }
      }
    } catch (e) {
      print('获取用户信息错误: $e');
    }
  }

  static Future<bool> revokeMsg(String clientMsgNo, String channelId,
      int channelType, int msgSeq, String msgId) async {
    try {
      // 检查必要参数
      if (clientMsgNo.isEmpty || channelId.isEmpty || msgId.isEmpty) {
        print('撤回消息需提供完整的消息信息');
        return false;
      }

      // 检查是否已登录
      if (WKHttpUtils.uid.isEmpty) {
        print('请先登录');
        return false;
      }

      final response = await dio.post('/message/revoke', data: {
        'login_uid': WKHttpUtils.uid,
        'channel_id': channelId,
        'channel_type': channelType,
        'client_msg_no': clientMsgNo,
        'message_seq': msgSeq,
        'message_id': msgId,
      });

      if (response.statusCode == HttpStatus.ok) {
        print('消息撤回成功');
        return true;
      } else {
        print('撤回消息失败: HTTP ${response.statusCode}');
        if (response.data != null && response.data is Map) {
          print('错误信息: ${response.data['message'] ?? response.data}');
        }
        return false;
      }
    } catch (e) {
      print('撤回消息错误: $e');
      return false;
    }
  }

  static Future<bool> deleteMsg(String clientMsgNo, String channelId,
      int channelType, int msgSeq, String msgId) async {
    try {
      // 检查必要参数
      if (clientMsgNo.isEmpty || channelId.isEmpty || msgId.isEmpty) {
        print('删除消息需提供完整的消息信息');
        return false;
      }

      // 检查是否已登录
      if (WKHttpUtils.uid.isEmpty) {
        print('请先登录');
        return false;
      }

      final response = await dio.post('/message/delete', data: {
        'login_uid': WKHttpUtils.uid,
        'channel_id': channelId,
        'channel_type': channelType,
        'message_seq': msgSeq,
        'message_id': msgId,
      });

      if (response.statusCode == HttpStatus.ok) {
        TIMUIKitCore.getWKIMSDKInstance()
            .messageManager
            .deleteWithClientMsgNo(clientMsgNo);
        print('消息删除成功');
        return true;
      } else {
        print('删除消息失败: HTTP ${response.statusCode}');
        if (response.data != null && response.data is Map) {
          print('错误信息: ${response.data['message'] ?? response.data}');
        }
        return false;
      }
    } catch (e) {
      print('删除消息错误: $e');
      return false;
    }
  }

  static Future<void> syncMsgExtra(
      String channelId, int channelType, int version) async {
    try {
      final response = await dio.post('/message/extra/sync', data: {
        'login_uid': WKHttpUtils.uid,
        'channel_id': channelId,
        'channel_type': channelType,
        'source': WKHttpUtils.uid,
        'limit': 100,
        'extra_version': version,
      });

      if (response.statusCode == HttpStatus.ok) {
        var arrJson = response.data;
        if (arrJson != null && arrJson.length > 0) {
          List<WKMsgExtra> list = [];
          for (int i = 0; i < arrJson.length; i++) {
            var extraJson = arrJson[i];
            WKMsgExtra extra = WKMsgExtra();
            extra.messageID = extraJson['message_id_str'];
            extra.revoke = extraJson['revoke'] ?? 0;
            extra.revoker = extraJson['revoker'] ?? '';
            extra.readed = extraJson['readed'] ?? 0;
            extra.readedCount = extraJson['readed_count'] ?? 0;
            extra.isMutualDeleted = extraJson['is_mutual_deleted'] ?? 0;
            extra.extraVersion = extraJson['extra_version'] ?? 0;
            list.add(extra);
          }
          TIMUIKitCore.getWKIMSDKInstance()
              .messageManager
              .saveRemoteExtraMsg(list);
        }
      }
    } catch (e) {
      print('Sync message extra error: $e');
    }
  }

  // 清空红点
  static Future<void> clearUnread(String channelId, int channelType) async {
    try {
      final response = await dio.put('/conversation/clearUnread', data: {
        'login_uid': WKHttpUtils.uid,
        'channel_id': channelId,
        'channel_type': channelType,
        'unread': 0,
      });

      if (response.statusCode == HttpStatus.ok) {
        print('Unread count cleared successfully');
      }
    } catch (e) {
      print('Clear unread count error: $e');
    }
  }

  // 清除频道消息
  static Future<void> clearChannelMsg(String channelId, int channelType) async {
    try {
      int maxSeq = await TIMUIKitCore.getWKIMSDKInstance()
          .messageManager
          .getMaxMessageSeq(channelId, channelType);

      final response = await dio.post('/message/offset', data: {
        'login_uid': WKHttpUtils.uid,
        'channel_id': channelId,
        'channel_type': channelType,
        'message_seq': maxSeq
      });

      if (response.statusCode == HttpStatus.ok) {
        TIMUIKitCore.getWKIMSDKInstance()
            .messageManager
            .clearWithChannel(channelId, channelType);
      }
    } catch (e) {
      print('Clear channel message error: $e');
    }
  }

  // 创建群
  static Future<bool> createGroup(String groupNo) async {
    try {
      final response = await dio.post('/group/create', data: {
        'login_uid': WKHttpUtils.uid,
        'group_no': groupNo,
      });
      return response.statusCode == HttpStatus.ok;
    } catch (e) {
      print('Create group error: $e');
      return false;
    }
  }

  // 修改群名称
  static Future<bool> updateGroupName(String groupNo, String groupName) async {
    try {
      final response = await dio.put('/groups/$groupNo', data: {
        'login_uid': WKHttpUtils.uid,
        'name': groupName,
      });
      return response.statusCode == HttpStatus.ok;
    } catch (e) {
      print('Update group name error: $e');
      return false;
    }
  }
}
