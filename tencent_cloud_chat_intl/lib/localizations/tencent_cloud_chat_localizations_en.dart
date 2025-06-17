// Copyright (c) 1998-2024 Tencent, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:intl/intl.dart' as intl;

import 'tencent_cloud_chat_localizations.dart';

/// The translations for English (`en`).
class TencentCloudChatLocalizationsEn extends TencentCloudChatLocalizations {
  TencentCloudChatLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get album => 'Album';

  @override
  String get chat => 'Chat';

  @override
  String get chats => 'Chats';

  @override
  String get calls => 'Calls';

  @override
  String get search => 'Search';

  @override
  String get contacts => 'Contacts';

  @override
  String get settings => 'Settings';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get sendAMessage => 'Message';

  @override
  String get done => 'Done';

  @override
  String get archive => 'Archive';

  @override
  String get read => 'Read';

  @override
  String get readAll => 'Read';

  @override
  String get delete => 'Delete';

  @override
  String get newChat => 'New Chat';

  @override
  String get newGroup => 'New Group';

  @override
  String get frequentlyContacted => 'Frequently Contacted';

  @override
  String get addParticipants => 'Add Members';

  @override
  String get addMembers => 'Add Members';

  @override
  String get cancel => 'Cancel';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get groupID => 'Group ID';

  @override
  String get groupIDCertificate => 'Group ID (Certificate)';

  @override
  String get groupOfType => 'Type of Group';

  @override
  String get typeOfGroup => 'Type of Group';

  @override
  String get work => 'Work';

  @override
  String get public => 'Public';

  @override
  String get meeting => 'Meeting';

  @override
  String get avChatRoom => 'AVChatRoom';

  @override
  String get groupPortrait => 'Group Portrait';

  @override
  String get participants => 'Participants';

  @override
  String get seeDocs => 'See Docs';

  @override
  String get you => 'You';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String youCreatedGroup(String groupName) {
    return 'You Created Group $groupName';
  }

  @override
  String get groups => 'Groups';

  @override
  String get chatRecord => 'Messages';

  @override
  String get messages => 'Messages';

  @override
  String get more => 'More';

  @override
  String get noConversationsContactsOrMessagesFound => 'No Conversations, Contacts or Messages found';

  @override
  String get contactInfo => 'Contact Info';

  @override
  String get exportChat => 'Export Chat';

  @override
  String get clearChat => 'Clear Chat';

  @override
  String get deleteChat => 'Delete Chat';

  @override
  String get video => 'Video';

  @override
  String get videoCall => 'Video Call';

  @override
  String get missedVideoCall => 'Missed video call';

  @override
  String get voice => 'Voice';

  @override
  String get voiceCall => 'Voice Call';

  @override
  String get missedVoiceCall => 'Missed voice call';

  @override
  String get location => 'Location';

  @override
  String get youStartedACall => 'You started a call';

  @override
  String get star => 'Star';

  @override
  String get copy => 'Copy';

  @override
  String get forward => 'Forward';

  @override
  String get multiSelect => 'Select';

  @override
  String get select => 'Select';

  @override
  String get quote => 'Quote';

  @override
  String get reply => 'Reply';

  @override
  String get all => 'All';

  @override
  String get tapToRemove => 'Tap to Remove';

  @override
  String get messageInfo => 'Message Info';

  @override
  String get delivered => 'Delivered';

  @override
  String get readBy => 'Read By';

  @override
  String get deliveredTo => 'Delivered To';

