import 'package:flutter/widgets.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_builder.dart';
import 'package:tencent_cloud_chat_common/data/contact/tencent_cloud_chat_contact_data.dart';
import 'package:tencent_cloud_chat_common/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_add_contacts.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_add_contacts_info.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_app_bar.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_application_info.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_application_list.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_block_list.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_group_list.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_item.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_tab.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_group_add_member.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_group_management.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_group_member_list.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_user_profile_body.dart';

typedef ContactItemAvatarBuilder = Widget? Function(V2TimFriendInfo friend);

typedef ContactItemContentBuilder = Widget? Function(V2TimFriendInfo friend);

typedef ContactItemElseBuilder = Widget? Function(V2TimFriendInfo friend);

typedef ContactListTagBuilder = Widget? Function(String tag);

typedef ContactListTabItemBuilder = Widget? Function(TTabItem item);

typedef ContactApplicationItemAvatarBuilder = Widget? Function(V2TimFriendApplication application);

typedef ContactApplicationItemContentBuilder = Widget? Function(V2TimFriendApplication application);

typedef ContactApplicationItemButtonBuilder = Widget? Function(
    V2TimFriendApplication application, ContactApplicationResult? result, Function? sendApplicationResult);

typedef ContactApplicationInfoAvatarBuilder = Widget? Function(V2TimFriendApplication application);

typedef ContactApplicationInfoContentBuilder = Widget? Function(V2TimFriendApplication application);

typedef ContactApplicationInfoAddWordingBuilder = Widget? Function(V2TimFriendApplication application);

typedef ContactApplicationInfoButtonBuilder = Widget? Function(
    V2TimFriendApplication application, Function? function, ContactApplicationResult? applicationResult);

typedef ContactBlockListItemAvatarBuilder = Widget? Function(V2TimFriendInfo friend);

typedef ContactBlockListItemContentBuilder = Widget? Function(V2TimFriendInfo friend);

typedef ContactGroupListItemAvatarBuilder = Widget? Function(V2TimGroupInfo group);

typedef ContactGroupListItemContentBuilder = Widget? Function(V2TimGroupInfo group);

typedef ContactGroupListTagBuilder = Widget? Function(String tag, int? count);

typedef ContactAppBarNameBuilder = Widget? Function({String? title});

typedef ContactAddContactsListItemAvatarBuilder = Widget? Function(V2TimUserFullInfo userFullInfo);

typedef ContactAddContactsListItemContentBuilder = Widget? Function(V2TimUserFullInfo userFullInfo);

typedef ContactAddContactsInfoAvatarBuilder = Widget? Function(V2TimUserFullInfo userFullInfo);

typedef ContactAddContactsInfoContentBuilder = Widget? Function(V2TimUserFullInfo userFullInfo);
typedef ContactAddContactsInfoButtonBuilder = Widget? Function(
    V2TimUserFullInfo userFullInfo, Function? showDetailAddInfo);

typedef ContactAddContactsInfoVerificationBuilder = Widget? Function(Function onVerificationChanged);

typedef ContactAddContactsInfoRemarksAndGroupBuilder = Widget? Function(
    Function onRemarksChanged, Function onFriendGroupChanged);

typedef ContactAddContactsDetailInfoSendButtonBuilder = Widget? Function(Function addFriend);

typedef GroupMemberListPageBuilder = Widget? Function(
    {required V2TimGroupInfo groupInfo, required List<V2TimGroupMemberFullInfo> memberInfoList});

typedef GroupManagementPageBuilder = Widget? Function({
  required V2TimGroupInfo groupInfo,
  required List<V2TimGroupMemberFullInfo> groupMember,
});

typedef GroupAddMemberPageBuilder = Widget? Function(
    {required V2TimGroupInfo groupInfo,
    required List<V2TimGroupMemberFullInfo> memberList,
    required List<V2TimFriendInfo> contactList});

typedef UserProfileAvatarBuilder = Widget? Function({required V2TimUserFullInfo userFullInfo});

typedef UserProfileContentBuilder = Widget? Function({required V2TimUserFullInfo userFullInfo});

