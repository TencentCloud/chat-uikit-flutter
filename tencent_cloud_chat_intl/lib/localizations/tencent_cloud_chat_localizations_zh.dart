// Copyright (c) 1998-2024 Tencent, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:intl/intl.dart' as intl;

import 'tencent_cloud_chat_localizations.dart';

/// The translations for Chinese (`zh`).
class TencentCloudChatLocalizationsZh extends TencentCloudChatLocalizations {
  TencentCloudChatLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get album => '相册';

  @override
  String get chat => '聊天';

  @override
  String get chats => '聊天';

  @override
  String get calls => '通话';

  @override
  String get search => '搜索';

  @override
  String get contacts => '联系人';

  @override
  String get settings => '设置';

  @override
  String get online => '在线';

  @override
  String get offline => '离线';

  @override
  String get sendAMessage => '发送消息';

  @override
  String get done => '完成';

  @override
  String get archive => '归档';

  @override
  String get read => '已读';

  @override
  String get readAll => '全部已读';

  @override
  String get delete => '删除';

  @override
  String get newChat => '新聊天';

  @override
  String get newGroup => '新建群组';

  @override
  String get frequentlyContacted => '常联系人';

  @override
  String get addParticipants => '添加成员';

  @override
  String get addMembers => '添加成员';

  @override
  String get cancel => '取消';

  @override
  String get next => '下一步';

  @override
  String get back => '返回';

  @override
  String get groupID => '群组ID';

  @override
  String get groupIDCertificate => '群组ID（证书）';

  @override
  String get groupOfType => '群组类型';

  @override
  String get typeOfGroup => '群组类型';

  @override
  String get work => '工作';

  @override
  String get public => '公开';

  @override
  String get meeting => '会议';

  @override
  String get avChatRoom => '音视频聊天室';

  @override
  String get groupPortrait => '群组头像';

  @override
  String get participants => '参与者';

  @override
  String get seeDocs => '查看文档';

  @override
  String get you => '你';

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String youCreatedGroup(String groupName) {
    return '您创建了群组 $groupName';
  }

  @override
  String get groups => '群组';

  @override
  String get chatRecord => '消息记录';

  @override
  String get messages => '消息';

  @override
  String get more => '更多';

  @override
  String get noConversationsContactsOrMessagesFound => '未找到对话、联系人或消息';

  @override
  String get contactInfo => '联系人信息';

  @override
  String get exportChat => '导出聊天记录';

  @override
  String get clearChat => '清空聊天记录';

  @override
  String get deleteChat => '删除聊天';

  @override
  String get video => '视频';

  @override
  String get videoCall => '视频通话';

  @override
  String get missedVideoCall => '未接视频通话';

  @override
  String get voice => '语音';

  @override
  String get voiceCall => '语音通话';

  @override
  String get missedVoiceCall => '未接语音通话';

  @override
  String get location => '位置';

  @override
  String get youStartedACall => '您发起了一个通话';

  @override
  String get star => '收藏';

  @override
  String get copy => '复制';

  @override
  String get forward => '转发';

  @override
  String get multiSelect => '多选';

  @override
  String get select => '选择';

  @override
  String get quote => '引用';

  @override
  String get reply => '回复';

  @override
  String get all => '全部';

  @override
  String get tapToRemove => '点击移除';

  @override
  String get messageInfo => '消息详情';

  @override
  String get delivered => '已送达';

  @override
  String get readBy => '已读';

  @override
  String get deliveredTo => '已送达';

