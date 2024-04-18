import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/preferred_size.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_message_common_defines.dart';
import 'package:tencent_cloud_chat/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat_sdk/enum/callbacks.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_application.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_application.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_full_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_full_info.dart';

abstract class TencentCloudChatComponentBuilder {
  get tencentCloudChatMessageItemBuilders => null;

  getConversationHeaderBuilder() {}

  getConversationItemInfoBuilder(V2TimConversation conversation) {}

  getConversationItemContentBuilder(V2TimConversation conversation) {}

  getConversationItemAvatarBuilder(
      V2TimConversation conversation, bool isOnline) {}

  getContactAddContactListItemAvatarBuilder(V2TimUserFullInfo userFullInfo) {}

  getContactAddContactListItemContentBuilder(V2TimUserFullInfo userFullInfo) {}

  getContactAddContactInfoButtonBuilder(
      V2TimUserFullInfo userFullInfo, Function() openContactsDetailInfo) {}

  getContactAddContactsInfoVerificationBuilder(
      Function(String value) getVerification) {}

  getContactAddContactsInfoRemarksAndGroupBuilder(
      Function(String value) getRemarks,
      Function(String value) getFriendGroup) {}

  getContactAddContactsDetailInfoSendButton(
      Function() sendAddFriendApplication) {}

  getContactAddContactInfoAvatarBuilder(V2TimUserFullInfo userFullInfo) {}

  getContactAddContactInfoContentBuilder(V2TimUserFullInfo userFullInfo) {}

  getContactAppBarNameBuilder({String? title}) {}

  getContactApplicationItemAvatarBuilder(V2TimFriendApplication application) {}

  getContactApplicationItemContentBuilder(V2TimFriendApplication application) {}

  getContactApplicationItemButtonBuilder(
      V2TimFriendApplication application,
      ContactApplicationResult applicationResult,
      void Function(ContactApplicationResult result)
          getApplicationResultFromButton) {}

  getContactApplicationInfoAvatarBuilder(V2TimFriendApplication application) {}

  getContactApplicationInfoAddWordingBuilder(
      V2TimFriendApplication application) {}

  getContactApplicationInfoButtonBuilder(V2TimFriendApplication application,
      Function? resultFunction, ContactApplicationResult? applicationResult) {}

  getContactApplicationInfoContentBuilder(V2TimFriendApplication application) {}

  getContactListTabItemBuilder(TTabItem item) {}

  getContactListTagBuilder(String suspensionTag) {}

  getContactBlockListItemAvatarBuilder(V2TimFriendInfo friend) {}

  getContactBlockListItemContentBuilder(V2TimFriendInfo friend) {}

  getContactGroupApplicationItemGroupNameBuilder(
      V2TimGroupApplication groupApplication) {}

  getContactGroupApplicationItemContentBuilder(
      V2TimGroupApplication groupApplication) {}

  getContactGroupApplicationItemButtonBuilder(
      V2TimGroupApplication groupApplication) {}

  getContactItemAvatarBuilder(V2TimFriendInfo friend) {}

  getContactItemContentBuilder(V2TimFriendInfo friend) {}

  getContactItemElseBuilder(V2TimFriendInfo friend) {}

  getContactGroupListTagBuilder(String tag, int? count) {}

  getContactGroupListItemAvatarBuilder(V2TimGroupInfo group) {}

  getContactGroupListItemContentBuilder(V2TimGroupInfo group) {}

  getGroupProfileAvatarBuilder(
      {required V2TimGroupInfo groupInfo,
      required List<V2TimGroupMemberFullInfo> groupMember}) {}

  getGroupProfileContentBuilder({required V2TimGroupInfo groupInfo}) {}

  getGroupProfileChatButtonBuilder(
      {required V2TimGroupInfo groupInfo,
      VoidCallback? startVideoCall,
      VoidCallback? startVoiceCall}) {}

  getGroupProfileStateButtonBuilder({required V2TimGroupInfo groupInfo}) {}

  getGroupProfileMuteMemberBuilder(
      {required V2TimGroupInfo groupInfo,
      required List<V2TimGroupMemberFullInfo> groupMember}) {}

  getGroupProfileSetNameCardBuilder(
      {required V2TimGroupInfo groupInfo,
      required List<V2TimGroupMemberFullInfo> groupMember}) {}

  getGroupProfileMemberBuilder(
      {required V2TimGroupInfo groupInfo,
      required List<V2TimGroupMemberFullInfo> groupMember,
      required List<V2TimFriendInfo> contactList}) {}

  getGroupProfileDeleteButtonBuilder({required V2TimGroupInfo groupInfo}) {}

  getGroupProfileNotificationPageBuilder({required V2TimGroupInfo groupInfo}) {}

  getGroupProfileMutePageBuilder(
      {required V2TimGroupInfo groupInfo,
      required List<V2TimGroupMemberFullInfo> groupMember}) {}

  getGroupProfileAddMemberPageBuilder(
      {required List<V2TimGroupMemberFullInfo> groupMember,
      required List<V2TimFriendInfo> contactList,
      required V2TimGroupInfo groupInfo}) {}