typedef UserProfileChatButtonBuilder = Widget? Function(
    {required V2TimUserFullInfo userFullInfo,
    VoidCallback? startVideoCall,
    VoidCallback? startVoiceCall,
    bool? isNavigatedFromChat});

typedef UserProfileStateButtonBuilder = Widget? Function({required V2TimUserFullInfo userFullInfo});

typedef UserProfileDeleteButtonBuilder = Widget? Function({required V2TimUserFullInfo userFullInfo});

class TencentCloudChatContactBuilders extends TencentCloudChatComponentBuilder {
  ContactItemAvatarBuilder? _contactItemAvatarBuilder;
  ContactItemContentBuilder? _contactItemContentBuilder;
  ContactItemElseBuilder? _contactItemElseBuilder;
  ContactListTagBuilder? _contactListTagBuilder;
  ContactListTabItemBuilder? _contactListTabItemBuilder;
  ContactApplicationItemAvatarBuilder? _contactApplicationItemAvatarBuilder;
  ContactApplicationItemContentBuilder? _contactApplicationItemContentBuilder;
  ContactApplicationItemButtonBuilder? _contactApplicationItemButtonBuilder;
  ContactApplicationInfoAvatarBuilder? _contactApplicationInfoAvatarBuilder;
  ContactApplicationInfoContentBuilder? _contactApplicationInfoContentBuilder;
  ContactApplicationInfoAddWordingBuilder? _contactApplicationInfoAddWordingBuilder;
  ContactApplicationInfoButtonBuilder? _contactApplicationInfoButtonBuilder;
  ContactBlockListItemAvatarBuilder? _contactBlockListItemAvatarBuilder;
  ContactBlockListItemContentBuilder? _contactBlockListItemContentBuilder;

  ContactGroupListItemAvatarBuilder? _contactGroupListItemAvatarBuilder;
  ContactGroupListItemContentBuilder? _contactGroupListItemContentBuilder;
  ContactGroupListTagBuilder? _contactGroupListTagBuilder;
  ContactAppBarNameBuilder? _contactAppBarNameBuilder;
  ContactAddContactsListItemAvatarBuilder? _contactAddContactListItemAvatar;
  ContactAddContactsListItemContentBuilder? _contactAddContactListItemContent;
  ContactAddContactsInfoAvatarBuilder? _contactAddContactsInfoAvatar;
  ContactAddContactsInfoContentBuilder? _contactAddContactsInfoContent;
  ContactAddContactsInfoButtonBuilder? _contactAddContactsInfoButton;
  ContactAddContactsInfoVerificationBuilder? _contactAddContactsInfoVerificationBuilder;
  ContactAddContactsInfoRemarksAndGroupBuilder? _contactAddContactsInfoRemarksAndGroupBuilder;
  ContactAddContactsDetailInfoSendButtonBuilder? _contactAddContactsDetailInfoSendButtonBuilder;

  GroupMemberListPageBuilder? _groupMemberListPageBuilder;
  GroupManagementPageBuilder? _groupManagementPageBuilder;
  GroupAddMemberPageBuilder? _groupAddMemberPageBuilder;

  UserProfileAvatarBuilder? _userProfileAvatarBuilder;
  UserProfileContentBuilder? _userProfileContentBuilder;
  UserProfileChatButtonBuilder? _userProfileChatButtonBuilder;
  UserProfileStateButtonBuilder? _userProfileStateButtonBuilder;
  UserProfileDeleteButtonBuilder? _userProfileDeleteButtonBuilder;

