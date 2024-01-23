import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/router/tencent_cloud_chat_route_names.dart';
import 'package:tencent_cloud_chat/router/tencent_cloud_chat_router.dart';

/// Navigate to `TencentCloudChatConversation`, while options should be `TencentCloudChatConversationOptions`
Future<T?>? navigateToConversation<T extends Object?>({
  required BuildContext context,
  dynamic options,
}) {
  return TencentCloudChatRouter().navigateTo<T>(
    context: context,
    routeName: TencentCloudChatRouteNames.conversation,
    options: options,
  );
}

/// Navigate to `TencentCloudChatMessage`, while options should be `TencentCloudChatMessageOptions`
Future<T?>? navigateToMessage<T extends Object?>({
  required BuildContext context,
  dynamic options,
}) {
  return TencentCloudChatRouter().navigateTo<T>(
    context: context,
    routeName: TencentCloudChatRouteNames.message,
    options: options,
  );
}

/// Navigate to `TencentCloudChatMessageInfo`, while options should be `TencentCloudChatMessageInfoOptions`
Future<T?>? navigateToMessageInfo<T extends Object?>({
  required BuildContext context,
  dynamic options,
}) {
  return TencentCloudChatRouter().navigateTo<T>(
    context: context,
    routeName: TencentCloudChatRouteNames.messageInfo,
    options: options,
  );
}

/// Navigate to `TencentCloudChatGlobalSearch`, while options should be `TencentCloudChatSearchOptions` /// TODO: 这里的名字根据实际的再改哦~
Future<T?>? navigateToGlobalSearch<T extends Object?>({
  required BuildContext context,
  dynamic options,
}) {
  return TencentCloudChatRouter().navigateTo<T>(
    context: context,
    routeName: TencentCloudChatRouteNames.globalSearch,
    options: options,
  );
}

/// Navigate to `TencentCloudChatMessageSearch`, while options should be `TencentCloudChatMessageSearchOptions`
Future<T?>? navigateToMessageSearch<T extends Object?>({
  required BuildContext context,
  dynamic options,
}) {
  return TencentCloudChatRouter().navigateTo<T>(
    context: context,
    routeName: TencentCloudChatRouteNames.messageSearch,
    options: options,
  );
}

/// Navigate to `TencentCloudChatUserProfile`, while options should be `TencentCloudChatUserProfileOptions`
Future<T?>? navigateToUserProfile<T extends Object?>({
  required BuildContext context,
  dynamic options,
}) {
  return TencentCloudChatRouter().navigateTo<T>(
    context: context,
    routeName: TencentCloudChatRouteNames.userProfile,
    options: options,
  );
}

/// Navigate to `TencentCloudChatUserProfileEdit`, while options should be `TencentCloudChatUserProfileEditOptions`
Future<T?>? navigateToUserProfileEdit<T extends Object?>({
  required BuildContext context,
  dynamic options,
}) {
  return TencentCloudChatRouter().navigateTo<T>(
    context: context,
    routeName: TencentCloudChatRouteNames.userProfileEdit,
    options: options,
  );
}

/// Navigate to `TencentCloudChatGroupProfile`, while options should be `TencentCloudChatGroupProfileOptions`
Future<T?>? navigateToGroupProfile<T extends Object?>({
  required BuildContext context,
  dynamic options,
}) {
  return TencentCloudChatRouter().navigateTo<T>(
    context: context,
    routeName: TencentCloudChatRouteNames.groupProfile,
    options: options,
  );
}

/// Navigate to `TencentCloudChatGroupMemberList`, while options should be `TencentCloudChatGroupMemberListOptions`
Future<T?>? navigateToGroupMemberList<T extends Object?>({
  required BuildContext context,
  dynamic options,
}) {
  return TencentCloudChatRouter().navigateTo<T>(
    context: context,
    routeName: TencentCloudChatRouteNames.groupMemberList,
    options: options,
  );
}

/// Navigate to `TencentCloudChatGroupNotice`, while options should be `TencentCloudChatGroupNoticeOptions`
Future<T?>? navigateToGroupNotice<T extends Object?>({
  required BuildContext context,
  dynamic options,
}) {
  return TencentCloudChatRouter().navigateTo<T>(
    context: context,
    routeName: TencentCloudChatRouteNames.groupNotice,
    options: options,
  );
}

/// Navigate to `TencentCloudChatGroupManagement`, while options should be `TencentCloudChatGroupManagementOptions`
Future<T?>? navigateToGroupManagement<T extends Object?>({
  required BuildContext context,
  dynamic options,
}) {
  return TencentCloudChatRouter().navigateTo<T>(
    context: context,
    routeName: TencentCloudChatRouteNames.groupManagement,
    options: options,
  );
}