  @override
  String numSelect(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num 已选择',
      zero: '选择消息',
    );
    return '$_temp0';
  }

  @override
  String numChats(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num 个聊天',
      one: '1 个聊天',
      zero: '未选择聊天',
    );
    return '$_temp0';
  }

  @override
  String get recentChats => '最近聊天';

  @override
  String numThreadQuote(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num 个主题引用',
      one: '$num 个主题引用',
    );
    return '$_temp0';
  }

  @override
  String get swipeLeftToCancelOrReleaseToSend => '向左滑动以取消，松开以发送';

  @override
  String get releaseToCancel => '松开以取消';

  @override
  String get camera => '相机';

  @override
  String get document => '文档';

  @override
  String get file => '文件';

  @override
  String get photos => '照片';

  @override
  String get contact => '联系人';

  @override
  String get custom => '自定义';

  @override
  String get message => '消息';

  @override
  String get doNotDisturb => '消息免打扰';

  @override
  String get mute => '静音';

  @override
  String get pin => '置顶聊天';

  @override
  String get blackUser => '拉黑用户';

  @override
  String get blockUser => '拉黑用户';

  @override
  String get saveContact => '保存联系人';

  @override
  String get call => '呼叫';

  @override
  String get clearingChatHistory => '清空聊天记录';

  @override
  String get clearMessages => '清空消息';

  @override
  String get firstName => '名字';

  @override
  String get lastName => '姓氏';

  @override
  String get groupNotice => '群公告';

  @override
  String get groupOfAnnouncement => '群公告';

  @override
  String get groupManagement => '群管理';

  @override
  String get groupType => '群类型';

  @override
  String get addGroupWay => '主动加群方式';

  @override
  String get inviteGroupType => '邀请进群方式';

  @override
  String get myAliasInGroup => '我的群昵称';

  @override
  String get myGroupNickName => '我的群昵称';

  @override
  String get groupMembers => '群成员';

  @override
  String get admin => '管理员';

  @override
  String adminNum(int num) {
    return '管理员 ($num)';
  }

  @override
  String get info => '信息';

  @override
  String get setAsAdmin => '设置为管理员';

  @override
  String get announcement => '群公告';

  @override
  String get totalSilence => '全员禁言';

  @override
  String get silenceAll => '全员禁言';

  @override
  String get addSilencedMember => '添加禁言成员';

  @override
  String get onlyGroupOwnerAndAdminsCanSendMessages => '启用后，仅群主和管理员可以发送消息。';

  @override
  String someoneEnabledSilenceAll(String name) {
    return '$name 启用了 \'全员禁言\'';
  }

  @override
  String someoneDisabledSilenceAll(String name) {
    return '$name 禁用了 \'全员禁言\'';
  }

  @override
  String get newContacts => '新联系人';

  @override
  String get myGroup => '我的群组';

  @override
  String get theBlackList => '黑名单';

  @override
  String get blockList => '已拉黑用户';

  @override
  String get groupChatNotifications => '群聊通知';

  @override
  String get userID => '用户ID';

  @override
  String myUserID(String userID) {
    return '我的用户ID: $userID';
  }

  @override
  String get searchUserID => '搜索用户ID';

  @override
  String get none => '无';

  @override
  String iDis(String userID) {
    return 'ID: $userID';
  }

  @override
  String get addToContacts => '添加到联系人';

  @override
  String get addContact => '添加联系人';

  @override
  String get bio => '个性签名';

  @override
  String bioIs(String bio) {
    return '个性签名: $bio';
  }

  @override
  String get fillInTheVerificationInformation => '发送请求';

  @override
  String get remarkAndGrouping => '备注和分组';

  @override
  String get remark => '备注';

  @override
  String get group => '分组';

  @override
  String get send => '发送';

  @override
  String get contactAddedSuccessfully => '联系人添加成功';

  @override
  String get requestSent => '请求已发送';

  @override
  String get cannotAddContact => '无法添加联系人';

  @override
  String get addGroup => '添加群组';

  @override
  String typeIs(String type) {
    return '类型: $type';
  }

  @override
  String get groupNotAcceptingRequests => '群组不接受请求';

  @override
  String get joinedGroupSuccessfully => '成功加入群组';

  @override
  String numNewApplications(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num 个新申请',
      one: '$num 个新申请',
    );
    return '$_temp0';
  }

  @override
  String get agree => '同意';

  @override
  String get accept => '接受';

  @override
  String get refuse => '拒绝';

  @override
  String get decline => '拒绝';

  @override
  String get verificationMessage => '验证消息';

  @override
  String get accepted => '已接受';

  @override
  String get declined => '已拒绝';

  @override
  String get confirm => '确定';

  @override
  String get contactRequest => '联系人请求';

  @override
  String get contactsPermission => '联系人权限';

  @override
  String get allowAnyUserAddYouAsContact => '允许任何人添加您为联系人';

  @override
  String get declineContactRequestFromAnyUser => '自动拒绝联系人请求';

  @override
  String get anyoneUponRequest => '手动接受请求';

  @override
  String get theme => '主题';

  @override
  String get language => '语言';

  @override
  String get aboutTencentCloudChat => '关于腾讯云 IM';

  @override
  String get logIn => '登录';

  @override
  String get signIn => '登录';

  @override
  String get signUp => '注册';

  @override
  String get signOut => '登出';

  @override
  String get logOut => '登出';

  @override
  String get signature => '个性签名';

  @override
  String get gender => '性别';

  @override
  String get birthday => '生日';

  @override
  String get male => '男';

  @override
  String get female => '女';

  @override
  String get unspecified => '未指定';

  @override
  String get unknown => '未知';

  @override
  String get sdkVersion => 'SDK版本';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get userAgreement => '用户协议';

  @override
  String get disclaimer => '免责声明';

  @override
  String get personalInformationCollected => '收集的个人信息';

  @override
  String get informationSharedWithThirdParties => '与第三方共享的信息';

  @override
  String get deleteAccount => '删除账户';

  @override
  String get contactUs => '联系我们';

  @override
  String get countryOrRegion => '国家/地区';

  @override
  String get selectACountry => '选择国家或地区';

  @override
  String get phoneNumber => '电话号码';

  @override
  String get email => '邮箱';

  @override
  String get verificationCode => '验证码';

  @override
  String get enterSMSCode => '输入短信验证码';

  @override
  String get sendCode => '发送验证码';

  @override
  String get visitOurWebsite => '访问我们的网站';

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
  String get style => '风格';

  @override
  String get classic => '经典';

  @override
  String get minimalist => '简约';

  @override
  String get messageReadStatus => '消息阅读状态';

  @override
  String get messageReadStatusDescription => '控制是否显示您的消息的已读状态，以及他人是否可以看到您已读他们的消息。';

  @override
  String get onlineStatus => '在线状态';

  @override
  String get onlineStatusDescription => '确定您的在线状态是否对您的联系人可见。';

  @override
  String get noBio => '无个性签名';

  @override
  String get noConversation => '无对话';

  @override
  String get sound => '声音';

  @override
  String get sticker => '贴纸';

  @override
  String get image => '图片';

  @override
  String get chatHistory => '聊天记录';

  @override
  String get audio => '音频';

  @override
  String get messageDeleted => '消息已删除';

  @override
  String get messageRecalled => '消息已撤回';

  @override
  String unreadCount(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num 个未读消息',
      one: '$num 个未读消息',
    );
    return '$_temp0';
  }

  @override
  String newMsgCount(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num 条新消息',
      one: '1条新消息',
    );
    return '$_temp0';
  }

  @override
  String get takeAPhoto => '拍摄照片';

  @override
  String get recordAVideo => '录制视频';

  @override
  String get pullDownToLoadMoreMessages => '下拉加载更多消息';

  @override
  String get releaseToLoadMore => '释放加载更多';

  @override
  String get noMoreMessage => '没有更多消息';

  @override
  String get pullUpToLoadMoreMessages => '上拉加载更多消息';

  @override
  String get holdToRecordReleaseToSend => '按住录制，松开发送';

  @override
  String get forwardIndividually => '逐条转发';

  @override
  String get forwardCombined => '合并转发';

  @override
  String get selectConversations => '选择聊天';

  @override
  String get recent => '最近';

  @override
  String get recall => '撤回';

  @override
  String replyTo(String name) {
    return '回复给 $name';
  }

  @override
  String get confirmDeletion => '确认删除';

  @override
  String get askDeleteThisMessage => '删除这条消息？';

  @override
  String deleteMessageCount(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '删除 $num 条消息？',
      one: '删除一条消息？',
      zero: '没有消息被删除',
    );
    return '$_temp0';
  }

  @override
  String memberReadCount(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num 个成员阅读',
      one: '1个成员阅读',
      zero: '没有成员阅读',
    );
    return '$_temp0';
  }

  @override
  String get allMembersRead => '所有成员已读';

  @override
  String get allowAny => '允许任何';

  @override
  String get cannotSendApplicationToWorkGroup => '无法发送申请至工作群';

  @override
  String get appearance => '外观';

  @override
  String get darkTheme => '暗黑主题';

  @override
  String get denyAny => '拒绝任何';

  @override
  String get edit => '编辑';

  @override
  String get friendsPermission => '好友权限';

  @override
  String get groupJoined => '加入群组';

  @override
  String get lightTheme => '亮色主题';

  @override
  String get noBlockList => '无屏蔽列表';

  @override
  String get noContact => '无联系人';

  @override
  String get noNewApplication => '无新申请';

  @override
  String get permissionNeeded => '需要权限';

  @override
  String get requireRequest => '需要请求';

  @override
  String get setNickname => '设置昵称';

  @override
  String get setSignature => '设置个性签名';

  @override
  String get validationMessages => '验证消息';

  @override
  String get getVerification => '获取验证码';

  @override
  String get invalidEmail => '无效邮箱';

  @override
  String get invalidPhoneNumber => '无效电话号码';

  @override
  String get invalidVerification => '无效验证码';

  @override
  String get searchGroupID => '搜索群组ID';

  @override
  String get callInitiated => '呼叫发起';

  @override
  String get callAccepted => '呼叫接受';

  @override
  String get callDeclined => '呼叫拒绝';

  @override
  String get noAnswer => '无应答';

  @override
  String get lineBusy => '占线';

  @override
  String get callHungUp => '挂断电话';

  @override
  String get callInProgress => '通话进行中';

  @override
  String get callEnded => '通话结束';

  @override
  String get unknownCallStatus => '通话中';

  @override
  String get groupChatCreated => '成功创建群聊！';

  @override
  String get vote => '投票';

  @override
  String get callCancelled => '呼叫取消';

  @override
  String get unknownGroupTips => '未知群组提示';

  @override
  String memberJoinedGroup(Object members) {
    return '$members已加入群组';
  }

  @override
  String opInvitedToGroup(Object members, Object opMember) {
    return '$opMember邀请$members加入群组';
  }

  @override
  String memberLeftGroup(Object members) {
    return '$members退出群组';
  }

  @override
  String opRemovedFromGroup(Object members, Object opMember) {
    return '$opMember将$members从群组中移除';
  }

  @override
  String opPromotedToAdmin(Object members, Object opMember) {
    return '$opMember将$members提升为管理员';
  }

  @override
  String opRevokedAdmin(Object members, Object opMember) {
    return '$opMember取消了$members的管理员身份';
  }

  @override
  String setToAdmin(Object members) {
    return '$members被设置管理员';
  }

  @override
  String revokedAdmin(Object members) {
    return '$members被取消管理员';
  }

  @override
  String opChangedGroupInfo(Object groupInfo, Object opMember) {
    return '$opMember更改了$groupInfo';
  }

  @override
  String opChangedMemberInfo(Object memberInfo, Object opMember) {
    return '$opMember更改了$memberInfo';
  }

  @override
  String changedGroupNameTo(Object name) {
    return '更改群组名称为$name';
  }

  @override
  String changedGroupDescriptionTo(Object description) {
    return '更改群组描述为$description';
  }

  @override
  String changedGroupAnnouncementTo(Object announcement) {
    return '更改群组公告为$announcement';
  }

  @override
  String get changedGroupAvatar => '更改群组头像';

  @override
  String transferredGroupOwnershipTo(Object owner) {
    return '将群组所有权转让给$owner';
  }

  @override
  String get changedGroupCustomInfo => '更改群组自定义信息';

  @override
  String get enabledGroupMute => '禁言全员';

  @override
  String get disabledGroupMute => '取消禁言全员';

  @override
  String changedGroupMessageReceptionTo(Object setting) {
    return '更改群组消息接收设置为：$setting';
  }

  @override
  String changedApplyToJoinGroupTo(Object setting) {
    return '修改加群方式为：$setting';
  }

  @override
  String changedInviteToJoinGroupTo(Object setting) {
    return '修改邀请进群方式为：$setting';
  }

  @override
  String opUnmuted(Object user) {
    return '$user 取消禁言';
  }

  @override
  String opMuted(Object duration, Object user) {
    return '$user 禁言 $duration 秒';
  }

  @override
  String get groupTips => '群组提示';

  @override
  String get receiveMessages => '接收消息';

  @override
  String get doNotReceiveMessages => '不接收消息';

  @override
  String get receiveMessagesWhenOnlineOnly => '仅在线时接收消息';

  @override
  String get disallowJoinGroup => '禁止加群';

  @override
  String get joinGroupNeedApproval => '管理员审批';

  @override
  String get joinGroupDirectly => '自动审批';

  @override
  String get disallowInviting => '禁止邀请';

  @override
  String get requireApprovalForInviting => '管理员审批';

  @override
  String get joinDirectlyBeenInvited => '自动审批';

  @override
  String get unmuted => '取消禁言';

  @override
  String muteTime(Object duration) {
    return '禁言 $duration 秒';
  }

  @override
  String get poll => '投票';

  @override
  String callDuration(Object duration) {
    return '通话时长：$duration';
  }

  @override
  String get selectMembers => '选择成员';

  @override
  String numSelectMembers(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num 已选择',
      zero: '选择成员',
    );
    return '$_temp0';
  }

  @override
  String get searchMembers => '搜索成员';

  @override
  String get startCall => '发起通话';

  @override
  String get clear => '清除';

  @override
  String groupSubtitle(Object count, Object name) {
    return '$name 和其他 $count 人';
  }

  @override
  String get markAsUnread => '标记为未读';

  @override
  String get hide => '隐藏';

  @override
  String get unreadMessagesBelow => '以下为未读消息';

  @override
  String get ar => 'اَلْعَرَبِيَّةُ';

  @override
  String get tencentCloudChat => '腾讯云 IM';

  @override
  String get changeTheme => '更改外观';

  @override
  String get deleteAccountNotification => '删除帐户后，您将无法使用当前帐户，相关数据将被删除且无法恢复。';

  @override
  String get restartAppForLanguage => '请重启应用以使语言更改生效';

  @override
  String get deleteAllMessages => '清除聊天记录';

  @override
  String get downloading => '下载中...';

  @override
  String get viewFullImage => '查看原图';

  @override
  String get messageRecall => '消息撤回';

  @override
  String get messageRecallConfirmation => '你确定要撤回这条消息吗？';

  @override
  String get quit => '退出群聊';

  @override
  String get dissolve => '解散该群';

  @override
  String get setGroupName => '设置群组名称';

  @override
  String get groupAddAny => '自动审批';

  @override
  String get groupAddAuth => '管理员审批';

  @override
  String get groupAddForbid => '禁止加群';

  @override
  String get groupOwner => '群主';

  @override
  String get groupMember => '成员';

  @override
  String get dismissAdmin => '取消管理员';

  @override
  String get welcomeToTencentCloudChat => '欢迎来到腾讯云 IM';

  @override
  String get draft => '草稿';

  @override
  String get openInNewWindow => '在新窗口中打开';

  @override
  String get selectAChat => '选择一个聊天';

  @override
  String get noConversationSelected => '未选择对话';

  @override
  String get unavailableToSendMessage => '无法发送消息';

  @override
  String get noSuchGroup => '没有这个群组';

  @override
  String get notGroupMember => '不是群组成员';

  @override
  String get userNotFound => '找不到用户';

  @override
  String get userBlockedYou => '用户已屏蔽你';

  @override
  String get muted => '已静音';

  @override
  String get groupMuted => '群组已静音';

  @override
  String get cantSendMessage => '无法发送消息';

  @override
  String get media => '媒体';

  @override
  String sendToSomeChat(String name) {
    return '发送给 $name';
  }

  @override
  String get unableToSendWithFolders => '由于包含文件夹，无法发送文件。请仅选择文件本身。';

  @override
  String get channelSwitch => '频道：';

  @override
  String get weChat => '微信';

  @override
  String get tGWA => 'Telegram 和 WhatsApp';

  @override
  String get contactUsIfQuestions => '如果有任何不清楚的地方或者您有更多的想法，请随时联系我们！';

  @override
  String get chatNow => '立即聊天';

  @override
  String get onlineServiceTimeFrom10To20 => '在线时间：周一至周五上午10点至晚上8点';

  @override
  String get officialWebsite => '官方网站';

  @override
  String get allSDKs => '所有 SDK';

  @override
  String get sourceCode => '源代码';

  @override
  String get personalInformationCollectionList => '个人信息收集列表';

  @override
  String get thirdPartyInformationSharingList => '第三方信息分享列表';

  @override
  String get version => '版本';

  @override
  String get feedback => '反馈';

  @override
  String get me => '我';

  @override
  String get about => '关于';

  @override
  String get profile => '个人资料';

  @override
  String get unpin => '取消置顶';

  @override
  String mentionedMessages(num count) {
    return '$count 条消息提到我';
  }

  @override
  String get longPressToNavigate => '按住查看';

  @override
  String get permissionDeniedTitle => '权限被拒绝';

  @override
  String permissionDeniedContent(Object permissionString) {
    return '请前往设置并启用 $permissionString 权限。';
  }

  @override
  String get goToSettingsButtonText => '前往设置';

  @override
  String get originalMessageNotFound => '未找到原始消息';

  @override
  String get markAsRead => '标为已读';

  @override
  String get reEdit => '重新编辑';

  @override
  String get translate => '翻译';

  @override
  String memberRecalledMessage(Object member) {
    return '$member撤回了一条消息';
  }

  @override
  String get copyFileSuccess => '复制文件成功';

  @override
  String get saveFileSuccess => '保存文件成功';

  @override
  String get saveFileFailed => '保存文件失败';

  @override
  String get copyLinkSuccess => '复制链接成功';

  @override
  String get copyImageContextMenuBtnText => '复制图片';

  @override
  String get saveToLocalContextMenuBtnText => '另存为';

  @override
  String get copyLinkContextMenuBtnText => '复制链接';

  @override
  String get openLinkContextMenuBtnText => '在新窗口打开';

  @override
  String get reactionList => 'Reaction List';

  @override
  String get translatedBy => '由腾讯云IM提供支持';

  @override
  String get convertToText => '转换';

  @override
  String numMessages(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 条消息',
      one: '1 条消息',
    );
    return '$_temp0';
  }

  @override
  String get filterBy => '筛选';

  @override
  String get text => '文本';

  @override
  String get numMessagesOver99 => '99+ 条消息';

  @override
  String get setGroupAnnouncement => '设置群公告';

  @override
  String get setNickName => '设置群名片';

  @override
  String get joinTime => '加入时间';

  @override
  String get myRoleInGroup => '角色';

  @override
  String get chooseAvatar => '选择头像';

  @override
  String get friendLimit => '您的好友数已达系统上限';

  @override
  String get otherFriendLimit => '对方的好友数已达系统上限';

  @override
  String get inBlacklist => '被加好友在自己的黑名单中';

  @override
  String get setInBlacklist => '您已被被对方设置为黑名单';

  @override
  String get forbidAddFriend => '对方已禁止加好友';

  @override
  String get waitAgreeFriend => '等待好友审核同意';

  @override
  String get haveBeFriend => '对方已是您的好友';

  @override
  String get contactAddFailed => '添加失败';

  @override
  String get addGroupPermissionDeny => '禁止加群';

  @override
  String get addGroupAlreadyMember => '已经是群成员';

  @override
  String get addGroupNotFound => '群组不存在';

  @override
  String get addGroupFullMember => '群已满员';

  @override
  String get joinedTip => '您已加入群:';

  @override
  String get quitGroupTip => '您确认退出该群？';

  @override
  String get dismissGroupTip => '您确认解散该群?';

  @override
  String get kickedOffTips => '您已被踢下线';

  @override
  String get userSigExpiredTips => '用户签名已经过期';

  @override
  String get convertTextFailed => '转换文本失败';

  @override
  String get deleteFriendSuccess => '删除好友成功';

  @override
  String get deleteFriendFailed => '删除好友失败';

  @override
  String get clearMsgTip => '确认清除聊天记录？';

  @override
  String get sendMsg => '发送消息';

  @override
  String get groupMemberMute => '因被禁言而不能发送消息，请检查发送者是否被设置禁言。';

  @override
  String get forwardFailedTip => '发送失败消息不支持转发！';

  @override
  String get fileTooLarge => '文件大小超出了限制';

  @override
  String get invalidApplication => '好友申请失效';

  @override
  String get atMeTips => '有人@我';

  @override
  String get atAllTips => '@所有人';

  @override
  String get forwardVoteFailedTip => '投票消息不支持转发！';

  @override
  String get forwardOneByOneLimitNumberTip => '转发消息过多，暂不支持逐条转发';

  @override
  String get modifyRemark => '修改备注';

  @override
  String banned(Object targetUser, Object time) {
    return '$targetUser 被禁言 $time';
  }

  @override
  String cancelBanned(Object targetUser) {
    return '$targetUser 被取消禁言';
  }

  @override
  String get day => '天';

  @override
  String get hour => '小时';

  @override
  String get min => '分';

  @override
  String get second => '秒';

  @override
  String get setFailed => '设置失败';

  @override
  String get callRejectCaller => '对方已拒绝';

  @override
  String get callRejectCallee => '已拒绝';

  @override
  String get callCancelCaller => '已取消';

  @override
  String get callCancelCallee => '对方已取消';

  @override
  String get stopCallTip => '通话时长：';

  @override
  String get callTimeoutCaller => '对方无应答';

  @override
  String get callTimeoutCallee => '对方已取消';

  @override
  String get callLineBusyCaller => '对方忙线中';

  @override
  String get callLineBusyCallee => '对方已取消';

  @override
  String get acceptCall => '已接听';

  @override
  String get callingSwitchToAudio => '视频转语音';

  @override
  String get callingSwitchToAudioAccept => '确认视频转语音';

  @override
  String get invalidCommand => '不能识别的通话指令';

  @override
  String get groupCallSend => '发起了群通话';

  @override
  String get groupCallEnd => '通话结束';

  @override
  String get groupCallNoAnswer => '未接听';

  @override
  String get groupCallReject => '拒绝群通话';

  @override
  String get groupCallAccept => '接听';

  @override
  String get groupCallConfirmSwitchToAudio => '同意视频转语音';

  @override
  String get callkitInPeerBlacklist => '发起通话失败，用户在黑名单中，禁止发起！';

  @override
  String get resendTips => '确定重发吗？';

  @override
  String get logoutTip => '您确定要退出登录么？';

  @override
  String get sendFileLimit => '你只能选择9个文件';

  @override
  String get atAll => '所有人';

  @override
  String get tuiEmojiSmile => '[微笑]';

  @override
  String get tuiEmojiExpect => '[期待]';

  @override
  String get tuiEmojiBlink => '[眨眼]';

  @override
  String get tuiEmojiGuffaw => '[大笑]';

  @override
  String get tuiEmojiKindSmile => '[姨母笑]';

  @override
  String get tuiEmojiHaha => '[哈哈哈]';

  @override
  String get tuiEmojiCheerful => '[愉快]';

  @override
  String get tuiEmojiSpeechless => '[无语]';

  @override
  String get tuiEmojiAmazed => '[惊讶]';

  @override
  String get tuiEmojiSorrow => '[悲伤]';

  @override
  String get tuiEmojiComplacent => '[得意]';

  @override
  String get tuiEmojiSilly => '[傻了]';

  @override
  String get tuiEmojiLustful => '[色]';

  @override
  String get tuiEmojiGiggle => '[憨笑]';

  @override
  String get tuiEmojiKiss => '[亲亲]';

  @override
  String get tuiEmojiWail => '[大哭]';

  @override
  String get tuiEmojiTearsLaugh => '[哭笑]';

  @override
  String get tuiEmojiTrapped => '[困]';

  @override
  String get tuiEmojiMask => '[口罩]';

  @override
  String get tuiEmojiFear => '[恐惧]';

  @override
  String get tuiEmojiBareTeeth => '[龇牙]';

  @override
  String get tuiEmojiFlareUp => '[发怒]';

  @override
  String get tuiEmojiYawn => '[打哈欠]';

  @override
  String get tuiEmojiTact => '[机智]';

  @override
  String get tuiEmojiStareyes => '[星星眼]';

  @override
  String get tuiEmojiShutUp => '[闭嘴]';

  @override
  String get tuiEmojiSigh => '[叹气]';

  @override
  String get tuiEmojiHehe => '[呵呵]';

  @override
  String get tuiEmojiSilent => '[收声]';

  @override
  String get tuiEmojiSurprised => '[惊喜]';

  @override
  String get tuiEmojiAskance => '[白眼]';

  @override
  String get tuiEmojiOk => '[OK]';

  @override
  String get tuiEmojiShit => '[便便]';

  @override
  String get tuiEmojiMonster => '[怪兽]';

  @override
  String get tuiEmojiDaemon => '[恶魔]';

  @override
  String get tuiEmojiRage => '[恶魔怒]';

  @override
  String get tuiEmojiFool => '[衰]';

  @override
  String get tuiEmojiPig => '[猪]';

  @override
  String get tuiEmojiCow => '[牛]';

  @override
  String get tuiEmojiAi => '[AI]';

  @override
  String get tuiEmojiSkull => '[骷髅]';

  @override
  String get tuiEmojiBombs => '[炸弹]';

  @override
  String get tuiEmojiCoffee => '[咖啡]';

  @override
  String get tuiEmojiCake => '[蛋糕]';

  @override
  String get tuiEmojiBeer => '[啤酒]';

  @override
  String get tuiEmojiFlower => '[花]';

  @override
  String get tuiEmojiWatermelon => '[瓜]';

  @override
  String get tuiEmojiRich => '[壕]';

  @override
  String get tuiEmojiHeart => '[爱心]';

  @override
  String get tuiEmojiMoon => '[月亮]';

  @override
  String get tuiEmojiSun => '[太阳]';

  @override
  String get tuiEmojiStar => '[星星]';

  @override
  String get tuiEmojiRedPacket => '[红包]';

  @override
  String get tuiEmojiCelebrate => '[庆祝]';

  @override
  String get tuiEmojiBless => '[福]';

  @override
  String get tuiEmojiFortune => '[发]';

  @override
  String get tuiEmojiConvinced => '[服]';

  @override
  String get tuiEmojiProhibit => '[禁]';

  @override
  String get tuiEmoji666 => '[666]';

  @override
  String get tuiEmoji857 => '[857]';

  @override
  String get tuiEmojiKnife => '[刀]';

  @override
  String get tuiEmojiLike => '[赞]';

  @override
  String get startConversation => '发起会话';

  @override
  String get createGroupChat => '创建群聊';

  @override
  String get createGroupTips => '创建群组';

  @override
  String get createCommunity => '创建社群';

  @override
  String get communityIDEditFormatTips => '社群 ID 前缀必须为 @TGS#_ !';

  @override
  String get groupIDEditFormatTips => '群组 ID 前缀不能为 @TGS# !';

  @override
  String get groupIDEditExceedTips => '群组 ID 最长 48 字节!';

  @override
  String get groupTypeContentButton => '查看产品文档';

  @override
  String get create => '创建';

  @override
  String get groupName => '群名称';

  @override
  String get groupIDOption => '群ID（选填）';

  @override
  String get groupFaceUrl => '群头像';

  @override
  String get groupMemberSelected => '已选择的群成员';

  @override
  String get groupWorkType => '好友工作群(Work)';

  @override
  String get groupPublicType => '陌生人社交群(Public)';

  @override
  String get groupMeetingType => '临时会议群(Meeting)';

  @override
  String get groupCommunityType => '社群(Community)';

  @override
  String get groupWorkDesc => '好友工作群(Work）：类似普通微信群，创建后仅支持已在群内的好友邀请加群，且无需被邀请方同意或群主审批。';

  @override
  String get groupPublicDesc => '陌生人社交群(Public）：类似 QQ 群，创建后群主可以指定群管理员，用户搜索群 ID 发起加群申请后，需要群主或管理员审批通过才能入群。';

  @override
  String get groupMeetingDesc => '临时会议群(Meeting）：创建后可以随意进出，且支持查看入群前消息；适用于音视频会议场景、在线教育场景等与实时音视频产品结合的场景。';

  @override
  String get groupCommunityDesc => '社群(Community)：创建后可以随意进出，最多支持100000人，支持历史消息存储，用户搜索群 ID 发起加群申请后，无需管理员审批即可进群。';

  @override
  String get groupDetail => '群聊详情';

  @override
  String get transferGroupOwner => '转让群主';

  @override
  String get privateGroup => '讨论组';

  @override
  String get publicGroup => '公开群';

  @override
  String get chatRoom => '聊天室';

  @override
  String get communityGroup => '社群';

  @override
  String get serverGroupInvalidReq => '请求非法';

  @override
  String get serverGroupReqAlreadyBeenProcessed => '此邀请或者申请请求已经被处理。';

  @override
  String inviteToGroupFrom(Object inviter) {
    return '来自$inviter的邀请';
  }

  @override
  String get applyToJoin => '申请加入:';

  @override
  String get requestWait => '邀请成功，等待处理';

  @override
  String dismissGroupTips(Object groupName) {
    return '您所在的群 $groupName 已解散';
  }
}

