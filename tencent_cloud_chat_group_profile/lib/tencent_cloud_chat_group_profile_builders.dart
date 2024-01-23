import 'package:flutter/widgets.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_group_profile/widget/tencent_cloud_chat_group_profile_add_member.dart';
import 'package:tencent_cloud_chat_group_profile/widget/tencent_cloud_chat_group_profile_body.dart';
import 'package:tencent_cloud_chat_group_profile/widget/tencent_cloud_chat_group_profile_management.dart';
import 'package:tencent_cloud_chat_group_profile/widget/tencent_cloud_chat_group_profile_member_list.dart';
import 'package:tencent_cloud_chat_group_profile/widget/tencent_cloud_chat_group_profile_notification.dart';

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
    {required V2TimGroupInfo groupInfo});

typedef GroupProfileNotificationPageBuilder = Widget? Function(
    {required V2TimGroupInfo groupInfo});

typedef GroupProfileMemberListPageBuilder = Widget? Function(
    {required V2TimGroupInfo groupInfo,
    required List<V2TimGroupMemberFullInfo> groupMember});

typedef GroupProfileMutePageBuilder = Widget? Function({
  required V2TimGroupInfo groupInfo,
  required List<V2TimGroupMemberFullInfo> groupMember,
});

typedef GroupProfileAddMemberPageBuilder = Widget? Function(
    {required V2TimGroupInfo groupInfo,
    required List<V2TimGroupMemberFullInfo> groupMember,
    required List<V2TimFriendInfo> contactList});

class TencentCloudChatGroupProfileBuilders {
  static GroupProfileAvatarBuilder? _groupProfileAvatarBuilder;
  static GroupProfileContentBuilder? _groupProfileContentBuilder;
  static GroupProfileChatButtonBuilder? _groupProfileChatButtonBuilder;
  static GroupProfileStateButtonBuilder? _groupProfileStateButtonBuilder;
  static GroupProfileMuteMemberBuilder? _groupProfileMuteMemberBuilder;
  static GroupProfileSetNameCardBuilder? _groupProfileSetNameCardBuilder;
  static GroupProfileMemberBuilder? _groupProfileMemberBuilder;
  static GroupProfileDeleteButtonBuilder? _groupProfileDeleteButtonBuilder;
  static GroupProfileNotificationPageBuilder?
      _groupProfileNotificationPageBuilder;
  static GroupProfileMemberListPageBuilder? _groupProfileMemberListPageBuilder;
  static GroupProfileMutePageBuilder? _groupProfileMutePageBuilder;
  static GroupProfileAddMemberPageBuilder? _groupProfileAddMemberPageBuilder;

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
    GroupProfileMemberListPageBuilder? groupProfileMemberListPageBuilder,
    GroupProfileMutePageBuilder? groupProfileMutePageBuilder,
    GroupProfileAddMemberPageBuilder? groupProfileAddMemberPageBuilder,
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
    _groupProfileMemberListPageBuilder = groupProfileMemberListPageBuilder;
    _groupProfileMutePageBuilder = groupProfileMutePageBuilder;
    _groupProfileAddMemberPageBuilder = groupProfileAddMemberPageBuilder;
  }

  static Widget getGroupProfileAvatarBuilder(
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

  static Widget getGroupProfileContentBuilder(
      {required V2TimGroupInfo groupInfo}) {
    Widget? widget;
    if (_groupProfileContentBuilder != null) {
      widget = _groupProfileContentBuilder!(groupInfo: groupInfo);
    }
    return widget ?? TencentCloudChatGroupProfileContent(groupInfo: groupInfo);
  }

  static Widget getGroupProfileChatButtonBuilder(
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

  static Widget getGroupProfileStateButtonBuilder(
      {required V2TimGroupInfo groupInfo}) {
    Widget? widget;
    if (_groupProfileStateButtonBuilder != null) {
      widget = _groupProfileStateButtonBuilder!(groupInfo: groupInfo);
    }
    return widget ??
        TencentCloudChatGroupProfileStateButton(groupInfo: groupInfo);
  }

  static Widget getGroupProfileMuteMemberBuilder({
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
          memberInfo: groupMember,
        );
  }

  static Widget getGroupProfileSetNameCardBuilder(
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

  static Widget getGroupProfileMemberBuilder(
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

  static Widget getGroupProfileDeleteButtonBuilder(
      {required V2TimGroupInfo groupInfo}) {
    Widget? widget;
    if (_groupProfileDeleteButtonBuilder != null) {
      widget = _groupProfileDeleteButtonBuilder!(groupInfo: groupInfo);
    }
    return widget ??
        TencentCloudChatGroupProfileDeleteButton(groupInfo: groupInfo);
  }

  static Widget getGroupProfileNotificationPageBuilder(
      {required V2TimGroupInfo groupInfo}) {
    Widget? widget;
    if (_groupProfileNotificationPageBuilder != null) {
      widget = _groupProfileNotificationPageBuilder!(groupInfo: groupInfo);
    }
    return widget ??
        TencentCloudChatGroupProfileNotification(groupInfo: groupInfo);
  }

  static Widget getGroupProfileMemberListPageBuilder(
      {required V2TimGroupInfo groupInfo,
      required List<V2TimGroupMemberFullInfo> groupMember}) {
    Widget? widget;
    if (_groupProfileMemberListPageBuilder != null) {
      widget = _groupProfileMemberListPageBuilder!(
          groupInfo: groupInfo, groupMember: groupMember);
    }
    return widget ??
        TencentCloudChatGroupProfileMemberList(
          groupInfo: groupInfo,
          memberInfoList: groupMember,
        );
  }

  static Widget getGroupProfileMutePageBuilder({
    required V2TimGroupInfo groupInfo,
    required List<V2TimGroupMemberFullInfo> groupMember,
  }) {
    Widget? widget;
    if (_groupProfileMutePageBuilder != null) {
      widget = _groupProfileMutePageBuilder!(
          groupInfo: groupInfo, groupMember: groupMember);
    }
    return widget ??
        TencentCloudChatGroupProfileManagement(
          groupInfo: groupInfo,
          memberList: groupMember,
        );
  }

  static Widget getGroupProfileAddMemberPageBuilder(
      {required V2TimGroupInfo groupInfo,
      required List<V2TimGroupMemberFullInfo> groupMember,
      required List<V2TimFriendInfo> contactList}) {
    Widget? widget;
    if (_groupProfileAddMemberPageBuilder != null) {
      widget = _groupProfileAddMemberPageBuilder!(
          groupInfo: groupInfo,
          groupMember: groupMember,
          contactList: contactList);
    }
    return widget ??
        TencentCloudChatGroupProfileAddMember(
          groupInfo: groupInfo,
          memberList: groupMember,
          contactList: contactList,
        );
  }
}
