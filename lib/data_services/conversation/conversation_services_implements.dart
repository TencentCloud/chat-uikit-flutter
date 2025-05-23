import 'package:tencent_cloud_chat_sdk/enum/V2TimConversationListener.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_callback.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_callback.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation_result.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_conversation_result.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_callback.dart';
import 'package:tencent_cloud_chat_uikit/data_services/conversation/conversation_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/core_services_implements.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';

class ConversationServicesImpl extends ConversationService {
  final CoreServicesImpl _coreService = serviceLocator<CoreServicesImpl>();

  @override
  Future<V2TimConversationResult?> getConversationList({
    required String nextSeq,
    required int count,
  }) async {
    final result = await TencentImSDKPlugin.v2TIMManager
        .getConversationManager()
        .getConversationList(nextSeq: nextSeq, count: count);
    if (result.code == 0) {
      return result.data;
    } else {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: result.desc, errorCode: result.code));
      return null;
    }
  }

  @override
  Future<V2TimCallback> pinConversation({
    required String conversationID,
    required bool isPinned,
  }) async {
    final result = await TencentImSDKPlugin.v2TIMManager
        .getConversationManager()
        .pinConversation(conversationID: conversationID, isPinned: isPinned);
    if (result.code != 0) {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: result.desc, errorCode: result.code));
    }
    return result;
  }

  @override
  Future<V2TimCallback> deleteConversation({
    required String conversationID,
  }) async {
    final result = await TencentImSDKPlugin.v2TIMManager
        .getConversationManager()
        .deleteConversation(conversationID: conversationID);
    if (result.code != 0) {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: result.desc, errorCode: result.code));
    }
    return result;
  }

  @override
  Future<void> addConversationListener({
    required V2TimConversationListener listener,
  }) {
    return TencentImSDKPlugin.v2TIMManager.getConversationManager().addConversationListener(listener: listener);
  }

  @override
  Future<V2TimConversation?> getConversation({
    required String conversationID,
  }) async {
    final res =
        await TencentImSDKPlugin.v2TIMManager.getConversationManager().getConversation(conversationID: conversationID);
    if (res.code == 0) {
      return res.data;
    } else {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: res.desc, errorCode: res.code));
    }
    return null;
  }

  @override
  Future<V2TimCallback> setConversationDraft({required String conversationID, String? draftText}) async {
    final result = await TencentImSDKPlugin.v2TIMManager
        .getConversationManager()
        .setConversationDraft(conversationID: conversationID, draftText: draftText);
    if (result.code != 0) {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: result.desc, errorCode: result.code));
    }
    return result;
  }

  @override
  Future<void> removeConversationListener({V2TimConversationListener? listener}) {
    return TencentImSDKPlugin.v2TIMManager.getConversationManager().removeConversationListener(listener: listener);
  }

  @override
  Future<V2TimConversation?> getConversationListByConversationId({required String convID}) async {
    final result = await TencentImSDKPlugin.v2TIMManager
        .getConversationManager()
        .getConversationListByConversationIds(conversationIDList: [convID]);
    if (result.code != 0) {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: result.desc, errorCode: result.code));
    }
    return (result.data != null && result.data!.isNotEmpty) ? result.data![0] : null;
  }

  @override
  Future<int> getTotalUnreadCount() async {
    final res = await TencentImSDKPlugin.v2TIMManager.getConversationManager().getTotalUnreadMessageCount();
    if (res.code == 0) {
      return res.data ?? 0;
    }
    _coreService.callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: res.desc, errorCode: res.code));
    return 0;
  }
}
