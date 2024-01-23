import 'package:flutter/widgets.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_add_contacts.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_add_contacts_info.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_app_bar.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_application_info.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_application_list.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_block_list.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_group_application_list.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_group_list.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_item.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_tab.dart';

typedef ContactItemAvatarBuilder = Widget? Function(V2TimFriendInfo friend);

typedef ContactItemContentBuilder = Widget? Function(V2TimFriendInfo friend);

typedef ContactItemElseBuilder = Widget? Function(V2TimFriendInfo friend);

typedef ContactListTagBuilder = Widget? Function(String tag);

typedef ContactListTabItemBuilder = Widget? Function(TabItem item);

typedef ContactApplicationItemAvatarBuilder = Widget? Function(V2TimFriendApplication application);

typedef ContactApplicationItemContentBuilder = Widget? Function(V2TimFriendApplication application);

typedef ContactApplicationItemButtonBuilder = Widget? Function(V2TimFriendApplication application, ApplicationResult? result, Function? sendApplicationResult);

typedef ContactApplicationInfoAvatarBuilder = Widget? Function(V2TimFriendApplication application);

typedef ContactApplicationInfoContentBuilder = Widget? Function(V2TimFriendApplication application);

typedef ContactApplicationInfoAddwordingBuilder = Widget? Function(V2TimFriendApplication application);

typedef ContactApplicationInfoButtonBuilder = Widget? Function(V2TimFriendApplication application, Function? function, ApplicationResult? applicationResult);

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
typedef ContactAddContactsInfoButtonBuilder = Widget? Function(V2TimUserFullInfo userFullInfo, Function? showDetailAddInfo);

typedef ContactAddContactsInfoVerificationBuilder = Widget? Function(Function onVerificationChanged);

typedef ContactAddContactsInfoRemarksAndGroupBuilder = Widget? Function(Function onRemarksChanged, Function onFriendGroupChanged);

typedef ContactAddContactsDetailInfoSendButtonBuilder = Widget? Function(Function addFriend);

typedef ContactGroupApplicationItemGroupNameBuilder = Widget? Function(V2TimGroupApplication application);
typedef ContactGroupApplicationItemContentBuilder = Widget? Function(V2TimGroupApplication application);

typedef ContactGroupApplicationItemButtonBuilder = Widget? Function(V2TimGroupApplication application);

class TencentCloudChatContactBuilders {
  static ContactItemAvatarBuilder? _contactItemAvatarBuilder;
  static ContactItemContentBuilder? _contactItemContentBuilder;
  static ContactItemElseBuilder? _contactItemElseBuilder;
  static ContactListTagBuilder? _contactListTagBuilder;
  static ContactListTabItemBuilder? _contactListTabItemBuilder;
  static ContactApplicationItemAvatarBuilder? _contactApplicationItemAvatarBuilder;
  static ContactApplicationItemContentBuilder? _contactApplicationItemContentBuilder;
  static ContactApplicationItemButtonBuilder? _contactApplicationItemButtonBuilder;
  static ContactApplicationInfoAvatarBuilder? _contactApplicationInfoAvatarBuilder;
  static ContactApplicationInfoContentBuilder? _contactApplicationInfoContentBuilder;
  static ContactApplicationInfoAddwordingBuilder? _contactApplicationInfoAddwordingBuilder;
  static ContactApplicationInfoButtonBuilder? _contactApplicationInfoButtonBuilder;
  static ContactBlockListItemAvatarBuilder? _contactBlockListItemAvatarBuilder;
  static ContactBlockListItemContentBuilder? _contactBlockListItemContentBuilder;

  static ContactGroupListItemAvatarBuilder? _contactGroupListItemAvatarBuilder;
  static ContactGroupListItemContentBuilder? _contactGroupListItemContentBuilder;
  static ContactGroupListTagBuilder? _contactGroupListTagBuilder;
  static ContactAppBarNameBuilder? _contactAppBarNameBuilder;
  static ContactAddContactsListItemAvatarBuilder? _contactAddContactListItemAvatar;
  static ContactAddContactsListItemContentBuilder? _contactAddContactListItemContent;
  static ContactAddContactsInfoAvatarBuilder? _contactAddContactsInfoAvatar;
  static ContactAddContactsInfoContentBuilder? _contactAddContactsInfoContent;
  static ContactAddContactsInfoButtonBuilder? _contactAddContactsInfoButton;
  static ContactAddContactsInfoVerificationBuilder? _contactAddContactsInfoVerificationBuilder;
  static ContactAddContactsInfoRemarksAndGroupBuilder? _contactAddContactsInfoRemarksAndGroupBuilder;
  static ContactAddContactsDetailInfoSendButtonBuilder? _contactAddContactsDetailInfoSendButtonBuilder;
  static ContactGroupApplicationItemGroupNameBuilder? _contactGroupApplicationItemGroupName;
  static ContactGroupApplicationItemContentBuilder? _contactGroupApplicationItemContent;
  static ContactGroupApplicationItemButtonBuilder? _contactGroupApplicationItemButton;