  TencentCloudChatContactBuilders(
      {ContactItemAvatarBuilder? contactItemAvatarBuilder,
      ContactItemContentBuilder? contactItemContentBuilder,
      ContactItemElseBuilder? contactItemElseBuilder,
      ContactListTagBuilder? contactListTagBuilder,
      ContactListTabItemBuilder? contactListTabItemBuilder,
      ContactApplicationItemAvatarBuilder? contactApplicationItemAvatarBuilder,
      ContactApplicationItemContentBuilder? contactApplicationItemContentBuilder,
      ContactApplicationItemButtonBuilder? contactApplicationItemButtonBuilder,
      ContactApplicationInfoAvatarBuilder? contactApplicationInfoAvatarBuilder,
      ContactApplicationInfoContentBuilder? contactApplicationInfoContentBuilder,
      ContactApplicationInfoAddWordingBuilder? contactApplicationInfoAddWordingBuilder,
      ContactApplicationInfoButtonBuilder? contactApplicationInfoButtonBuilder,
      ContactBlockListItemAvatarBuilder? contactBlockListItemAvatarBuilder,
      ContactBlockListItemContentBuilder? contactBlockListItemContentBuilder,
      ContactGroupListItemAvatarBuilder? contactGroupListItemAvatarBuilder,
      ContactGroupListItemContentBuilder? contactGroupListItemContentBuilder,
      ContactGroupListTagBuilder? contactGroupListTagBuilder,
      ContactAppBarNameBuilder? contactAppBarNameBuilder,
      ContactAddContactsListItemAvatarBuilder? contactAddContactListItemAvatar,
      ContactAddContactsListItemContentBuilder? contactAddContactListItemContent,
      ContactAddContactsInfoAvatarBuilder? contactAddContactsInfoAvatar,
      ContactAddContactsInfoContentBuilder? contactAddContactsInfoContent,
      ContactAddContactsInfoButtonBuilder? contactAddContactsInfoButton,
      ContactAddContactsInfoVerificationBuilder? contactAddContactsInfoVerificationBuilder,
      ContactAddContactsInfoRemarksAndGroupBuilder? contactAddContactsInfoRemarksAndGroupBuilder,
      ContactAddContactsDetailInfoSendButtonBuilder? contactAddContactsDetailInfoSendButtonBuilder,
      GroupMemberListPageBuilder? groupMemberListPageBuilder,
      GroupManagementPageBuilder? groupManagementPageBuilder,
      GroupAddMemberPageBuilder? groupAddMemberPageBuilder,
      UserProfileAvatarBuilder? userProfileAvatarBuilder,
      UserProfileContentBuilder? userProfileContentBuilder,
      UserProfileChatButtonBuilder? userProfileChatButtonBuilder,
      UserProfileStateButtonBuilder? userProfileStateButtonBuilder,
      UserProfileDeleteButtonBuilder? userProfileDeleteButtonBuilder}) {
    _contactItemAvatarBuilder = contactItemAvatarBuilder;
    _contactItemContentBuilder = contactItemContentBuilder;
    _contactItemElseBuilder = contactItemElseBuilder;
    _contactListTagBuilder = contactListTagBuilder;
    _contactListTabItemBuilder = contactListTabItemBuilder;
    _contactApplicationItemAvatarBuilder = contactApplicationItemAvatarBuilder;
    _contactApplicationItemContentBuilder = contactApplicationItemContentBuilder;
    _contactApplicationItemButtonBuilder = contactApplicationItemButtonBuilder;
    _contactApplicationInfoAvatarBuilder = contactApplicationInfoAvatarBuilder;
    _contactApplicationInfoContentBuilder = contactApplicationInfoContentBuilder;
    _contactApplicationInfoAddWordingBuilder = contactApplicationInfoAddWordingBuilder;
    _contactApplicationInfoButtonBuilder = contactApplicationInfoButtonBuilder;
    _contactBlockListItemAvatarBuilder = contactBlockListItemAvatarBuilder;
    _contactBlockListItemContentBuilder = contactBlockListItemContentBuilder;
    _contactGroupListItemAvatarBuilder = contactGroupListItemAvatarBuilder;
    _contactGroupListItemContentBuilder = contactGroupListItemContentBuilder;
    _contactGroupListTagBuilder = contactGroupListTagBuilder;
    _contactAppBarNameBuilder = contactAppBarNameBuilder;
    _contactAddContactListItemAvatar = contactAddContactListItemAvatar;
    _contactAddContactListItemContent = contactAddContactListItemContent;
    _contactAddContactsInfoAvatar = contactAddContactsInfoAvatar;
    _contactAddContactsInfoContent = contactAddContactsInfoContent;
    _contactAddContactsInfoButton = contactAddContactsInfoButton;
    _contactAddContactsInfoVerificationBuilder = contactAddContactsInfoVerificationBuilder;
    _contactAddContactsInfoRemarksAndGroupBuilder = contactAddContactsInfoRemarksAndGroupBuilder;
    _contactAddContactsDetailInfoSendButtonBuilder = contactAddContactsDetailInfoSendButtonBuilder;

    _groupMemberListPageBuilder = groupMemberListPageBuilder;
    _groupManagementPageBuilder = groupManagementPageBuilder;
    _groupAddMemberPageBuilder = groupAddMemberPageBuilder;

    _userProfileAvatarBuilder = userProfileAvatarBuilder;
    _userProfileContentBuilder = userProfileContentBuilder;
    _userProfileChatButtonBuilder = userProfileChatButtonBuilder;
    _userProfileStateButtonBuilder = userProfileStateButtonBuilder;
    _userProfileDeleteButtonBuilder = userProfileDeleteButtonBuilder;
  }

