// Copyright (c) 1998-2024 Tencent, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'tencent_cloud_chat_localizations_ar.dart';
import 'tencent_cloud_chat_localizations_en.dart';
import 'tencent_cloud_chat_localizations_ja.dart';
import 'tencent_cloud_chat_localizations_ko.dart';
import 'tencent_cloud_chat_localizations_zh.dart';

/// Callers can lookup localized strings with an instance of TencentCloudChatLocalizations
/// returned by `TencentCloudChatLocalizations.of(context)`.
///
/// Applications need to include `TencentCloudChatLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localizations/tencent_cloud_chat_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: TencentCloudChatLocalizations.localizationsDelegates,
///   supportedLocales: TencentCloudChatLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the TencentCloudChatLocalizations.supportedLocales
/// property.
abstract class TencentCloudChatLocalizations {
  TencentCloudChatLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static TencentCloudChatLocalizations? of(BuildContext context) {
    return Localizations.of<TencentCloudChatLocalizations>(
        context, TencentCloudChatLocalizations);
  }

  static const LocalizationsDelegate<TencentCloudChatLocalizations> delegate =
      _TencentCloudChatLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')
  ];

  /// No description provided for @album.
  ///
  /// In en, this message translates to:
  /// **'Album'**
  String get album;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @chats.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chats;

  /// No description provided for @calls.
  ///
  /// In en, this message translates to:
  /// **'Calls'**
  String get calls;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @contacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @sendAMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get sendAMessage;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @archive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archive;

  /// No description provided for @read.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get read;

  /// No description provided for @readAll.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get readAll;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @newChat.
  ///
  /// In en, this message translates to:
  /// **'New Chat'**
  String get newChat;

  /// No description provided for @newGroup.
  ///
  /// In en, this message translates to:
  /// **'New Group'**
  String get newGroup;

  /// No description provided for @frequentlyContacted.
  ///
  /// In en, this message translates to:
  /// **'Frequently Contacted'**
  String get frequentlyContacted;

  /// No description provided for @addParticipants.
  ///
  /// In en, this message translates to:
  /// **'Add Members'**
  String get addParticipants;

  /// No description provided for @addMembers.
  ///
  /// In en, this message translates to:
  /// **'Add Members'**
  String get addMembers;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @groupID.
  ///
  /// In en, this message translates to:
  /// **'Group ID'**
  String get groupID;

  /// No description provided for @groupIDCertificate.
  ///
  /// In en, this message translates to:
  /// **'Group ID (Certificate)'**
  String get groupIDCertificate;

  /// No description provided for @groupOfType.
  ///
  /// In en, this message translates to:
  /// **'Type of Group'**
  String get groupOfType;

  /// No description provided for @typeOfGroup.
  ///
  /// In en, this message translates to:
  /// **'Type of Group'**
  String get typeOfGroup;

  /// No description provided for @work.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get work;

  /// No description provided for @public.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get public;

  /// No description provided for @meeting.
  ///
  /// In en, this message translates to:
  /// **'Meeting'**
  String get meeting;

  /// No description provided for @avChatRoom.
  ///
  /// In en, this message translates to:
  /// **'AVChatRoom'**
  String get avChatRoom;

  /// No description provided for @groupPortrait.
  ///
  /// In en, this message translates to:
  /// **'Group Portrait'**
  String get groupPortrait;

  /// No description provided for @participants.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get participants;

  /// No description provided for @seeDocs.
  ///
  /// In en, this message translates to:
  /// **'See Docs'**
  String get seeDocs;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// The current user created a group.
  ///
  /// In en, this message translates to:
  /// **'You Created Group {groupName}'**
  String youCreatedGroup(String groupName);

  /// No description provided for @groups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groups;

  /// No description provided for @chatRecord.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get chatRecord;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @noConversationsContactsOrMessagesFound.
  ///
  /// In en, this message translates to:
  /// **'No Conversations, Contacts or Messages found'**
  String get noConversationsContactsOrMessagesFound;

  /// No description provided for @contactInfo.
  ///
  /// In en, this message translates to:
  /// **'Contact Info'**
  String get contactInfo;

  /// No description provided for @exportChat.
  ///
  /// In en, this message translates to:
  /// **'Export Chat'**
  String get exportChat;

  /// No description provided for @clearChat.
  ///
  /// In en, this message translates to:
  /// **'Clear Chat'**
  String get clearChat;

  /// No description provided for @deleteChat.
  ///
  /// In en, this message translates to:
  /// **'Delete Chat'**
  String get deleteChat;

  /// No description provided for @video.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get video;

  /// No description provided for @videoCall.
  ///
  /// In en, this message translates to:
  /// **'Video Call'**
  String get videoCall;

  /// No description provided for @missedVideoCall.
  ///
  /// In en, this message translates to:
  /// **'Missed video call'**
  String get missedVideoCall;

  /// No description provided for @voice.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get voice;

  /// No description provided for @voiceCall.
  ///
  /// In en, this message translates to:
  /// **'Voice Call'**
  String get voiceCall;

  /// No description provided for @missedVoiceCall.
  ///
  /// In en, this message translates to:
  /// **'Missed voice call'**
  String get missedVoiceCall;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @youStartedACall.
  ///
  /// In en, this message translates to:
  /// **'You started a call'**
  String get youStartedACall;

  /// No description provided for @star.
  ///
  /// In en, this message translates to:
  /// **'Star'**
  String get star;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @forward.
  ///
  /// In en, this message translates to:
  /// **'Forward'**
  String get forward;

  /// No description provided for @multiSelect.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get multiSelect;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @quote.
  ///
  /// In en, this message translates to:
  /// **'Quote'**
  String get quote;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @tapToRemove.
  ///
  /// In en, this message translates to:
  /// **'Tap to Remove'**
  String get tapToRemove;

  /// No description provided for @messageInfo.
  ///
  /// In en, this message translates to:
  /// **'Message Info'**
  String get messageInfo;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @readBy.
  ///
  /// In en, this message translates to:
  /// **'Read By'**
  String get readBy;

  /// No description provided for @deliveredTo.
  ///
  /// In en, this message translates to:
  /// **'Delivered To'**
  String get deliveredTo;

  /// The number of messages select
  ///
  /// In en, this message translates to:
  /// **'{num, plural, zero {Select Messages} other {{num} Selected}}'**
  String numSelect(int num);

  /// The number of selected chats
  ///
  /// In en, this message translates to:
  /// **'{num, plural, zero {No Chat Selected} one {1 Chat} other {{num} Chats}}'**
  String numChats(int num);

  /// No description provided for @recentChats.
  ///
  /// In en, this message translates to:
  /// **'Recent Chats'**
  String get recentChats;

  /// The number of Thread Quotes
  ///
  /// In en, this message translates to:
  /// **'{num, plural, one {{num} Thread Quote} other {{num} Thread Quotes}}'**
  String numThreadQuote(int num);

  /// No description provided for @swipeLeftToCancelOrReleaseToSend.
  ///
  /// In en, this message translates to:
  /// **'Swipe left to cancel or release to send'**
  String get swipeLeftToCancelOrReleaseToSend;

  /// No description provided for @releaseToCancel.
  ///
  /// In en, this message translates to:
  /// **'Release to Cancel'**
  String get releaseToCancel;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @document.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get document;

  /// No description provided for @file.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get file;

  /// No description provided for @photos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photos;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @doNotDisturb.
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get doNotDisturb;

  /// No description provided for @mute.
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get mute;

  /// No description provided for @topChat.
  ///
  /// In en, this message translates to:
  /// **'Pin'**
  String get topChat;

  /// No description provided for @pin.
  ///
  /// In en, this message translates to:
  /// **'Pin'**
  String get pin;

  /// No description provided for @blackUser.
  ///
  /// In en, this message translates to:
  /// **'Block User'**
  String get blackUser;

  /// No description provided for @blockUser.
  ///
  /// In en, this message translates to:
  /// **'Block User'**
  String get blockUser;

  /// No description provided for @saveContact.
  ///
  /// In en, this message translates to:
  /// **'Save Contact'**
  String get saveContact;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @clearingChatHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear Messages'**
  String get clearingChatHistory;

  /// No description provided for @clearMessages.
  ///
  /// In en, this message translates to:
  /// **'Clear Messages'**
  String get clearMessages;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @groupNotice.
  ///
  /// In en, this message translates to:
  /// **'Group Notice'**
  String get groupNotice;

  /// No description provided for @groupOfAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'Group Notice'**
  String get groupOfAnnouncement;

  /// No description provided for @groupManagement.
  ///
  /// In en, this message translates to:
  /// **'Manage Group'**
  String get groupManagement;

  /// No description provided for @groupType.
  ///
  /// In en, this message translates to:
  /// **'Group Type'**
  String get groupType;

  /// No description provided for @addGroupWay.
  ///
  /// In en, this message translates to:
  /// **'Add Group Way'**
  String get addGroupWay;

  /// No description provided for @myAliasInGroup.
  ///
  /// In en, this message translates to:
  /// **'My Alias in Group'**
  String get myAliasInGroup;

  /// No description provided for @myGroupNickName.
  ///
  /// In en, this message translates to:
  /// **'My Alias in Group'**
  String get myGroupNickName;

  /// No description provided for @groupMembers.
  ///
  /// In en, this message translates to:
  /// **'Group Members'**
  String get groupMembers;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// The number of Admin
  ///
  /// In en, this message translates to:
  /// **'Admin ({num})'**
  String adminNum(int num);

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @setAsAdmin.
  ///
  /// In en, this message translates to:
  /// **'Set as Admin'**
  String get setAsAdmin;

  /// No description provided for @announcement.
  ///
  /// In en, this message translates to:
  /// **'Group Notice'**
  String get announcement;

  /// No description provided for @totalSilence.
  ///
  /// In en, this message translates to:
  /// **'Silence All'**
  String get totalSilence;

  /// No description provided for @silenceAll.
  ///
  /// In en, this message translates to:
  /// **'Silence All'**
  String get silenceAll;

  /// No description provided for @addSilencedMember.
  ///
  /// In en, this message translates to:
  /// **'Add Silenced Member'**
  String get addSilencedMember;

  /// No description provided for @onlyGroupOwnerAndAdminsCanSendMessages.
  ///
  /// In en, this message translates to:
  /// **'After enabling, only the group owner and admins can send messages.'**
  String get onlyGroupOwnerAndAdminsCanSendMessages;

  /// Someone Enabled Silence All
  ///
  /// In en, this message translates to:
  /// **'{name} enabled \'Silence All\''**
  String someoneEnabledSilenceAll(String name);

  /// Someone Disabled Silence All
  ///
  /// In en, this message translates to:
  /// **'{name} disabled \'Silence All\''**
  String someoneDisabledSilenceAll(String name);

  /// No description provided for @newContacts.
  ///
  /// In en, this message translates to:
  /// **'New Contacts'**
  String get newContacts;

  /// No description provided for @myGroup.
  ///
  /// In en, this message translates to:
  /// **'My Groups'**
  String get myGroup;

  /// No description provided for @theBlackList.
  ///
  /// In en, this message translates to:
  /// **'Block List'**
  String get theBlackList;

  /// No description provided for @blockList.
  ///
  /// In en, this message translates to:
  /// **'Blocked Users'**
  String get blockList;

  /// No description provided for @groupChatNotifications.
  ///
  /// In en, this message translates to:
  /// **'Group Chat Notifications'**
  String get groupChatNotifications;

  /// No description provided for @userID.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get userID;

  /// My User ID
  ///
  /// In en, this message translates to:
  /// **'My User ID: {userID}'**
  String myUserID(String userID);

  /// No description provided for @searchUserID.
  ///
  /// In en, this message translates to:
  /// **'SearchUserID'**
  String get searchUserID;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// User ID
  ///
  /// In en, this message translates to:
  /// **'ID: {userID}'**
  String iDis(String userID);

  /// No description provided for @addToContacts.
  ///
  /// In en, this message translates to:
  /// **'Add to Contacts'**
  String get addToContacts;

  /// No description provided for @addContact.
  ///
  /// In en, this message translates to:
  /// **'Add Contact'**
  String get addContact;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// Bio:
  ///
  /// In en, this message translates to:
  /// **'Bio: {bio}'**
  String bioIs(String bio);

  /// No description provided for @fillInTheVerificationInformation.
  ///
  /// In en, this message translates to:
  /// **'Send Request'**
  String get fillInTheVerificationInformation;

  /// No description provided for @remarkAndGrouping.
  ///
  /// In en, this message translates to:
  /// **'Remark and Grouping'**
  String get remarkAndGrouping;

  /// No description provided for @remark.
  ///
  /// In en, this message translates to:
  /// **'Remark'**
  String get remark;

  /// No description provided for @group.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get group;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @contactAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Contact Added Successfully'**
  String get contactAddedSuccessfully;

  /// No description provided for @requestSent.
  ///
  /// In en, this message translates to:
  /// **'Request Sent'**
  String get requestSent;

  /// No description provided for @cannotAddContact.
  ///
  /// In en, this message translates to:
  /// **'Cannot Add Contact'**
  String get cannotAddContact;

  /// No description provided for @addGroup.
  ///
  /// In en, this message translates to:
  /// **'Add Group'**
  String get addGroup;

  /// Type:
  ///
  /// In en, this message translates to:
  /// **'Type: {type}'**
  String typeIs(String type);

  /// No description provided for @groupNotAcceptingRequests.
  ///
  /// In en, this message translates to:
  /// **'Group Not Accepting Requests'**
  String get groupNotAcceptingRequests;

  /// No description provided for @joinedGroupSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Joined Group Successfully'**
  String get joinedGroupSuccessfully;

  /// numNewApplications
  ///
  /// In en, this message translates to:
  /// **'{num, plural, one {{num} New Application} other {{num} New Applications}}'**
  String numNewApplications(int num);

  /// No description provided for @agree.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get agree;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @refuse.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get refuse;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @verificationMessage.
  ///
  /// In en, this message translates to:
  /// **'Verification Message'**
  String get verificationMessage;

  /// No description provided for @accepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get accepted;

  /// No description provided for @declined.
  ///
  /// In en, this message translates to:
  /// **'Declined'**
  String get declined;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @contactRequest.
  ///
  /// In en, this message translates to:
  /// **'Contact Request'**
  String get contactRequest;

  /// No description provided for @contactsPermission.
  ///
  /// In en, this message translates to:
  /// **'Contacts Permission'**
  String get contactsPermission;

  /// No description provided for @allowAnyUserAddYouAsContact.
  ///
  /// In en, this message translates to:
  /// **'Allow Anyone to Add You as a Contact'**
  String get allowAnyUserAddYouAsContact;

  /// No description provided for @declineContactRequestFromAnyUser.
  ///
  /// In en, this message translates to:
  /// **'Auto Decline Contact Requests'**
  String get declineContactRequestFromAnyUser;

  /// No description provided for @anyoneUponRequest.
  ///
  /// In en, this message translates to:
  /// **'Accept Requests Manually'**
  String get anyoneUponRequest;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @aboutTencentCloudChat.
  ///
  /// In en, this message translates to:
  /// **'About Tencent Cloud Chat'**
  String get aboutTencentCloudChat;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @signature.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get signature;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @birthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get birthday;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @unspecified.
  ///
  /// In en, this message translates to:
  /// **'Unspecified'**
  String get unspecified;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @sdkVersion.
  ///
  /// In en, this message translates to:
  /// **'SDK Version'**
  String get sdkVersion;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @userAgreement.
  ///
  /// In en, this message translates to:
  /// **'User Agreement'**
  String get userAgreement;

  /// No description provided for @disclaimer.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer'**
  String get disclaimer;

  /// No description provided for @personalInformationCollected.
  ///
  /// In en, this message translates to:
  /// **'Personal Information Collected'**
  String get personalInformationCollected;

  /// No description provided for @informationSharedWithThirdParties.
  ///
  /// In en, this message translates to:
  /// **'Information Shared with Third Parties'**
  String get informationSharedWithThirdParties;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @countryOrRegion.
  ///
  /// In en, this message translates to:
  /// **'Country / Region'**
  String get countryOrRegion;

  /// No description provided for @selectACountry.
  ///
  /// In en, this message translates to:
  /// **'Select a Country or Region'**
  String get selectACountry;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'EMail'**
  String get email;

  /// No description provided for @verificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verificationCode;

  /// No description provided for @enterSMSCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent via SMS'**
  String get enterSMSCode;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get sendCode;

  /// No description provided for @visitOurWebsite.
  ///
  /// In en, this message translates to:
  /// **'Visit Our Website'**
  String get visitOurWebsite;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @simplifiedChinese.
  ///
  /// In en, this message translates to:
  /// **'简体中文'**
  String get simplifiedChinese;

  /// No description provided for @traditionalChinese.
  ///
  /// In en, this message translates to:
  /// **'繁體中文'**
  String get traditionalChinese;

  /// No description provided for @japanese.
  ///
  /// In en, this message translates to:
  /// **'日本語'**
  String get japanese;

  /// No description provided for @korean.
  ///
  /// In en, this message translates to:
  /// **'한국어'**
  String get korean;

  /// No description provided for @style.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get style;

  /// No description provided for @classic.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get classic;

  /// No description provided for @minimalist.
  ///
  /// In en, this message translates to:
  /// **'Minimalist'**
  String get minimalist;

  /// No description provided for @messageReadStatus.
  ///
  /// In en, this message translates to:
  /// **'Message Read Status'**
  String get messageReadStatus;

  /// No description provided for @messageReadStatusDescription.
  ///
  /// In en, this message translates to:
  /// **'Controls whether the read status is displayed for your messages and if others can see whether you\'ve read their messages.'**
  String get messageReadStatusDescription;

  /// No description provided for @onlineStatus.
  ///
  /// In en, this message translates to:
  /// **'Online Status'**
  String get onlineStatus;

  /// No description provided for @onlineStatusDescription.
  ///
  /// In en, this message translates to:
  /// **'Determines if your online status is visible to your contacts.'**
  String get onlineStatusDescription;

  /// No description provided for @noBio.
  ///
  /// In en, this message translates to:
  /// **'No Bio'**
  String get noBio;

  /// No description provided for @noConversation.
  ///
  /// In en, this message translates to:
  /// **'No Conversation'**
  String get noConversation;

  /// No description provided for @sound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// No description provided for @sticker.
  ///
  /// In en, this message translates to:
  /// **'Sticker'**
  String get sticker;

  /// No description provided for @image.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get image;

  /// No description provided for @chatHistory.
  ///
  /// In en, this message translates to:
  /// **'Chat History'**
  String get chatHistory;

  /// No description provided for @audio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get audio;

  /// No description provided for @messageDeleted.
  ///
  /// In en, this message translates to:
  /// **'Message Deleted'**
  String get messageDeleted;

  /// No description provided for @messageRecalled.
  ///
  /// In en, this message translates to:
  /// **'Message Recalled'**
  String get messageRecalled;

  /// The number of Unread Messages
  ///
  /// In en, this message translates to:
  /// **'{num, plural, one {{num} Unread Message} other {{num} Unread Messages}}'**
  String unreadCount(int num);

  /// The number of New Messages
  ///
  /// In en, this message translates to:
  /// **'{num, plural, one {A New Message} other {{num} New Messages}}'**
  String newMsgCount(int num);

  /// No description provided for @takeAPhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takeAPhoto;

  /// No description provided for @recordAVideo.
  ///
  /// In en, this message translates to:
  /// **'Record a video'**
  String get recordAVideo;

  /// No description provided for @pullDownToLoadMoreMessages.
  ///
  /// In en, this message translates to:
  /// **'Pull down to load more messages'**
  String get pullDownToLoadMoreMessages;

  /// No description provided for @releaseToLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Release to load more'**
  String get releaseToLoadMore;

  /// No description provided for @noMoreMessage.
  ///
  /// In en, this message translates to:
  /// **'No more message'**
  String get noMoreMessage;

  /// No description provided for @pullUpToLoadMoreMessages.
  ///
  /// In en, this message translates to:
  /// **'Pull up to load more messages'**
  String get pullUpToLoadMoreMessages;

  /// No description provided for @holdToRecordReleaseToSend.
  ///
  /// In en, this message translates to:
  /// **'Hold to record, release to send'**
  String get holdToRecordReleaseToSend;

  /// No description provided for @forwardIndividually.
  ///
  /// In en, this message translates to:
  /// **'Forward Individually'**
  String get forwardIndividually;

  /// No description provided for @forwardCombined.
  ///
  /// In en, this message translates to:
  /// **'Forward Combined'**
  String get forwardCombined;

  /// No description provided for @selectConversations.
  ///
  /// In en, this message translates to:
  /// **'Select Conversations'**
  String get selectConversations;

  /// No description provided for @recent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recent;

  /// No description provided for @recall.
  ///
  /// In en, this message translates to:
  /// **'Recall'**
  String get recall;

  /// Reply to a message.
  ///
  /// In en, this message translates to:
  /// **'Reply to {name}'**
  String replyTo(String name);

  /// No description provided for @confirmDeletion.
  ///
  /// In en, this message translates to:
  /// **'Confirm Deletion'**
  String get confirmDeletion;

  /// No description provided for @deleteForEveryone.
  ///
  /// In en, this message translates to:
  /// **'Delete for everyone'**
  String get deleteForEveryone;

  /// No description provided for @deleteForMe.
  ///
  /// In en, this message translates to:
  /// **'Delete for me'**
  String get deleteForMe;

  /// No description provided for @askDeleteThisMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete this message?'**
  String get askDeleteThisMessage;

  /// The number of deletion Messages
  ///
  /// In en, this message translates to:
  /// **'{num, plural, zero {No message been deleted} one {Delete a message?} other {Delete {num} messages?}}'**
  String deleteMessageCount(int num);

  /// The number of message read members
  ///
  /// In en, this message translates to:
  /// **'{num, plural, zero {No member read} one {1 member read} other {{num} members read}}'**
  String memberReadCount(int num);

  /// No description provided for @allMembersRead.
  ///
  /// In en, this message translates to:
  /// **'All members read'**
  String get allMembersRead;

  /// No description provided for @allowAny.
  ///
  /// In en, this message translates to:
  /// **'Allow Any'**
  String get allowAny;

  /// No description provided for @cannotSendApplicationToWorkGroup.
  ///
  /// In en, this message translates to:
  /// **'Cannot send application to work group'**
  String get cannotSendApplicationToWorkGroup;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @denyAny.
  ///
  /// In en, this message translates to:
  /// **'Deny Any'**
  String get denyAny;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @friendsPermission.
  ///
  /// In en, this message translates to:
  /// **'Friends Permission'**
  String get friendsPermission;

  /// No description provided for @groupJoined.
  ///
  /// In en, this message translates to:
  /// **'Group Joined'**
  String get groupJoined;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @noBlockList.
  ///
  /// In en, this message translates to:
  /// **'No blocked users'**
  String get noBlockList;

  /// No description provided for @noContact.
  ///
  /// In en, this message translates to:
  /// **'No contacts'**
  String get noContact;

  /// No description provided for @noNewApplication.
  ///
  /// In en, this message translates to:
  /// **'No new application'**
  String get noNewApplication;

  /// No description provided for @permissionNeeded.
  ///
  /// In en, this message translates to:
  /// **'Permission needed'**
  String get permissionNeeded;

  /// No description provided for @requireRequest.
  ///
  /// In en, this message translates to:
  /// **'Required request'**
  String get requireRequest;

  /// No description provided for @setNickname.
  ///
  /// In en, this message translates to:
  /// **'Set nickname'**
  String get setNickname;

  /// No description provided for @setSignature.
  ///
  /// In en, this message translates to:
  /// **'Set signature'**
  String get setSignature;

  /// No description provided for @validationMessages.
  ///
  /// In en, this message translates to:
  /// **'Validation Messages'**
  String get validationMessages;

  /// No description provided for @getVerification.
  ///
  /// In en, this message translates to:
  /// **'Get verification'**
  String get getVerification;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid Email'**
  String get invalidEmail;

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalidPhoneNumber;

  /// No description provided for @invalidVerification.
  ///
  /// In en, this message translates to:
  /// **'Invalid verification'**
  String get invalidVerification;

  /// No description provided for @searchGroupID.
  ///
  /// In en, this message translates to:
  /// **'Search Group ID'**
  String get searchGroupID;

  /// No description provided for @callInitiated.
  ///
  /// In en, this message translates to:
  /// **'Call initiated'**
  String get callInitiated;

  /// No description provided for @callAccepted.
  ///
  /// In en, this message translates to:
  /// **'Call accepted'**
  String get callAccepted;

  /// No description provided for @callDeclined.
  ///
  /// In en, this message translates to:
  /// **'Call declined'**
  String get callDeclined;

  /// No description provided for @noAnswer.
  ///
  /// In en, this message translates to:
  /// **'No answer'**
  String get noAnswer;

  /// No description provided for @lineBusy.
  ///
  /// In en, this message translates to:
  /// **'Line busy'**
  String get lineBusy;

  /// No description provided for @callHungUp.
  ///
  /// In en, this message translates to:
  /// **'Call hung up'**
  String get callHungUp;

  /// No description provided for @callInProgress.
  ///
  /// In en, this message translates to:
  /// **'Call in progress'**
  String get callInProgress;

  /// No description provided for @callEnded.
  ///
  /// In en, this message translates to:
  /// **'Call ended'**
  String get callEnded;

  /// No description provided for @unknownCallStatus.
  ///
  /// In en, this message translates to:
  /// **'Calling'**
  String get unknownCallStatus;

  /// No description provided for @groupChatCreated.
  ///
  /// In en, this message translates to:
  /// **'Group chat created successfully!'**
  String get groupChatCreated;

  /// No description provided for @vote.
  ///
  /// In en, this message translates to:
  /// **'Vote'**
  String get vote;

  /// No description provided for @callCancelled.
  ///
  /// In en, this message translates to:
  /// **'Call cancelled'**
  String get callCancelled;

  /// No description provided for @unknownGroupTips.
  ///
  /// In en, this message translates to:
  /// **'Unknown group tips'**
  String get unknownGroupTips;

  /// No description provided for @memberJoinedGroup.
  ///
  /// In en, this message translates to:
  /// **'{members} has joined the group'**
  String memberJoinedGroup(Object members);

  /// No description provided for @opInvitedToGroup.
  ///
  /// In en, this message translates to:
  /// **'{opMember} invited {members} to the group'**
  String opInvitedToGroup(Object members, Object opMember);

  /// No description provided for @memberLeftGroup.
  ///
  /// In en, this message translates to:
  /// **'{members} left the group'**
  String memberLeftGroup(Object members);

  /// No description provided for @opRemovedFromGroup.
  ///
  /// In en, this message translates to:
  /// **'{opMember} removed {members} from the group'**
  String opRemovedFromGroup(Object members, Object opMember);

  /// No description provided for @opPromotedToAdmin.
  ///
  /// In en, this message translates to:
  /// **'{opMember} promoted {members} to admin'**
  String opPromotedToAdmin(Object members, Object opMember);

  /// No description provided for @opRevokedAdmin.
  ///
  /// In en, this message translates to:
  /// **'{opMember} revoked admin role from {members}'**
  String opRevokedAdmin(Object members, Object opMember);

  /// No description provided for @opChangedGroupInfo.
  ///
  /// In en, this message translates to:
  /// **'{opMember} changed {groupInfo}'**
  String opChangedGroupInfo(Object groupInfo, Object opMember);

  /// No description provided for @opChangedMemberInfo.
  ///
  /// In en, this message translates to:
  /// **'{opMember} changed {memberInfo}'**
  String opChangedMemberInfo(Object memberInfo, Object opMember);

  /// No description provided for @changedGroupNameTo.
  ///
  /// In en, this message translates to:
  /// **'Changed group name to {name}'**
  String changedGroupNameTo(Object name);

  /// No description provided for @changedGroupDescriptionTo.
  ///
  /// In en, this message translates to:
  /// **'Changed group description to {description}'**
  String changedGroupDescriptionTo(Object description);

  /// No description provided for @changedGroupAnnouncementTo.
  ///
  /// In en, this message translates to:
  /// **'Changed group announcement to {announcement}'**
  String changedGroupAnnouncementTo(Object announcement);

  /// No description provided for @changedGroupAvatar.
  ///
  /// In en, this message translates to:
  /// **'Changed group avatar'**
  String get changedGroupAvatar;

  /// No description provided for @transferredGroupOwnershipTo.
  ///
  /// In en, this message translates to:
  /// **'Transferred group ownership to {owner}'**
  String transferredGroupOwnershipTo(Object owner);

  /// No description provided for @changedGroupCustomInfo.
  ///
  /// In en, this message translates to:
  /// **'Changed group custom info'**
  String get changedGroupCustomInfo;

  /// No description provided for @enabledGroupMute.
  ///
  /// In en, this message translates to:
  /// **'Enabled group-wide mute'**
  String get enabledGroupMute;

  /// No description provided for @disabledGroupMute.
  ///
  /// In en, this message translates to:
  /// **'Disabled group-wide mute'**
  String get disabledGroupMute;

  /// No description provided for @changedGroupMessageReceptionTo.
  ///
  /// In en, this message translates to:
  /// **'Changed group message reception setting to: {setting}'**
  String changedGroupMessageReceptionTo(Object setting);

  /// No description provided for @changedApplyToJoinGroupTo.
  ///
  /// In en, this message translates to:
  /// **'Changed apply to join group setting to: {setting}'**
  String changedApplyToJoinGroupTo(Object setting);

  /// No description provided for @changedInviteToJoinGroupTo.
  ///
  /// In en, this message translates to:
  /// **'Changed invite to join group setting to: {setting}'**
  String changedInviteToJoinGroupTo(Object setting);

  /// No description provided for @opUnmuted.
  ///
  /// In en, this message translates to:
  /// **'{user} Unmuted'**
  String opUnmuted(Object user);

  /// No description provided for @opMuted.
  ///
  /// In en, this message translates to:
  /// **'{user} Muted for {duration} seconds'**
  String opMuted(Object duration, Object user);

  /// No description provided for @groupTips.
  ///
  /// In en, this message translates to:
  /// **'Group Tips'**
  String get groupTips;

  /// No description provided for @receiveMessages.
  ///
  /// In en, this message translates to:
  /// **'Receive messages'**
  String get receiveMessages;

  /// No description provided for @doNotReceiveMessages.
  ///
  /// In en, this message translates to:
  /// **'Do not receive messages'**
  String get doNotReceiveMessages;

  /// No description provided for @receiveMessagesWhenOnlineOnly.
  ///
  /// In en, this message translates to:
  /// **'Receive messages when online only'**
  String get receiveMessagesWhenOnlineOnly;

  /// No description provided for @disallowJoinGroup.
  ///
  /// In en, this message translates to:
  /// **'Disallow applying to join group'**
  String get disallowJoinGroup;

  /// No description provided for @joinGroupNeedApproval.
  ///
  /// In en, this message translates to:
  /// **'Require admin approval for applying to join group'**
  String get joinGroupNeedApproval;

  /// No description provided for @joinGroupDirectly.
  ///
  /// In en, this message translates to:
  /// **'Join group directly after applying'**
  String get joinGroupDirectly;

  /// No description provided for @disallowInviting.
  ///
  /// In en, this message translates to:
  /// **'Disallow inviting to join group'**
  String get disallowInviting;

  /// No description provided for @requireApprovalForInviting.
  ///
  /// In en, this message translates to:
  /// **'Require admin approval for inviting to join group'**
  String get requireApprovalForInviting;

  /// No description provided for @joinDirectlyBeenInvited.
  ///
  /// In en, this message translates to:
  /// **'Join group directly after being invited'**
  String get joinDirectlyBeenInvited;

  /// No description provided for @unmuted.
  ///
  /// In en, this message translates to:
  /// **'Unmuted'**
  String get unmuted;

  /// No description provided for @muteTime.
  ///
  /// In en, this message translates to:
  /// **'Muted for {duration} seconds'**
  String muteTime(Object duration);

  /// No description provided for @poll.
  ///
  /// In en, this message translates to:
  /// **'Poll'**
  String get poll;

  /// No description provided for @callDuration.
  ///
  /// In en, this message translates to:
  /// **'Call duration: {duration}'**
  String callDuration(Object duration);

  /// No description provided for @selectMembers.
  ///
  /// In en, this message translates to:
  /// **'Select Members'**
  String get selectMembers;

  /// The number of members select
  ///
  /// In en, this message translates to:
  /// **'{num, plural, zero {Select Members} other {{num} Selected}}'**
  String numSelectMembers(int num);

  /// No description provided for @searchMembers.
  ///
  /// In en, this message translates to:
  /// **'Search Members'**
  String get searchMembers;

  /// No description provided for @startCall.
  ///
  /// In en, this message translates to:
  /// **'Start Call'**
  String get startCall;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @groupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{name} and {count} others'**
  String groupSubtitle(Object count, Object name);

  /// No description provided for @markAsUnread.
  ///
  /// In en, this message translates to:
  /// **'Mark as Unread'**
  String get markAsUnread;

  /// No description provided for @hide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get hide;

  /// No description provided for @unreadMessagesBelow.
  ///
  /// In en, this message translates to:
  /// **'Unread Messages Below'**
  String get unreadMessagesBelow;

  /// No description provided for @ar.
  ///
  /// In en, this message translates to:
  /// **'اَلْعَرَبِيَّةُ'**
  String get ar;

  /// No description provided for @tencentCloudChat.
  ///
  /// In en, this message translates to:
  /// **'Tencent Cloud Chat'**
  String get tencentCloudChat;

  /// No description provided for @changeTheme.
  ///
  /// In en, this message translates to:
  /// **'Change appearance'**
  String get changeTheme;

  /// No description provided for @deleteAccountNotification.
  ///
  /// In en, this message translates to:
  /// **'After deleted account, you will not be able to use your current account, and related data will be deleted and cannot be retrieved.'**
  String get deleteAccountNotification;

  /// No description provided for @restartAppForLanguage.
  ///
  /// In en, this message translates to:
  /// **'Please restart the app for the language change to take effect'**
  String get restartAppForLanguage;

  /// No description provided for @deleteAllMessages.
  ///
  /// In en, this message translates to:
  /// **'Delete All Messages'**
  String get deleteAllMessages;

  /// No description provided for @downloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading...'**
  String get downloading;

  /// No description provided for @viewFullImage.
  ///
  /// In en, this message translates to:
  /// **'View Full Image'**
  String get viewFullImage;

  /// No description provided for @messageRecall.
  ///
  /// In en, this message translates to:
  /// **'Message Recall'**
  String get messageRecall;

  /// No description provided for @messageRecallConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to recall this message?'**
  String get messageRecallConfirmation;

  /// No description provided for @quit.
  ///
  /// In en, this message translates to:
  /// **'Quit'**
  String get quit;

  /// No description provided for @quitAndDelete.
  ///
  /// In en, this message translates to:
  /// **'Quit and Delete'**
  String get quitAndDelete;

  /// No description provided for @setGroupName.
  ///
  /// In en, this message translates to:
  /// **'set Group Name'**
  String get setGroupName;

  /// No description provided for @groupAddAny.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get groupAddAny;

  /// No description provided for @groupAddAuth.
  ///
  /// In en, this message translates to:
  /// **'Need Approve'**
  String get groupAddAuth;

  /// No description provided for @groupAddForbid.
  ///
  /// In en, this message translates to:
  /// **'Forbidden'**
  String get groupAddForbid;

  /// No description provided for @groupOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get groupOwner;

  /// No description provided for @groupMember.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get groupMember;

  /// No description provided for @dismissAdmin.
  ///
  /// In en, this message translates to:
  /// **'Dismiss Admin'**
  String get dismissAdmin;

  /// No description provided for @welcomeToTencentCloudChat.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Tencent Cloud Chat'**
  String get welcomeToTencentCloudChat;

  /// No description provided for @draft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get draft;

  /// Label for a button that opens a media resource in a new window
  ///
  /// In en, this message translates to:
  /// **'Open in New Window'**
  String get openInNewWindow;

  /// No description provided for @selectAChat.
  ///
  /// In en, this message translates to:
  /// **'Select a Chat'**
  String get selectAChat;

  /// No description provided for @noConversationSelected.
  ///
  /// In en, this message translates to:
  /// **'No conversation selected'**
  String get noConversationSelected;

  /// No description provided for @unavailableToSendMessage.
  ///
  /// In en, this message translates to:
  /// **'Unavailable to Send Message'**
  String get unavailableToSendMessage;

  /// No description provided for @noSuchGroup.
  ///
  /// In en, this message translates to:
  /// **'No such group'**
  String get noSuchGroup;

  /// No description provided for @notGroupMember.
  ///
  /// In en, this message translates to:
  /// **'Not a group member'**
  String get notGroupMember;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get userNotFound;

  /// No description provided for @userBlockedYou.
  ///
  /// In en, this message translates to:
  /// **'User blocked you'**
  String get userBlockedYou;

  /// No description provided for @muted.
  ///
  /// In en, this message translates to:
  /// **'Muted'**
  String get muted;

  /// No description provided for @groupMuted.
  ///
  /// In en, this message translates to:
  /// **'Group muted'**
  String get groupMuted;

  /// No description provided for @cantSendMessage.
  ///
  /// In en, this message translates to:
  /// **'Can\'t send message'**
  String get cantSendMessage;

  /// No description provided for @media.
  ///
  /// In en, this message translates to:
  /// **'Media'**
  String get media;

  /// Send to specific chat
  ///
  /// In en, this message translates to:
  /// **'Send to {name}'**
  String sendToSomeChat(String name);

  /// No description provided for @unableToSendWithFolders.
  ///
  /// In en, this message translates to:
  /// **'Unable to send files because folders are included. Please select individual files only.'**
  String get unableToSendWithFolders;

  /// No description provided for @channelSwitch.
  ///
  /// In en, this message translates to:
  /// **'Channel: '**
  String get channelSwitch;

  /// No description provided for @weChat.
  ///
  /// In en, this message translates to:
  /// **'WeChat'**
  String get weChat;

  /// No description provided for @tGWA.
  ///
  /// In en, this message translates to:
  /// **'Telegram & WhatsApp'**
  String get tGWA;

  /// No description provided for @contactUsIfQuestions.
  ///
  /// In en, this message translates to:
  /// **'If there\'s anything unclear or you have more ideas, feel free to contact us!'**
  String get contactUsIfQuestions;

  /// No description provided for @chatNow.
  ///
  /// In en, this message translates to:
  /// **'Chat Now'**
  String get chatNow;

  /// No description provided for @onlineServiceTimeFrom10To20.
  ///
  /// In en, this message translates to:
  /// **'Online time: 10 AM to 8 PM, Mon through Fri'**
  String get onlineServiceTimeFrom10To20;

  /// No description provided for @officialWebsite.
  ///
  /// In en, this message translates to:
  /// **'Official Website'**
  String get officialWebsite;

  /// No description provided for @allSDKs.
  ///
  /// In en, this message translates to:
  /// **'All SDKs'**
  String get allSDKs;

  /// No description provided for @sourceCode.
  ///
  /// In en, this message translates to:
  /// **'Source Code'**
  String get sourceCode;

  /// No description provided for @personalInformationCollectionList.
  ///
  /// In en, this message translates to:
  /// **'Personal information collection list'**
  String get personalInformationCollectionList;

  /// No description provided for @thirdPartyInformationSharingList.
  ///
  /// In en, this message translates to:
  /// **'Third-party information sharing list'**
  String get thirdPartyInformationSharingList;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @me.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get me;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @unpin.
  ///
  /// In en, this message translates to:
  /// **'Unpin'**
  String get unpin;

  /// No description provided for @mentionedMessages.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1 {1 Message Mentioned Me} other {{count} Messages Mentioned Me}}'**
  String mentionedMessages(num count);
}

class _TencentCloudChatLocalizationsDelegate
    extends LocalizationsDelegate<TencentCloudChatLocalizations> {
  const _TencentCloudChatLocalizationsDelegate();

  @override
  Future<TencentCloudChatLocalizations> load(Locale locale) {
    return SynchronousFuture<TencentCloudChatLocalizations>(
        lookupTencentCloudChatLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'ja', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_TencentCloudChatLocalizationsDelegate old) => false;
}

TencentCloudChatLocalizations lookupTencentCloudChatLocalizations(
    Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return TencentCloudChatLocalizationsZhHans();
          case 'Hant':
            return TencentCloudChatLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return TencentCloudChatLocalizationsAr();
    case 'en':
      return TencentCloudChatLocalizationsEn();
    case 'ja':
      return TencentCloudChatLocalizationsJa();
    case 'ko':
      return TencentCloudChatLocalizationsKo();
    case 'zh':
      return TencentCloudChatLocalizationsZh();
  }

  throw FlutterError(
      'TencentCloudChatLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