  @override
  String numSelect(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num Selected',
      zero: 'Select Messages',
    );
    return '$_temp0';
  }

  @override
  String numChats(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num Chats',
      one: '1 Chat',
      zero: 'No Chat Selected',
    );
    return '$_temp0';
  }

  @override
  String get recentChats => 'Recent Chats';

  @override
  String numThreadQuote(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num Thread Quotes',
      one: '$num Thread Quote',
    );
    return '$_temp0';
  }

  @override
  String get swipeLeftToCancelOrReleaseToSend => 'Swipe left to cancel or release to send';

  @override
  String get releaseToCancel => 'Release to Cancel';

  @override
  String get camera => 'Camera';

  @override
  String get document => 'Document';

  @override
  String get file => 'File';

  @override
  String get photos => 'Photos';

  @override
  String get contact => 'Contact';

  @override
  String get custom => 'Custom';

  @override
  String get message => 'Message';

  @override
  String get doNotDisturb => 'Mute Notifications';

  @override
  String get mute => 'Mute';

  @override
  String get pin => 'Pin';

  @override
  String get blackUser => 'Block User';

  @override
  String get blockUser => 'Block User';

  @override
  String get saveContact => 'Save Contact';

  @override
  String get call => 'Call';

  @override
  String get clearingChatHistory => 'Clear Messages';

  @override
  String get clearMessages => 'Clear Messages';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get groupNotice => 'Group Notice';

  @override
  String get groupOfAnnouncement => 'Group Notice';

  @override
  String get groupManagement => 'Manage Group';

  @override
  String get groupType => 'Group Type';

  @override
  String get addGroupWay => 'Group Joining Method';

  @override
  String get inviteGroupType => 'Group Inviting Method';

  @override
  String get myAliasInGroup => 'My Alias in Group';

  @override
  String get myGroupNickName => 'My Alias in Group';

  @override
  String get groupMembers => 'Group Members';

  @override
  String get admin => 'Admin';

  @override
  String adminNum(int num) {
    return 'Admin ($num)';
  }

  @override
  String get info => 'Info';

  @override
  String get setAsAdmin => 'Set Administrator';

  @override
  String get announcement => 'Group Notice';

  @override
  String get totalSilence => 'Silence All';

  @override
  String get silenceAll => 'Silence All';

  @override
  String get addSilencedMember => 'Add Silenced Member';

  @override
  String get onlyGroupOwnerAndAdminsCanSendMessages => 'After enabling, only the group owner and admins can send messages.';

  @override
  String someoneEnabledSilenceAll(String name) {
    return '$name enabled \'Silence All\'';
  }

  @override
  String someoneDisabledSilenceAll(String name) {
    return '$name disabled \'Silence All\'';
  }

  @override
  String get newContacts => 'New Contacts';

  @override
  String get myGroup => 'My Groups';

  @override
  String get theBlackList => 'Block List';

  @override
  String get blockList => 'Blocked Users';

  @override
  String get groupChatNotifications => 'Group Chat Notifications';

  @override
  String get userID => 'User ID';

  @override
  String myUserID(String userID) {
    return 'My User ID: $userID';
  }

  @override
  String get searchUserID => 'SearchUserID';

  @override
  String get none => 'None';

  @override
  String iDis(String userID) {
    return 'ID: $userID';
  }

  @override
  String get addToContacts => 'Add to Contacts';

  @override
  String get addContact => 'Add Contact';

  @override
  String get bio => 'Bio';

  @override
  String bioIs(String bio) {
    return 'Bio: $bio';
  }

  @override
  String get fillInTheVerificationInformation => 'Send Request';

  @override
  String get remarkAndGrouping => 'Remark and Grouping';

  @override
  String get remark => 'Remark';

  @override
  String get group => 'Group';

  @override
  String get send => 'Send';

  @override
  String get contactAddedSuccessfully => 'Contact Added Successfully';

  @override
  String get requestSent => 'Request Sent';

  @override
  String get cannotAddContact => 'Cannot Add Contact';

  @override
  String get addGroup => 'Add Group';

  @override
  String typeIs(String type) {
    return 'Type: $type';
  }

  @override
  String get groupNotAcceptingRequests => 'Group Not Accepting Requests';

  @override
  String get joinedGroupSuccessfully => 'Joined Group Successfully';

  @override
  String numNewApplications(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num New Applications',
      one: '$num New Application',
    );
    return '$_temp0';
  }

  @override
  String get agree => 'Accept';

  @override
  String get accept => 'Accept';

  @override
  String get refuse => 'Decline';

  @override
  String get decline => 'Decline';

  @override
  String get verificationMessage => 'Verification Message';

  @override
  String get accepted => 'Accepted';

  @override
  String get declined => 'Declined';

  @override
  String get confirm => 'Confirm';

  @override
  String get contactRequest => 'Contact Request';

  @override
  String get contactsPermission => 'Contacts Permission';

  @override
  String get allowAnyUserAddYouAsContact => 'Allow Anyone to Add You as a Contact';

  @override
  String get declineContactRequestFromAnyUser => 'Auto Decline Contact Requests';

  @override
  String get anyoneUponRequest => 'Accept Requests Manually';

  @override
  String get theme => 'Theme';

  @override
  String get language => 'Language';

  @override
  String get aboutTencentCloudChat => 'About Tencent Cloud Chat';

  @override
  String get logIn => 'Log In';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signOut => 'Sign Out';

  @override
  String get logOut => 'Log Out';

  @override
  String get signature => 'Bio';

  @override
  String get gender => 'Gender';

  @override
  String get birthday => 'Birthday';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get unspecified => 'Unspecified';

  @override
  String get unknown => 'Unknown';

  @override
  String get sdkVersion => 'SDK Version';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get userAgreement => 'User Agreement';

  @override
  String get disclaimer => 'Disclaimer';

  @override
  String get personalInformationCollected => 'Personal Information Collected';

  @override
  String get informationSharedWithThirdParties => 'Information Shared with Third Parties';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get countryOrRegion => 'Country / Region';

  @override
  String get selectACountry => 'Select a Country or Region';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get email => 'EMail';

  @override
  String get verificationCode => 'Verification Code';

  @override
  String get enterSMSCode => 'Enter the code sent via SMS';

  @override
  String get sendCode => 'Send Code';

  @override
  String get visitOurWebsite => 'Visit Our Website';

  @override
  String get english => 'English';

  @override
  String get simplifiedChinese => '简体中文';

  @override
  String get traditionalChinese => '繁體中文';

  @override
  String get japanese => '日本語';

  @override
  String get korean => '한국어';

  @override
  String get style => 'Style';

  @override
  String get classic => 'Classic';

  @override
  String get minimalist => 'Minimalist';

  @override
  String get messageReadStatus => 'Message Read Status';

  @override
  String get messageReadStatusDescription => 'Controls whether the read status is displayed for your messages and if others can see whether you\'ve read their messages.';

  @override
  String get onlineStatus => 'Online Status';

  @override
  String get onlineStatusDescription => 'Determines if your online status is visible to your contacts.';

  @override
  String get noBio => 'No Bio';

  @override
  String get noConversation => 'No Conversation';

  @override
  String get sound => 'Sound';

  @override
  String get sticker => 'Sticker';

  @override
  String get image => 'Image';

  @override
  String get chatHistory => 'Chat History';

  @override
  String get audio => 'Audio';

  @override
  String get messageDeleted => 'Message Deleted';

  @override
  String get messageRecalled => 'Message Recalled';

  @override
  String unreadCount(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num Unread Messages',
      one: '$num Unread Message',
    );
    return '$_temp0';
  }

  @override
  String newMsgCount(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num New Messages',
      one: 'A New Message',
    );
    return '$_temp0';
  }

  @override
  String get takeAPhoto => 'Take a photo';

  @override
  String get recordAVideo => 'Record a video';

  @override
  String get pullDownToLoadMoreMessages => 'Pull down to load more messages';

  @override
  String get releaseToLoadMore => 'Release to load more';

  @override
  String get noMoreMessage => 'No more message';

  @override
  String get pullUpToLoadMoreMessages => 'Pull up to load more messages';

  @override
  String get holdToRecordReleaseToSend => 'Hold to record, release to send';

  @override
  String get forwardIndividually => 'Forward Individually';

  @override
  String get forwardCombined => 'Forward Combined';

  @override
  String get selectConversations => 'Select Conversations';

  @override
  String get recent => 'Recent';

  @override
  String get recall => 'Recall';

  @override
  String replyTo(String name) {
    return 'Reply to $name';
  }

  @override
  String get confirmDeletion => 'Confirm Deletion';

  @override
  String get askDeleteThisMessage => 'Delete this message?';

  @override
  String deleteMessageCount(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: 'Delete $num messages?',
      one: 'Delete a message?',
      zero: 'No message been deleted',
    );
    return '$_temp0';
  }

  @override
  String memberReadCount(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num members read',
      one: '1 member read',
      zero: 'No member read',
    );
    return '$_temp0';
  }

  @override
  String get allMembersRead => 'All members read';

  @override
  String get allowAny => 'Allow Any';

  @override
  String get cannotSendApplicationToWorkGroup => 'Cannot send application to work group';

  @override
  String get appearance => 'Appearance';

  @override
  String get darkTheme => 'Dark';

  @override
  String get denyAny => 'Deny Any';

  @override
  String get edit => 'Edit';

  @override
  String get friendsPermission => 'Friends Permission';

  @override
  String get groupJoined => 'Group Joined';

  @override
  String get lightTheme => 'Light';

  @override
  String get noBlockList => 'No blocked users';

  @override
  String get noContact => 'No contacts';

  @override
  String get noNewApplication => 'No new application';

  @override
  String get permissionNeeded => 'Permission needed';

  @override
  String get requireRequest => 'Required request';

  @override
  String get setNickname => 'Set nickname';

  @override
  String get setSignature => 'Set signature';

  @override
  String get validationMessages => 'Validation Messages';

  @override
  String get getVerification => 'Get verification';

  @override
  String get invalidEmail => 'Invalid Email';

  @override
  String get invalidPhoneNumber => 'Invalid phone number';

  @override
  String get invalidVerification => 'Invalid verification';

  @override
  String get searchGroupID => 'Search Group ID';

  @override
  String get callInitiated => 'Call initiated';

  @override
  String get callAccepted => 'Call accepted';

  @override
  String get callDeclined => 'Call declined';

  @override
  String get noAnswer => 'No answer';

  @override
  String get lineBusy => 'Line busy';

  @override
  String get callHungUp => 'Call hung up';

  @override
  String get callInProgress => 'Call in progress';

  @override
  String get callEnded => 'Call ended';

  @override
  String get unknownCallStatus => 'Calling';

  @override
  String get groupChatCreated => 'Group chat created successfully!';

  @override
  String get vote => 'Vote';

  @override
  String get callCancelled => 'Call cancelled';

  @override
  String get unknownGroupTips => 'Unknown group tips';

  @override
  String memberJoinedGroup(Object members) {
    return '$members has joined the group';
  }

  @override
  String opInvitedToGroup(Object members, Object opMember) {
    return '$opMember invited $members to the group';
  }

  @override
  String memberLeftGroup(Object members) {
    return '$members left the group';
  }

  @override
  String opRemovedFromGroup(Object members, Object opMember) {
    return '$opMember removed $members from the group';
  }

  @override
  String opPromotedToAdmin(Object members, Object opMember) {
    return '$opMember promoted $members to admin';
  }

  @override
  String opRevokedAdmin(Object members, Object opMember) {
    return '$opMember revoked admin role from $members';
  }

  @override
  String setToAdmin(Object members) {
    return '$members was promoted to group manager';
  }

  @override
  String revokedAdmin(Object members) {
    return '$members was demoted from group manager';
  }

  @override
  String opChangedGroupInfo(Object groupInfo, Object opMember) {
    return '$opMember changed $groupInfo';
  }

  @override
  String opChangedMemberInfo(Object memberInfo, Object opMember) {
    return '$opMember changed $memberInfo';
  }

  @override
  String changedGroupNameTo(Object name) {
    return 'Changed group name to $name';
  }

  @override
  String changedGroupDescriptionTo(Object description) {
    return 'Changed group description to $description';
  }

  @override
  String changedGroupAnnouncementTo(Object announcement) {
    return 'Changed group announcement to $announcement';
  }

  @override
  String get changedGroupAvatar => 'Changed group avatar';

  @override
  String transferredGroupOwnershipTo(Object owner) {
    return 'Transferred group ownership to $owner';
  }

  @override
  String get changedGroupCustomInfo => 'Changed group custom info';

  @override
  String get enabledGroupMute => 'muted all members';

  @override
  String get disabledGroupMute => 'unmuted all members';

  @override
  String changedGroupMessageReceptionTo(Object setting) {
    return ' changed group message reception setting to: $setting';
  }

  @override
  String changedApplyToJoinGroupTo(Object setting) {
    return ' changed the group join setting to to: $setting';
  }

  @override
  String changedInviteToJoinGroupTo(Object setting) {
    return ' changed the group invitation setting to: $setting';
  }

  @override
  String opUnmuted(Object user) {
    return '$user Unmuted';
  }

  @override
  String opMuted(Object duration, Object user) {
    return '$user Muted for $duration seconds';
  }

  @override
  String get groupTips => 'Group Tips';

  @override
  String get receiveMessages => 'Receive messages';

  @override
  String get doNotReceiveMessages => 'Do not receive messages';

  @override
  String get receiveMessagesWhenOnlineOnly => 'Receive messages when online only';

  @override
  String get disallowJoinGroup => 'Disallow applying to join group';

  @override
  String get joinGroupNeedApproval => 'Require admin approval for applying to join group';

  @override
  String get joinGroupDirectly => 'Join group directly after applying';

  @override
  String get disallowInviting => 'Disallow inviting to join group';

  @override
  String get requireApprovalForInviting => 'Require admin approval for inviting to join group';

  @override
  String get joinDirectlyBeenInvited => 'Join group directly after being invited';

  @override
  String get unmuted => 'Unmuted';

  @override
  String muteTime(Object duration) {
    return 'Muted for $duration seconds';
  }

  @override
  String get poll => 'Poll';

  @override
  String callDuration(Object duration) {
    return 'Call duration: $duration';
  }

  @override
  String get selectMembers => 'Select Members';

  @override
  String numSelectMembers(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num Selected',
      zero: 'Select Members',
    );
    return '$_temp0';
  }

  @override
  String get searchMembers => 'Search Members';

  @override
  String get startCall => 'Start Call';

  @override
  String get clear => 'Clear';

  @override
  String groupSubtitle(Object count, Object name) {
    return '$name and $count others';
  }

  @override
  String get markAsUnread => 'Mark as Unread';

  @override
  String get hide => 'Hide';

  @override
  String get unreadMessagesBelow => 'Unread Messages Below';

  @override
  String get ar => 'اَلْعَرَبِيَّةُ';

  @override
  String get tencentCloudChat => 'Tencent Cloud Chat';

  @override
  String get changeTheme => 'Change appearance';

  @override
  String get deleteAccountNotification => 'After deleted account, you will not be able to use your current account, and related data will be deleted and cannot be retrieved.';

  @override
  String get restartAppForLanguage => 'Please restart the app for the language change to take effect';

  @override
  String get deleteAllMessages => 'Clear Chat History';

  @override
  String get downloading => 'Downloading...';

  @override
  String get viewFullImage => 'View Full Image';

  @override
  String get messageRecall => 'Message Recall';

  @override
  String get messageRecallConfirmation => 'Are you sure you want to recall this message?';

  @override
  String get quit => 'Leave';

  @override
  String get dissolve => 'Disband Group';

  @override
  String get setGroupName => 'set Group Name';

  @override
  String get groupAddAny => 'Auto Approval';

  @override
  String get groupAddAuth => 'Admin Approval';

  @override
  String get groupAddForbid => 'Prohibited from Joining';

  @override
  String get groupOwner => 'Owner';

  @override
  String get groupMember => 'Member';

  @override
  String get dismissAdmin => 'Cancel Admin';

  @override
  String get welcomeToTencentCloudChat => 'Welcome to Tencent Cloud Chat';

  @override
  String get draft => 'Draft';

  @override
  String get openInNewWindow => 'Open in New Window';

  @override
  String get selectAChat => 'Select a Chat';

  @override
  String get noConversationSelected => 'No conversation selected';

  @override
  String get unavailableToSendMessage => 'Unavailable to Send Message';

  @override
  String get noSuchGroup => 'No such group';

  @override
  String get notGroupMember => 'Not a group member';

  @override
  String get userNotFound => 'User not found';

  @override
  String get userBlockedYou => 'User blocked you';

  @override
  String get muted => 'Muted';

  @override
  String get groupMuted => 'Group muted';

  @override
  String get cantSendMessage => 'Can\'t send message';

  @override
  String get media => 'Media';

  @override
  String sendToSomeChat(String name) {
    return 'Send to $name';
  }

  @override
  String get unableToSendWithFolders => 'Unable to send files because folders are included. Please select individual files only.';

  @override
  String get channelSwitch => 'Channel: ';

  @override
  String get weChat => 'WeChat';

  @override
  String get tGWA => 'Telegram & WhatsApp';

  @override
  String get contactUsIfQuestions => 'If there\'s anything unclear or you have more ideas, feel free to contact us!';

  @override
  String get chatNow => 'Chat Now';

  @override
  String get onlineServiceTimeFrom10To20 => 'Online time: 10 AM to 8 PM, Mon through Fri';

  @override
  String get officialWebsite => 'Official Website';

  @override
  String get allSDKs => 'All SDKs';

  @override
  String get sourceCode => 'Source Code';

  @override
  String get personalInformationCollectionList => 'Personal information collection list';

  @override
  String get thirdPartyInformationSharingList => 'Third-party information sharing list';

  @override
  String get version => 'Version';

  @override
  String get feedback => 'Feedback';

  @override
  String get me => 'Me';

  @override
  String get about => 'About';

  @override
  String get profile => 'Profile';

  @override
  String get unpin => 'Unpin';

  @override
  String mentionedMessages(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Messages Mentioned Me',
      one: '1 Message Mentioned Me',
    );
    return '$_temp0';
  }

  @override
  String get longPressToNavigate => 'Press & hold to view';

  @override
  String get permissionDeniedTitle => 'Permission Denied';

  @override
  String permissionDeniedContent(Object permissionString) {
    return 'Please go to settings and enable the $permissionString permission.';
  }

  @override
  String get goToSettingsButtonText => 'Go to Settings';

  @override
  String get originalMessageNotFound => 'Original message not found';

  @override
  String get markAsRead => 'Mark as Read';

  @override
  String get reEdit => 'Re-Edit';

  @override
  String get translate => 'Translate';

  @override
  String memberRecalledMessage(Object member) {
    return '$member Recalled a Message';
  }

  @override
  String get copyFileSuccess => 'Copy File Success';

  @override
  String get saveFileSuccess => 'Save File Success';

  @override
  String get saveFileFailed => 'Save File Failed';

  @override
  String get copyLinkSuccess => 'Copy Link Success';

  @override
  String get copyImageContextMenuBtnText => 'Copy Image';

  @override
  String get saveToLocalContextMenuBtnText => 'Save As';

  @override
  String get copyLinkContextMenuBtnText => 'Copy Link';

  @override
  String get openLinkContextMenuBtnText => 'Open in New Window';

  @override
  String get reactionList => 'Reaction List';

  @override
  String get translatedBy => 'Powered by Tencent RTC';

  @override
  String get convertToText => 'Convert';

  @override
  String numMessages(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Messages',
      one: '1 Message',
    );
    return '$_temp0';
  }

  @override
  String get filterBy => 'Filter by';

  @override
  String get text => 'Text';

  @override
  String get numMessagesOver99 => '99+ Messages';

  @override
  String get setGroupAnnouncement => 'Set Group Announcement';

  @override
  String get setNickName => 'Set Group Name Card';

  @override
  String get joinTime => 'Joined Time';

  @override
  String get myRoleInGroup => 'Role';

  @override
  String get chooseAvatar => 'Choose Avatar';

  @override
  String get friendLimit => 'The number of your contacts exceeds the limit.';

  @override
  String get otherFriendLimit => 'The number of the other user\'s contacts exceeds the limit.';

  @override
  String get inBlacklist => 'You have blocked this user.';

  @override
  String get setInBlacklist => 'You have been blocked.';

  @override
  String get forbidAddFriend => 'This user has disabled contact request.';

  @override
  String get waitAgreeFriend => 'Request sent';

  @override
  String get haveBeFriend => 'You two are already contacts of each other.';

  @override
  String get contactAddFailed => 'Failed';

  @override
  String get addGroupPermissionDeny => 'Prohibited from Joining';

  @override
  String get addGroupAlreadyMember => 'The user is a group member';

  @override
  String get addGroupNotFound => 'The group does not exist';

  @override
  String get addGroupFullMember => 'The number of group members has reached the limit';

  @override
  String get joinedTip => 'You have joined the group: ';

  @override
  String get quitGroupTip => 'Leave the group?';

  @override
  String get dismissGroupTip => 'Disband the group?';

  @override
  String get kickedOffTips => 'You have been kicked off';

  @override
  String get userSigExpiredTips => 'UserSig is expired';

  @override
  String get convertTextFailed => 'Failed to convert text';

  @override
  String get deleteFriendSuccess => 'Friend deleted successfully';

  @override
  String get deleteFriendFailed => 'Failed to delete friend';

  @override
  String get clearMsgTip => 'Are you sure you want to clear the chat history?';

  @override
  String get sendMsg => 'Send a message';

  @override
  String get groupMemberMute => 'This user is blocked from posting and thus cannot send messages. Check whether the sender is blocked from posting.';

  @override
  String get forwardFailedTip => 'Unable to forward failed messages.';

  @override
  String get fileTooLarge => 'File size exceeds the limit.';

  @override
  String get invalidApplication => 'Invalid friend application';

  @override
  String get atMeTips => 'Someone @ me';

  @override
  String get atAllTips => '@All';

  @override
  String get forwardVoteFailedTip => 'Voting messages cannot be forwarded!';

  @override
  String get forwardOneByOneLimitNumberTip => 'Unable to forward the messages one by one because there are too many messages.';

  @override
  String get modifyRemark => 'Modify remark';

  @override
  String banned(Object targetUser, Object time) {
    return '$targetUser has been banned $time';
  }

  @override
  String cancelBanned(Object targetUser) {
    return '$targetUser has been unbanned';
  }

  @override
  String get day => 'day';

  @override
  String get hour => 'hour';

  @override
  String get min => 'minute';

  @override
  String get second => 'second';

  @override
  String get setFailed => 'Failed to set';

  @override
  String get callRejectCaller => 'Call declined by user';

  @override
  String get callRejectCallee => 'Declined';

  @override
  String get callCancelCaller => 'Canceled';

  @override
  String get callCancelCallee => 'Call canceled by caller';

  @override
  String get stopCallTip => 'Duration:';

  @override
  String get callTimeoutCaller => 'Call was not answered';

  @override
  String get callTimeoutCallee => 'Call canceled by caller';

  @override
  String get callLineBusyCaller => 'Line busy';

  @override
  String get callLineBusyCallee => 'Call canceled by caller';

  @override
  String get acceptCall => 'Answered';

  @override
  String get callingSwitchToAudio => 'Switch to voice call';

  @override
  String get callingSwitchToAudioAccept => 'Confirm video to voice';

  @override
  String get invalidCommand => 'invalid command';

  @override
  String get groupCallSend => 'initiated a group call';

  @override
  String get groupCallEnd => 'End group call';

  @override
  String get groupCallNoAnswer => 'no answer';

  @override
  String get groupCallReject => ' declined call';

  @override
  String get groupCallAccept => ' answered';

  @override
  String get groupCallConfirmSwitchToAudio => ' confirm to audio call';

  @override
  String get callkitInPeerBlacklist => 'The identifier is in blacklist. Failed to send this message!';

  @override
  String get resendTips => 'Are you sure you want to resend?';

  @override
  String get logoutTip => 'Log out now?';

  @override
  String get sendFileLimit => 'You can only select 9 files';

  @override
  String get atAll => 'All';

  @override
  String get tuiEmojiSmile => '[Smile]';

  @override
  String get tuiEmojiExpect => '[Expect]';

  @override
  String get tuiEmojiBlink => '[Blink]';

  @override
  String get tuiEmojiGuffaw => '[Guffaw]';

  @override
  String get tuiEmojiKindSmile => '[Kind Smile]';

  @override
  String get tuiEmojiHaha => '[Haha]';

  @override
  String get tuiEmojiCheerful => '[Cheerful]';

  @override
  String get tuiEmojiSpeechless => '[Speechless]';

  @override
  String get tuiEmojiAmazed => '[Amazed]';

  @override
  String get tuiEmojiSorrow => '[Sorrow]';

  @override
  String get tuiEmojiComplacent => '[Complacent]';

  @override
  String get tuiEmojiSilly => '[Silly]';

  @override
  String get tuiEmojiLustful => '[Lustful]';

  @override
  String get tuiEmojiGiggle => '[Giggle]';

  @override
  String get tuiEmojiKiss => '[Kiss]';

  @override
  String get tuiEmojiWail => '[Wail]';

  @override
  String get tuiEmojiTearsLaugh => '[Tears Laugh]';

  @override
  String get tuiEmojiTrapped => '[Trapped]';

  @override
  String get tuiEmojiMask => '[Mask]';

  @override
  String get tuiEmojiFear => '[Fear]';

  @override
  String get tuiEmojiBareTeeth => '[Bare Teeth]';

  @override
  String get tuiEmojiFlareUp => '[Flare Up]';

  @override
  String get tuiEmojiYawn => '[Yawn]';

  @override
  String get tuiEmojiTact => '[Tact]';

  @override
  String get tuiEmojiStareyes => '[Stareyes]';

  @override
  String get tuiEmojiShutUp => '[Shut Up]';

  @override
  String get tuiEmojiSigh => '[Sigh]';

  @override
  String get tuiEmojiHehe => '[Hehe]';

  @override
  String get tuiEmojiSilent => '[Silent]';

  @override
  String get tuiEmojiSurprised => '[Surprised]';

  @override
  String get tuiEmojiAskance => '[Askance]';

  @override
  String get tuiEmojiOk => '[OK]';

  @override
  String get tuiEmojiShit => '[Shit]';

  @override
  String get tuiEmojiMonster => '[Monster]';

  @override
  String get tuiEmojiDaemon => '[Daemon]';

  @override
  String get tuiEmojiRage => '[Rage]';

  @override
  String get tuiEmojiFool => '[Fool]';

  @override
  String get tuiEmojiPig => '[Pig]';

  @override
  String get tuiEmojiCow => '[Cow]';

  @override
  String get tuiEmojiAi => '[AI]';

  @override
  String get tuiEmojiSkull => '[Skull]';

  @override
  String get tuiEmojiBombs => '[Bombs]';

  @override
  String get tuiEmojiCoffee => '[Coffee]';

  @override
  String get tuiEmojiCake => '[Cake]';

  @override
  String get tuiEmojiBeer => '[Beer]';

  @override
  String get tuiEmojiFlower => '[Flower]';

  @override
  String get tuiEmojiWatermelon => '[Watermelon]';

  @override
  String get tuiEmojiRich => '[Rich]';

  @override
  String get tuiEmojiHeart => '[Heart]';

  @override
  String get tuiEmojiMoon => '[Moon]';

  @override
  String get tuiEmojiSun => '[Sun]';

  @override
  String get tuiEmojiStar => '[Star]';

  @override
  String get tuiEmojiRedPacket => '[Red Packet]';

  @override
  String get tuiEmojiCelebrate => '[Celebrate]';

  @override
  String get tuiEmojiBless => '[Bless]';

  @override
  String get tuiEmojiFortune => '[Fortune]';

  @override
  String get tuiEmojiConvinced => '[Convinced]';

  @override
  String get tuiEmojiProhibit => '[Prohibit]';

  @override
  String get tuiEmoji666 => '[666]';

  @override
  String get tuiEmoji857 => '[857]';

  @override
  String get tuiEmojiKnife => '[Knife]';

  @override
  String get tuiEmojiLike => '[Like]';

  @override
  String get startConversation => 'New Chat';

  @override
  String get createGroupChat => 'Create Group Chat';

  @override
  String get createGroupTips => 'Create Group';

  @override
  String get createCommunity => 'Create Community';

  @override
  String get communityIDEditFormatTips => 'Community ID prefix must be @TGS#_ !';

  @override
  String get groupIDEditFormatTips => 'Group ID prefix cannot be @TGS# !';

  @override
  String get groupIDEditExceedTips => 'Group ID up to 48 bytes!';

  @override
  String get groupTypeContentButton => 'View product documentation';

  @override
  String get create => 'Create';

  @override
  String get groupName => 'Group Name';

  @override
  String get groupIDOption => 'Group ID (optional)';

  @override
  String get groupFaceUrl => 'Group Avatar';

  @override
  String get groupMemberSelected => 'Participants';

  @override
  String get groupWorkType => 'Friends Working group(Work)';

  @override
  String get groupPublicType => 'Stranger Social group(Public）';

  @override
  String get groupMeetingType => 'Temporary Meeting group(Meeting）';

  @override
  String get groupCommunityType => 'Community(Community)';

  @override
  String get groupWorkDesc => 'Friends work group (Work): Similar to ordinary WeChat groups, after creation, only friends who are already in the group can be invited to join the group, and there is no need for the approval of the invitee or the approval of the group owner.';

  @override
  String get groupPublicDesc => 'Stranger social group (Public): Similar to QQ group, the group owner can designate the group administrator after creation. After the user searches for the group ID and initiates a group application, the group owner or administrator must approve it before joining the group.';

  @override
  String get groupMeetingDesc => 'Temporary meeting group (Meeting): After creation, you can enter and leave at will, and support viewing of messages before joining the group; it is suitable for audio and video conference scenarios, online education scenarios, and other scenarios that are combined with real-time audio and video products.';

  @override
  String get groupCommunityDesc => 'Community(Community)：After creation, you can enter and leave at will, support up to 100,000 people, support historical message storage, and after users search for group ID and initiate a group application, they can join the group without administrator approval.';

  @override
  String get groupDetail => 'Group Chat Details';

  @override
  String get transferGroupOwner => 'Transfer Group Owner';

  @override
  String get privateGroup => 'Discussion Group';

  @override
  String get publicGroup => 'Public Group';

  @override
  String get chatRoom => 'Chatroom';

  @override
  String get communityGroup => 'Community';

  @override
  String get serverGroupInvalidReq => 'Invalid request';

  @override
  String get serverGroupReqAlreadyBeenProcessed => 'This invitation or request has been processed.';

  @override
  String inviteToGroupFrom(Object inviter) {
    return 'Invitation from $inviter';
  }

  @override
  String get applyToJoin => 'Apply to join:';

  @override
  String get requestWait => 'Invitation sent. Waiting for response.';

  @override
  String dismissGroupTips(Object groupName) {
    return 'The group you were in $groupName has been disbanded';
  }
}