/// The translations for Chinese, using the Han script (`zh_Hans`).
class TencentCloudChatLocalizationsZhHans extends TencentCloudChatLocalizationsZh {
  TencentCloudChatLocalizationsZhHans(): super('zh_Hans');


}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class TencentCloudChatLocalizationsZhHant extends TencentCloudChatLocalizationsZh {
  TencentCloudChatLocalizationsZhHant(): super('zh_Hant');

  @override
  String get album => '相册';

  @override
  String get chat => '對話';

  @override
  String get chats => '對話';

  @override
  String get calls => '通話';

  @override
  String get search => '搜尋';

  @override
  String get contacts => '聯絡人';

  @override
  String get settings => '設定';

  @override
  String get online => '在線';

  @override
  String get offline => '離線';

  @override
  String get sendAMessage => '發信息';

  @override
  String get done => '完成';

  @override
  String get archive => '歸檔';

  @override
  String get read => '已讀';

  @override
  String get readAll => '全部已讀';

  @override
  String get delete => '刪除';

  @override
  String get newChat => '新對話';

  @override
  String get newGroup => '新群組';

  @override
  String get frequentlyContacted => '常聯絡人';

  @override
  String get addParticipants => '加成員';

  @override
  String get addMembers => '加成員';

  @override
  String get cancel => '取消';

  @override
  String get next => '下一步';

  @override
  String get back => '返回';

  @override
  String get groupID => '群組ID';

  @override
  String get groupIDCertificate => '群組ID（證書）';

  @override
  String get groupOfType => '群組類型';

  @override
  String get typeOfGroup => '群組類型';

  @override
  String get work => '工作';

  @override
  String get public => '公開';

  @override
  String get meeting => '會議';

  @override
  String get avChatRoom => '視訊聊天室';

  @override
  String get groupPortrait => '群組頭像';

  @override
  String get participants => '參與者';

  @override
  String get seeDocs => '查看文檔';

  @override
  String get you => '你';

  @override
  String get today => '今日';

  @override
  String get yesterday => '昨日';

  @override
  String youCreatedGroup(String groupName) {
    return '你創建咗群組 $groupName';
  }

  @override
  String get groups => '群組';

  @override
  String get chatRecord => '訊息';

  @override
  String get messages => '訊息';

  @override
  String get more => '更多';

  @override
  String get noConversationsContactsOrMessagesFound => '冇搜尋到對話、聯絡人或訊息';

  @override
  String get contactInfo => '聯絡人信息';

  @override
  String get exportChat => '導出對話';

  @override
  String get clearChat => '清除對話';

  @override
  String get deleteChat => '刪除對話';

  @override
  String get video => '視訊';

  @override
  String get videoCall => '視像通話';

  @override
  String get missedVideoCall => '未接視像通話';

  @override
  String get voice => '語音';

  @override
  String get voiceCall => '語音通話';

  @override
  String get missedVoiceCall => '未接語音通話';

  @override
  String get location => '位置';

  @override
  String get youStartedACall => '你發起咗個通話';

  @override
  String get star => '星標';

  @override
  String get copy => '複製';

  @override
  String get forward => '轉發';

  @override
  String get multiSelect => '多選';

  @override
  String get select => '揀選';

  @override
  String get quote => '引用';

  @override
  String get reply => '回覆';

  @override
  String get all => '全部';

  @override
  String get tapToRemove => '點擊移除';

  @override
  String get messageInfo => '訊息信息';

  @override
  String get delivered => '已送達';

  @override
  String get readBy => '已讀';

  @override
  String get deliveredTo => '已送達';

  @override
  String numSelect(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num 已揀選',
      zero: '揀選訊息',
    );
    return '$_temp0';
  }

  @override
  String numChats(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num 個對話',
      one: '1 個對話',
      zero: '冇揀選對話',
    );
    return '$_temp0';
  }

  @override
  String get recentChats => '最近對話';

  @override
  String numThreadQuote(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num 綫程引用',
      one: '$num 綫程引用',
    );
    return '$_temp0';
  }

  @override
  String get swipeLeftToCancelOrReleaseToSend => '向左滑取消或放開發送';

  @override
  String get releaseToCancel => '放開取消';

  @override
  String get camera => '相機';

  @override
  String get document => '檔案';

  @override
  String get file => '文件';

  @override
  String get photos => '相片';

  @override
  String get contact => '聯絡人';

  @override
  String get custom => '自定義';

  @override
  String get message => '訊息';

  @override
  String get doNotDisturb => '消息免打擾';

  @override
  String get mute => '靜音';

  @override
  String get pin => '置頂聊天';

  @override
  String get blackUser => '封鎖用戶';

  @override
  String get blockUser => '封鎖用戶';

  @override
  String get saveContact => '保存聯絡人';

  @override
  String get call => '通話';

  @override
  String get clearingChatHistory => '清除訊息';

  @override
  String get clearMessages => '清除訊息';

  @override
  String get firstName => '名';

  @override
  String get lastName => '姓';

  @override
  String get groupNotice => '群通知';

  @override
  String get groupOfAnnouncement => '群通知';

  @override
  String get groupManagement => '管理群組';

  @override
  String get groupType => '群組類型';

  @override
  String get addGroupWay => '主動加群方式';

  @override
  String get inviteGroupType => '邀請進群方式';

  @override
  String get myAliasInGroup => '我在群裡嘅別名';

  @override
  String get myGroupNickName => '我在群裡嘅別名';

  @override
  String get groupMembers => '群成員';

  @override
  String get admin => '管理員';

  @override
  String adminNum(int num) {
    return '管理員 ($num)';
  }

  @override
  String get info => '詳情';

  @override
  String get setAsAdmin => '設置為管理員';

  @override
  String get announcement => '群通知';

  @override
  String get totalSilence => '全員禁言';

  @override
  String get silenceAll => '全員禁言';

  @override
  String get addSilencedMember => '加禁言成員';

  @override
  String get onlyGroupOwnerAndAdminsCanSendMessages => '開啟後，只有群主同管理員可以發訊息。';

  @override
  String someoneEnabledSilenceAll(String name) {
    return '$name 開啟咗「全員禁言」';
  }

  @override
  String someoneDisabledSilenceAll(String name) {
    return '$name 關閉咗「全員禁言」';
  }

  @override
  String get newContacts => '新聯絡人';

  @override
  String get myGroup => '群組';

  @override
  String get theBlackList => '黑名單';

  @override
  String get blockList => '封鎖用戶';

  @override
  String get groupChatNotifications => '群對話通知';

  @override
  String get userID => '用戶ID';

  @override
  String myUserID(String userID) {
    return '我嘅用戶ID: $userID';
  }

  @override
  String get searchUserID => '搜尋用戶ID';

  @override
  String get none => '無';

  @override
  String iDis(String userID) {
    return 'ID: $userID';
  }

  @override
  String get addToContacts => '加到聯絡人';

  @override
  String get addContact => '加聯絡人';

  @override
  String get bio => '簡介';

  @override
  String bioIs(String bio) {
    return '簡介: $bio';
  }

  @override
  String get fillInTheVerificationInformation => '發送請求';

  @override
  String get remarkAndGrouping => '備註同分組';

  @override
  String get remark => '備註';

  @override
  String get group => '分組';

  @override
  String get send => '發送';

  @override
  String get contactAddedSuccessfully => '成功加聯絡人';

  @override
  String get requestSent => '請求已發送';

  @override
  String get cannotAddContact => '唔可以加聯絡人';

  @override
  String get addGroup => '加群組';

  @override
  String typeIs(String type) {
    return '類型: $type';
  }

  @override
  String get groupNotAcceptingRequests => '群組唔接受請求';

  @override
  String get joinedGroupSuccessfully => '成功加入群組';

  @override
  String numNewApplications(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num 個新申請',
      one: '$num 個新申請',
    );
    return '$_temp0';
  }

  @override
  String get agree => '接受';

  @override
  String get accept => '接受';

  @override
  String get refuse => '拒絕';

  @override
  String get decline => '拒絕';

  @override
  String get verificationMessage => '驗證訊息';

  @override
  String get accepted => '已接受';

  @override
  String get declined => '已拒絕';

  @override
  String get confirm => '確定';

  @override
  String get contactRequest => '聯絡人請求';

  @override
  String get contactsPermission => '聯絡人許可';

  @override
  String get allowAnyUserAddYouAsContact => '允許任何人將您添加為聯絡人';

  @override
  String get declineContactRequestFromAnyUser => '自動拒絕聯絡人請求';

  @override
  String get anyoneUponRequest => '手動接受請求';

  @override
  String get theme => '主題';

  @override
  String get language => '語言';

  @override
  String get aboutTencentCloudChat => '關於騰訊雲 IM';

  @override
  String get logIn => '登錄';

  @override
  String get signIn => '登錄';

  @override
  String get signUp => '註冊';

  @override
  String get signOut => '登出';

  @override
  String get logOut => '登出';

  @override
  String get signature => '個性簽名';

  @override
  String get gender => '性別';

  @override
  String get birthday => '生日';

  @override
  String get male => '男';

  @override
  String get female => '女';

  @override
  String get unspecified => '未指定';

  @override
  String get unknown => '未知';

  @override
  String get sdkVersion => 'SDK版本';

  @override
  String get privacyPolicy => '隱私政策';

  @override
  String get userAgreement => '用戶協議';

  @override
  String get disclaimer => '免責聲明';

  @override
  String get personalInformationCollected => '收集的個人信息';

  @override
  String get informationSharedWithThirdParties => '與第三方共享的信息';

  @override
  String get deleteAccount => '刪除帳戶';

  @override
  String get contactUs => '聯絡我們';

  @override
  String get countryOrRegion => '國家/地區';

  @override
  String get selectACountry => '揀選國家或地區';

  @override
  String get phoneNumber => '電話號碼';

  @override
  String get email => '電子郵件';

  @override
  String get verificationCode => '驗證碼';

  @override
  String get enterSMSCode => '輸入短信收到的驗證碼';

  @override
  String get sendCode => '發送驗證碼';

  @override
  String get visitOurWebsite => '訪問我們的網站';

  @override
  String get english => '英文';

  @override
  String get simplifiedChinese => '簡體中文';

  @override
  String get traditionalChinese => '繁體中文';

  @override
  String get japanese => '日本語';

  @override
  String get korean => '한국어';

  @override
  String get style => '風格';

  @override
  String get classic => '經典';

  @override
  String get minimalist => '簡約';

  @override
  String get messageReadStatus => '訊息已讀狀態';

  @override
  String get messageReadStatusDescription => '控制是否顯示您的訊息已讀狀態以及其他人是否可以看到您已讀他們的訊息。';

  @override
  String get onlineStatus => '在線狀態';

  @override
  String get onlineStatusDescription => '決定您的在線狀態是否對您的聯絡人可見。';

  @override
  String get noBio => '無個性簽名';

  @override
  String get noConversation => '無對話';

  @override
  String get sound => '聲音';

  @override
  String get sticker => '貼圖';

  @override
  String get image => '圖片';

  @override
  String get chatHistory => '聊天記錄';

  @override
  String get audio => '音頻';

  @override
  String get messageDeleted => '訊息已刪除';

  @override
  String get messageRecalled => '訊息已撤回';

  @override
  String unreadCount(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num 未讀訊息',
      one: '$num 未讀訊息',
    );
    return '$_temp0';
  }

  @override
  String newMsgCount(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num 條新訊息',
      one: '一條新訊息',
    );
    return '$_temp0';
  }

  @override
  String get takeAPhoto => '拍攝照片';

  @override
  String get recordAVideo => '錄製影片';

  @override
  String get pullDownToLoadMoreMessages => '下拉加載更多訊息';

  @override
  String get releaseToLoadMore => '釋放以加載更多';

  @override
  String get noMoreMessage => '沒有更多訊息';

  @override
  String get pullUpToLoadMoreMessages => '上拉加載更多訊息';

  @override
  String get holdToRecordReleaseToSend => '按住錄音，鬆開發送';

  @override
  String get forwardIndividually => '單獨轉發';

  @override
  String get forwardCombined => '合併轉發';

  @override
  String get selectConversations => '揀選對話';

  @override
  String get recent => '最近';

  @override
  String get recall => '撤回';

  @override
  String replyTo(String name) {
    return '回覆 $name';
  }

  @override
  String get confirmDeletion => '確認刪除';

  @override
  String get askDeleteThisMessage => '確定刪除此訊息嗎？';

  @override
  String deleteMessageCount(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '刪除 $num 條訊息？',
      one: '刪除一條訊息？',
      zero: '未刪除訊息',
    );
    return '$_temp0';
  }

  @override
  String memberReadCount(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num 位成員已讀',
      one: '1 位成員已讀',
      zero: '無成員已讀',
    );
    return '$_temp0';
  }

  @override
  String get allMembersRead => '所有成員已讀';

  @override
  String get allowAny => '允許任何';

  @override
  String get cannotSendApplicationToWorkGroup => '無法向工作組發送申請';

  @override
  String get appearance => '外觀';

  @override
  String get darkTheme => '深色';

  @override
  String get denyAny => '拒絕任何';

  @override
  String get edit => '編輯';

  @override
  String get friendsPermission => '朋友權限';

  @override
  String get groupJoined => '已加入群組';

  @override
  String get lightTheme => '淺色';

  @override
  String get noBlockList => '沒有封鎖用戶';

  @override
  String get noContact => '無聯絡人';

  @override
  String get noNewApplication => '無新申請';

  @override
  String get permissionNeeded => '需要許可';

  @override
  String get requireRequest => '需要請求';

  @override
  String get setNickname => '設置暱稱';

  @override
  String get setSignature => '設置簽名';

  @override
  String get validationMessages => '驗證消息';

  @override
  String get getVerification => '獲取驗證';

  @override
  String get invalidEmail => '無效電子郵件';

  @override
  String get invalidPhoneNumber => '無效電話號碼';

  @override
  String get invalidVerification => '無效驗證';

  @override
  String get searchGroupID => '搜索群組ID';

  @override
  String get callInitiated => '呼叫已發起';

  @override
  String get callAccepted => '呼叫已接受';

  @override
  String get callDeclined => '呼叫已拒絕';

  @override
  String get noAnswer => '無回答';

  @override
  String get lineBusy => '線路繁忙';

  @override
  String get callHungUp => '掛斷電話';

  @override
  String get callInProgress => '通話進行中';

  @override
  String get callEnded => '通話結束';

  @override
  String get unknownCallStatus => '正在通話';

  @override
  String get groupChatCreated => '群聊成功創建！';

  @override
  String get vote => '投票';

  @override
  String get callCancelled => '通話已取消';

  @override
  String get unknownGroupTips => '未知群組提示';

  @override
  String memberJoinedGroup(Object members) {
    return '$members已加入群組';
  }

  @override
  String opInvitedToGroup(Object members, Object opMember) {
    return '$opMember邀請$members加入群組';
  }

  @override
  String memberLeftGroup(Object members) {
    return '$members離開了群組';
  }

  @override
  String opRemovedFromGroup(Object members, Object opMember) {
    return '$opMember將$members從群組中移除';
  }

  @override
  String opPromotedToAdmin(Object members, Object opMember) {
    return '$opMember將$members提升為管理員';
  }

  @override
  String opRevokedAdmin(Object members, Object opMember) {
    return '$opMember撤銷了$members的管理員角色';
  }

  @override
  String setToAdmin(Object members) {
    return '$members被設置管理員';
  }

  @override
  String revokedAdmin(Object members) {
    return '$members被取消管理員';
  }

  @override
  String opChangedGroupInfo(Object groupInfo, Object opMember) {
    return '$opMember更改了$groupInfo';
  }

  @override
  String opChangedMemberInfo(Object memberInfo, Object opMember) {
    return '$opMember更改了$memberInfo';
  }

  @override
  String changedGroupNameTo(Object name) {
    return '將群組名更改為$name';
  }

  @override
  String changedGroupDescriptionTo(Object description) {
    return '將群組描述更改為$description';
  }

  @override
  String changedGroupAnnouncementTo(Object announcement) {
    return '將群組公告更改為$announcement';
  }

  @override
  String get changedGroupAvatar => '更改群組頭像';

  @override
  String transferredGroupOwnershipTo(Object owner) {
    return '將群組所有權轉讓給$owner';
  }

  @override
  String get changedGroupCustomInfo => '更改群組自定義信息';

  @override
  String get enabledGroupMute => '禁言全員';

  @override
  String get disabledGroupMute => '取消禁言全員';

  @override
  String changedGroupMessageReceptionTo(Object setting) {
    return '將群組消息接收設置更改為：$setting';
  }

  @override
  String changedApplyToJoinGroupTo(Object setting) {
    return '修改加群方式為：$setting';
  }

  @override
  String changedInviteToJoinGroupTo(Object setting) {
    return '修改邀請進群方式為：$setting';
  }

  @override
  String opUnmuted(Object user) {
    return '$user 取消靜音';
  }

  @override
  String opMuted(Object duration, Object user) {
    return '$user 靜音 $duration 秒';
  }

  @override
  String get groupTips => '群組提示';

  @override
  String get receiveMessages => '接收消息';

  @override
  String get doNotReceiveMessages => '不接收消息';

  @override
  String get receiveMessagesWhenOnlineOnly => '僅在線時接收消息';

  @override
  String get disallowJoinGroup => '禁止加群';

  @override
  String get joinGroupNeedApproval => '管理員審批';

  @override
  String get joinGroupDirectly => '自動審批';

  @override
  String get disallowInviting => '禁止邀請';

  @override
  String get requireApprovalForInviting => '管理員審批';

  @override
  String get joinDirectlyBeenInvited => '自動審批';

  @override
  String get unmuted => '取消靜音';

  @override
  String muteTime(Object duration) {
    return '靜音 $duration 秒';
  }

  @override
  String get poll => '投票';

  @override
  String callDuration(Object duration) {
    return '通話時長：$duration';
  }

  @override
  String get selectMembers => '揀選成員';

  @override
  String numSelectMembers(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num 已選',
      zero: '揀選成員',
    );
    return '$_temp0';
  }

  @override
  String get searchMembers => '搜索成員';

  @override
  String get startCall => '發起通話';

  @override
  String get clear => '清除';

  @override
  String groupSubtitle(Object count, Object name) {
    return '$name 和其他 $count 人';
  }

  @override
  String get markAsUnread => '標記為未讀';

  @override
  String get hide => '隱藏';

  @override
  String get unreadMessagesBelow => '下方未讀訊息';

  @override
  String get ar => 'اَلْعَرَبِيَّةُ';

  @override
  String get tencentCloudChat => '騰訊雲 IM';

  @override
  String get changeTheme => '改變外觀';

  @override
  String get deleteAccountNotification => '帳戶刪除後，您將無法使用目前帳戶，相關資料也將被刪除且無法找回。';

  @override
  String get restartAppForLanguage => '請重新啟動應用程式以使語言變更生效';

  @override
  String get deleteAllMessages => '清除聊天記錄';

  @override
  String get downloading => '下載中...';

  @override
  String get viewFullImage => '查看原圖';

  @override
  String get messageRecall => '訊息撤回';

  @override
  String get messageRecallConfirmation => '您確定要撤回這條訊息嗎？';

  @override
  String get quit => '退出群聊';

  @override
  String get setGroupName => '設置群組名稱';

  @override
  String get groupAddAny => '自動審批';

  @override
  String get groupAddAuth => '管理員審批';

  @override
  String get groupAddForbid => '禁止加群';

  @override
  String get groupOwner => '群主';

  @override
  String get groupMember => '成員';

  @override
  String get dismissAdmin => '取消管理員';

  @override
  String get welcomeToTencentCloudChat => '歡迎來到騰訊雲 IM';

  @override
  String get draft => '草稿';

  @override
  String get openInNewWindow => '在新視窗中開啟';

  @override
  String get selectAChat => '選擇一個聊天';

  @override
  String get noConversationSelected => '未選擇對話';

  @override
  String get unavailableToSendMessage => '無法發送消息';

  @override
  String get noSuchGroup => '沒有這個群組';

  @override
  String get notGroupMember => '不是群組成員';

  @override
  String get userNotFound => '找不到用戶';

  @override
  String get userBlockedYou => '用戶已屏蔽你';

  @override
  String get muted => '已靜音';

  @override
  String get groupMuted => '群組已靜音';

  @override
  String get cantSendMessage => '無法發送訊息';

  @override
  String get media => '媒體';

  @override
  String sendToSomeChat(String name) {
    return '發送給 $name';
  }

  @override
  String get unableToSendWithFolders => '由於包含檔案夾，無法發送檔案。請僅選擇檔案本身。';

  @override
  String get channelSwitch => '頻道：';

  @override
  String get weChat => 'WeChat';

  @override
  String get tGWA => 'Telegram 和 WhatsApp';

  @override
  String get contactUsIfQuestions => '如果有任何不清楚的地方或者您有更多的想法，請隨時聯絡我們！';

  @override
  String get chatNow => '立即對話';

  @override
  String get onlineServiceTimeFrom10To20 => '在線時間：週一至週五上午10點至晚上8點';

  @override
  String get officialWebsite => '官方網站';

  @override
  String get allSDKs => '所有 SDK';

  @override
  String get sourceCode => '源代碼';

  @override
  String get personalInformationCollectionList => '個人信息收集列表';

  @override
  String get thirdPartyInformationSharingList => '第三方信息分享列表';

  @override
  String get version => '版本';

  @override
  String get feedback => '反饋';

  @override
  String get me => '我';

  @override
  String get about => '關於';

  @override
  String get profile => '個人資料';

  @override
  String get unpin => '取消置頂';

  @override
  String mentionedMessages(num count) {
    return '$count 條訊息提及我';
  }

  @override
  String get longPressToNavigate => '按住查看';

  @override
  String get permissionDeniedTitle => '權限被禁止';

  @override
  String permissionDeniedContent(Object permissionString) {
    return '請前往設定並允許 $permissionString 權限。';
  }

  @override
  String get goToSettingsButtonText => '前往設定';

  @override
  String get originalMessageNotFound => '未找到原始訊息';

  @override
  String get markAsRead => '標為已讀';

  @override
  String get reEdit => '重新編輯';

  @override
  String get translate => '翻譯';

  @override
  String memberRecalledMessage(Object member) {
    return '$member撤回咗一條訊息';
  }

  @override
  String get copyFileSuccess => '複製文件成功';

  @override
  String get saveFileSuccess => '儲存文件成功';

  @override
  String get saveFileFailed => '儲存文件失敗';

  @override
  String get copyLinkSuccess => '複製連結成功';

  @override
  String get copyImageContextMenuBtnText => '複製圖片';

  @override
  String get saveToLocalContextMenuBtnText => '另存為';

  @override
  String get copyLinkContextMenuBtnText => '複製連結';

  @override
  String get openLinkContextMenuBtnText => '喺新窗口打開';

  @override
  String get translatedBy => '由騰訊 RTC 提供支持';

  @override
  String get convertToText => '轉換';

  @override
  String numMessages(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 條訊息',
      one: '1 條訊息',
    );
    return '$_temp0';
  }

  @override
  String get filterBy => '篩選';

  @override
  String get text => '文字';

  @override
  String get numMessagesOver99 => '99+ 條訊息';

  @override
  String get setGroupAnnouncement => '設置群公告';

  @override
  String get setNickName => '設置群名片';

  @override
  String get joinTime => '加入時間';

  @override
  String get myRoleInGroup => '角色';

  @override
  String get chooseAvatar => '選擇頭像';

  @override
  String get friendLimit => '您的好友數已達系統上限';

  @override
  String get otherFriendLimit => '對方的好友數已達系統上限';

  @override
  String get inBlacklist => '被加好友在自己的黑名單中';

  @override
  String get setInBlacklist => '您已被被對方設置為黑名單';

  @override
  String get forbidAddFriend => '對方已禁止加好友';

  @override
  String get waitAgreeFriend => '等待好友審核同意';

  @override
  String get haveBeFriend => '對方已是您的好友';

  @override
  String get contactAddFailed => '添加失敗';

  @override
  String get addGroupPermissionDeny => '禁止加群';

  @override
  String get addGroupAlreadyMember => '已經是群成員';

  @override
  String get addGroupNotFound => '群組不存在';

  @override
  String get addGroupFullMember => '群已滿員';

  @override
  String get joinedTip => '您已加入群:';

  @override
  String get quitGroupTip => '您確認退出該群？';

  @override
  String get dismissGroupTip => '您確認解散該群?';

  @override
  String get kickedOffTips => '您已被踢下線';

  @override
  String get userSigExpiredTips => '使用者簽名已過期';

  @override
  String get convertTextFailed => '轉換文字失敗';

  @override
  String get deleteFriendSuccess => '刪除好友成功';

  @override
  String get deleteFriendFailed => '刪除好友失敗';

  @override
  String get clearMsgTip => '確認清除聊天記錄？';

  @override
  String get sendMsg => '发送消息';

  @override
  String get groupMemberMute => '因被禁言而不能發送消息，請檢查發送者是否被設置禁言。';

  @override
  String get forwardFailedTip => '發送失敗訊息不支持轉發！';

  @override
  String get fileTooLarge => '文件大小超出了限制';

  @override
  String get invalidApplication => '好友申請失效';

  @override
  String get atMeTips => '有人@我';

  @override
  String get atAllTips => '@所有人';

  @override
  String get forwardVoteFailedTip => '投票訊息不支援轉發！';

  @override
  String get forwardOneByOneLimitNumberTip => '轉發訊息過多，暫不支持逐條轉發';

  @override
  String get modifyRemark => '修改备注';

  @override
  String banned(Object targetUser, Object time) {
    return '$targetUser 被禁言 $time';
  }

  @override
  String cancelBanned(Object targetUser) {
    return '$targetUser 被取消禁言';
  }

  @override
  String get day => '天';

  @override
  String get hour => '小時';

  @override
  String get min => '分';

  @override
  String get second => '秒';

  @override
  String get setFailed => '設置失敗';

  @override
  String get callRejectCaller => '對方已拒絕';

  @override
  String get callRejectCallee => '已拒絕';

  @override
  String get callCancelCaller => '已取消';

  @override
  String get callCancelCallee => '對方已取消';

  @override
  String get stopCallTip => '通話時長：';

  @override
  String get callTimeoutCaller => '對方無應答';

  @override
  String get callTimeoutCallee => '對方已取消';

  @override
  String get callLineBusyCaller => '對方忙線中';

  @override
  String get callLineBusyCallee => '對方已取消';

  @override
  String get acceptCall => '已接聽';

  @override
  String get callingSwitchToAudio => '視頻轉語音';

  @override
  String get callingSwitchToAudioAccept => '確認視頻轉語音';

  @override
  String get invalidCommand => '不能識別的通話指令';

  @override
  String get groupCallSend => '發起了群通話';

  @override
  String get groupCallEnd => '通話結束';

  @override
  String get groupCallNoAnswer => '未接聽';

  @override
  String get groupCallReject => '拒絕群通話';

  @override
  String get groupCallAccept => '接聽';

  @override
  String get groupCallConfirmSwitchToAudio => '同意視頻轉語音';

  @override
  String get callkitInPeerBlacklist => '發起通話失敗，用戶在黑名單中，禁止發起！';

  @override
  String get resendTips => '確定重發嗎？';

  @override
  String get logoutTip => '您確定要退出登錄嗎？';

  @override
  String get sendFileLimit => '你只能選擇9個文件';

  @override
  String get atAll => '所有人';

  @override
  String get tuiEmojiSmile => '[微笑]';

  @override
  String get tuiEmojiExpect => '[期待]';

  @override
  String get tuiEmojiBlink => '[眨眼]';

  @override
  String get tuiEmojiGuffaw => '[大笑]';

  @override
  String get tuiEmojiKindSmile => '[姨母笑]';

  @override
  String get tuiEmojiHaha => '[哈哈哈]';

  @override
  String get tuiEmojiCheerful => '[愉快]';

  @override
  String get tuiEmojiSpeechless => '[無語]';

  @override
  String get tuiEmojiAmazed => '[驚訝]';

  @override
  String get tuiEmojiSorrow => '[悲傷]';

  @override
  String get tuiEmojiComplacent => '[得意]';

  @override
  String get tuiEmojiSilly => '[傻了]';

  @override
  String get tuiEmojiLustful => '[色]';

  @override
  String get tuiEmojiGiggle => '[憨笑]';

  @override
  String get tuiEmojiKiss => '[親親]';

  @override
  String get tuiEmojiWail => '[大哭]';

  @override
  String get tuiEmojiTearsLaugh => '[哭笑]';

  @override
  String get tuiEmojiTrapped => '[困]';

  @override
  String get tuiEmojiMask => '[口罩]';

  @override
  String get tuiEmojiFear => '[恐懼]';

  @override
  String get tuiEmojiBareTeeth => '[齜牙]';

  @override
  String get tuiEmojiFlareUp => '[發怒]';

  @override
  String get tuiEmojiYawn => '[打哈欠]';

  @override
  String get tuiEmojiTact => '[機智]';

  @override
  String get tuiEmojiStareyes => '[星星眼]';

  @override
  String get tuiEmojiShutUp => '[閉嘴]';

  @override
  String get tuiEmojiSigh => '[嘆氣]';

  @override
  String get tuiEmojiHehe => '[呵呵]';

  @override
  String get tuiEmojiSilent => '[收聲]';

  @override
  String get tuiEmojiSurprised => '[驚喜]';

  @override
  String get tuiEmojiAskance => '[白眼]';

  @override
  String get tuiEmojiOk => '[OK]';

  @override
  String get tuiEmojiShit => '[便便]';

  @override
  String get tuiEmojiMonster => '[怪獸]';

  @override
  String get tuiEmojiDaemon => '[惡魔]';

  @override
  String get tuiEmojiRage => '[惡魔怒]';

  @override
  String get tuiEmojiFool => '[衰]';

  @override
  String get tuiEmojiPig => '[豬]';

  @override
  String get tuiEmojiCow => '[牛]';

  @override
  String get tuiEmojiAi => '[AI]';

  @override
  String get tuiEmojiSkull => '[骷髏]';

  @override
  String get tuiEmojiBombs => '[炸彈]';

  @override
  String get tuiEmojiCoffee => '[咖啡]';

  @override
  String get tuiEmojiCake => '[蛋糕]';

  @override
  String get tuiEmojiBeer => '[啤酒]';

  @override
  String get tuiEmojiFlower => '[花]';

  @override
  String get tuiEmojiWatermelon => '[瓜]';

  @override
  String get tuiEmojiRich => '[壕]';

  @override
  String get tuiEmojiHeart => '[愛心]';

  @override
  String get tuiEmojiMoon => '[月亮]';

  @override
  String get tuiEmojiSun => '[太陽]';

  @override
  String get tuiEmojiStar => '[星星]';

  @override
  String get tuiEmojiRedPacket => '[红包]';

  @override
  String get tuiEmojiCelebrate => '[慶祝]';

  @override
  String get tuiEmojiBless => '[福]';

  @override
  String get tuiEmojiFortune => '[發]';

  @override
  String get tuiEmojiConvinced => '[服]';

  @override
  String get tuiEmojiProhibit => '[禁]';

  @override
  String get tuiEmoji666 => '[666]';

  @override
  String get tuiEmoji857 => '[857]';

  @override
  String get tuiEmojiKnife => '[刀]';

  @override
  String get tuiEmojiLike => '[讚]';

  @override
  String get startConversation => '發起會話';

  @override
  String get createGroupChat => '創建群聊';

  @override
  String get createGroupTips => '創建群組';

  @override
  String get createCommunity => '創建社群';

  @override
  String get communityIDEditFormatTips => '社群 ID 前綴必須為 @TGS#_ !';

  @override
  String get groupIDEditFormatTips => '群組 ID 前綴不能為 @TGS# !';

  @override
  String get groupIDEditExceedTips => '群組 ID 最長 48 字節!';

  @override
  String get groupTypeContentButton => '查看產品文檔';

  @override
  String get create => '創建';

  @override
  String get groupName => '群名稱';

  @override
  String get groupIDOption => '群ID (選填)';

  @override
  String get groupFaceUrl => '群頭像';

  @override
  String get groupMemberSelected => '已選擇的群成員';

  @override
  String get groupWorkType => '好友工作群(Work)';

  @override
  String get groupPublicType => '陌生人社交群(Public)';

  @override
  String get groupMeetingType => '臨時會議群(Meeting)';

  @override
  String get groupCommunityType => '社群(Community)';

  @override
  String get groupWorkDesc => '好友工作群(Work）：類似普通微信群，創建後僅支持已在群內的好友邀請加群，且無需被邀請方同意或群主審批。';

  @override
  String get groupPublicDesc => '陌生人社交群(Public）：類似 QQ 群，創建後群主可以指定群管理員，用戶搜索群 ID 發起加群申請後，需要群主或管理員審批通過才能入群。';

  @override
  String get groupMeetingDesc => '臨時會議群(Meeting）：創建後可以隨意進出，且支持查看入群前消息；適用於音視頻會議場景、在線教育場景等與實時音視頻產品結合的場景。';

  @override
  String get groupCommunityDesc => '社群(Community)：創建後可以隨意進出，最多支持100000人，支持歷史消息存儲，用戶搜索群 ID 發起加群申請後，無需管理員審批即可進群。';

  @override
  String get groupDetail => '群聊詳情';

  @override
  String get transferGroupOwner => '轉讓群主';

  @override
  String get privateGroup => '討論組';

  @override
  String get publicGroup => '公開群';

  @override
  String get chatRoom => '聊天室';

  @override
  String get communityGroup => '社群';

  @override
  String get serverGroupInvalidReq => '請求非法';

  @override
  String get serverGroupReqAlreadyBeenProcessed => '此邀請或者申請請求已經被處理。';

  @override
  String inviteToGroupFrom(Object inviter) {
    return '來自$inviter的邀請';
  }

  @override
  String get applyToJoin => '申請加入:';

  @override
  String get requestWait => '邀請成功，等待處理';

  @override
  String dismissGroupTips(Object groupName) {
    return '您所在的群組 $groupName 已解散';
  }
}