/// Navigate to `TencentCloudChatContact`, while options should be `TencentCloudChatContactOptions`
Future<T?>? navigateToContact<T extends Object?>({
  required BuildContext context,
  dynamic options,
}) {
  return TencentCloudChatRouter().navigateTo<T>(
    context: context,
    routeName: TencentCloudChatRouteNames.contact,
    options: options,
  );
}

/// Navigate to `TencentCloudChatAddContact`, while options should be `TencentCloudChatAddContactOptions`
Future<T?>? navigateToAddContact<T extends Object?>({
  required BuildContext context,
  dynamic options,
}) {
  return TencentCloudChatRouter().navigateTo<T>(
    context: context,
    routeName: TencentCloudChatRouteNames.addContact,
    options: options,
  );
}

/// Navigate to `TencentCloudChatAddGroup`, while options should be `TencentCloudChatAddGroupOptions`
Future<T?>? navigateToAddGroup<T extends Object?>({
  required BuildContext context,
  dynamic options,
}) {
  return TencentCloudChatRouter().navigateTo<T>(
    context: context,
    routeName: TencentCloudChatRouteNames.addGroup,
    options: options,
  );
}

/// Navigate to `TencentCloudChatNewContactApplication`, while options should be `TencentCloudChatNewContactApplicationOptions`
Future<T?>? navigateToNewContactApplication<T extends Object?>({
  required BuildContext context,
  dynamic options,
}) {
  return TencentCloudChatRouter().navigateTo<T>(
    context: context,
    routeName: TencentCloudChatRouteNames.newContactApplication,
    options: options,
  );
}

/// Navigate to `TencentCloudChatNewContactApplicationDetail`, while options should be `TencentCloudChatNewContactApplicationDetailOptions`
Future<T?>? navigateToNewContactApplicationDetail<T extends Object?>({
  required BuildContext context,
  dynamic options,
}) {
  return TencentCloudChatRouter().navigateTo<T>(
    context: context,
    routeName: TencentCloudChatRouteNames.newContactApplicationDetail,
    options: options,
  );
}

/// Navigate to `TencentCloudChatContactGroupList`, while options should be `TencentCloudChatContactGroupListOptions`
Future<T?>? navigateToGroupList<T extends Object?>({
  required BuildContext context,
  dynamic options,
}) {
  return TencentCloudChatRouter().navigateTo<T>(
    context: context,
    routeName: TencentCloudChatRouteNames.groupList,
    options: options,
  );
}

/// Navigate to `TencentCloudChatContactBlockList`, while options should be `TencentCloudChatContactBlockRListOptions`
Future<T?>? navigateToBlockList<T extends Object?>({
  required BuildContext context,
  dynamic options,
}) {
  return TencentCloudChatRouter().navigateTo<T>(
    context: context,
    routeName: TencentCloudChatRouteNames.blockList,
    options: options,
  );
}

Future<T?>? navigateToFriendInfo<T extends Object?>({
  required BuildContext context,
  dynamic options,
}) {
  return TencentCloudChatRouter().navigateTo<T>(
    context: context,
    routeName: TencentCloudChatRouteNames.friendInfo,
    options: options,
  );
}

/// Navigate to `TencentCloudChatContactGroupApplicationList`, while options should be `TencentCloudChatContactGroupApplicationListData`
Future<T?>? navigateToGroupApplication<T extends Object>({
  required BuildContext context,
  dynamic options,
}) {
  return TencentCloudChatRouter().navigateTo<T>(
    context: context,
    routeName: TencentCloudChatRouteNames.groupApplication,
    options: options,
  );
}

Future<T?>? navigateToSettingsSetInfo<T extends Object>({
  required BuildContext context,
  dynamic options,
}) {
  return TencentCloudChatRouter().navigateTo<T>(
    context: context,
    routeName: TencentCloudChatRouteNames.settingsInfo,
    options: options,
  );
}

Future<T?>? navigateToSettingsAbout<T extends Object>({
  required BuildContext context,
  dynamic options,
}) {
  return TencentCloudChatRouter().navigateTo<T>(
    context: context,
    routeName: TencentCloudChatRouteNames.settingsAbout,
    options: options,
  );
}

Future<T?>? navigateToHomePage<T extends Object>({
  required BuildContext context,
  dynamic options,
}) {
  return TencentCloudChatRouter().navigateTo<T>(
    context: context,
    routeName: TencentCloudChatRouteNames.homePage,
    options: options,
  );
}

Future<T?>? navigateToLoginPage<T extends Object>({
  required BuildContext context,
  dynamic options,
}) {
  return TencentCloudChatRouter().navigateTo<T>(
    context: context,
    routeName: TencentCloudChatRouteNames.loginPage,
    options: options,
  );
}
