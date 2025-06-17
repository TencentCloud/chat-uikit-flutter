library tencent_cloud_chat;

import 'package:tencent_cloud_chat_common/cache/tencent_cloud_chat_cache_global.dart';
import 'package:tencent_cloud_chat_common/chat_sdk/tencent_cloud_chat_sdk.dart';
import 'package:tencent_cloud_chat_common/controller/tencent_cloud_chat_controller.dart';
import 'package:tencent_cloud_chat_common/data/tencent_cloud_chat_data.dart';
import 'package:tencent_cloud_chat_common/eventbus/tencent_cloud_chat_eventbus.dart';
import 'package:tencent_cloud_chat_common/log/tencent_cloud_chat_log.dart';
import 'package:tencent_cloud_chat_common/models/tencent_cloud_chat_callbacks_trigger.dart';
import 'package:tencent_cloud_chat_common/observer/tencent_cloud_chat_observer.dart';

export 'package:path_provider/path_provider.dart';
export 'package:tencent_cloud_chat_intl/tencent_cloud_chat_intl.dart';
// SDK
export "package:tencent_cloud_chat_sdk/enum/V2TIMManager.dart";
export "package:tencent_cloud_chat_sdk/enum/V2TimAdvancedMsgListener.dart";
export "package:tencent_cloud_chat_sdk/enum/V2TimConversationListener.dart";
export "package:tencent_cloud_chat_sdk/enum/V2TimFriendshipListener.dart";
export "package:tencent_cloud_chat_sdk/enum/V2TimGroupListener.dart";
export "package:tencent_cloud_chat_sdk/enum/V2TimSDKListener.dart";
export "package:tencent_cloud_chat_sdk/enum/V2TimSignalingListener.dart";
export "package:tencent_cloud_chat_sdk/enum/V2TimSimpleMsgListener.dart";
export "package:tencent_cloud_chat_sdk/enum/at_info_types.dart";
export "package:tencent_cloud_chat_sdk/enum/callbacks.dart";
export "package:tencent_cloud_chat_sdk/enum/conversation_type.dart";
export "package:tencent_cloud_chat_sdk/enum/friend_application_type_enum.dart";
export "package:tencent_cloud_chat_sdk/enum/friend_response_type_enum.dart";
export "package:tencent_cloud_chat_sdk/enum/friend_type.dart";
export "package:tencent_cloud_chat_sdk/enum/friend_type_enum.dart";
export "package:tencent_cloud_chat_sdk/enum/get_group_message_read_member_list_filter.dart";
export "package:tencent_cloud_chat_sdk/enum/group_add_opt_enum.dart";
export "package:tencent_cloud_chat_sdk/enum/group_add_opt_type.dart";
export "package:tencent_cloud_chat_sdk/enum/group_application_handle_result.dart";
export "package:tencent_cloud_chat_sdk/enum/group_application_handle_status.dart";
export "package:tencent_cloud_chat_sdk/enum/group_application_type.dart";
export "package:tencent_cloud_chat_sdk/enum/group_application_type_enum.dart";
export "package:tencent_cloud_chat_sdk/enum/group_change_info_type.dart";
export "package:tencent_cloud_chat_sdk/enum/group_member_filter_enum.dart";
export "package:tencent_cloud_chat_sdk/enum/group_member_filter_type.dart";
export "package:tencent_cloud_chat_sdk/enum/group_member_role.dart";
export "package:tencent_cloud_chat_sdk/enum/group_member_role_enum.dart";
export "package:tencent_cloud_chat_sdk/enum/group_tips_elem_type.dart";
export "package:tencent_cloud_chat_sdk/enum/group_type.dart";
export "package:tencent_cloud_chat_sdk/enum/history_message_get_type.dart";
export "package:tencent_cloud_chat_sdk/enum/history_msg_get_type_enum.dart";
export "package:tencent_cloud_chat_sdk/enum/log_level.dart";
export "package:tencent_cloud_chat_sdk/enum/log_level_enum.dart";
export "package:tencent_cloud_chat_sdk/enum/message_elem_type.dart";
export "package:tencent_cloud_chat_sdk/enum/message_priority.dart";
export "package:tencent_cloud_chat_sdk/enum/message_priority_enum.dart";
export "package:tencent_cloud_chat_sdk/enum/message_status.dart";
export "package:tencent_cloud_chat_sdk/enum/offlinePushInfo.dart";
export "package:tencent_cloud_chat_sdk/enum/receive_message_opt_enum.dart";
export "package:tencent_cloud_chat_sdk/enum/simpleMsgListenerType.dart";
export "package:tencent_cloud_chat_sdk/enum/user_info_allow_type.dart";
export "package:tencent_cloud_chat_sdk/enum/utils.dart";
export "package:tencent_cloud_chat_sdk/enum/v2_tim_conversation_marktype.dart";
export "package:tencent_cloud_chat_sdk/enum/v2_tim_keyword_list_match_type.dart";
export "package:tencent_cloud_chat_sdk/manager/v2_tim_conversation_manager.dart";
export "package:tencent_cloud_chat_sdk/manager/v2_tim_friendship_manager.dart";
export "package:tencent_cloud_chat_sdk/manager/v2_tim_group_manager.dart";
export "package:tencent_cloud_chat_sdk/manager/v2_tim_manager.dart";
export "package:tencent_cloud_chat_sdk/manager/v2_tim_message_manager.dart";
export "package:tencent_cloud_chat_sdk/manager/v2_tim_offline_push_manager.dart";
export "package:tencent_cloud_chat_sdk/manager/v2_tim_signaling_manager.dart";
export "package:tencent_cloud_chat_sdk/enum/user_status_type.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_application_processed.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_callback.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_conversationList_filter.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_conversation_operation_result.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_conversation_result.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_custom_elem.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_face_elem.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_file_elem.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_friend_application.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_friend_application_result.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_friend_check_result.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_friend_group.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_friend_info.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_friend_info_result.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_friend_operation_result.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_friend_search_param.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_grant_administrator.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_group_application.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_group_application_result.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_group_at_info.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_group_attribute_changed.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_group_change_info.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_group_created.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_group_dismissed.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_group_info.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_group_info_changed.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_group_info_result.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_group_member.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_group_member_change_info.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_group_member_full_info.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_group_member_info.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_group_member_info_result.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_group_member_operation_result.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_group_member_search_param.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_group_member_search_result.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_group_message_read_member_list.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_group_recycled.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_group_search_param.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_group_tips_elem.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_image.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_image_elem.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_location_elem.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_member.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_member_enter.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_member_info_changed.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_member_invited.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_member_kicked.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_member_leave.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_merger_elem.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_message.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_message_change_info.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_message_download_progress.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_message_extension.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_message_extension_result.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_message_list_result.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_message_online_url.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_message_receipt.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_message_search_param.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_message_search_result.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_message_search_result_item.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_msg_create_info_result.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_quit_from_group.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_receive_message_opt_info.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_receive_rest_custom_data.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_recv_c2c_custom_message.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_recv_c2c_text_message.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_recv_group_custom_message.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_recv_group_text_message.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_revoke_administrator.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_signaling_info.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_sound_elem.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_text_elem.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_topic_info.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_topic_info_result.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_topic_operation_result.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_user_full_info.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_user_info.dart";
export 'package:tencent_cloud_chat_sdk/models/v2_tim_message_reaction.dart';
export "package:tencent_cloud_chat_sdk/models/v2_tim_user_status.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart";
export "package:tencent_cloud_chat_sdk/models/v2_tim_video_elem.dart";
export 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';

class TencentCloudChat {
  TencentCloudChat._();

  static final TencentCloudChat _instance = TencentCloudChat._();

  static TencentCloudChat get instance => _instance;

  final TencentCloudChatCallbacksTrigger callbacks = TencentCloudChatCallbacksTriggerGenerator.getInstance();

  final TencentCloudChatCoreController chatController = TencentCloudChatCoreControllerGenerator.getInstance();

  static TencentCloudChatCoreController get controller => TencentCloudChat.instance.chatController;

  final TencentCloudChatLog logInstance = TencentCloudChatLogGenerator.getInstance();

  final TencentCloudChatData dataInstance = TencentCloudChatData.getInstance();

  final TencentCloudChatEventBus eventBusInstance = TencentCloudChatEventBusGenerator.getInstance();

  final TencentCloudChatSDK chatSDKInstance = TencentCloudChatSDKGenerator.getInstance();

  final TencentCloudChatCacheGlobal cache = TencentCloudChatCacheGlobal.instance;

  final TencentCloudChatObserver navigatorObserver = TencentCloudChatObserver.getInstance();
}