  TencentCloudChatContactBuilders({
    ContactItemAvatarBuilder? contactItemAvatarBuilder,
    ContactItemContentBuilder? contactItemContentBuilder,
    ContactItemElseBuilder? contactItemElseBuilder,
    ContactListTagBuilder? contactListTagBuilder,
    ContactListTabItemBuilder? contactListTabItemBuilder,
    ContactApplicationItemAvatarBuilder? contactApplicationItemAvatarBuilder,
    ContactApplicationItemContentBuilder? contactApplicationItemContentBuilder,
    ContactApplicationItemButtonBuilder? contactApplicationItemButtonBuilder,
    ContactApplicationInfoAvatarBuilder? contactApplicationInfoAvatarBuilder,
    ContactApplicationInfoContentBuilder? contactApplicationInfoContentBuilder,
    ContactApplicationInfoAddwordingBuilder? contactApplicationInfoAddwordingBuilder,
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
    ContactGroupApplicationItemGroupNameBuilder? contactGroupApplicationItemGroupName,
    ContactGroupApplicationItemContentBuilder? contactGroupApplicationItemContent,
    ContactGroupApplicationItemButtonBuilder? contactGroupApplicationItemButton,
  }) {
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
    _contactApplicationInfoAddwordingBuilder = contactApplicationInfoAddwordingBuilder;
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
    _contactGroupApplicationItemGroupName = contactGroupApplicationItemGroupName;
    _contactGroupApplicationItemContent = contactGroupApplicationItemContent;
    _contactGroupApplicationItemButton = contactGroupApplicationItemButton;
    _contactAddContactsInfoVerificationBuilder = contactAddContactsInfoVerificationBuilder;
    _contactAddContactsInfoRemarksAndGroupBuilder = contactAddContactsInfoRemarksAndGroupBuilder;
    _contactAddContactsDetailInfoSendButtonBuilder = contactAddContactsDetailInfoSendButtonBuilder;
  }

  static Widget getContactItemAvatarBuilder(V2TimFriendInfo friend) {
    Widget? widget;
    if (_contactItemAvatarBuilder != null) {
      widget = _contactItemAvatarBuilder!(friend);
    }
    return widget ?? TencentCloudChatContactItemAvatar(friend: friend);
  }

  static Widget getContactItemContentBuilder(V2TimFriendInfo friend) {
    Widget? widget;
    if (_contactItemContentBuilder != null) {
      widget = _contactItemContentBuilder!(friend);
    }
    return widget ?? TencentCloudChatContactItemContent(friend: friend);
  }

  static Widget getContactItemElseBuilder(V2TimFriendInfo friend) {
    Widget? widget;
    if (_contactItemElseBuilder != null) {
      widget = _contactItemElseBuilder!(friend);
    }
    return widget ?? TencentCloudChatContactItemElse(friend: friend);
  }

  static Widget getContactListTagBuilder(String tag) {
    Widget? widget;
    if (_contactListTagBuilder != null) {
      widget = _contactListTagBuilder!(tag);
    }
    return widget ?? TencentCloudChatContactListTag(tag: tag);
  }

  static Widget getContactListTabItemBuilder(TabItem item) {
    Widget? widget;
    if (_contactListTabItemBuilder != null) {
      widget = _contactListTabItemBuilder!(item);
    }
    return widget ?? TencentCloudChatContactTabItem(item: item);
  }

  static Widget getContactApplicationItemAvatarBuilder(V2TimFriendApplication application) {
    Widget? widget;
    if (_contactApplicationItemAvatarBuilder != null) {
      widget = _contactApplicationItemAvatarBuilder!(application);
    }
    return widget ?? TencentCloudChatContactApplicationItemAvatar(application: application);
  }

