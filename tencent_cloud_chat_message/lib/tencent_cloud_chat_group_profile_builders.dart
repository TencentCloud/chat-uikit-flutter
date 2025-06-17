import 'package:flutter/widgets.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_builder.dart';
import 'package:tencent_cloud_chat_common/data/group_profile/tencent_cloud_chat_group_profile_data.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_message/group_profile_widgets/tencent_cloud_chat_group_profile_body.dart';
import 'package:tencent_cloud_chat_message/group_profile_widgets/tencent_cloud_chat_group_notification.dart';

typedef GroupProfileAvatarBuilder = Widget? Function({
  required V2TimGroupInfo groupInfo,
  required List<V2TimGroupMemberFullInfo> groupMember,
});

typedef GroupProfileContentBuilder = Widget? Function(
    {required V2TimGroupInfo groupInfo});

typedef GroupProfileChatButtonBuilder = Widget? Function(
    {required V2TimGroupInfo groupInfo,
    VoidCallback? startVideoCall,
    VoidCallback? startVoiceCall});

typedef GroupProfileStateButtonBuilder = Widget? Function(
    {required V2TimGroupInfo groupInfo});

typedef GroupProfileMuteMemberBuilder = Widget? Function({
  required V2TimGroupInfo groupInfo,
  required List<V2TimGroupMemberFullInfo> groupMember,
});

typedef GroupProfileSetNameCardBuilder = Widget? Function(
    {required V2TimGroupInfo groupInfo,
    required List<V2TimGroupMemberFullInfo> groupMember});

typedef GroupProfileMemberBuilder = Widget? Function(
    {required V2TimGroupInfo groupInfo,
    required List<V2TimGroupMemberFullInfo> groupMember,
    required List<V2TimFriendInfo> contactList});

typedef GroupProfileDeleteButtonBuilder = Widget? Function(
    {required V2TimGroupInfo groupInfo, required List<V2TimGroupMemberFullInfo> groupMemberList});

typedef GroupProfileNotificationPageBuilder = Widget? Function(
    {required V2TimGroupInfo groupInfo});

class TencentCloudChatGroupProfileBuilders extends TencentCloudChatComponentBuilder {
  GroupProfileAvatarBuilder? _groupProfileAvatarBuilder;
  GroupProfileContentBuilder? _groupProfileContentBuilder;
  GroupProfileChatButtonBuilder? _groupProfileChatButtonBuilder;
  GroupProfileStateButtonBuilder? _groupProfileStateButtonBuilder;
  GroupProfileMuteMemberBuilder? _groupProfileMuteMemberBuilder;
  GroupProfileSetNameCardBuilder? _groupProfileSetNameCardBuilder;
  GroupProfileMemberBuilder? _groupProfileMemberBuilder;
  GroupProfileDeleteButtonBuilder? _groupProfileDeleteButtonBuilder;
  GroupProfileNotificationPageBuilder? _groupProfileNotificationPageBuilder;

  TencentCloudChatGroupProfileBuilders({
    GroupProfileAvatarBuilder? groupProfileAvatarBuilder,
    GroupProfileContentBuilder? groupProfileContentBuilder,
    GroupProfileChatButtonBuilder? groupProfileChatButtonBuilder,
    GroupProfileStateButtonBuilder? groupProfileStateButtonBuilder,
    GroupProfileMuteMemberBuilder? groupProfileMuteMemberBuilder,
    GroupProfileSetNameCardBuilder? groupProfileSetNameCardBuilder,
    GroupProfileMemberBuilder? groupProfileMemberBuilder,
    GroupProfileDeleteButtonBuilder? groupProfileDeleteButtonBuilder,
    GroupProfileNotificationPageBuilder? groupProfileNotificationPageBuilder,
  }) {
    _groupProfileAvatarBuilder = groupProfileAvatarBuilder;
    _groupProfileContentBuilder = groupProfileContentBuilder;
    _groupProfileChatButtonBuilder = groupProfileChatButtonBuilder;
    _groupProfileStateButtonBuilder = groupProfileStateButtonBuilder;
    _groupProfileMuteMemberBuilder = groupProfileMuteMemberBuilder;
    _groupProfileSetNameCardBuilder = groupProfileSetNameCardBuilder;
    _groupProfileMemberBuilder = groupProfileMemberBuilder;
    _groupProfileDeleteButtonBuilder = groupProfileDeleteButtonBuilder;
    _groupProfileNotificationPageBuilder = groupProfileNotificationPageBuilder;
  }

  void setBuilders({
    GroupProfileAvatarBuilder? groupProfileAvatarBuilder,
    GroupProfileContentBuilder? groupProfileContentBuilder,
    GroupProfileChatButtonBuilder? groupProfileChatButtonBuilder,
    GroupProfileStateButtonBuilder? groupProfileStateButtonBuilder,
    GroupProfileMuteMemberBuilder? groupProfileMuteMemberBuilder,
    GroupProfileSetNameCardBuilder? groupProfileSetNameCardBuilder,
    GroupProfileMemberBuilder? groupProfileMemberBuilder,
    GroupProfileDeleteButtonBuilder? groupProfileDeleteButtonBuilder,
    GroupProfileNotificationPageBuilder? groupProfileNotificationPageBuilder,
  }) {
    _groupProfileAvatarBuilder = groupProfileAvatarBuilder;
    _groupProfileContentBuilder = groupProfileContentBuilder;
    _groupProfileChatButtonBuilder = groupProfileChatButtonBuilder;
    _groupProfileStateButtonBuilder = groupProfileStateButtonBuilder;
    _groupProfileMuteMemberBuilder = groupProfileMuteMemberBuilder;
    _groupProfileSetNameCardBuilder = groupProfileSetNameCardBuilder;
    _groupProfileMemberBuilder = groupProfileMemberBuilder;
    _groupProfileDeleteButtonBuilder = groupProfileDeleteButtonBuilder;
    _groupProfileNotificationPageBuilder = groupProfileNotificationPageBuilder;
    TencentCloudChat.instance.dataInstance.groupProfile.notifyListener(TencentCloudChatGroupProfileDataKeys.builder);
  }