  void setBuilders(
      {ContactItemAvatarBuilder? contactItemAvatarBuilder,
      ContactItemContentBuilder? contactItemContentBuilder,
      ContactItemElseBuilder? contactItemElseBuilder,
      ContactListTagBuilder? contactListTagBuilder,
      ContactListTabItemBuilder? contactListTabItemBuilder,
      ContactApplicationItemAvatarBuilder? contactApplicationItemAvatarBuilder,
      ContactApplicationItemContentBuilder? contactApplicationItemContentBuilder,
      ContactApplicationItemButtonBuilder? contactApplicationItemButtonBuilder,
      ContactApplicationInfoAvatarBuilder? contactApplicationInfoAvatarBuilder,
      ContactApplicationInfoContentBuilder? contactApplicationInfoContentBuilder,
      ContactApplicationInfoAddWordingBuilder? contactApplicationInfoAddWordingBuilder,
      ContactApplicationInfoButtonBuilder? contactApplicationInfoButtonBuilder,
      ContactBlockListItemAvatarBuilder? contactBlockListItemAvatarBuilder,
      ContactBlockListItemContentBuilder? contactBlockListItemContentBuilder,
      ContactGroupListItemAvatarBuilder? contactGroupListItemAvatarBuilder,
      ContactGroupListItemContentBuilder? contactGroupListItemContentBuilder,
      ContactGroupListTagBuilder? contactGroupListTagBuilder,
      ContactAppBarNameBuilder? contactAppBarNameBuilder,
      ContactAddContactsListItemAvatarBuilder? contactAddContactListItemAvatar,
      ContactAddContactsListItemContentBuilder? contactAddContactListItemContent,
      ContactAddContactsInfoAvatarBuilder? contactAddContactsInfoAvatar,
      ContactAddContactsInfoContentBuilder? contactAddContactsInfoContent,
      ContactAddContactsInfoButtonBuilder? contactAddContactsInfoButton,
      ContactAddContactsInfoVerificationBuilder? contactAddContactsInfoVerificationBuilder,
      ContactAddContactsInfoRemarksAndGroupBuilder? contactAddContactsInfoRemarksAndGroupBuilder,
      ContactAddContactsDetailInfoSendButtonBuilder? contactAddContactsDetailInfoSendButtonBuilder,
      GroupMemberListPageBuilder? groupMemberListPageBuilder,
      GroupManagementPageBuilder? groupManagementPageBuilder,
      GroupAddMemberPageBuilder? groupAddMemberPageBuilder,
      UserProfileAvatarBuilder? userProfileAvatarBuilder,
      UserProfileContentBuilder? userProfileContentBuilder,
      UserProfileChatButtonBuilder? userProfileChatButtonBuilder,
      UserProfileStateButtonBuilder? userProfileStateButtonBuilder,
      UserProfileDeleteButtonBuilder? userProfileDeleteButtonBuilder}) {
    _contactItemAvatarBuilder = contactItemAvatarBuilder;
    _contactItemContentBuilder = contactItemContentBuilder;
    _contactItemElseBuilder = contactItemElseBuilder;
    _contactListTagBuilder = contactListTagBuilder;
    _contactListTabItemBuilder = contactListTabItemBuilder;
    _contactApplicationItemAvatarBuilder = contactApplicationItemAvatarBuilder;
    _contactApplicationItemContentBuilder = contactApplicationItemContentBuilder;
    _contactApplicationItemButtonBuilder = contactApplicationItemButtonBuilder;
    _contactApplicationInfoAvatarBuilder = contactApplicationInfoAvatarBuilder;
    _contactApplicationInfoContentBuilder = contactApplicationInfoContentBuilder;
    _contactApplicationInfoAddWordingBuilder = contactApplicationInfoAddWordingBuilder;
    _contactApplicationInfoButtonBuilder = contactApplicationInfoButtonBuilder;
    _contactBlockListItemAvatarBuilder = contactBlockListItemAvatarBuilder;
    _contactBlockListItemContentBuilder = contactBlockListItemContentBuilder;
    _contactGroupListItemAvatarBuilder = contactGroupListItemAvatarBuilder;
    _contactGroupListItemContentBuilder = contactGroupListItemContentBuilder;
    _contactGroupListTagBuilder = contactGroupListTagBuilder;
    _contactAppBarNameBuilder = contactAppBarNameBuilder;
    _contactAddContactListItemAvatar = contactAddContactListItemAvatar;
    _contactAddContactListItemContent = contactAddContactListItemContent;
    _contactAddContactsInfoAvatar = contactAddContactsInfoAvatar;
    _contactAddContactsInfoContent = contactAddContactsInfoContent;
    _contactAddContactsInfoButton = contactAddContactsInfoButton;
    _contactAddContactsInfoVerificationBuilder = contactAddContactsInfoVerificationBuilder;
    _contactAddContactsInfoRemarksAndGroupBuilder = contactAddContactsInfoRemarksAndGroupBuilder;
    _contactAddContactsDetailInfoSendButtonBuilder = contactAddContactsDetailInfoSendButtonBuilder;

    _groupMemberListPageBuilder = groupMemberListPageBuilder;
    _groupManagementPageBuilder = groupManagementPageBuilder;
    _groupAddMemberPageBuilder = groupAddMemberPageBuilder;

    _userProfileAvatarBuilder = userProfileAvatarBuilder;
    _userProfileContentBuilder = userProfileContentBuilder;
    _userProfileChatButtonBuilder = userProfileChatButtonBuilder;
    _userProfileStateButtonBuilder = userProfileStateButtonBuilder;
    _userProfileDeleteButtonBuilder = userProfileDeleteButtonBuilder;

    TencentCloudChat.instance.dataInstance.contact.notifyListener(TencentCloudChatContactDataKeys.builder);
  }

