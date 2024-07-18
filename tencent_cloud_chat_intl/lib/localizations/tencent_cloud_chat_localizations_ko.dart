// Copyright (c) 1998-2024 Tencent, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:intl/intl.dart' as intl;

import 'tencent_cloud_chat_localizations.dart';

/// The translations for Korean (`ko`).
class TencentCloudChatLocalizationsKo extends TencentCloudChatLocalizations {
  TencentCloudChatLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get album => '앨범';

  @override
  String get chat => '채팅';

  @override
  String get chats => '채팅';

  @override
  String get calls => '통화';

  @override
  String get search => '검색';

  @override
  String get contacts => '연락처';

  @override
  String get settings => '설정';

  @override
  String get online => '온라인';

  @override
  String get offline => '오프라인';

  @override
  String get sendAMessage => '메시지';

  @override
  String get done => '완료';

  @override
  String get archive => '보관';

  @override
  String get read => '읽음';

  @override
  String get readAll => '읽음';

  @override
  String get delete => '삭제';

  @override
  String get newChat => '새 채팅';

  @override
  String get newGroup => '새 그룹';

  @override
  String get frequentlyContacted => '자주 연락하는 사람';

  @override
  String get addParticipants => '멤버 추가';

  @override
  String get addMembers => '멤버 추가';

  @override
  String get cancel => '취소';

  @override
  String get next => '다음';

  @override
  String get back => '뒤로';

  @override
  String get groupID => '그룹 ID';

  @override
  String get groupIDCertificate => '그룹 ID (인증서)';

  @override
  String get groupOfType => '그룹 유형';

  @override
  String get typeOfGroup => '그룹 유형';

  @override
  String get work => '작업';

  @override
  String get public => '공개';

  @override
  String get meeting => '회의';

  @override
  String get avChatRoom => 'AV채팅룸';

  @override
  String get groupPortrait => '그룹 초상화';

  @override
  String get participants => '참가자';

  @override
  String get seeDocs => '문서 보기';

  @override
  String get you => '당신';

  @override
  String get today => '오늘';

  @override
  String get yesterday => '어제';

  @override
  String youCreatedGroup(String groupName) {
    return '당신이 그룹 $groupName을(를) 생성했습니다';
  }

  @override
  String get groups => '그룹';

  @override
  String get chatRecord => '메시지';

  @override
  String get messages => '메시지';

  @override
  String get more => '더보기';

  @override
  String get noConversationsContactsOrMessagesFound => '대화, 연락처 또는 메시지가 없습니다';

  @override
  String get contactInfo => '연락처 정보';

  @override
  String get exportChat => '채팅 내보내기';

  @override
  String get clearChat => '채팅 지우기';

  @override
  String get deleteChat => '채팅 삭제';

  @override
  String get video => '비디오';

  @override
  String get videoCall => '영상 통화';

  @override
  String get missedVideoCall => '부재 중 영상 통화';

  @override
  String get voice => '음성';

  @override
  String get voiceCall => '음성 통화';

  @override
  String get missedVoiceCall => '부재 중 음성 통화';

  @override
  String get location => '위치';

  @override
  String get youStartedACall => '당신이 통화를 시작했습니다';

  @override
  String get star => '별표';

  @override
  String get copy => '복사';

  @override
  String get forward => '전달';

  @override
  String get multiSelect => '선택';

  @override
  String get select => '선택';

  @override
  String get quote => '인용';

  @override
  String get reply => '답장';

  @override
  String get all => '모두';

  @override
  String get tapToRemove => '제거하려면 탭하세요';

  @override
  String get messageInfo => '메시지 정보';

  @override
  String get delivered => '전달됨';

  @override
  String get readBy => '읽음';

  @override
  String get deliveredTo => '전달 대상';