  getMessageHeader(
      {required controller,
      required bool Function() onCancelSelect,
      required List<V2TimMessage> Function() onClearSelect,
      required int selectAmount,
      required bool inSelectMode,
      required Future<V2TimConversation> Function({bool shouldUpdateState})
          loadConversation,
      String? userID,
      String? groupID,
      V2TimConversation? conversation,
      Future<void> Function()? startVideoCall,
      Future<void> Function()? startVoiceCall,
      required bool showUserOnlineStatus,
      required bool Function({required String userID}) getUserOnlineStatus,
      required List<V2TimGroupMemberFullInfo> Function()
          getGroupMembersInfo}) {}

  getMessageForwardBuilder(
      {required TencentCloudChatForwardType type,
      required List<V2TimConversation> conversationList,
      required Null Function(dynamic chatList) onSelectConversations,
      required void Function() onCancel,
      required List<V2TimGroupInfo> groupList,
      required List<V2TimFriendInfo> contactList}) {}

  getMessageInputReplyBuilder(
      {V2TimMessage? repliedMessage,
      required Null Function() onCancel,
      required V2TimMessage? Function() onClickReply}) {}

  getAttachmentOptionsBuilder(
      {required List<TencentCloudChatMessageGeneralOptionItem>
          attachmentOptions,
      required void Function() onActionFinish}) {}

  getMessageInputSelectBuilder(
      {required List<V2TimMessage> messages,
      required bool enableMessageDeleteForEveryone,
      required bool enableMessageForwardIndividually,
      required bool enableMessageForwardCombined,
      required bool enableMessageDeleteForSelf,
      required Null Function(dynamic messages) onDeleteForMe,
      required Null Function(dynamic messages) onDeleteForEveryone}) {}

  getMessageInputBuilder(
      {required controller,
      required void Function(
              {List<String>? mentionedUsers, required String text})
          sendTextMessage,
      required void Function({required String videoPath}) sendVideoMessage,
      required void Function({required String imagePath}) sendImageMessage,
      required void Function({required int duration, required String voicePath})
          sendVoiceMessage,
      required TencentCloudChatMessageInputStatus status,
      required void Function({required String filePath}) sendFileMessage,
      String? userID,
      required bool isGroupAdmin,
      String? groupID,
      required List<TencentCloudChatMessageGeneralOptionItem>
          attachmentOrInputControlBarOptions,
      required bool inSelectMode,
      required List<V2TimMessage> selectedMessages,
      V2TimMessage? repliedMessage,
      required Null Function() clearRepliedMessage,
      required Future<List<V2TimGroupMemberFullInfo>> Function(
              {int? maxSelectionAmount, String? onSelectLabel, String? title})
          onChooseGroupMembers,
      required desktopInputMemberSelectionPanelScroll,
      required double desktopMentionBoxPositionX,
      required double desktopMentionBoxPositionY,
      required List<V2TimGroupMemberFullInfo> groupMemberList,
      required int activeMentionIndex,
      required List<V2TimGroupMemberFullInfo?>
          currentFilteredMembersListForMention,
      required Function(dynamic value) setDesktopMentionBoxPositionX,
      required Function(dynamic value) setDesktopMentionBoxPositionY,
      required Function(dynamic value) setActiveMentionIndex,
      required Function(dynamic value) setCurrentFilteredMembersListForMention,
      V2TimGroupMemberFullInfo? memberNeedToMention,
      required String currentConversationShowName}) {}

  getMessageLayoutBuilder(
      {String? userID,
      String? groupID,
      required PreferredSizeWidget header,
      required Widget messageListView,
      required Widget messageInput,
      required String currentConversationShowName,
      required double desktopMentionBoxPositionY,
      required double desktopMentionBoxPositionX,
      required int activeMentionIndex,
      required List<V2TimGroupMemberFullInfo?>
          currentFilteredMembersListForMention,
      required desktopInputMemberSelectionPanelScroll,
      required void Function({required String filePath}) sendFileMessage,
      required void Function({required int duration, required String voicePath})
          sendVoiceMessage,
      required void Function({required String videoPath}) sendVideoMessage,
      required void Function({required String imagePath}) sendImageMessage,
      required void Function(
              {List<String>? mentionedUsers, required String text})
          sendTextMessage,
      required Null Function(
              ({int index, V2TimGroupMemberFullInfo memberFullInfo}) memberData)
          onSelectMember}) {}

  getMessageRowBuilder(
      {required Key key,
      required V2TimMessage message,
      String? userID,
      String? groupID,
      required double messageRowWidth,
      required bool inSelectMode,
      required Future<bool> Function(
              {bool highLightTargetMessage,
              V2TimMessage? message,
              int? seq,
              int? timeStamp})
          loadToSpecificMessage,
      required bool showSelfAvatar,
      required bool showOthersAvatar,
      required bool showMessageTimeIndicator,
      required bool showMessageStatusIndicator,
      required bool isSelected,
      required bool isMergeMessage,
      required Null Function(dynamic msg) onSelectCurrent}) {}

  getMessageNoChatBuilder() {}

  getUserProfileAvatarBuilder({required V2TimUserFullInfo userFullInfo}) {}

  getUserProfileContentBuilder({required V2TimUserFullInfo userFullInfo}) {}

  getUserProfileChatButtonBuilder(
      {required V2TimUserFullInfo userFullInfo,
      VoidCallback? startVideoCall,
      VoidCallback? startVoiceCall}) {}

  getUserProfileStateButtonBuilder({required V2TimUserFullInfo userFullInfo}) {}

  getUserProfileDeleteButtonBuilder(
      {required V2TimUserFullInfo userFullInfo}) {}
}
