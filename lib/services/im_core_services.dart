import 'package:zhaopin/app_config.dart';
import 'package:zhaopin/constants.dart';
import 'package:zhaopin/im/data_services/core/tim_uikit_config.dart';
import 'package:zhaopin/im/tencent_cloud_chat_uikit.dart';
import 'package:zhaopin/im/utils/im_utils.dart';
import 'package:zhaopin/net/index.dart';
import 'package:zhaopin/services/services_locator.dart';
import 'package:zhaopin/services/user_services.dart';
import 'package:zhaopin/utils/log_utils.dart';
import 'package:zhaopin/widget/yd_alert_dialog.dart';

class IMCoreServices {
  String? userID;

  String? userSig;

  //adk是否初始化
  bool isInitIMSDK = false;

  final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();

  final V2TIMManager _sdkInstance = TIMUIKitCore.getSDKInstance();

  // 初始化im
  initIMSDKAndAddIMListeners() async {
    final isInitSuccess = await _coreInstance.init(
      config: const TIMUIKitConfig(
        isShowOnlineStatus: true,
        isCheckDiskStorageSpace: true,
      ),
      onTUIKitCallbackListener: (TIMCallback callbackValue) {
        switch (callbackValue.type) {
          case TIMCallbackType.INFO:
            break;
          case TIMCallbackType.API_ERROR:
            print(
                "错误 from TUIKit: ${callbackValue.errorMsg}, Code: ${callbackValue.errorCode}");
            break;
          case TIMCallbackType.FLUTTER_ERROR:
          default:
        }
      },
      sdkAppID: Constants.skdAppID,
      loglevel: AppConfig.mode == AppMode.debug
          ? LogLevelEnum.V2TIM_LOG_INFO
          : LogLevelEnum.V2TIM_LOG_ERROR,
      listener: V2TimSDKListener(
        onConnectFailed: onConnectFailed,
        // SDK 已经成功连接到腾讯云服务器
        onConnectSuccess: onConnectSuccess,
        // SDK 正在连接到腾讯云服务器
        onConnecting: onConnecting,
        // 当前用户被踢下线，此时可以 UI 提示用户，并再次调用 V2TIMManager 的 login() 函数重新登录。
        onKickedOffline: onKickedOffline,
        // 在线时票据过期：此时您需要生成新的 userSig 并再次调用 V2TIMManager 的 login() 函数重新登录。
        onUserSigExpired: onUserSigExpired,
        // 登录用户的资料发生了更新
        onSelfInfoUpdated: onSelfInfoUpdated,
      ),
    );
    isInitIMSDK = isInitSuccess ?? false;
    return isInitSuccess;
  }

  onConnectFailed(code, error) {}

  onConnectSuccess() {}

  onConnecting() {}

  // 当前用户被踢下线
  onKickedOffline() async {
    await showYDAlertDialog(
      titleStr: '温馨提示',
      contentStr: '您已经在其他端登录了当前帐号',
    );
    if (ServiceLocator.userServices.loginType == LoginUserType.c) {
      ServiceLocator.userServices.logoutC();
    } else {
      ServiceLocator.userServices.logoutB();
    }
  }

  // 获取IM登录需要的userID和userSig  C-0  B-1
  Future fetchUserIdAndIMSig() async {
    final url = ServiceLocator.userServices.loginType == LoginUserType.c
        ? HttpApi.bApi.bIMSign
        : HttpApi.bApi.bIMSign;
    final res = await HttpUtils().get(url, showLoading: false);
    if (isHttpResError(res)) return;
    userID = IMUtils.userIDWithEnv(res!.data['imAccount']);
    userSig = res.data['userSig'];
  }

  // 登录票据已经过期
  onUserSigExpired() async {
    await fetchUserIdAndIMSig();
    await login();
  }

  // 登录用户的资料发生了更新
  onSelfInfoUpdated(V2TimUserFullInfo info) {}

  // 反初始化，基本用不到
  Future<bool> unInit() async {
    final res = await TencentImSDKPlugin.v2TIMManager.unInitSDK();
    return res.code == 0;
  }

  // 登录
  Future<V2TimCallback?> login() async {
    if (userID == null || userSig == null) return null;
    final result =
        await _coreInstance.login(userID: userID!, userSig: userSig!);
    LogUtils.d('im登陆: ${result.code} ${result.desc}');
    return result;
  }

  //退出im
  Future<V2TimCallback?> logout() async {
    return await _coreInstance.logout();
  }

  // 登录
  loginWithRetry() async {
    bool success = false;
    while (!success) {
      V2TimCallback? res = await login();
      if (res?.code == 0) {
        success = true;
        didLoginSuccess();
      } else {
        await Future.delayed(const Duration(seconds: 2));
      }
    }
  }

  // 登录成功
  didLoginSuccess() async {}

  Future<bool> isLogin() async {
    V2TimValueCallback<int> getLoginStatusRes =
        await _sdkInstance.getLoginStatus();
    if (getLoginStatusRes.code == 0) {
      int status = getLoginStatusRes.data!;
      if (status == 0 || status == 1) {
        return true;
      }
    }
    return false;
  }
}
