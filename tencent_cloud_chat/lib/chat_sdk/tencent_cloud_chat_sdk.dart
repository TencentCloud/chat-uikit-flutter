import 'dart:convert';

import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';

class TencentCloudChatSDK {
  static final V2TIMManager _manager = TencentImSDKPlugin.v2TIMManager;

  static const String _tag = "TencentCloudChatUIKitCoreSDK";

  static V2TimSDKListener getInitSDKListener(V2TimSDKListener? sdkListener) =>
      V2TimSDKListener(
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
          TencentCloudChat.dataInstance.basic.updateLoginStatus(
            status: false,
          );

          sdkListener?.onKickedOffline();
        },
        onSelfInfoUpdated: (info) {
          TencentCloudChat.dataInstance.basic
              .updateCurrentUserInfo(userFullInfo: info);

          sdkListener?.onSelfInfoUpdated(info);
        },
        onUserSigExpired: () {
          TencentCloudChat.dataInstance.basic.updateLoginStatus(
            status: false,
          );

          sdkListener?.onUserSigExpired();
        },
        onUserStatusChanged: (userStatusList) {
          TencentCloudChat.dataInstance.contact
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
              TencentCloudChat.dataInstance.messageData
                  .onReceiveNewMessage(message);
            }
          }

          sdkListener?.onPluginEventEmited(event);
        },
        onUIKitEventEmited: (event) {
          sdkListener?.onUIKitEventEmited(event);
        },
      );

  static V2TIMManager get manager => _manager;

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
      TencentCloudChat.dataInstance.basic.updateInitializedStatus(
        status: true,
      );
      TencentCloudChat.dataInstance.basic.updateSDKAppID(
        sdkappid: sdkAppID,
      );
    }

    TencentCloudChat.logInstance.console(
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
    TencentCloudChat.logInstance.console(
      componentName: _tag,
      logs:
          "login Is Called. Res Is $res. Desc Is ${loginRes.desc} Code is ${loginRes.code}",
    );
    TencentCloudChat.dataInstance.basic.updateLoginStatus(
      status: loginRes.code == 0,
    );
    return res;
  }

  static Future<bool> logout() async {
    V2TimCallback logoutRes = await _manager.logout();
    bool res = true;
    if (logoutRes.code == 0) {
      res = false;
    }
    TencentCloudChat.logInstance.console(
      componentName: _tag,
      logs:
          "logout Is Called. Res Is $res. Desc Is ${logoutRes.desc} Code is ${logoutRes.code}",
    );
    TencentCloudChat.dataInstance.basic.updateLoginStatus(
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

  static Future<void> setSelfInfo(
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
    if (res.code == 0) {}
  }

  addAdvancedMessageListener() {}
}