  @override
  Widget getContactItemAvatarBuilder(V2TimFriendInfo friend) {
    Widget? widget;
    if (_contactItemAvatarBuilder != null) {
      widget = _contactItemAvatarBuilder!(friend);
    }
    return widget ?? TencentCloudChatContactItemAvatar(friend: friend);
  }

  @override
  Widget getContactItemContentBuilder(V2TimFriendInfo friend) {
    Widget? widget;
    if (_contactItemContentBuilder != null) {
      widget = _contactItemContentBuilder!(friend);
    }
    return widget ?? TencentCloudChatContactItemContent(friend: friend);
  }

  @override
  Widget getContactItemElseBuilder(V2TimFriendInfo friend) {
    Widget? widget;
    if (_contactItemElseBuilder != null) {
      widget = _contactItemElseBuilder!(friend);
    }
    return widget ?? TencentCloudChatContactItemElse(friend: friend);
  }

  @override
  Widget getContactListTagBuilder(String tag) {
    Widget? widget;
    if (_contactListTagBuilder != null) {
      widget = _contactListTagBuilder!(tag);
    }
    return widget ?? TencentCloudChatContactListTag(tag: tag);
  }

  @override
  Widget getContactListTabItemBuilder(TTabItem item) {
    Widget? widget;
    if (_contactListTabItemBuilder != null) {
      widget = _contactListTabItemBuilder!(item);
    }
    return widget ?? TencentCloudChatContactTabItem(item: item);
  }