  static Widget getContactApplicationItemContentBuilder(V2TimFriendApplication application) {
    Widget? widget;
    if (_contactApplicationItemContentBuilder != null) {
      widget = _contactApplicationItemContentBuilder!(application);
    }
    return widget ?? TencentCloudChatContactApplicationItemContent(application: application);
  }

  static Widget getContactApplicationItemButtonBuilder(V2TimFriendApplication application, ApplicationResult? result, Function? sendApplicationResult) {
    Widget? widget;
    if (_contactApplicationItemButtonBuilder != null) {
      widget = _contactApplicationItemButtonBuilder!(application, result, sendApplicationResult);
    }
    return widget ?? TencentCloudChatApplicationItemButton(application: application, applicationResult: result, sendApplicationResult: sendApplicationResult);
  }

  static Widget getContactApplicationInfoAvatarbuilder(V2TimFriendApplication application) {
    Widget? widget;
    if (_contactApplicationInfoAvatarBuilder != null) {
      widget = _contactApplicationInfoAvatarBuilder!(application);
    }
    return widget ?? TencentCloudChatContactApplicationInfoAvatar(application: application);
  }

  static Widget getContactApplicationInfoContentBuilder(V2TimFriendApplication application) {
    Widget? widget;
    if (_contactApplicationInfoContentBuilder != null) {
      widget = _contactApplicationInfoContentBuilder!(application);
    }
    return widget ?? TencentCloudChatContactApplicationInfoContent(application: application);
  }

  static Widget getContactApplicationInfoAddwordingBuilder(V2TimFriendApplication application) {
    Widget? widget;
    if (_contactApplicationInfoAddwordingBuilder != null) {
      widget = _contactApplicationInfoAddwordingBuilder!(application);
    }
    return widget ?? TencentCloudChatContentApplicationInfoAddwording(application: application);
  }

  static Widget getContactApplicationInfoButtonBuilder(V2TimFriendApplication application, Function? resultFunction, ApplicationResult? applicationResult) {
    Widget? widget;
    if (_contactApplicationInfoButtonBuilder != null) {
      widget = _contactApplicationInfoButtonBuilder!(application, resultFunction, applicationResult);
    }
    return widget ?? TencentCloudChatContactApplicationInfoButton(application: application, resultFunction: resultFunction, applicationResult: applicationResult);
  }

  static Widget getContactBlockListItemAvatarBuilder(V2TimFriendInfo friend) {
    Widget? widget;
    if (_contactBlockListItemAvatarBuilder != null) {
      widget = _contactBlockListItemAvatarBuilder!(friend);
    }
    return widget ?? TencentCloudChatContactBlockListItemAvatar(friend: friend);
  }

  static Widget getContactBlockListItemContentBuilder(V2TimFriendInfo friend) {
    Widget? widget;
    if (_contactBlockListItemContentBuilder != null) {
      widget = _contactBlockListItemContentBuilder!(friend);
    }
    return widget ?? TencentCloudChatContactBlockListItemContent(friend: friend);
  }

  static Widget getContactGroupListItemAvatarBuilder(V2TimGroupInfo group) {
    Widget? widget;
    if (_contactGroupListItemAvatarBuilder != null) {
      widget = _contactGroupListItemAvatarBuilder!(group);
    }
    return widget ?? TencentCloudChatContactGroupItemAvatar(group: group);
  }

  static Widget getContactGroupListItemContentBuilder(V2TimGroupInfo group) {
    Widget? widget;
    if (_contactGroupListItemContentBuilder != null) {
      widget = _contactGroupListItemContentBuilder!(group);
    }
    return widget ?? TencentCloudChatContactGroupItemContent(group: group);
  }

  static Widget getContactGroupListTagBuilder(String tag, int? count) {
    Widget? widget;
    if (_contactGroupListTagBuilder != null) {
      widget = _contactGroupListTagBuilder!(tag, count);
    }
    return widget ?? TencentCloudChatContactGroupListTag(tag: tag, count: count);
  }

  static Widget getContactAppBarNameBuilder({String? title}) {
    Widget? widget;
    if (_contactAppBarNameBuilder != null) {
      widget = _contactAppBarNameBuilder!(title: title);
    }
    return widget ?? TencentCloudChatContactAppBarName(title: title);
  }

