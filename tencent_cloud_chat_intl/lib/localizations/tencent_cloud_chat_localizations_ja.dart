// Copyright (c) 1998-2024 Tencent, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:intl/intl.dart' as intl;

import 'tencent_cloud_chat_localizations.dart';

/// The translations for Japanese (`ja`).
class TencentCloudChatLocalizationsJa extends TencentCloudChatLocalizations {
  TencentCloudChatLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get album => 'アルバム';

  @override
  String get chat => 'チャット';

  @override
  String get chats => 'チャット';

  @override
  String get calls => '通話';

  @override
  String get search => '検索';

  @override
  String get contacts => '連絡先';

  @override
  String get settings => '設定';

  @override
  String get online => 'オンライン';

  @override
  String get offline => 'オフライン';

  @override
  String get sendAMessage => 'メッセージ';

  @override
  String get done => '完了';

  @override
  String get archive => 'アーカイブ';

  @override
  String get read => '既読';

  @override
  String get readAll => '既読';

  @override
  String get delete => '削除';

  @override
  String get newChat => '新規チャット';

  @override
  String get newGroup => '新規グループ';

  @override
  String get frequentlyContacted => 'よく連絡する人';

  @override
  String get addParticipants => 'メンバー追加';

  @override
  String get addMembers => 'メンバー追加';

  @override
  String get cancel => 'キャンセル';

  @override
  String get next => '次へ';

  @override
  String get back => '戻る';

  @override
  String get groupID => 'グループID';

  @override
  String get groupIDCertificate => 'グループID（証明書）';

  @override
  String get groupOfType => 'グループの種類';

  @override
  String get typeOfGroup => 'グループの種類';

  @override
  String get work => '仕事';

  @override
  String get public => '公開';

  @override
  String get meeting => '会議';

  @override
  String get avChatRoom => 'AVチャットルーム';

  @override
  String get groupPortrait => 'グループポートレート';

  @override
  String get participants => '参加者';

  @override
  String get seeDocs => 'ドキュメントを見る';

  @override
  String get you => 'あなた';

  @override
  String get today => '今日';

  @override
  String get yesterday => '昨日';

  @override
  String youCreatedGroup(String groupName) {
    return 'あなたが作成したグループ $groupName';
  }

  @override
  String get groups => 'グループ';

  @override
  String get chatRecord => 'メッセージ';

  @override
  String get messages => 'メッセージ';

  @override
  String get more => 'もっと';

  @override
  String get noConversationsContactsOrMessagesFound => '会話、連絡先、メッセージが見つかりません';

  @override
  String get contactInfo => '連絡先情報';

  @override
  String get exportChat => 'チャットをエクスポート';

  @override
  String get clearChat => 'チャットをクリア';

  @override
  String get deleteChat => 'チャットを削除';

  @override
  String get video => 'ビデオ';

  @override
  String get videoCall => 'ビデオ通話';

  @override
  String get missedVideoCall => 'ビデオ通話を見逃しました';

  @override
  String get voice => '音声';

  @override
  String get voiceCall => '音声通話';

  @override
  String get missedVoiceCall => '音声通話を見逃しました';

  @override
  String get location => '場所';

  @override
  String get youStartedACall => 'あなたが通話を開始しました';

  @override
  String get star => 'スター';

  @override
  String get copy => 'コピー';

  @override
  String get forward => '転送';

  @override
  String get multiSelect => '多肢選択';

  @override
  String get select => '選択';

  @override
  String get quote => '引用';

  @override
  String get reply => '返信';

  @override
  String get all => 'すべて';

  @override
  String get tapToRemove => 'タップして削除';

  @override
  String get messageInfo => 'メッセージ情報';

  @override
  String get delivered => '配信済み';

  @override
  String get readBy => '既読者';

  @override
  String get deliveredTo => '配信先';