  @override
  Widget getContactApplicationItemAvatarBuilder(V2TimFriendApplication application) {
    Widget? widget;
    if (_contactApplicationItemAvatarBuilder != null) {
      widget = _contactApplicationItemAvatarBuilder!(application);
    }
    return widget ?? TencentCloudChatContactApplicationItemAvatar(application: application);
  }

  @override
  Widget getContactApplicationItemContentBuilder(V2TimFriendApplication application) {
    Widget? widget;
    if (_contactApplicationItemContentBuilder != null) {
      widget = _contactApplicationItemContentBuilder!(application);
    }
    return widget ?? TencentCloudChatContactApplicationItemContent(application: application);
  }

  @override
  Widget getContactApplicationItemButtonBuilder(
      V2TimFriendApplication application, ContactApplicationResult? result, Function? sendApplicationResult) {
    Widget? widget;
    if (_contactApplicationItemButtonBuilder != null) {
      widget = _contactApplicationItemButtonBuilder!(application, result, sendApplicationResult);
    }
    return widget ??
        TencentCloudChatApplicationItemButton(
            application: application, applicationResult: result, sendApplicationResult: sendApplicationResult);
  }

  @override
  Widget getContactApplicationInfoAvatarBuilder(V2TimFriendApplication application) {
    Widget? widget;
    if (_contactApplicationInfoAvatarBuilder != null) {
      widget = _contactApplicationInfoAvatarBuilder!(application);
    }
    return widget ?? TencentCloudChatContactApplicationInfoAvatar(application: application);
  }

  @override
  Widget getContactApplicationInfoContentBuilder(V2TimFriendApplication application) {
    Widget? widget;
    if (_contactApplicationInfoContentBuilder != null) {
      widget = _contactApplicationInfoContentBuilder!(application);
    }
    return widget ?? TencentCloudChatContactApplicationInfoContent(application: application);
  }

  @override
  Widget getContactApplicationInfoAddWordingBuilder(V2TimFriendApplication application) {
    Widget? widget;
    if (_contactApplicationInfoAddWordingBuilder != null) {
      widget = _contactApplicationInfoAddWordingBuilder!(application);
    }
    return widget ?? TencentCloudChatContentApplicationInfoAddwording(application: application);
  }

  @override
  Widget getContactApplicationInfoButtonBuilder(
      V2TimFriendApplication application, Function? resultFunction, ContactApplicationResult? applicationResult) {
    Widget? widget;
    if (_contactApplicationInfoButtonBuilder != null) {
      widget = _contactApplicationInfoButtonBuilder!(application, resultFunction, applicationResult);
    }
    return widget ??
        TencentCloudChatContactApplicationInfoButton(
            application: application, resultFunction: resultFunction, applicationResult: applicationResult);
  }

  @override
  Widget getContactBlockListItemAvatarBuilder(V2TimFriendInfo friend) {
    Widget? widget;
    if (_contactBlockListItemAvatarBuilder != null) {
      widget = _contactBlockListItemAvatarBuilder!(friend);
    }
    return widget ?? TencentCloudChatContactBlockListItemAvatar(friend: friend);
  }

  @override
  Widget getContactBlockListItemContentBuilder(V2TimFriendInfo friend) {
    Widget? widget;
    if (_contactBlockListItemContentBuilder != null) {
      widget = _contactBlockListItemContentBuilder!(friend);
    }
    return widget ?? TencentCloudChatContactBlockListItemContent(friend: friend);
  }

  @override
  Widget getContactGroupListItemAvatarBuilder(V2TimGroupInfo group) {
    Widget? widget;
    if (_contactGroupListItemAvatarBuilder != null) {
      widget = _contactGroupListItemAvatarBuilder!(group);
    }
    return widget ?? TencentCloudChatContactGroupItemAvatar(group: group);
  }

  @override
  Widget getContactGroupListItemContentBuilder(V2TimGroupInfo group) {
    Widget? widget;
    if (_contactGroupListItemContentBuilder != null) {
      widget = _contactGroupListItemContentBuilder!(group);
    }
    return widget ?? TencentCloudChatContactGroupItemContent(group: group);
  }