  @override
  Widget getGroupProfileAvatarBuilder(
      {required V2TimGroupInfo groupInfo,
      required List<V2TimGroupMemberFullInfo> groupMember}) {
    Widget? widget;
    if (_groupProfileAvatarBuilder != null) {
      widget = _groupProfileAvatarBuilder!(
          groupInfo: groupInfo, groupMember: groupMember);
    }
    return widget ??
        TencentCloudChatGroupProfileAvatar(
          groupInfo: groupInfo,
          groupMemberList: groupMember,
        );
  }

  @override
  Widget getGroupProfileContentBuilder(
      {required V2TimGroupInfo groupInfo}) {
    Widget? widget;
    if (_groupProfileContentBuilder != null) {
      widget = _groupProfileContentBuilder!(groupInfo: groupInfo);
    }
    return widget ?? TencentCloudChatGroupProfileContent(groupInfo: groupInfo);
  }

  @override
  Widget getGroupProfileChatButtonBuilder(
      {required V2TimGroupInfo groupInfo,
      VoidCallback? startVideoCall,
      VoidCallback? startVoiceCall}) {
    Widget? widget;
    if (_groupProfileChatButtonBuilder != null) {
      widget = _groupProfileChatButtonBuilder!(
          groupInfo: groupInfo,
          startVideoCall: startVideoCall,
          startVoiceCall: startVoiceCall);
    }
    return widget ??
        TencentCloudChatGroupProfileChatButton(
          groupInfo: groupInfo,
          startVideoCall: startVideoCall,
          startVoiceCall: startVoiceCall,
        );
  }

  @override
  Widget getGroupProfileStateButtonBuilder(
      {required V2TimGroupInfo groupInfo}) {
    Widget? widget;
    if (_groupProfileStateButtonBuilder != null) {
      widget = _groupProfileStateButtonBuilder!(groupInfo: groupInfo);
    }
    return widget ??
        TencentCloudChatGroupProfileStateButton(groupInfo: groupInfo);
  }

  @override
  Widget getGroupProfileMuteMemberBuilder({
    required V2TimGroupInfo groupInfo,
    required List<V2TimGroupMemberFullInfo> groupMember,
  }) {
    Widget? widget;
    if (_groupProfileMuteMemberBuilder != null) {
      widget = _groupProfileMuteMemberBuilder!(
          groupInfo: groupInfo, groupMember: groupMember);
    }
    return widget ??
        TencentCloudChatGroupProfileGroupManagement(
          groupInfo: groupInfo,
          memberList: groupMember,
        );
  }

  @override
  Widget getGroupProfileSetNameCardBuilder(
      {required V2TimGroupInfo groupInfo,
      required List<V2TimGroupMemberFullInfo> groupMember}) {
    Widget? widget;
    if (_groupProfileSetNameCardBuilder != null) {
      widget = _groupProfileSetNameCardBuilder!(
          groupInfo: groupInfo, groupMember: groupMember);
    }
    return widget ??
        TencentCloudChatGroupProfileNickName(
          groupInfo: groupInfo,
          groupMembersInfo: groupMember,
        );
  }

  @override
  Widget getGroupProfileMemberBuilder(
      {required V2TimGroupInfo groupInfo,
      required List<V2TimGroupMemberFullInfo> groupMember,
      required List<V2TimFriendInfo> contactList}) {
    Widget? widget;
    if (_groupProfileMemberBuilder != null) {
      widget = _groupProfileMemberBuilder!(
          groupInfo: groupInfo,
          groupMember: groupMember,
          contactList: contactList);
    }
    return widget ??
        TencentCloudChatGroupProfileGroupMember(
          groupInfo: groupInfo,
          groupMembersInfo: groupMember,
          contactList: contactList,
        );
  }

  @override
  Widget getGroupProfileDeleteButtonBuilder(
      {required V2TimGroupInfo groupInfo, required List<V2TimGroupMemberFullInfo> groupMemberList}) {
    Widget? widget;
    if (_groupProfileDeleteButtonBuilder != null) {
      widget = _groupProfileDeleteButtonBuilder!(groupInfo: groupInfo, groupMemberList: groupMemberList);
    }
    return widget ??
        TencentCloudChatGroupProfileDeleteButton(groupInfo: groupInfo, groupMemberList: groupMemberList);
  }

  @override
  Widget getGroupProfileNotificationPageBuilder(
      {required V2TimGroupInfo groupInfo}) {
    Widget? widget;
    if (_groupProfileNotificationPageBuilder != null) {
      widget = _groupProfileNotificationPageBuilder!(groupInfo: groupInfo);
    }
    return widget ??
        TencentCloudChatGroupNotification(groupInfo: groupInfo);
  }
}
