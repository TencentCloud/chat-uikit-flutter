// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:tencent_cloud_chat/components/components_definition/tencent_cloud_chat_component_builder_definitions.dart';
import 'package:tencent_cloud_chat/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat_sdk/enum/callbacks.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_application.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_application.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_full_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_full_info.dart';

abstract class TencentCloudChatComponentBuilder {
  get tencentCloudChatMessageItemBuilders => null;

 getConversationHeaderBuilder({
    TextEditingController? textEditingController,
  }){}

  getConversationItemInfoBuilder(V2TimConversation conversation) {}

  getConversationItemContentBuilder(V2TimConversation conversation) {}

  getConversationItemAvatarBuilder(V2TimConversation conversation, bool isOnline) {}

  getContactAddContactListItemAvatarBuilder(V2TimUserFullInfo userFullInfo) {}

  getContactAddContactListItemContentBuilder(V2TimUserFullInfo userFullInfo) {}

  getContactAddContactInfoButtonBuilder(V2TimUserFullInfo userFullInfo, Function() openContactsDetailInfo) {}

  getContactAddContactsInfoVerificationBuilder(Function(String value) getVerification) {}

  getContactAddContactsInfoRemarksAndGroupBuilder(Function(String value) getRemarks, Function(String value) getFriendGroup) {}

  getContactAddContactsDetailInfoSendButton(Function() sendAddFriendApplication) {}

  getContactAddContactInfoAvatarBuilder(V2TimUserFullInfo userFullInfo) {}

  getContactAddContactInfoContentBuilder(V2TimUserFullInfo userFullInfo) {}

  getContactAppBarNameBuilder({String? title}) {}

  getContactApplicationItemAvatarBuilder(V2TimFriendApplication application) {}

  getContactApplicationItemContentBuilder(V2TimFriendApplication application) {}

  getContactApplicationItemButtonBuilder(V2TimFriendApplication application, ContactApplicationResult applicationResult, void Function(ContactApplicationResult result) getApplicationResultFromButton) {}

  getContactApplicationInfoAvatarBuilder(V2TimFriendApplication application) {}

  getContactApplicationInfoAddWordingBuilder(V2TimFriendApplication application) {}

  getContactApplicationInfoButtonBuilder(V2TimFriendApplication application, Function? resultFunction, ContactApplicationResult? applicationResult) {}

  getContactApplicationInfoContentBuilder(V2TimFriendApplication application) {}

  getContactListTabItemBuilder(TTabItem item) {}

  getContactListTagBuilder(String suspensionTag) {}

  getContactBlockListItemAvatarBuilder(V2TimFriendInfo friend) {}

  getContactBlockListItemContentBuilder(V2TimFriendInfo friend) {}

  getContactGroupApplicationItemGroupNameBuilder(V2TimGroupApplication groupApplication) {}

  getContactGroupApplicationItemContentBuilder(V2TimGroupApplication groupApplication) {}

  getContactGroupApplicationItemButtonBuilder(V2TimGroupApplication groupApplication) {}

  getContactItemAvatarBuilder(V2TimFriendInfo friend) {}

  getContactItemContentBuilder(V2TimFriendInfo friend) {}

  getContactItemElseBuilder(V2TimFriendInfo friend) {}

  getContactGroupListTagBuilder(String tag, int? count) {}

  getContactGroupListItemAvatarBuilder(V2TimGroupInfo group) {}

  getContactGroupListItemContentBuilder(V2TimGroupInfo group) {}

  getGroupProfileAvatarBuilder({required V2TimGroupInfo groupInfo, required List<V2TimGroupMemberFullInfo> groupMember}) {}

  getGroupProfileContentBuilder({required V2TimGroupInfo groupInfo}) {}

  getGroupProfileChatButtonBuilder({required V2TimGroupInfo groupInfo, VoidCallback? startVideoCall, VoidCallback? startVoiceCall}) {}

  getGroupProfileStateButtonBuilder({required V2TimGroupInfo groupInfo}) {}

  getGroupProfileMuteMemberBuilder({required V2TimGroupInfo groupInfo, required List<V2TimGroupMemberFullInfo> groupMember}) {}

  getGroupProfileSetNameCardBuilder({required V2TimGroupInfo groupInfo, required List<V2TimGroupMemberFullInfo> groupMember}) {}