  @override
  Widget getContactGroupListTagBuilder(String tag, int? count) {
    Widget? widget;
    if (_contactGroupListTagBuilder != null) {
      widget = _contactGroupListTagBuilder!(tag, count);
    }
    return widget ?? TencentCloudChatContactGroupListTag(tag: tag, count: count);
  }

  @override
  Widget getContactAppBarNameBuilder({String? title}) {
    Widget? widget;
    if (_contactAppBarNameBuilder != null) {
      widget = _contactAppBarNameBuilder!(title: title);
    }
    return widget ?? TencentCloudChatContactAppBarName(title: title);
  }

  @override
  Widget getContactAddContactListItemAvatarBuilder(V2TimUserFullInfo userFullInfo) {
    Widget? widget;
    if (_contactAddContactListItemAvatar != null) {
      widget = _contactAddContactListItemAvatar!(userFullInfo);
    }
    return widget ?? TencentCloudChatContactAddContactListItemAvatar(userFullInfo: userFullInfo);
  }

  @override
  Widget getContactAddContactListItemContentBuilder(V2TimUserFullInfo userFullInfo) {
    Widget? widget;
    if (_contactAddContactListItemContent != null) {
      widget = _contactAddContactListItemContent!(userFullInfo);
    }
    return widget ?? TencentCloudChatChontactAddContactListItemContent(userFullInfo: userFullInfo);
  }

  @override
  Widget getContactAddContactInfoAvatarBuilder(V2TimUserFullInfo userFullInfo) {
    Widget? widget;
    if (_contactAddContactsInfoAvatar != null) {
      widget = _contactAddContactsInfoAvatar!(userFullInfo);
    }
    return widget ?? TencentCloudChatContactAddContactsInfoAvatar(userFullInfo: userFullInfo);
  }

  @override
  Widget getContactAddContactInfoContentBuilder(V2TimUserFullInfo userFullInfo) {
    Widget? widget;
    if (_contactAddContactsInfoContent != null) {
      widget = _contactAddContactsInfoContent!(userFullInfo);
    }
    return widget ?? TencentCloudChatContactAddContactsInfoContent(userFullInfo: userFullInfo);
  }

  @override
  Widget getContactAddContactInfoButtonBuilder(V2TimUserFullInfo userFullInfo, Function? showDetailAddInfo) {
    Widget? widget;
    if (_contactAddContactsInfoButton != null) {
      widget = _contactAddContactsInfoButton!(userFullInfo, showDetailAddInfo);
    }
    return widget ??
        TencentCloudChatContactAddContactsInfoButton(userFullInfo: userFullInfo, showDetailAddInfo: showDetailAddInfo);
  }

  @override
  Widget getContactAddContactsInfoVerificationBuilder(Function onVerificationChanged) {
    Widget? widget;
    if (_contactAddContactsInfoVerificationBuilder != null) {
      widget = _contactAddContactsInfoVerificationBuilder!(onVerificationChanged);
    }
    return widget ?? TencentCloudChatContactAddContactsInfoVerification(onVerificationChanged: onVerificationChanged);
  }

  @override
  Widget getContactAddContactsInfoRemarksAndGroupBuilder(Function onRemarksChanged, Function onFriendGroupChanged) {
    Widget? widget;
    if (_contactAddContactsInfoRemarksAndGroupBuilder != null) {
      widget = _contactAddContactsInfoRemarksAndGroupBuilder!(onRemarksChanged, onFriendGroupChanged);
    }
    return widget ??
        TencentCloudChatContactAddContactsInfoRemarksAndGroup(
            onRemarksChanged: onRemarksChanged, onFriendGroupChanged: onFriendGroupChanged);
  }

  @override
  Widget getContactAddContactsDetailInfoSendButton(Function addFriend) {
    Widget? widget;
    if (_contactAddContactsDetailInfoSendButtonBuilder != null) {
      widget = _contactAddContactsDetailInfoSendButtonBuilder!(addFriend);
    }
    return widget ?? TencentCloudChatContactAddContactsDetailInfoSendButton(addFriend: addFriend);
  }