  @override
  String numSelect(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num 선택됨',
      zero: '메시지 선택',
    );
    return '$_temp0';
  }

  @override
  String numChats(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num 채팅',
      one: '1 채팅',
      zero: '선택된 채팅 없음',
    );
    return '$_temp0';
  }

  @override
  String get recentChats => '최근 채팅';

  @override
  String numThreadQuote(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num 스레드 인용',
      one: '$num 스레드 인용',
    );
    return '$_temp0';
  }

  @override
  String get swipeLeftToCancelOrReleaseToSend => '왼쪽으로 스와이프하여 취소하거나 보내기 위해 놓으십시오';

  @override
  String get releaseToCancel => '취소하려면 놓으십시오';

  @override
  String get camera => '카메라';

  @override
  String get document => '문서';

  @override
  String get file => '파일';

  @override
  String get photos => '사진';

  @override
  String get contact => '연락처';

  @override
  String get custom => '사용자 정의';

  @override
  String get message => '메시지';

  @override
  String get doNotDisturb => '무음';

  @override
  String get mute => '무음';

  @override
  String get topChat => '고정';

  @override
  String get pin => '고정';

  @override
  String get blackUser => '사용자 차단';

  @override
  String get blockUser => '사용자 차단';

  @override
  String get saveContact => '연락처 저장';

  @override
  String get call => '통화';

  @override
  String get clearingChatHistory => '메시지 지우기';

  @override
  String get clearMessages => '메시지 지우기';

  @override
  String get firstName => '이름';

  @override
  String get lastName => '성';

  @override
  String get groupNotice => '그룹 공지';

  @override
  String get groupOfAnnouncement => '그룹 공지';

  @override
  String get groupManagement => '그룹 관리';

  @override
  String get groupType => '그룹 유형';

  @override
  String get addGroupWay => '그룹 추가 방법';

  @override
  String get myAliasInGroup => '그룹에서의 별칭';

  @override
  String get myGroupNickName => '그룹에서의 별칭';

  @override
  String get groupMembers => '그룹 멤버';

  @override
  String get admin => '관리자';

  @override
  String adminNum(int num) {
    return '관리자 ($num)';
  }

  @override
  String get info => '정보';

  @override
  String get setAsAdmin => '관리자로 설정';

  @override
  String get announcement => '그룹 공지';

  @override
  String get totalSilence => '전체 무음';

  @override
  String get silenceAll => '모두 무음';

  @override
  String get addSilencedMember => '무음 멤버 추가';

  @override
  String get onlyGroupOwnerAndAdminsCanSendMessages => '활성화하면 그룹 소유자와 관리자만 메시지를 보낼 수 있습니다.';

  @override
  String someoneEnabledSilenceAll(String name) {
    return '$name님이 \'모두 무음\'을 활성화했습니다';
  }

  @override
  String someoneDisabledSilenceAll(String name) {
    return '$name님이 \'모두 무음\'을 비활성화했습니다';
  }

  @override
  String get newContacts => '새 연락처';

  @override
  String get myGroup => '내 그룹';

  @override
  String get theBlackList => '차단 목록';

  @override
  String get blockList => '차단된 사용자';

  @override
  String get groupChatNotifications => '그룹 채팅 알림';

  @override
  String get userID => '사용자 ID';

  @override
  String myUserID(String userID) {
    return '내 사용자 ID: $userID';
  }

  @override
  String get searchUserID => '사용자ID 검색';

  @override
  String get none => '없음';

  @override
  String iDis(String userID) {
    return 'ID: $userID';
  }

  @override
  String get addToContacts => '연락처에 추가';

  @override
  String get addContact => '연락처 추가';

  @override
  String get bio => '자기소개';

  @override
  String bioIs(String bio) {
    return '자기소개: $bio';
  }

  @override
  String get fillInTheVerificationInformation => '요청 보내기';

  @override
  String get remarkAndGrouping => '비고 및 그룹화';

  @override
  String get remark => '비고';

  @override
  String get group => '그룹';

  @override
  String get send => '보내기';

  @override
  String get contactAddedSuccessfully => '연락처가 성공적으로 추가되었습니다';

  @override
  String get requestSent => '요청 전송됨';

  @override
  String get cannotAddContact => '연락처를 추가할 수 없습니다';

  @override
  String get addGroup => '그룹 추가';

  @override
  String typeIs(String type) {
    return '유형: $type';
  }

  @override
  String get groupNotAcceptingRequests => '그룹이 요청을 수락하지 않음';

  @override
  String get joinedGroupSuccessfully => '그룹에 성공적으로 가입';

  @override
  String numNewApplications(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num 개의 새로운 신청',
      one: '$num 개의 새로운 신청',
    );
    return '$_temp0';
  }

  @override
  String get agree => '수락';

  @override
  String get accept => '수락';

  @override
  String get refuse => '거절';

  @override
  String get decline => '거절';

  @override
  String get verificationMessage => '인증 메시지';

  @override
  String get accepted => '수락됨';

  @override
  String get declined => '거부됨';

  @override
  String get confirm => '확인';

  @override
  String get contactRequest => '연락처 요청';

  @override
  String get contactsPermission => '연락처 권한';

  @override
  String get allowAnyUserAddYouAsContact => '누구나 연락처로 추가할 수 있도록 허용';

  @override
  String get declineContactRequestFromAnyUser => '자동 거절 연락처 요청';

  @override
  String get anyoneUponRequest => '수동으로 요청 수락';

  @override
  String get theme => '테마';

  @override
  String get language => '언어';

  @override
  String get aboutTencentCloudChat => '텐센트 클라우드 채팅 정보';

  @override
  String get logIn => '로그인';

  @override
  String get signIn => '로그인';

  @override
  String get signUp => '가입';

  @override
  String get signOut => '로그아웃';

  @override
  String get logOut => '로그아웃';

  @override
  String get signature => '자기소개';

  @override
  String get gender => '성별';

  @override
  String get birthday => '생일';

  @override
  String get male => '남성';

  @override
  String get female => '여성';

  @override
  String get unspecified => '미지정';

  @override
  String get unknown => '알 수 없음';

  @override
  String get sdkVersion => 'SDK 버전';

  @override
  String get privacyPolicy => '개인정보 처리방침';

  @override
  String get userAgreement => '사용자 동의';

  @override
  String get disclaimer => '면책 조항';

  @override
  String get personalInformationCollected => '수집된 개인 정보';

  @override
  String get informationSharedWithThirdParties => '제3자와 공유된 정보';

  @override
  String get deleteAccount => '계정 삭제';

  @override
  String get contactUs => '문의하기';

  @override
  String get countryOrRegion => '국가 / 지역';

  @override
  String get selectACountry => '국가 또는 지역 선택';

  @override
  String get phoneNumber => '전화번호';

  @override
  String get email => '이메일';

  @override
  String get verificationCode => '인증 코드';

  @override
  String get enterSMSCode => 'SMS로 전송된 코드 입력';

  @override
  String get sendCode => '코드 보내기';

  @override
  String get visitOurWebsite => '웹사이트 방문';

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
  String get style => '스타일';

  @override
  String get classic => '클래식';

  @override
  String get minimalist => '미니멀리스트';

  @override
  String get messageReadStatus => '메시지 읽음 상태';

  @override
  String get messageReadStatusDescription => '메시지 읽음 상태를 표시하고 다른 사람이 메시지를 읽었는지 확인할 수 있는지 여부를 제어합니다.';

  @override
  String get onlineStatus => '온라인 상태';

  @override
  String get onlineStatusDescription => '온라인 상태가 연락처에 표시되는지 여부를 결정합니다.';

  @override
  String get noBio => '자기소개 없음';

  @override
  String get noConversation => '대화 없음';

  @override
  String get sound => '소리';

  @override
  String get sticker => '스티커';

  @override
  String get image => '이미지';

  @override
  String get chatHistory => '채팅 기록';

  @override
  String get audio => '오디오';

  @override
  String get messageDeleted => '메시지 삭제됨';

  @override
  String get messageRecalled => '메시지 회수됨';

  @override
  String unreadCount(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num 개의 안 읽은 메시지',
      one: '$num 개의 안 읽은 메시지',
    );
    return '$_temp0';
  }

  @override
  String newMsgCount(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num 개의 새 메시지',
      one: '새 메시지',
    );
    return '$_temp0';
  }

  @override
  String get takeAPhoto => '사진 찍기';

  @override
  String get recordAVideo => '비디오 녹화';

  @override
  String get pullDownToLoadMoreMessages => '더 많은 메시지를 불러오려면 아래로 당겨주세요';

  @override
  String get releaseToLoadMore => '더 불러오려면 놓아주세요';

  @override
  String get noMoreMessage => '더 이상 메시지 없음';

  @override
  String get pullUpToLoadMoreMessages => '더 많은 메시지를 불러오려면 위로 당겨주세요';

  @override
  String get holdToRecordReleaseToSend => '녹음하려면 길게 누르고 보내려면 놓으세요';

  @override
  String get forwardIndividually => '개별 전달';

  @override
  String get forwardCombined => '결합 전달';

  @override
  String get selectConversations => '대화 선택';

  @override
  String get recent => '최근';

  @override
  String get recall => '회수';

  @override
  String replyTo(String name) {
    return '$name님에게 답장';
  }

  @override
  String get confirmDeletion => '삭제 확인';

  @override
  String get deleteForEveryone => '모두에게 삭제';

  @override
  String get deleteForMe => '나만 삭제';

  @override
  String get askDeleteThisMessage => '이 메시지를 삭제하시겠습니까?';

  @override
  String deleteMessageCount(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num 개의 메시지 삭제하시겠습니까?',
      one: '메시지 삭제하시겠습니까?',
      zero: '메시지 삭제 없음',
    );
    return '$_temp0';
  }

  @override
  String memberReadCount(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num 명의 회원이 읽음',
      one: '1 명의 회원이 읽음',
      zero: '회원이 읽지 않음',
    );
    return '$_temp0';
  }

  @override
  String get allMembersRead => '모든 회원이 읽었습니다';

  @override
  String get allowAny => '모두 허용';

  @override
  String get cannotSendApplicationToWorkGroup => '작업 그룹에 신청서를 보낼 수 없습니다';

  @override
  String get appearance => '외관';

  @override
  String get darkTheme => '어두운 테마';

  @override
  String get denyAny => '거부';

  @override
  String get edit => '편집';

  @override
  String get friendsPermission => '친구 권한';

  @override
  String get groupJoined => '그룹 가입됨';

  @override
  String get lightTheme => '밝은 테마';

  @override
  String get noBlockList => '차단된 사용자 없음';

  @override
  String get noContact => '연락처 없음';

  @override
  String get noNewApplication => '새로운 신청 없음';

  @override
  String get permissionNeeded => '권한 필요';

  @override
  String get requireRequest => '요청 필요';

  @override
  String get setNickname => '닉네임 설정';

  @override
  String get setSignature => '서명 설정';

  @override
  String get validationMessages => '유효성 검사 메시지';

  @override
  String get getVerification => '인증 받기';

  @override
  String get invalidEmail => '잘못된 이메일';

  @override
  String get invalidPhoneNumber => '잘못된 전화번호';

  @override
  String get invalidVerification => '잘못된 인증';

  @override
  String get searchGroupID => '그룹 ID 검색';

  @override
  String get callInitiated => '통화 시작됨';

  @override
  String get callAccepted => '통화 수락됨';

  @override
  String get callDeclined => '통화 거절됨';

  @override
  String get noAnswer => '응답 없음';

  @override
  String get lineBusy => '통화중';

  @override
  String get callHungUp => '통화 끊김';

  @override
  String get callInProgress => '통화 진행 중';

  @override
  String get callEnded => '통화 종료';

  @override
  String get unknownCallStatus => '통화 중';

  @override
  String get groupChatCreated => '그룹 채팅이 성공적으로 생성되었습니다!';

  @override
  String get vote => '투표';

  @override
  String get callCancelled => '통화 취소됨';

  @override
  String get unknownGroupTips => '알 수 없는 그룹 팁';

  @override
  String memberJoinedGroup(Object members) {
    return '$members님이 그룹에 가입했습니다';
  }

  @override
  String opInvitedToGroup(Object members, Object opMember) {
    return '$opMember님이 $members님을 그룹에 초대했습니다';
  }

  @override
  String memberLeftGroup(Object members) {
    return '$members님이 그룹을 떠났습니다';
  }

  @override
  String opRemovedFromGroup(Object members, Object opMember) {
    return '$opMember님이 $members님을 그룹에서 제거했습니다';
  }

  @override
  String opPromotedToAdmin(Object members, Object opMember) {
    return '$opMember님이 $members님을 관리자로 승격시켰습니다';
  }

  @override
  String opRevokedAdmin(Object members, Object opMember) {
    return '$opMember님이 $members님의 관리자 권한을 취소했습니다';
  }

  @override
  String opChangedGroupInfo(Object groupInfo, Object opMember) {
    return '$opMember님이 $groupInfo를 변경했습니다';
  }

  @override
  String opChangedMemberInfo(Object memberInfo, Object opMember) {
    return '$opMember님이 $memberInfo를 변경했습니다';
  }

  @override
  String changedGroupNameTo(Object name) {
    return '그룹 이름을 $name로 변경했습니다';
  }

  @override
  String changedGroupDescriptionTo(Object description) {
    return '그룹 설명을 $description로 변경했습니다';
  }

  @override
  String changedGroupAnnouncementTo(Object announcement) {
    return '그룹 공지를 $announcement로 변경했습니다';
  }

  @override
  String get changedGroupAvatar => '그룹 아바타 변경';

  @override
  String transferredGroupOwnershipTo(Object owner) {
    return '그룹 소유권을 $owner님에게 이전했습니다';
  }

  @override
  String get changedGroupCustomInfo => '그룹 사용자 정의 정보 변경';

  @override
  String get enabledGroupMute => '그룹 전체 음소거 활성화';

  @override
  String get disabledGroupMute => '그룹 전체 음소거 비활성화';

  @override
  String changedGroupMessageReceptionTo(Object setting) {
    return '그룹 메시지 수신 설정을 다음으로 변경했습니다: $setting';
  }

  @override
  String changedApplyToJoinGroupTo(Object setting) {
    return '그룹 가입 신청 설정을 다음으로 변경했습니다: $setting';
  }

  @override
  String changedInviteToJoinGroupTo(Object setting) {
    return '그룹 초대 가입 설정을 다음으로변경했습니다: $setting';
  }

  @override
  String opUnmuted(Object user) {
    return '$user 음소거 해제';
  }

  @override
  String opMuted(Object duration, Object user) {
    return '$user $duration 초 동안 음소거';
  }

  @override
  String get groupTips => '그룹 팁';

  @override
  String get receiveMessages => '메시지 받기';

  @override
  String get doNotReceiveMessages => '메시지 받지 않기';

  @override
  String get receiveMessagesWhenOnlineOnly => '온라인 상태일 때만 메시지 받기';

  @override
  String get disallowJoinGroup => '그룹 가입 신청 거부';

  @override
  String get joinGroupNeedApproval => '그룹 가입 신청에 관리자 승인 필요';

  @override
  String get joinGroupDirectly => '신청 후 바로 그룹에 가입';

  @override
  String get disallowInviting => '그룹 초대 거부';

  @override
  String get requireApprovalForInviting => '초대 가입에 관리자 승인 필요';

  @override
  String get joinDirectlyBeenInvited => '초대 후 바로 그룹에 가입';

  @override
  String get unmuted => '음소거 해제';

  @override
  String muteTime(Object duration) {
    return '$duration 초 동안 음소거';
  }

  @override
  String get poll => '설문 조사';

  @override
  String callDuration(Object duration) {
    return '통화 시간: $duration';
  }

  @override
  String get selectMembers => '멤버 선택';

  @override
  String numSelectMembers(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num 선택됨',
      zero: '멤버 선택',
    );
    return '$_temp0';
  }

  @override
  String get searchMembers => '멤버 검색';

  @override
  String get startCall => '통화 시작';

  @override
  String get clear => '지우기';

  @override
  String groupSubtitle(Object count, Object name) {
    return '$name 및 $count 명의 다른 사람들';
  }

  @override
  String get markAsUnread => '읽지 않은 상태로 표시';

  @override
  String get hide => '숨기기';

  @override
  String get unreadMessagesBelow => '아래에 읽지 않은 메시지';

  @override
  String get ar => 'اَلْعَرَبِيَّةُ';

  @override
  String get tencentCloudChat => 'Tencent Cloud Chat';

  @override
  String get changeTheme => '외관 변경';

  @override
  String get deleteAccountNotification => '계정을 삭제한 후 현재 계정을 사용할 수 없으며 관련 데이터가 삭제되어 복구할 수 없습니다.';

  @override
  String get restartAppForLanguage => '언어 변경 사항을 적용하려면 앱을 다시 시작하십시오';

  @override
  String get deleteAllMessages => '모든 메시지 삭제';

  @override
  String get downloading => '다운로드 중...';

  @override
  String get viewFullImage => '전체 이미지 보기';

  @override
  String get messageRecall => '메시지 철회';

  @override
  String get messageRecallConfirmation => '이 메시지를 철회하시겠습니까?';

  @override
  String get quit => '그룹에서 나가기';

  @override
  String get quitAndDelete => '나가기 및 삭제';

  @override
  String get setGroupName => '그룹 이름 설정';

  @override
  String get groupAddAny => '어떤';

  @override
  String get groupAddAuth => '승인 필요';

  @override
  String get groupAddForbid => '금지';

  @override
  String get groupOwner => '그룹 소유자';

  @override
  String get groupMember => '회원';

  @override
  String get dismissAdmin => '관리자 해임';

  @override
  String get welcomeToTencentCloudChat => '텐센트 클라우드 채팅에 오신 것을 환영합니다';

  @override
  String get draft => '초안';

  @override
  String get openInNewWindow => '새 창에서 열기';

  @override
  String get selectAChat => '채팅 선택';

  @override
  String get noConversationSelected => '선택된 대화 없음';

  @override
  String get unavailableToSendMessage => '메시지를 보낼 수 없습니다';

  @override
  String get noSuchGroup => '그런 그룹 없음';

  @override
  String get notGroupMember => '그룹 회원이 아닙니다';

  @override
  String get userNotFound => '사용자를 찾을 수 없습니다';

  @override
  String get userBlockedYou => '사용자가 당신을 차단했습니다';

  @override
  String get muted => '음소거';

  @override
  String get groupMuted => '그룹 음소거';

  @override
  String get cantSendMessage => '메시지를 보낼 수 없습니다';

  @override
  String get media => '미디어';

  @override
  String sendToSomeChat(String name) {
    return '$name에게 보내기';
  }

  @override
  String get unableToSendWithFolders => '폴더가 포함되어 있어 파일을 보낼 수 없습니다. 개별 파일만 선택해주세요.';

  @override
  String get channelSwitch => '채널: ';

  @override
  String get weChat => '위챗';

  @override
  String get tGWA => '텔레그램 & 왓츠앱';

  @override
  String get contactUsIfQuestions => '불분명한 점이나 더 많은 아이디어가 있으면 언제든지 문의하십시오!';

  @override
  String get chatNow => '지금 채팅하기';

  @override
  String get onlineServiceTimeFrom10To20 => '온라인 서비스 시간: 월요일부터 금요일까지 오전 10시부터 오후 8시까지';

  @override
  String get officialWebsite => '공식 웹사이트';

  @override
  String get allSDKs => '모든 SDKs';

  @override
  String get sourceCode => '소스 코드';

  @override
  String get personalInformationCollectionList => '개인 정보 수집 목록';

  @override
  String get thirdPartyInformationSharingList => '제3자 정보 공유 목록';

  @override
  String get version => '버전';

  @override
  String get feedback => '피드백';

  @override
  String get me => '나';

  @override
  String get about => '소개하다';

  @override
  String get profile => '프로필';

  @override
  String get unpin => '고정 취소';

  @override
  String mentionedMessages(num count) {
    return '나에게 $count 개의 언급';
  }

  @override
  String get longPressToNavigate => '길게 눌러서 보기';

  @override
  String get permissionDeniedTitle => '권한 거부됨';

  @override
  String permissionDeniedContent(Object permissionString) {
    return '설정으로 이동하여 $permissionString 권한을 활성화하세요.';
  }

  @override
  String get goToSettingsButtonText => '설정으로 이동';

  @override
  String get originalMessageNotFound => '기존 메시지 찾을 수 없음';

  @override
  String get markAsRead => '읽음으로 표시';

  @override
  String get reEdit => '다시 편집';

  @override
  String get translate => '번역';

  @override
  String memberRecalledMessage(Object member) {
    return '$member가 메시지를 철회하였습니다';
  }

  @override
  String get copyFileSuccess => '파일 복사 성공';

  @override
  String get saveFileSuccess => '파일 저장 성공';

  @override
  String get saveFileFailed => '파일 저장 실패';

  @override
  String get copyLinkSuccess => '링크 복사 성공';

  @override
  String get copyImageContextMenuBtnText => '이미지 복사';

  @override
  String get saveToLocalContextMenuBtnText => '다른 이름으로 저장';

  @override
  String get copyLinkContextMenuBtnText => '링크 복사';

  @override
  String get openLinkContextMenuBtnText => '새 창에서 열기';

  @override
  String get reactionList => 'Reaction List';

  @override
  String get translatedBy => 'Tencent RTC 에 의해 제공됨';

  @override
  String get convertToText => '변환';

  @override
  String numMessages(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개의 메시지',
      one: '1개의 메시지',
    );
    return '$_temp0';
  }

  @override
  String get filterBy => '필터';

  @override
  String get text => '텍스트';

  @override
  String get numMessagesOver99 => '99+ 개의 메시지';

  @override
  String get setGroupAnnouncement => '그룹 공지 설정';

  @override
  String get setNickName => '그룹 이름 설정';

  @override
  String get joinTime => '가입 시간';

  @override
  String get myRoleInGroup => '역할';
}