  getGroupProfileMemberBuilder({required V2TimGroupInfo groupInfo, required List<V2TimGroupMemberFullInfo> groupMember, required List<V2TimFriendInfo> contactList}) {}

  getGroupProfileDeleteButtonBuilder({required V2TimGroupInfo groupInfo}) {}

  getGroupProfileNotificationPageBuilder({required V2TimGroupInfo groupInfo}) {}

  getGroupProfileMutePageBuilder({required V2TimGroupInfo groupInfo, required List<V2TimGroupMemberFullInfo> groupMember}) {}

  getGroupProfileAddMemberPageBuilder({required List<V2TimGroupMemberFullInfo> groupMember, required List<V2TimFriendInfo> contactList, required V2TimGroupInfo groupInfo}) {}

  getMessageHeader({
    Key? key,
    required MessageHeaderBuilderWidgets widgets,
    required MessageHeaderBuilderData data,
    required MessageHeaderBuilderMethods methods,
  }) {}

  getMessageForwardBuilder({
    Key? key,
    required MessageForwardBuilderWidgets widgets,
    required MessageForwardBuilderData data,
    required MessageForwardBuilderMethods methods,
  }) {}

  getMessageInputReplyBuilder({
    Key? key,
    MessageInputReplyBuilderWidgets? widgets,
    required MessageInputReplyBuilderData data,
    required MessageInputReplyBuilderMethods methods,
  }) {}

  getAttachmentOptionsBuilder({
    Key? key,
    MessageAttachmentOptionsBuilderWidgets? widgets,
    required MessageAttachmentOptionsBuilderData data,
    required MessageAttachmentOptionsBuilderMethods methods,
  }) {}

  getMessageInputSelectBuilder({
    Key? key,
    MessageInputSelectBuilderWidgets? widgets,
    required MessageInputSelectBuilderData data,
    required MessageInputSelectBuilderMethods methods,
  }) {}

  getMessageInputBuilder({
    Key? key,
    MessageInputBuilderWidgets? widgets,
    required MessageInputBuilderData data,
    required MessageInputBuilderMethods methods,
  }) {}

  getMessageLayoutBuilder({
    Key? key,
    required MessageLayoutBuilderWidgets widgets,
    required MessageLayoutBuilderData data,
    required MessageLayoutBuilderMethods methods,
  }) {}

  getMessageRowBuilder({
    Key? key,
    required MessageRowBuilderWidgets widgets,
    required MessageRowBuilderData data,
    required MessageRowBuilderMethods methods,
  }) {}

  getMessageNoChatBuilder() {}

  getMessageItemBuilder({
    Key? key,
    MessageItemBuilderWidgets? widgets,
    required MessageItemBuilderData data,
    required MessageItemBuilderMethods methods,
  }) {}

  getUserProfileAvatarBuilder({required V2TimUserFullInfo userFullInfo}) {}

  getUserProfileContentBuilder({required V2TimUserFullInfo userFullInfo}) {}

  getUserProfileChatButtonBuilder({required V2TimUserFullInfo userFullInfo, VoidCallback? startVideoCall, VoidCallback? startVoiceCall}) {}

  getUserProfileStateButtonBuilder({required V2TimUserFullInfo userFullInfo}) {}

  getMessageDynamicButtonBuilder({
    Key? key,
    MessageDynamicButtonBuilderWidgets? widgets,
    required MessageDynamicButtonBuilderData data,
    required MessageDynamicButtonBuilderMethods methods,
  }) {}

  getUserProfileDeleteButtonBuilder({required V2TimUserFullInfo userFullInfo}) {}

  getMessageRowMessageSenderAvatarBuilder({
    Key? key,
    MessageRowMessageSenderAvatarBuilderWidgets? widgets,
    required MessageRowMessageSenderAvatarBuilderData data,
    required MessageRowMessageSenderAvatarBuilderMethods methods,
  }){}

  getMessageRowMessageSenderNameBuilder({
    Key? key,
    MessageRowMessageSenderNameBuilderWidgets? widgets,
    required MessageRowMessageSenderNameBuilderData data,
    required MessageRowMessageSenderNameBuilderMethods methods,
  }){}
}