  @override
  Widget getGroupMemberListPageBuilder(
      {required V2TimGroupInfo groupInfo, required List<V2TimGroupMemberFullInfo> memberInfoList}) {
    Widget? widget;
    if (_groupMemberListPageBuilder != null) {
      widget = _groupMemberListPageBuilder!(groupInfo: groupInfo, memberInfoList: memberInfoList);
    }
    return widget ?? TencentCloudChatGroupMemberList(groupInfo: groupInfo, memberInfoList: memberInfoList);
  }

  @override
  getGroupManagementPageBuilder(
      {required V2TimGroupInfo groupInfo, required List<V2TimGroupMemberFullInfo> memberList}) {
    Widget? widget;
    if (_groupManagementPageBuilder != null) {
      widget = _groupManagementPageBuilder!(groupInfo: groupInfo, groupMember: memberList);
    }

    return widget ?? TencentCloudChatGroupManagement(groupInfo: groupInfo, memberList: memberList);
  }

  @override
  getGroupAddMemberPageBuilder(
      {required List<V2TimGroupMemberFullInfo> memberList,
      required List<V2TimFriendInfo> contactList,
      required V2TimGroupInfo groupInfo}) {
    Widget? widget;
    if (_groupAddMemberPageBuilder != null) {
      widget = _groupAddMemberPageBuilder!(groupInfo: groupInfo, memberList: memberList, contactList: contactList);
    }

    return widget ??
        TencentCloudChatGroupAddMember(groupInfo: groupInfo, memberList: memberList, contactList: contactList);
  }

  @override
  Widget getUserProfileAvatarBuilder({required V2TimUserFullInfo userFullInfo}) {
    Widget? widget;
    if (_userProfileAvatarBuilder != null) {
      widget = _userProfileAvatarBuilder!(userFullInfo: userFullInfo);
    }
    return widget ?? TencentCloudChatUserProfileAvatar(userFullInfo: userFullInfo);
  }

  @override
  Widget getUserProfileContentBuilder({required V2TimUserFullInfo userFullInfo}) {
    Widget? widget;
    if (_userProfileContentBuilder != null) {
      widget = _userProfileContentBuilder!(userFullInfo: userFullInfo);
    }
    return widget ?? TencentCloudChatUserProfileContent(userFullInfo: userFullInfo);
  }

  @override
  Widget getUserProfileChatButtonBuilder(
      {required V2TimUserFullInfo userFullInfo,
      VoidCallback? startVideoCall,
      VoidCallback? startVoiceCall,
      bool? isNavigatedFromChat}) {
    Widget? widget;
    if (_userProfileChatButtonBuilder != null) {
      widget = _userProfileChatButtonBuilder!(
          userFullInfo: userFullInfo,
          startVideoCall: startVideoCall,
          startVoiceCall: startVoiceCall,
          isNavigatedFromChat: isNavigatedFromChat);
    }
    return widget ??
        TencentCloudChatUserProfileChatButton(
            userFullInfo: userFullInfo,
            startVideoCall: startVideoCall,
            startVoiceCall: startVoiceCall,
            isNavigatedFromChat: isNavigatedFromChat);
  }

  @override
  Widget getUserProfileStateButtonBuilder({required V2TimUserFullInfo userFullInfo}) {
    Widget? widget;
    if (_userProfileStateButtonBuilder != null) {
      widget = _userProfileStateButtonBuilder!(userFullInfo: userFullInfo);
    }
    return widget ?? TencentCloudChatUserProfileStateButton(userFullInfo: userFullInfo);
  }

  @override
  Widget getUserProfileDeleteButtonBuilder({required V2TimUserFullInfo userFullInfo}) {
    Widget? widget;
    if (_userProfileDeleteButtonBuilder != null) {
      widget = _userProfileDeleteButtonBuilder!(userFullInfo: userFullInfo);
    }
    return widget ?? TencentCloudChatUserProfileDeleteButton(userFullInfo: userFullInfo);
  }
}
