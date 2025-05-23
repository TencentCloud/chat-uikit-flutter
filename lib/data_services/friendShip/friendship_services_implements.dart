import 'package:tencent_chat_i18n_tool/tencent_chat_i18n_tool.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimFriendshipListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/friend_application_type_enum.dart';
import 'package:tencent_cloud_chat_sdk/enum/friend_response_type_enum.dart';
import 'package:tencent_cloud_chat_sdk/enum/friend_type_enum.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_callback.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_callback.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_application_result.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_friend_application_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_check_result.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_friend_check_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_friend_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info_result.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_friend_info_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_operation_result.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_friend_operation_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_search_param.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_friend_search_param.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_full_info.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_user_full_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_status.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_user_status.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_value_callback.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_callback.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/core_services_implements.dart';
import 'package:tencent_cloud_chat_uikit/data_services/friendShip/friendship_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/error_message_converter.dart';

class FriendshipServicesImpl implements FriendshipServices {
  final CoreServicesImpl _coreService = serviceLocator<CoreServicesImpl>();

  @override
  Future<List<V2TimFriendInfoResult>?> getFriendsInfo({
    required List<String> userIDList,
  }) async {
    final res = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().getFriendsInfo(userIDList: userIDList);
    if (res.code == 0) {
      return res.data;
    } else {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: res.desc, errorCode: res.code));
      return null;
    }
  }

  @override
  Future<List<V2TimUserFullInfo>?> getUsersInfo({
    required List<String> userIDList,
  }) async {
    final res = await TencentImSDKPlugin.v2TIMManager.getUsersInfo(userIDList: userIDList);
    if (res.code == 0) {
      return res.data;
    } else {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: res.desc, errorCode: res.code));
      return null;
    }
  }

  @override
  Future<List<V2TimFriendOperationResult>?> addToBlackList({
    required List<String> userIDList,
  }) async {
    final res = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().addToBlackList(userIDList: userIDList);
    if (res.code == 0) {
      return res.data;
    } else {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: res.desc, errorCode: res.code));
      return null;
    }
  }

  @override
  Future<V2TimValueCallback<V2TimFriendOperationResult>> addFriend({
    required String userID,
    required FriendTypeEnum addType,
    String? remark,
    String? friendGroup,
    String? addSource,
    String? addWording,
  }) async {
    final result = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().addFriend(
          userID: userID,
          addType: addType,
          remark: remark,
          addWording: addWording,
          friendGroup: friendGroup,
          addSource: addSource,
        );
    if (result.code != 0) {
      _coreService.callOnCallback(TIMCallback(
        type: TIMCallbackType.API_ERROR,
        errorMsg: result.desc,
        errorCode: result.code,
        infoRecommendText: TIM_t("好友添加失败"),
      ));
    } else if (result.code == 0 && result.data?.resultCode != 0) {
      String recommendText = "";
      if (result.data != null && result.data!.resultCode != null) {
        recommendText = ErrorMessageConverter.getErrorMessage(result.data!.resultCode!);
      }

      _coreService.callOnCallback(TIMCallback(
        type: TIMCallbackType.API_ERROR,
        errorMsg: result.code == 0 ? result.data?.resultInfo : result.desc,
        errorCode: result.code == 0 ? result.data?.resultCode : result.code,
        infoRecommendText: recommendText,
      ));
    } else {
      _coreService.callOnCallback(TIMCallback(
        type: TIMCallbackType.API_ERROR,
        errorMsg: result.desc,
        errorCode: result.code,
        infoRecommendText: TIM_t("好友添加成功"),
      ));
    }

    return result;
  }

  @override
  Future<List<V2TimFriendOperationResult>?> deleteFromBlackList({
    required List<String> userIDList,
  }) async {
    final res =
        await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().deleteFromBlackList(userIDList: userIDList);
    if (res.code == 0) {
      return res.data;
    } else {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: res.desc, errorCode: res.code));
      return null;
    }
  }

  @override
  Future<List<V2TimFriendOperationResult>?> deleteFromFriendList({
    required List<String> userIDList,
    required FriendTypeEnum deleteType,
  }) async {
    final res = await TencentImSDKPlugin.v2TIMManager
        .getFriendshipManager()
        .deleteFromFriendList(userIDList: userIDList, deleteType: deleteType);
    if (res.code == 0) {
      _coreService.callOnCallback(TIMCallback(
          type: TIMCallbackType.API_ERROR,
          errorMsg: res.desc,
          errorCode: res.code,
          infoRecommendText: TIM_t("好友删除成功")));
      return res.data;
    } else {
      _coreService.callOnCallback(TIMCallback(
          type: TIMCallbackType.API_ERROR,
          errorMsg: res.desc,
          errorCode: res.code,
          infoRecommendText: TIM_t("好友删除失败")));
      return null;
    }
  }

  @override
  Future<List<V2TimFriendInfo>?> getFriendList() async {
    final res = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().getFriendList();
    if (res.code == 0) {
      return res.data;
    } else {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: res.desc, errorCode: res.code));
      return null;
    }
  }

  @override
  Future<List<V2TimFriendInfo>?> getBlackList() async {
    final res = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().getBlackList();
    if (res.code == 0) {
      return res.data;
    } else {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: res.desc, errorCode: res.code));
      return null;
    }
  }

  @override
  Future<List<V2TimFriendCheckResult>?> checkFriend({
    required List<String> userIDList,
    required FriendTypeEnum checkType,
  }) async {
    final res = await TencentImSDKPlugin.v2TIMManager
        .getFriendshipManager()
        .checkFriend(userIDList: userIDList, checkType: checkType);
    if (res.code == 0) {
      return res.data;
    } else {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: res.desc, errorCode: res.code));
      return null;
    }
  }

  @override
  Future<void> addFriendListener({
    required V2TimFriendshipListener listener,
  }) {
    return TencentImSDKPlugin.v2TIMManager.getFriendshipManager().addFriendListener(listener: listener);
  }

  @override
  Future<void> removeFriendListener({
    V2TimFriendshipListener? listener,
  }) {
    return TencentImSDKPlugin.v2TIMManager.getFriendshipManager().removeFriendListener(listener: listener);
  }

  @override
  Future<V2TimFriendApplicationResult?> getFriendApplicationList() async {
    final res = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().getFriendApplicationList();
    if (res.code == 0) {
      return res.data;
    } else {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: res.desc, errorCode: res.code));
      return null;
    }
  }

  @override
  Future<V2TimFriendOperationResult?> acceptFriendApplication({
    required FriendResponseTypeEnum responseType,
    required FriendApplicationTypeEnum type,
    required String userID,
  }) async {
    final res = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().acceptFriendApplication(
          responseType: responseType,
          type: type,
          userID: userID,
        );
    if (res.code == 0) {
      return res.data;
    } else {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: res.desc, errorCode: res.code));
      return null;
    }
  }

  @override
  Future<V2TimFriendOperationResult?> refuseFriendApplication(
      {required FriendApplicationTypeEnum type, required String userID}) async {
    final res = await TencentImSDKPlugin.v2TIMManager
        .getFriendshipManager()
        .refuseFriendApplication(type: type, userID: userID);
    if (res.code == 0) {
      return res.data;
    } else {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: res.desc, errorCode: res.code));
      return null;
    }
  }

  @override
  Future<V2TimCallback> setFriendInfo({
    required String userID,
    String? friendRemark,
    Map<String, String>? friendCustomInfo,
  }) async {
    final res = await TencentImSDKPlugin.v2TIMManager
        .getFriendshipManager()
        .setFriendInfo(friendRemark: friendRemark, friendCustomInfo: friendCustomInfo, userID: userID);
    if (res.code != 0) {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: res.desc, errorCode: res.code));
    }
    return res;
  }

  @override
  Future<List<V2TimFriendInfoResult>?> searchFriends({
    required V2TimFriendSearchParam searchParam,
  }) async {
    final res = await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().searchFriends(searchParam: searchParam);
    if (res.code == 0) {
      return res.data;
    } else {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: res.desc, errorCode: res.code));
      return null;
    }
  }

  @override
  Future<List<V2TimUserStatus>> getUserStatus({
    required List<String> userIDList,
  }) async {
    final res = await TencentImSDKPlugin.v2TIMManager.getUserStatus(userIDList: userIDList);
    if (res.code == 0) {
      return res.data ?? [];
    } else {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: res.desc, errorCode: res.code));
      return [];
    }
  }
}
