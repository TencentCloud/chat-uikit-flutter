import 'dart:convert';

import 'package:tencent_cloud_chat_common/chat_sdk/components/tencent_cloud_chat_contact_sdk.dart';
import 'package:tencent_cloud_chat_common/chat_sdk/components/tencent_cloud_chat_conversation_sdk.dart';
import 'package:tencent_cloud_chat_common/chat_sdk/components/tencent_cloud_chat_group_sdk.dart';
import 'package:tencent_cloud_chat_common/chat_sdk/components/tencent_cloud_chat_message_sdk.dart';
import 'package:tencent_cloud_chat_common/chat_sdk/components/tencent_cloud_chat_search_sdk.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';

class TencentCloudChatSDKGenerator {
  static TencentCloudChatSDK getInstance() {
    return TencentCloudChatSDK._();
  }
}

class TencentCloudChatSDK {
  TencentCloudChatSDK._();

  final V2TIMManager _manager = TencentImSDKPlugin.v2TIMManager;

  static const String _tag = "TencentCloudChatUIKitCoreSDK";

  final contactSDK = TencentCloudChatContactSDKGenerator.getInstance();

  final conversationSDK =
      TencentCloudChatConversationSDKGenerator.getInstance();

  final messageSDK = TencentCloudChatMessageSDKGenerator.getInstance();

  final groupSDK = TencentCloudChatGroupSDKGenerator.getInstance();

  final searchSDK = TencentCloudChatSearchSDKGenerator.getInstance();

  V2TimSDKListener getInitSDKListener(V2TimSDKListener? sdkListener) => V2TimSDKListener(
        onConnectFailed: (code, error) {
          sdkListener?.onConnectFailed(code, error);
        },
        onConnectSuccess: () {
          sdkListener?.onConnectSuccess();
        },
        onConnecting: () {
          sdkListener?.onConnecting();
        },
        onKickedOffline: () {
          TencentCloudChat.instance.dataInstance.basic.updateLoginStatus(
            status: false,
          );

          sdkListener?.onKickedOffline();
        },
        onSelfInfoUpdated: (info) {
          TencentCloudChat.instance.dataInstance.basic
              .updateCurrentUserInfo(userFullInfo: info);

          sdkListener?.onSelfInfoUpdated(info);
        },
        onUserSigExpired: () {
          TencentCloudChat.instance.dataInstance.basic.updateLoginStatus(
            status: false,
          );

          sdkListener?.onUserSigExpired();
        },
        onUserStatusChanged: (userStatusList) {
          TencentCloudChat.instance.dataInstance.contact
              .buildUserStatusList(userStatusList, "onUserStatusChanged");

          sdkListener?.onUserStatusChanged(userStatusList);
        },
        onPluginEventEmited: (event) {
          // Handle TencentCloudChatRobot Plugin sendMessage
          if (event.pluginName == "TencentCloudChatRobotPlugin") {
            if (event.type == "onSendMessageToRobotSuccess") {
              Map<String, dynamic> messageMap =
                  json.decode(event.detail["data"] ?? "{}");
              var message = V2TimMessage.fromJson(messageMap);
              TencentCloudChat.instance.dataInstance.messageData
                  .onReceiveNewMessage(message);
            }
          }

          if (event.pluginName == "TencentCloudChatCustomerServicePlugin") {
            if (event.type == "onSendMessageToCustomerServiceSuccess") {
              Map<String, dynamic> messageMap =
                  json.decode(event.detail["data"] ?? "{}");
              var message = V2TimMessage.fromJson(messageMap);
              TencentCloudChat.instance.dataInstance.messageData
                  .onReceiveNewMessage(message);
            }
          }

          sdkListener?.onPluginEventEmited(event);
        },
        onUIKitEventEmited: (event) {
          sdkListener?.onUIKitEventEmited(event);
        },
      );

  V2TIMManager get manager => _manager;

  Future<bool> initSDK({
    required int sdkAppID,
    LogLevelEnum? logLevel,
    V2TimSDKListener? sdkListener,
  }) async {
    logLevel ??= LogLevelEnum.V2TIM_LOG_DEBUG;

    V2TimValueCallback<bool> initRes = await _manager.initSDK(
      sdkAppID: sdkAppID,
      loglevel: logLevel,
      listener: getInitSDKListener(sdkListener),
    );

    bool res = initRes.data ?? false;

    if (res) {
      TencentCloudChat.instance.dataInstance.basic.updateInitializedStatus(
        status: true,
      );
      TencentCloudChat.instance.dataInstance.basic.updateSDKAppID(
        sdkappid: sdkAppID,
      );
    }

    TencentCloudChat.instance.logInstance.console(
      componentName: _tag,
      logs: "initSDK Is Called. Res Is $res",
    );

    return res;
  }

  Future<bool> login({
    required String userID,
    required String userSig,
  }) async {
    V2TimCallback loginRes = await _manager.login(
      userID: userID,
      userSig: userSig,
    );
    bool res = false;
    if (loginRes.code == 0) {
      res = true;
    }
    TencentCloudChat.instance.logInstance.console(
      componentName: _tag,
      logs:
          "login Is Called. Res Is $res. Desc Is ${loginRes.desc} Code is ${loginRes.code}",
    );
    TencentCloudChat.instance.dataInstance.basic.updateLoginStatus(
      status: loginRes.code == 0,
    );
    return res;
  }

  Future<bool> logout() async {
    V2TimCallback logoutRes = await _manager.logout();
    bool res = false;
    if (logoutRes.code == 0) {
      _manager.unInitSDK();
      res = true;
    }
    TencentCloudChat.instance.logInstance.console(
      componentName: _tag,
      logs:
          "logout Is Called. Res Is $res. Desc Is ${logoutRes.desc} Code is ${logoutRes.code}",
    );
    TencentCloudChat.instance.dataInstance.basic.updateLoginStatus(
      status: res,
    );
    return res;
  }

  Future<void> uikitTrace({
    required String trace,
  }) async {
    manager.uikitTrace(
      trace: trace,
    );
  }

  Future<V2TimCallback> setSelfInfo(
      {String? userID,
      String? nickName,
      String? faceUrl,
      String? signature,
      int? gender,
      int? allowType,
      int? role,
      int? level,
      int? birthday}) async {
    V2TimUserFullInfo info = V2TimUserFullInfo(
        userID: userID,
        nickName: nickName,
        faceUrl: faceUrl,
        selfSignature: signature,
        gender: gender,
        allowType: allowType,
        role: role,
        level: level,
        birthday: birthday);
    V2TimCallback res = await _manager.setSelfInfo(userFullInfo: info);
    return res;
  }

  addAdvancedMessageListener() {}
}