  @override
  String numSelect(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num 選択済み',
      zero: 'メッセージを選択',
    );
    return '$_temp0';
  }

  @override
  String numChats(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num チャット',
      one: '1 チャット',
      zero: 'チャットが選択されていません',
    );
    return '$_temp0';
  }

  @override
  String get recentChats => '最近のチャット';

  @override
  String numThreadQuote(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num スレッド引用',
      one: '$num スレッド引用',
    );
    return '$_temp0';
  }

  @override
  String get swipeLeftToCancelOrReleaseToSend => '左にスワイプしてキャンセル、または送信するためにリリース';

  @override
  String get releaseToCancel => 'キャンセルするためにリリース';

  @override
  String get camera => 'カメラ';

  @override
  String get document => 'ドキュメント';

  @override
  String get file => 'ファイル';

  @override
  String get photos => '写真';

  @override
  String get contact => '連絡先';

  @override
  String get custom => 'カスタム';

  @override
  String get message => 'メッセージ';

  @override
  String get doNotDisturb => 'メッセージを邪魔しないでください';

  @override
  String get mute => 'ミュート';

  @override
  String get pin => '固定されたチャット';

  @override
  String get blackUser => 'ユーザーをブロック';

  @override
  String get blockUser => 'ユーザーをブロック';

  @override
  String get saveContact => '連絡先を保存';

  @override
  String get call => '通話';

  @override
  String get clearingChatHistory => 'メッセージをクリア';

  @override
  String get clearMessages => 'メッセージをクリア';

  @override
  String get firstName => '名';

  @override
  String get lastName => '姓';

  @override
  String get groupNotice => 'グループ通知';

  @override
  String get groupOfAnnouncement => 'グループ通知';

  @override
  String get groupManagement => 'グループ管理';

  @override
  String get groupType => 'グループタイプ';

  @override
  String get addGroupWay => 'グループに参加するための積極的な方法';

  @override
  String get inviteGroupType => 'グループに招待する方法';

  @override
  String get myAliasInGroup => 'グループ内の私のエイリアス';

  @override
  String get myGroupNickName => 'グループ内の私のエイリアス';

  @override
  String get groupMembers => 'グループメンバー';

  @override
  String get admin => '管理者';

  @override
  String adminNum(int num) {
    return '管理者 ($num)';
  }

  @override
  String get info => '情報';

  @override
  String get setAsAdmin => '管理者に設定';

  @override
  String get announcement => 'グループ通知';

  @override
  String get totalSilence => 'すべてをミュート';

  @override
  String get silenceAll => 'すべてをミュート';

  @override
  String get addSilencedMember => 'ミュートされたメンバーを追加';

  @override
  String get onlyGroupOwnerAndAdminsCanSendMessages => '有効にすると、グループの所有者と管理者のみがメッセージを送信できます。';

  @override
  String someoneEnabledSilenceAll(String name) {
    return '$name が \'すべてをミュート\' を有効にしました';
  }

  @override
  String someoneDisabledSilenceAll(String name) {
    return '$name が \'すべてをミュート\' を無効にしました';
  }

  @override
  String get newContacts => '新しい連絡先';

  @override
  String get myGroup => '私のグループ';

  @override
  String get theBlackList => 'ブロックリスト';

  @override
  String get blockList => 'ブロックされたユーザー';

  @override
  String get groupChatNotifications => 'グループチャット通知';

  @override
  String get userID => 'ユーザーID';

  @override
  String myUserID(String userID) {
    return '私のユーザーID: $userID';
  }

  @override
  String get searchUserID => 'SearchUserID';

  @override
  String get none => 'なし';

  @override
  String iDis(String userID) {
    return 'ID: $userID';
  }

  @override
  String get addToContacts => '連絡先に追加';

  @override
  String get addContact => '連絡先を追加';

  @override
  String get bio => '自己紹介';

  @override
  String bioIs(String bio) {
    return '自己紹介: $bio';
  }

  @override
  String get fillInTheVerificationInformation => 'リクエストを送信';

  @override
  String get remarkAndGrouping => '備考とグループ化';

  @override
  String get remark => '備考';

  @override
  String get group => 'グループ';

  @override
  String get send => '送信';

  @override
  String get contactAddedSuccessfully => '連絡先が正常に追加されました';

  @override
  String get requestSent => 'リクエストが送信されました';

  @override
  String get cannotAddContact => '連絡先を追加できません';

  @override
  String get addGroup => 'グループを追加';

  @override
  String typeIs(String type) {
    return 'タイプ: $type';
  }

  @override
  String get groupNotAcceptingRequests => 'グループがリクエストを受け付けていません';

  @override
  String get joinedGroupSuccessfully => 'グループに正常に参加しました';

  @override
  String numNewApplications(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num 新しいアプリケーション',
      one: '$num 新しいアプリケーション',
    );
    return '$_temp0';
  }

  @override
  String get agree => '承認';

  @override
  String get accept => '承認';

  @override
  String get refuse => '拒否';

  @override
  String get decline => '拒否';

  @override
  String get verificationMessage => '確認メッセージ';

  @override
  String get accepted => '承認済み';

  @override
  String get declined => '拒否済み';

  @override
  String get confirm => '確認';

  @override
  String get contactRequest => '連絡先リクエスト';

  @override
  String get contactsPermission => '連絡先の許可';

  @override
  String get allowAnyUserAddYouAsContact => '誰でもあなたを連絡先に追加できるようにする';

  @override
  String get declineContactRequestFromAnyUser => '連絡先リクエストを自動的に拒否する';

  @override
  String get anyoneUponRequest => 'リクエストを手動で承認する';

  @override
  String get theme => 'テーマ';

  @override
  String get language => '言語';

  @override
  String get aboutTencentCloudChat => 'Tencent Cloud Chatについて';

  @override
  String get logIn => 'ログイン';

  @override
  String get signIn => 'サインイン';

  @override
  String get signUp => 'サインアップ';

  @override
  String get signOut => 'サインアウト';

  @override
  String get logOut => 'ログアウト';

  @override
  String get signature => '自己紹介';

  @override
  String get gender => '性別';

  @override
  String get birthday => '誕生日';

  @override
  String get male => '男性';

  @override
  String get female => '女性';

  @override
  String get unspecified => '未指定';

  @override
  String get unknown => '不明';

  @override
  String get sdkVersion => 'SDKバージョン';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get userAgreement => 'ユーザー同意書';

  @override
  String get disclaimer => '免責事項';

  @override
  String get personalInformationCollected => '収集された個人情報';

  @override
  String get informationSharedWithThirdParties => '第三者と共有される情報';

  @override
  String get deleteAccount => 'アカウントを削除';

  @override
  String get contactUs => 'お問い合わせ';

  @override
  String get countryOrRegion => '国 / 地域';

  @override
  String get selectACountry => '国または地域を選択';

  @override
  String get phoneNumber => '電話番号';

  @override
  String get email => 'EMail';

  @override
  String get verificationCode => '確認コード';

  @override
  String get enterSMSCode => 'SMSで送信されたコードを入力';

  @override
  String get sendCode => 'コードを送信';

  @override
  String get visitOurWebsite => 'ウェブサイトを訪問';

  @override
  String get english => '英語';

  @override
  String get simplifiedChinese => '简体中文';

  @override
  String get traditionalChinese => '繁體中文';

  @override
  String get japanese => '日本語';

  @override
  String get korean => '한국어';

  @override
  String get style => 'スタイル';

  @override
  String get classic => 'クラシック';

  @override
  String get minimalist => 'ミニマリスト';

  @override
  String get messageReadStatus => 'メッセージの既読ステータス';

  @override
  String get messageReadStatusDescription => 'あなたのメッセージの既読ステータスが表示されるかどうかを制御し、他の人があなたのメッセージを読んだかどうかを確認できるかどうかを制御します。';

  @override
  String get onlineStatus => 'オンラインステータス';

  @override
  String get onlineStatusDescription => 'オンラインステータスが連絡先に表示されるかどうかを決定します。';

  @override
  String get noBio => '自己紹介がありません';

  @override
  String get noConversation => '会話がありません';

  @override
  String get sound => 'サウンド';

  @override
  String get sticker => 'ステッカー';

  @override
  String get image => '画像';

  @override
  String get chatHistory => 'チャット履歴';

  @override
  String get audio => 'オーディオ';

  @override
  String get messageDeleted => 'メッセージが削除されました';

  @override
  String get messageRecalled => 'メッセージが取り消されました';

  @override
  String unreadCount(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num 未読メッセージ',
      one: '$num 未読メッセージ',
    );
    return '$_temp0';
  }

  @override
  String newMsgCount(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num 新しいメッセージ',
      one: '新しいメッセージ',
    );
    return '$_temp0';
  }

  @override
  String get takeAPhoto => '写真を撮る';

  @override
  String get recordAVideo => 'ビデオを録画する';

  @override
  String get pullDownToLoadMoreMessages => 'メッセージをさらに読み込むために引き下げる';

  @override
  String get releaseToLoadMore => 'もっと読み込むためにリリース';

  @override
  String get noMoreMessage => 'これ以上メッセージはありません';

  @override
  String get pullUpToLoadMoreMessages => 'メッセージをさらに読み込むために引き上げる';

  @override
  String get holdToRecordReleaseToSend => '録音するために押し続け、送信するためにリリース';

  @override
  String get forwardIndividually => '個別に転送';

  @override
  String get forwardCombined => 'まとめて転送';

  @override
  String get selectConversations => '会話を選択';

  @override
  String get recent => '最近';

  @override
  String get recall => 'リコール';

  @override
  String replyTo(String name) {
    return '$name に返信';
  }

  @override
  String get confirmDeletion => '削除の確認';

  @override
  String get askDeleteThisMessage => 'このメッセージを削除しますか？';

  @override
  String deleteMessageCount(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num件のメッセージを削除しますか？',
      one: 'メッセージを削除しますか？',
      zero: 'メッセージは削除されていません',
    );
    return '$_temp0';
  }

  @override
  String memberReadCount(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num人のメンバーが読んだ',
      one: '1人のメンバーが読んだ',
      zero: 'メンバーが読んでいません',
    );
    return '$_temp0';
  }

  @override
  String get allMembersRead => '全メンバーが読んだ';

  @override
  String get allowAny => 'Allow Any';

  @override
  String get cannotSendApplicationToWorkGroup => '作業グループにアプリケーションを送信できません';

  @override
  String get appearance => 'Appearance';

  @override
  String get darkTheme => 'Dark';

  @override
  String get denyAny => 'Deny Any';

  @override
  String get edit => '編集';

  @override
  String get friendsPermission => '友達の許可';

  @override
  String get groupJoined => 'グループに参加しました';

  @override
  String get lightTheme => 'Light';

  @override
  String get noBlockList => 'ブロックされたユーザーはいません';

  @override
  String get noContact => '連絡先がありません';

  @override
  String get noNewApplication => '新しいアプリケーションはありません';

  @override
  String get permissionNeeded => '許可が必要です';

  @override
  String get requireRequest => 'リクエストが必要です';

  @override
  String get setNickname => 'ニックネームを設定する';

  @override
  String get setSignature => '署名を設定する';

  @override
  String get validationMessages => '検証メッセージ';

  @override
  String get getVerification => '検証を取得する';

  @override
  String get invalidEmail => '無効なメールアドレス';

  @override
  String get invalidPhoneNumber => '無効な電話番号';

  @override
  String get invalidVerification => '無効な検証';

  @override
  String get searchGroupID => 'グループIDを検索する';

  @override
  String get callInitiated => '通話が開始されました';

  @override
  String get callAccepted => '通話が受け入れられました';

  @override
  String get callDeclined => '通話が拒否されました';

  @override
  String get noAnswer => '応答がありません';

  @override
  String get lineBusy => '回線が混んでいます';

  @override
  String get callHungUp => '通話が切れました';

  @override
  String get callInProgress => '通話中';

  @override
  String get callEnded => '通話が終了しました';

  @override
  String get unknownCallStatus => 'Calling';

  @override
  String get groupChatCreated => 'グループチャットが正常に作成されました！';

  @override
  String get vote => '投票';

  @override
  String get callCancelled => '通話がキャンセルされました';

  @override
  String get unknownGroupTips => '不明なグループのヒント';

  @override
  String memberJoinedGroup(Object members) {
    return '$membersがグループに参加しました';
  }

  @override
  String opInvitedToGroup(Object members, Object opMember) {
    return '$opMemberが$membersをグループに招待しました';
  }

  @override
  String memberLeftGroup(Object members) {
    return '$membersがグループを退出しました';
  }

  @override
  String opRemovedFromGroup(Object members, Object opMember) {
    return '$opMemberが$membersをグループから削除しました';
  }

  @override
  String opPromotedToAdmin(Object members, Object opMember) {
    return '$opMemberが$membersを管理者に昇格させました';
  }

  @override
  String opRevokedAdmin(Object members, Object opMember) {
    return '$opMemberが$membersから管理者権限を取り消しました';
  }

  @override
  String setToAdmin(Object members) {
    return '$members管理者として設定';
  }

  @override
  String revokedAdmin(Object members) {
    return '$membersキャンセルされた管理者';
  }

  @override
  String opChangedGroupInfo(Object groupInfo, Object opMember) {
    return '$opMemberが$groupInfoを変更しました';
  }

  @override
  String opChangedMemberInfo(Object memberInfo, Object opMember) {
    return '$opMemberが$memberInfoを変更しました';
  }

  @override
  String changedGroupNameTo(Object name) {
    return 'グループ名を$nameに変更しました';
  }

  @override
  String changedGroupDescriptionTo(Object description) {
    return 'グループの説明を$descriptionに変更しました';
  }

  @override
  String changedGroupAnnouncementTo(Object announcement) {
    return 'グループのアナウンスメントを$announcementに変更しました';
  }

  @override
  String get changedGroupAvatar => 'グループのアバターを変更しました';

  @override
  String transferredGroupOwnershipTo(Object owner) {
    return 'グループの所有権を$ownerに譲渡しました';
  }

  @override
  String get changedGroupCustomInfo => 'グループのカスタム情報を変更しました';

  @override
  String get enabledGroupMute => 'メンバー全員を禁止する';

  @override
  String get disabledGroupMute => 'すべてのメンバーの禁止を解除する';

  @override
  String changedGroupMessageReceptionTo(Object setting) {
    return 'グループのメッセージ受信設定を$settingに変更しました';
  }

  @override
  String changedApplyToJoinGroupTo(Object setting) {
    return '그룹 가입 방법을 다음으로 수정하세요: $setting';
  }

  @override
  String changedInviteToJoinGroupTo(Object setting) {
    return 'グループに参加するための招待方法を変更します: $setting';
  }

  @override
  String opUnmuted(Object user) {
    return '$userのミュートを解除しました';
  }

  @override
  String opMuted(Object duration, Object user) {
    return '$userを$duration秒間ミュートしました';
  }

  @override
  String get groupTips => 'グループのヒント';

  @override
  String get receiveMessages => 'メッセージを受信する';

  @override
  String get doNotReceiveMessages => 'メッセージを受信しない';

  @override
  String get receiveMessagesWhenOnlineOnly => 'オンライン時のみメッセージを受信する';

  @override
  String get disallowJoinGroup => 'グループへの参加は禁止です';

  @override
  String get joinGroupNeedApproval => 'グループへの参加申請に管理者の承認が必要です';

  @override
  String get joinGroupDirectly => '申請後に直接グループに参加する';

  @override
  String get disallowInviting => '招待を無効にする';

  @override
  String get requireApprovalForInviting => 'グループへの招待に管理者の承認が必要です';

  @override
  String get joinDirectlyBeenInvited => '招待された後に直接グループに参加する';

  @override
  String get unmuted => 'ミュート解除';

  @override
  String muteTime(Object duration) {
    return '$duration秒間ミュート';
  }

  @override
  String get poll => '投票';

  @override
  String callDuration(Object duration) {
    return '通話時間：$duration';
  }

  @override
  String get selectMembers => 'メンバーを選択';

  @override
  String numSelectMembers(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num人を選択',
      zero: 'メンバーを選択',
    );
    return '$_temp0';
  }

  @override
  String get searchMembers => 'メンバーを検索';

  @override
  String get startCall => '通話を開始する';

  @override
  String get clear => 'クリア';

  @override
  String groupSubtitle(Object count, Object name) {
    return '$nameと$count人の他のメンバー';
  }

  @override
  String get markAsUnread => '未読にする';

  @override
  String get hide => '非表示';

  @override
  String get unreadMessagesBelow => '未読メッセージが下にあります';

  @override
  String get ar => 'اَلْعَرَبِيَّةُ';

  @override
  String get tencentCloudChat => 'Tencent Cloud Chat';

  @override
  String get changeTheme => '外観を変更';

  @override
  String get deleteAccountNotification => 'アカウントを削除すると、現在のアカウントを使用できなくなり、関連データが削除されて復元できなくなります。';

  @override
  String get restartAppForLanguage => '言語の変更を適用するには、アプリを再起動してください';

  @override
  String get deleteAllMessages => 'チャット履歴をクリアする';

  @override
  String get downloading => 'ダウンロード中...';

  @override
  String get viewFullImage => 'フル画像を表示';

  @override
  String get messageRecall => 'メッセージを取り消す';

  @override
  String get messageRecallConfirmation => 'このメッセージを取り消してもよろしいですか？';

  @override
  String get quit => 'グループチャットを終了する';

  @override
  String get dissolve => 'グループを解散する';

  @override
  String get setGroupName => 'グループ名の設定';

  @override
  String get groupAddAny => '自動承認';

  @override
  String get groupAddAuth => '管理者の承認';

  @override
  String get groupAddForbid => 'グループへの参加は禁止です';

  @override
  String get groupOwner => 'グループのオーナー';

  @override
  String get groupMember => 'メンバー';

  @override
  String get dismissAdmin => '管理者を解任';

  @override
  String get welcomeToTencentCloudChat => 'テンセントクラウドチャットへようこそ';

  @override
  String get draft => '下書き';

  @override
  String get openInNewWindow => '新しいウィンドウで開く';

  @override
  String get selectAChat => 'チャットを選択';

  @override
  String get noConversationSelected => '選択された会話がありません';

  @override
  String get unavailableToSendMessage => 'メッセージを送信できません';

  @override
  String get noSuchGroup => 'そのようなグループはありません';

  @override
  String get notGroupMember => 'グループメンバーではありません';

  @override
  String get userNotFound => 'ユーザーが見つかりません';

  @override
  String get userBlockedYou => 'ユーザーにブロックされました';

  @override
  String get muted => 'ミュート';

  @override
  String get groupMuted => 'グループがミュートされました';

  @override
  String get cantSendMessage => 'メッセージを送信できません';

  @override
  String get media => 'メディア';

  @override
  String sendToSomeChat(String name) {
    return '$nameに送信';
  }

  @override
  String get unableToSendWithFolders => 'フォルダが含まれているため、ファイルを送信できません。個々のファイルのみを選択してください。';

  @override
  String get channelSwitch => 'チャンネル：';

  @override
  String get weChat => 'WeChat';

  @override
  String get tGWA => 'Telegram & WhatsApp';

  @override
  String get contactUsIfQuestions => 'わからないことやアイデアがあれば、お気軽にお問い合わせください！';

  @override
  String get chatNow => '今すぐチャット';

  @override
  String get onlineServiceTimeFrom10To20 => 'オンライン時間：月曜日から金曜日の午前10時から午後8時';

  @override
  String get officialWebsite => '公式ウェブサイト';

  @override
  String get allSDKs => 'すべてのSDK';

  @override
  String get sourceCode => 'ソースコード';

  @override
  String get personalInformationCollectionList => '個人情報収集リスト';

  @override
  String get thirdPartyInformationSharingList => '第三者情報共有リスト';

  @override
  String get version => 'バージョン';

  @override
  String get feedback => 'フィードバック';

  @override
  String get me => '自分';

  @override
  String get about => '紹介';

  @override
  String get profile => 'プロフィール';

  @override
  String get unpin => 'ピン留めを解除';

  @override
  String mentionedMessages(num count) {
    return '私への $count 件のメンション';
  }

  @override
  String get longPressToNavigate => '押し続けて表示';

  @override
  String get permissionDeniedTitle => 'アクセス権限が拒否されました';

  @override
  String permissionDeniedContent(Object permissionString) {
    return '設定に移動して $permissionString 権限を有効にしてください。';
  }

  @override
  String get goToSettingsButtonText => '設定へ';

  @override
  String get originalMessageNotFound => '元のメッセージが見つかりません';

  @override
  String get markAsRead => '既読にする';

  @override
  String get reEdit => '再編集';

  @override
  String get translate => '翻訳';

  @override
  String memberRecalledMessage(Object member) {
    return '$memberがメッセージを取り消しました';
  }

  @override
  String get copyFileSuccess => 'ファイルのコピーに成功しました';

  @override
  String get saveFileSuccess => 'ファイルの保存に成功しました';

  @override
  String get saveFileFailed => 'ファイルの保存に失敗しました';

  @override
  String get copyLinkSuccess => 'リンクをコピーしました';

  @override
  String get copyImageContextMenuBtnText => '画像をコピー';

  @override
  String get saveToLocalContextMenuBtnText => '名前を付けて保存';

  @override
  String get copyLinkContextMenuBtnText => 'リンクをコピー';

  @override
  String get openLinkContextMenuBtnText => '新しいウィンドウで開く';

  @override
  String get reactionList => 'Reaction List';

  @override
  String get translatedBy => 'Tencent RTC によって提供される';

  @override
  String get convertToText => '変換';

  @override
  String numMessages(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件のメッセージ',
      one: '1 件のメッセージ',
    );
    return '$_temp0';
  }

  @override
  String get filterBy => 'フィルター';

  @override
  String get text => 'テキスト';

  @override
  String get numMessagesOver99 => '99+ 件のメッセージ';

  @override
  String get setGroupAnnouncement => 'グループ通知を設定';

  @override
  String get setNickName => 'グループ名の設定';

  @override
  String get joinTime => '参加時間';

  @override
  String get myRoleInGroup => '役割';

  @override
  String get chooseAvatar => 'アバターを選択';

  @override
  String get friendLimit => '友達の数がシステムの制限に達しました';

  @override
  String get otherFriendLimit => '相手の友達数がシステムの上限に達しています';

  @override
  String get inBlacklist => 'ブラックリストに友達として追加される';

  @override
  String get setInBlacklist => '相手からブラックリストに登録されている';

  @override
  String get forbidAddFriend => '相手が友達追加を禁止されている';

  @override
  String get waitAgreeFriend => '友達からのレビューと承認を待っています';

  @override
  String get haveBeFriend => '相手はすでにあなたの友達です';

  @override
  String get contactAddFailed => '追加に失敗しました';

  @override
  String get addGroupPermissionDeny => 'グループへの参加は禁止です';

  @override
  String get addGroupAlreadyMember => 'すでにグループメンバーです';

  @override
  String get addGroupNotFound => 'グループが存在しません';

  @override
  String get addGroupFullMember => 'グループは満員です';

  @override
  String get joinedTip => 'あなたはグループに参加しました:';

  @override
  String get quitGroupTip => 'このグループを退会してもよろしいですか?';

  @override
  String get dismissGroupTip => '本当にこのグループを解散しますか？';

  @override
  String get kickedOffTips => 'オフラインにされました';

  @override
  String get userSigExpiredTips => 'ユーザーの署名の有効期限が切れています';

  @override
  String get convertTextFailed => 'テキストの変換に失敗しました';

  @override
  String get deleteFriendSuccess => '友達を正常に削除しました';

  @override
  String get deleteFriendFailed => '友達の削除に失敗しました';

  @override
  String get clearMsgTip => 'チャット履歴を消去しますか?';

  @override
  String get sendMsg => 'メッセージを送信';

  @override
  String get groupMemberMute => 'メッセージは禁止されているため送信できません。送信者が禁止されているかどうかを確認してください。';

  @override
  String get forwardFailedTip => '失敗したメッセージの転送はサポートされていません。';

  @override
  String get fileTooLarge => 'ファイルサイズが制限を超えています';

  @override
  String get invalidApplication => 'フレンド申請無効';

  @override
  String get atMeTips => '誰かが私に来て';

  @override
  String get atAllTips => '@みんな';

  @override
  String get forwardVoteFailedTip => '投票メッセージは転送をサポートしていません。';

  @override
  String get forwardOneByOneLimitNumberTip => '転送されたメッセージが多すぎます。現時点では、1 つずつの転送はサポートされていません。';

  @override
  String get modifyRemark => '修改备注';

  @override
  String banned(Object targetUser, Object time) {
    return '$targetUser 禁止された $time';
  }

  @override
  String cancelBanned(Object targetUser) {
    return '$targetUser の禁止が解除されました';
  }

  @override
  String get day => '日';

  @override
  String get hour => '時';

  @override
  String get min => '分';

  @override
  String get second => '秒';

  @override
  String get setFailed => 'セットアップに失敗しました';

  @override
  String get callRejectCaller => '相手が拒否しました';

  @override
  String get callRejectCallee => '拒否されました';

  @override
  String get callCancelCaller => 'キャンセル';

  @override
  String get callCancelCallee => '相手がキャンセルした';

  @override
  String get stopCallTip => '通話時間:';

  @override
  String get callTimeoutCaller => '相手からの応答がありません';

  @override
  String get callTimeoutCallee => '相手がキャンセルした';

  @override
  String get callLineBusyCaller => '相手は忙しいです';

  @override
  String get callLineBusyCallee => '相手がキャンセルした';

  @override
  String get acceptCall => '答えた';

  @override
  String get callingSwitchToAudio => 'ビデオから音声へ';

  @override
  String get callingSwitchToAudioAccept => 'ビデオから音声への変換を確認する';

  @override
  String get invalidCommand => '認識できない呼び出しコマンド';

  @override
  String get groupCallSend => 'グループ通話が始まりました';

  @override
  String get groupCallEnd => '通話が終了しました';

  @override
  String get groupCallNoAnswer => '答えはありません';

  @override
  String get groupCallReject => 'グループ通話を拒否する';

  @override
  String get groupCallAccept => '答え';

  @override
  String get groupCallConfirmSwitchToAudio => '動画を音声に変換することに同意する';

  @override
  String get callkitInPeerBlacklist => 'ユーザーはブラックリストに登録され、通話が開始できませんでした。';

  @override
  String get resendTips => '再送信してもよろしいですか?';

  @override
  String get logoutTip => 'ログアウトしてもよろしいですか?';

  @override
  String get sendFileLimit => '選択できるファイルは 9 個までです';

  @override
  String get atAll => 'みんな';

  @override
  String get tuiEmojiSmile => '[微笑]';

  @override
  String get tuiEmojiExpect => '[期待]';

  @override
  String get tuiEmojiBlink => '[ウィンク]';

  @override
  String get tuiEmojiGuffaw => '[大笑い]';

  @override
  String get tuiEmojiKindSmile => '[おばさん笑い]';

  @override
  String get tuiEmojiHaha => '[ははは]';

  @override
  String get tuiEmojiCheerful => '[楽しい]';

  @override
  String get tuiEmojiSpeechless => '[呆れ]';

  @override
  String get tuiEmojiAmazed => '[驚き]';

  @override
  String get tuiEmojiSorrow => '[悲しみ]';

  @override
  String get tuiEmojiComplacent => '[得意げ]';

  @override
  String get tuiEmojiSilly => '[バカ]';

  @override
  String get tuiEmojiLustful => '[色気]';

  @override
  String get tuiEmojiGiggle => '[にこにこ笑い]';

  @override
  String get tuiEmojiKiss => '[キス]';

  @override
  String get tuiEmojiWail => '[大泣き]';

  @override
  String get tuiEmojiTearsLaugh => '[泣き笑い]';

  @override
  String get tuiEmojiTrapped => '[困った]';

  @override
  String get tuiEmojiMask => '[マスク]';

  @override
  String get tuiEmojiFear => '[恐怖]';

  @override
  String get tuiEmojiBareTeeth => '[牙をむく]';

  @override
  String get tuiEmojiFlareUp => '[怒り]';

  @override
  String get tuiEmojiYawn => '[あくび]';

  @override
  String get tuiEmojiTact => '[機知]';

  @override
  String get tuiEmojiStareyes => '[星目]';

  @override
  String get tuiEmojiShutUp => '[黙れ]';

  @override
  String get tuiEmojiSigh => '[ため息]';

  @override
  String get tuiEmojiHehe => '[へへ]';

  @override
  String get tuiEmojiSilent => '[静か]';

  @override
  String get tuiEmojiSurprised => '[驚喜]';

  @override
  String get tuiEmojiAskance => '[白目]';

  @override
  String get tuiEmojiOk => '[OK]';

  @override
  String get tuiEmojiShit => '[うんち]';

  @override
  String get tuiEmojiMonster => '[モンスター]';

  @override
  String get tuiEmojiDaemon => '[悪魔]';

  @override
  String get tuiEmojiRage => '[悪魔の怒り]';

  @override
  String get tuiEmojiFool => '[ダメ]';

  @override
  String get tuiEmojiPig => '[豚]';

  @override
  String get tuiEmojiCow => '[牛]';

  @override
  String get tuiEmojiAi => '[AI]';

  @override
  String get tuiEmojiSkull => '[骸骨]';

  @override
  String get tuiEmojiBombs => '[爆弾]';

  @override
  String get tuiEmojiCoffee => '[コーヒー]';

  @override
  String get tuiEmojiCake => '[ケーキ]';

  @override
  String get tuiEmojiBeer => '[ビール]';

  @override
  String get tuiEmojiFlower => '[花]';

  @override
  String get tuiEmojiWatermelon => '[スイカ]';

  @override
  String get tuiEmojiRich => '[お金持ち]';

  @override
  String get tuiEmojiHeart => '[ハート]';

  @override
  String get tuiEmojiMoon => '[月]';

  @override
  String get tuiEmojiSun => '[太陽]';

  @override
  String get tuiEmojiStar => '[星]';

  @override
  String get tuiEmojiRedPacket => '[レッドパケット]';

  @override
  String get tuiEmojiCelebrate => '[祝賀]';

  @override
  String get tuiEmojiBless => '[福]';

  @override
  String get tuiEmojiFortune => '[発財]';

  @override
  String get tuiEmojiConvinced => '[納得]';

  @override
  String get tuiEmojiProhibit => '[禁止]';

  @override
  String get tuiEmoji666 => '[666]';

  @override
  String get tuiEmoji857 => '[857]';

  @override
  String get tuiEmojiKnife => '[ナイフ]';

  @override
  String get tuiEmojiLike => '[いいね]';

  @override
  String get startConversation => 'セッションを開始する';

  @override
  String get createGroupChat => 'グループチャットを作成する';

  @override
  String get createGroupTips => 'グループの作成';

  @override
  String get createCommunity => 'コミュニティを作成する';

  @override
  String get communityIDEditFormatTips => 'コミュニティ ID には接頭辞として @TGS#_ を付ける必要があります。';

  @override
  String get groupIDEditFormatTips => 'グループ ID プレフィックスを @TGS# にすることはできません。';

  @override
  String get groupIDEditExceedTips => 'グループ ID は最大 48 バイトです。';

  @override
  String get groupTypeContentButton => '製品ドキュメントを表示する';

  @override
  String get create => '作成する';

  @override
  String get groupName => 'グループ名';

  @override
  String get groupIDOption => 'グループID (オプション)';

  @override
  String get groupFaceUrl => 'グループアバター';

  @override
  String get groupMemberSelected => '選択されたグループメンバー';

  @override
  String get groupWorkType => 'お疲れ様グループ（仕事）';

  @override
  String get groupPublicType => 'ストレンジャー ソーシャル グループ (パブリック)';

  @override
  String get groupMeetingType => '臨時会議グループ（会議）';

  @override
  String get groupCommunityType => 'コミュニティ';

  @override
  String get groupWorkDesc => '友達ワークグループ（Work）：通常のWeChatグループと同様に、作成後はすでにグループに参加している友達のみをグループに招待でき、招待された側の同意やグループの承認は必要ありません。所有者。';

  @override
  String get groupPublicDesc => '見知らぬソーシャル グループ (パブリック): QQ グループと同様に、グループ所有者は作成後にグループ管理者を指定できます。ユーザーがグループ ID を検索してグループへの参加申請を開始した後、グループに参加する前にグループ所有者または管理者の承認が必要です。 。';

  @override
  String get groupMeetingDesc => '一時的な会議グループ (会議): 作成後は自由に出入りでき、グループに参加する前にメッセージの表示をサポートするため、音声会議やビデオ会議のシナリオ、オンライン教育のシナリオ、およびリアルタイム音声と組み合わせたその他のシナリオに適しています。そしてビデオ製品。';

  @override
  String get groupCommunityDesc => 'コミュニティ: 作成後は自由に参加および退出でき、最大 100,000 人のユーザーがグループ ID を検索してグループ アプリケーションを開始すると、管理者の承認なしでグループに参加できます。';

  @override
  String get groupDetail => 'グループチャットの詳細';

  @override
  String get transferGroupOwner => 'グループ所有者を転送する';

  @override
  String get privateGroup => 'ディスカッショングループ';

  @override
  String get publicGroup => 'パブリックグループ';

  @override
  String get chatRoom => 'チャットルーム';

  @override
  String get communityGroup => 'コミュニティ';

  @override
  String get serverGroupInvalidReq => '不正なリクエスト';

  @override
  String get serverGroupReqAlreadyBeenProcessed => 'この招待または申請リクエストはすでに処理されています。';

  @override
  String inviteToGroupFrom(Object inviter) {
    return '$inviter からの招待';
  }

  @override
  String get applyToJoin => '参加を申し込む:';

  @override
  String get requestWait => '招待は成功しました。処理を待っています';

  @override
  String dismissGroupTips(Object groupName) {
    return 'あなたが所属していたグループ $groupName は解散しました';
  }
}