  static Widget getContactAddContactListItemAvatarBuilder(V2TimUserFullInfo userFullInfo) {
    Widget? widget;
    if (_contactAddContactListItemAvatar != null) {
      widget = _contactAddContactListItemAvatar!(userFullInfo);
    }
    return widget ?? TencentCloudChatContactAddContactListItemAvatar(userFullInfo: userFullInfo);
  }

  static Widget getContactAddContactListItemContentBuilder(V2TimUserFullInfo userFullInfo) {
    Widget? widget;
    if (_contactAddContactListItemContent != null) {
      widget = _contactAddContactListItemContent!(userFullInfo);
    }
    return widget ?? TencentCloudChatChontactAddContactListItemContent(userFullInfo: userFullInfo);
  }

  static Widget getContactAddContactInfoAvatarBuilder(V2TimUserFullInfo userFullInfo) {
    Widget? widget;
    if (_contactAddContactsInfoAvatar != null) {
      widget = _contactAddContactsInfoAvatar!(userFullInfo);
    }
    return widget ?? TencentCloudChatContactAddContactsInfoAvatar(userFullInfo: userFullInfo);
  }

  static Widget getContactAddContactInfoContentBuilder(V2TimUserFullInfo userFullInfo) {
    Widget? widget;
    if (_contactAddContactsInfoContent != null) {
      widget = _contactAddContactsInfoContent!(userFullInfo);
    }
    return widget ?? TencentCloudChatContactAddContactsInfoContent(userFullInfo: userFullInfo);
  }

  static Widget getContactAddContactInfoButtonBuilder(V2TimUserFullInfo userFullInfo, Function? showDetailAddInfo) {
    Widget? widget;
    if (_contactAddContactsInfoButton != null) {
      widget = _contactAddContactsInfoButton!(userFullInfo, showDetailAddInfo);
    }
    return widget ?? TencentCloudChatContactAddContactsInfoButton(userFullInfo: userFullInfo, showDetailAddInfo: showDetailAddInfo);
  }

  static Widget getContactGroupApplicationItemGroupNameBuilder(V2TimGroupApplication groupApplication) {
    Widget? widget;
    if (_contactGroupApplicationItemGroupName != null) {
      widget = _contactGroupApplicationItemGroupName!(groupApplication);
    }
    return widget ?? TencentCloudChatContactGroupApplicationItemGroupName(application: groupApplication);
  }

  static Widget getContactGroupApplicationItemContentBuilder(V2TimGroupApplication groupApplication) {
    Widget? widget;
    if (_contactGroupApplicationItemContent != null) {
      widget = _contactGroupApplicationItemContent!(groupApplication);
    }
    return widget ?? TencentCloudChatContactGroupApplicationItemContent(application: groupApplication);
  }

  static Widget getContactGroupApplicationItemButtonBuilder(V2TimGroupApplication groupApplication) {
    Widget? widget;
    if (_contactGroupApplicationItemButton != null) {
      widget = _contactGroupApplicationItemButton!(groupApplication);
    }
    return widget ?? TencentCloudChatContactGroupApplicationItemButton(application: groupApplication);
  }

  static Widget getContactAddContactsInfoVerificationBuilder(Function onVerificationChanged) {
    Widget? widget;
    if (_contactAddContactsInfoVerificationBuilder != null) {
      widget = _contactAddContactsInfoVerificationBuilder!(onVerificationChanged);
    }
    return widget ??
        TencentCloudChatContactAddContactsInfoVerification(
          onVerificationChanged: onVerificationChanged,
        );
  }

  static Widget getContactAddContactsInfoRemarksAndGroupBuilder(Function onRemarksChanged, Function onFriendGroupChanged) {
    Widget? widget;
    if (_contactAddContactsInfoRemarksAndGroupBuilder != null) {
      widget = _contactAddContactsInfoRemarksAndGroupBuilder!(onRemarksChanged, onFriendGroupChanged);
    }
    return widget ??
        TencentCloudChatContactAddContactsInfoRemarksAndGroup(
          onRemarksChanged: onRemarksChanged,
          onFriendGroupChanged: onFriendGroupChanged,
        );
  }

  static Widget getContactAddContactsDetailInfoSendButton(Function addFriend) {
    Widget? widget;
    if (_contactAddContactsDetailInfoSendButtonBuilder != null) {
      widget = _contactAddContactsDetailInfoSendButtonBuilder!(addFriend);
    }
    return widget ??
        TencentCloudChatContactAddContactsDetailInfoSendButton(
          addFriend: addFriend,
        );
  }
}
