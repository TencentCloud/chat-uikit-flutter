// Copyright (c) 1998-2024 Tencent, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:intl/intl.dart' as intl;

import 'tencent_cloud_chat_localizations.dart';

/// The translations for Arabic (`ar`).
class TencentCloudChatLocalizationsAr extends TencentCloudChatLocalizations {
  TencentCloudChatLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get album => 'ألبوم';

  @override
  String get chat => 'دردشة';

  @override
  String get chats => 'الدردشات';

  @override
  String get calls => 'المكالمات';

  @override
  String get search => 'بحث';

  @override
  String get contacts => 'جهات الاتصال';

  @override
  String get settings => 'الإعدادات';

  @override
  String get online => 'متصل';

  @override
  String get offline => 'غير متصل';

  @override
  String get sendAMessage => 'رسالة';

  @override
  String get done => 'تم';

  @override
  String get archive => 'أرشيف';

  @override
  String get read => 'اقرأ';

  @override
  String get readAll => 'اقرأ';

  @override
  String get delete => 'حذف';

  @override
  String get newChat => 'دردشة جديدة';

  @override
  String get newGroup => 'مجموعة جديدة';

  @override
  String get frequentlyContacted => 'جهات الاتصال المتكررة';

  @override
  String get addParticipants => 'إضافة أعضاء';

  @override
  String get addMembers => 'إضافة أعضاء';

  @override
  String get cancel => 'إلغاء';

  @override
  String get next => 'التالى';

  @override
  String get back => 'عودة';

  @override
  String get groupID => 'معرف المجموعة';

  @override
  String get groupIDCertificate => 'معرف المجموعة (شهادة)';

  @override
  String get groupOfType => 'نوع المجموعة';

  @override
  String get typeOfGroup => 'نوع المجموعة';

  @override
  String get work => 'عمل';

  @override
  String get public => 'عام';

  @override
  String get meeting => 'اجتماع';

  @override
  String get avChatRoom => 'غرفة دردشة الفيديو';

  @override
  String get groupPortrait => 'صورة المجموعة';

  @override
  String get participants => 'المشاركون';

  @override
  String get seeDocs => 'انظر المستندات';

  @override
  String get you => 'أنت';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String youCreatedGroup(String groupName) {
    return 'أنشأت المجموعة $groupName';
  }

  @override
  String get groups => 'المجموعات';

  @override
  String get chatRecord => 'الرسائل';

  @override
  String get messages => 'الرسائل';

  @override
  String get more => 'المزيد';

  @override
  String get noConversationsContactsOrMessagesFound => 'لم يتم العثور على محادثات أو جهات اتصال أو رسائل';

  @override
  String get contactInfo => 'معلومات الاتصال';

  @override
  String get exportChat => 'تصدير الدردشة';

  @override
  String get clearChat => 'مسح الدردشة';

  @override
  String get deleteChat => 'حذف الدردشة';

  @override
  String get video => 'فيديو';

  @override
  String get videoCall => 'مكالمة فيديو';

  @override
  String get missedVideoCall => 'مكالمة فيديو فائتة';

  @override
  String get voice => 'صوت';

  @override
  String get voiceCall => 'مكالمة صوتية';

  @override
  String get missedVoiceCall => 'مكالمة صوتية فائتة';

  @override
  String get location => 'الموقع';

  @override
  String get youStartedACall => 'بدأت مكالمة';

  @override
  String get star => 'نجمة';

  @override
  String get copy => 'نسخ';

  @override
  String get forward => 'إعادة توجيه';

  @override
  String get multiSelect => 'تحديد';

  @override
  String get select => 'تحديد';

  @override
  String get quote => 'اقتباس';

  @override
  String get reply => 'الرد';

  @override
  String get all => 'الكل';

  @override
  String get tapToRemove => 'اضغط للإزالة';

  @override
  String get messageInfo => 'معلومات الرسالة';

  @override
  String get delivered => 'تم التوصيل';

  @override
  String get readBy => 'قراءة بواسطة';

  @override
  String get deliveredTo => 'تم التوصيل إلى';

  @override
  String numSelect(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num محدد',
      zero: 'تحديد الرسائل',
    );
    return '$_temp0';
  }

  @override
  String numChats(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num دردشات',
      one: 'دردشة واحدة',
      zero: 'لم يتم تحديد دردشة',
    );
    return '$_temp0';
  }

  @override
  String get recentChats => 'الدردشات الأخيرة';

  @override
  String numThreadQuote(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num اقتباسات موضوع',
      one: '$num اقتباس موضوع',
    );
    return '$_temp0';
  }

  @override
  String get swipeLeftToCancelOrReleaseToSend => 'اسحب لليسار للإلغاء أو الإفلات للإرسال';

  @override
  String get releaseToCancel => 'إفلات للإلغاء';

  @override
  String get camera => 'كاميرا';

  @override
  String get document => 'مستند';

  @override
  String get file => 'ملف';

  @override
  String get photos => 'الصور';

  @override
  String get contact => 'جهة اتصال';

  @override
  String get custom => 'مخصص';

  @override
  String get message => 'رسالة';

  @override
  String get doNotDisturb => 'كتم';

  @override
  String get mute => 'كتم';

  @override
  String get topChat => 'تثبيت';

  @override
  String get pin => 'تثبيت';

  @override
  String get blackUser => 'حظر المستخدم';

  @override
  String get blockUser => 'حظر المستخدم';

  @override
  String get saveContact => 'حفظ جهة الاتصال';

  @override
  String get call => 'اتصال';

  @override
  String get clearingChatHistory => 'مسح الرسائل';

  @override
  String get clearMessages => 'مسح الرسائل';

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get lastName => 'اسم العائلة';

  @override
  String get groupNotice => 'إشعار المجموعة';

  @override
  String get groupOfAnnouncement => 'إشعار المجموعة';

  @override
  String get groupManagement => 'إدارة المجموعة';

  @override
  String get groupType => 'نوع المجموعة';

  @override
  String get addGroupWay => 'إضافة طريقة المجموعة';

  @override
  String get myAliasInGroup => 'لقبي في المجموعة';

  @override
  String get myGroupNickName => 'لقبي في المجموعة';

  @override
  String get groupMembers => 'أعضاء المجموعة';

  @override
  String get admin => 'مشرف';

  @override
  String adminNum(int num) {
    return 'المشرف ($num)';
  }

  @override
  String get info => 'معلومات';

  @override
  String get setAsAdmin => 'تعيين كمشرف';

  @override
  String get announcement => 'إشعار المجموعة';

  @override
  String get totalSilence => 'كتم الصوت الإجمالي';

  @override
  String get silenceAll => 'كتم الصوت للجميع';

  @override
  String get addSilencedMember => 'إضافة عضو مكتوم';

  @override
  String get onlyGroupOwnerAndAdminsCanSendMessages => 'بعد التمكين، يمكن لمالك المجموعة والمشرفين فقط إرسالة.';

  @override
  String someoneEnabledSilenceAll(String name) {
    return '$name قام بتفعيل \'كتم الصوت للجميع\'';
  }

  @override
  String someoneDisabledSilenceAll(String name) {
    return '$name قام بتعطيل \'كتم الصوت للجميع\'';
  }

  @override
  String get newContacts => 'جهات اتصال جديدة';

  @override
  String get myGroup => 'مجموعاتي';

  @override
  String get theBlackList => 'قائمة الحظر';

  @override
  String get blockList => 'المستخدمين المحظورين';

  @override
  String get groupChatNotifications => 'إشعارات دردشة المجموعة';

  @override
  String get userID => 'معرف المستخدم';

  @override
  String myUserID(String userID) {
    return 'معرف المستخدم الخاص بي: $userID';
  }

  @override
  String get searchUserID => 'بحث عن معرف المستخدم';

  @override
  String get none => 'لا شيء';

  @override
  String iDis(String userID) {
    return 'المعرف: $userID';
  }

  @override
  String get addToContacts => 'إضافة إلى جهات الاتصال';

  @override
  String get addContact => 'إضافة جهة اتصال';

  @override
  String get bio => 'نبذة';

  @override
  String bioIs(String bio) {
    return 'النبذة: $bio';
  }

  @override
  String get fillInTheVerificationInformation => 'إرسال الطلب';

  @override
  String get remarkAndGrouping => 'ملاحظة وتجميع';

  @override
  String get remark => 'ملاحظة';

  @override
  String get group => 'مجموعة';

  @override
  String get send => 'إرسال';

  @override
  String get contactAddedSuccessfully => 'تمت إضافة جهة الاتصال بنجاح';

  @override
  String get requestSent => 'تم إرسال الطلب';

  @override
  String get cannotAddContact => 'لا يمكن إضافة جهة اتصال';

  @override
  String get addGroup => 'إضافة مجموعة';

  @override
  String typeIs(String type) {
    return 'النوع: $type';
  }

  @override
  String get groupNotAcceptingRequests => 'المجموعة لا تقبل الطلبات';

  @override
  String get joinedGroupSuccessfully => 'انضممت إلى المجموعة بنجاح';

  @override
  String numNewApplications(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num طلبات جديدة',
      one: '$num طلب جديد',
    );
    return '$_temp0';
  }

  @override
  String get agree => 'قبول';

  @override
  String get accept => 'قبول';

  @override
  String get refuse => 'رفض';

  @override
  String get decline => 'رفض';

  @override
  String get verificationMessage => 'رسالة التحقق';

  @override
  String get accepted => 'مقبول';

  @override
  String get declined => 'مرفوض';

  @override
  String get confirm => 'تأكيد';

  @override
  String get contactRequest => 'طلب جهة اتصال';

  @override
  String get contactsPermission => 'إذن جهات الاتصال';

  @override
  String get allowAnyUserAddYouAsContact => 'السماح لأي شخص بإضافتك كجهة اتصال';

  @override
  String get declineContactRequestFromAnyUser => 'رفض طلبات جهة الاتصال تلقائيًا';

  @override
  String get anyoneUponRequest => 'قبول الطلبات يدويًا';

  @override
  String get theme => 'المظهر';

  @override
  String get language => 'اللغة';

  @override
  String get aboutTencentCloudChat => 'حول Tencent Cloud Chat';

  @override
  String get logIn => 'تسجيل الدخول';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get logOut => 'تسجيل الخروج';

  @override
  String get signature => 'التوقيع';

  @override
  String get gender => 'الجنس';

  @override
  String get birthday => 'تاريخ الميلاد';

  @override
  String get male => 'ذكر';

  @override
  String get female => 'أنثى';

  @override
  String get unspecified => 'غير محدد';

  @override
  String get unknown => 'غير معروف';

  @override
  String get sdkVersion => 'إصدار SDK';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get userAgreement => 'اتفاقية المستخدم';

  @override
  String get disclaimer => 'إخلاء المسؤولية';

  @override
  String get personalInformationCollected => 'المعلومات الشخصية المجمعة';

  @override
  String get informationSharedWithThirdParties => 'المعلومات المشتركة مع الأطراف الثالثة';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get contactUs => 'اتصل بنا';

  @override
  String get countryOrRegion => 'الدولة / المنطقة';

  @override
  String get selectACountry => 'اختر دولة أو منطقة';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get verificationCode => 'رمز التحقق';

  @override
  String get enterSMSCode => 'أدخل الرمز المرسل عبر الرسائل القصيرة';

  @override
  String get sendCode => 'إرسال الرمز';

  @override
  String get visitOurWebsite => 'زيارة موقعنا';

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
  String get style => 'النمط';

  @override
  String get classic => 'كلاسيكي';

  @override
  String get minimalist => 'مينيمالي';

  @override
  String get messageReadStatus => 'حالة قراءة الرسالة';

  @override
  String get messageReadStatusDescription => 'يتحكم فيعرض حالة القراءة لرسائلك ومعرفة ما إذا كان الآخرين يمكنهم رؤية ما إذا كنت قد قرأت رسائلهم.';

  @override
  String get onlineStatus => 'حالة الاتصال';

  @override
  String get onlineStatusDescription => 'يحدد ما إذا كانت حالة اتصالك مرئية لجهات اتصالك.';

  @override
  String get noBio => 'لا نبذة';

  @override
  String get noConversation => 'لا محادثة';

  @override
  String get sound => 'الصوت';

  @override
  String get sticker => 'ملصق';

  @override
  String get image => 'صورة';

  @override
  String get chatHistory => 'سجل المحادثة';

  @override
  String get audio => 'الصوت';

  @override
  String get messageDeleted => 'تم حذف الرسالة';

  @override
  String get messageRecalled => 'تم استدعاء الرسالة';

  @override
  String unreadCount(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num رسائل غير مقروءة',
      one: '$num رسالة غير مقروءة',
    );
    return '$_temp0';
  }

  @override
  String newMsgCount(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num رسائل جديدة',
      one: 'رسالة جديدة',
    );
    return '$_temp0';
  }

  @override
  String get takeAPhoto => 'التقاط صورة';

  @override
  String get recordAVideo => 'تسجيل فيديو';

  @override
  String get pullDownToLoadMoreMessages => 'اسحب لأسفل لتحميل المزيد من الرسائل';

  @override
  String get releaseToLoadMore => 'أفلت لتحميل المزيد';

  @override
  String get noMoreMessage => 'لا توجد المزيد من الرسائل';

  @override
  String get pullUpToLoadMoreMessages => 'اسحب لأعلى لتحميل المزيد من الرسائل';

  @override
  String get holdToRecordReleaseToSend => 'اضغط مع الاستمرار للتسجيل ، وأفلت للإرسال';

  @override
  String get forwardIndividually => 'إعادة توجيه بشكل فردي';

  @override
  String get forwardCombined => 'إعادة توجيه مجتمعة';

  @override
  String get selectConversations => 'اختر المحادثات';

  @override
  String get recent => 'الأخيرة';

  @override
  String get recall => 'استدعاء';

  @override
  String replyTo(String name) {
    return 'الرد على $name';
  }

  @override
  String get confirmDeletion => 'تأكيد الحذف';

  @override
  String get deleteForEveryone => 'حذف للجميع';

  @override
  String get deleteForMe => 'حذف بالنسبة لي';

  @override
  String get askDeleteThisMessage => 'حذف هذه الرسالة؟';

  @override
  String deleteMessageCount(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: 'حذف $num رسائل؟',
      one: 'حذف رسالة واحدة؟',
      zero: 'لم يتم حذف الرسالة',
    );
    return '$_temp0';
  }

  @override
  String memberReadCount(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num أعضاء قرأوا',
      one: 'عضو واحد قرأ',
      zero: 'لم يقرأأي عضو',
    );
    return '$_temp0';
  }

  @override
  String get allMembersRead => 'جميع الأعضاء قرأوا';

  @override
  String get allowAny => 'السماح لأي';

  @override
  String get cannotSendApplicationToWorkGroup => 'لا يمكن إرسال الطلب إلى مجموعة العمل';

  @override
  String get appearance => 'المظهر';

  @override
  String get darkTheme => 'مظلم';

  @override
  String get denyAny => 'رفض أي';

  @override
  String get edit => 'تعديل';

  @override
  String get friendsPermission => 'إذن الأصدقاء';

  @override
  String get groupJoined => 'انضم إلى المجموعة';

  @override
  String get lightTheme => 'فاتح';

  @override
  String get noBlockList => 'لا يوجد مستخدمون محظورون';

  @override
  String get noContact => 'لا توجد جهات اتصال';

  @override
  String get noNewApplication => 'لا يوجد تطبيق جديد';

  @override
  String get permissionNeeded => 'الإذن مطلوب';

  @override
  String get requireRequest => 'يتطلب طلب';

  @override
  String get setNickname => 'تعيين اسم مستعار';

  @override
  String get setSignature => 'تعيين التوقيع';

  @override
  String get validationMessages => 'رسائل التحقق';

  @override
  String get getVerification => 'الحصول على التحقق';

  @override
  String get invalidEmail => 'بريد إلكتروني غير صالح';

  @override
  String get invalidPhoneNumber => 'رقم هاتف غير صالح';

  @override
  String get invalidVerification => 'التحقق غير صالح';

  @override
  String get searchGroupID => 'البحث عن معرف المجموعة';

  @override
  String get callInitiated => 'تم بدء المكالمة';

  @override
  String get callAccepted => 'تم قبول المكالمة';

  @override
  String get callDeclined => 'تم رفض المكالمة';

  @override
  String get noAnswer => 'لا يوجد إجابة';

  @override
  String get lineBusy => 'الخط مشغول';

  @override
  String get callHungUp => 'أنهى المكالمة';

  @override
  String get callInProgress => 'المكالمة قيد التقدم';

  @override
  String get callEnded => 'انتهت المكالمة';

  @override
  String get unknownCallStatus => 'مكالمة';

  @override
  String get groupChatCreated => 'تم إنشاء محادثة المجموعة بنجاح!';

  @override
  String get vote => 'تصويت';

  @override
  String get callCancelled => 'تم إلغاء المكالمة';

  @override
  String get unknownGroupTips => 'نصائح المجموعة المجهولة';

  @override
  String memberJoinedGroup(Object members) {
    return 'انضم $members إلى المجموعة';
  }

  @override
  String opInvitedToGroup(Object members, Object opMember) {
    return 'دعا $opMember $members إلى المجموعة';
  }

  @override
  String memberLeftGroup(Object members) {
    return 'غادر $members المجموعة';
  }

  @override
  String opRemovedFromGroup(Object members, Object opMember) {
    return 'أزال $opMember $members من المجموعة';
  }

  @override
  String opPromotedToAdmin(Object members, Object opMember) {
    return 'ترقية $opMember $members إلى مشرف';
  }

  @override
  String opRevokedAdmin(Object members, Object opMember) {
    return 'أزال $opMember دور المشرف من $members';
  }

  @override
  String opChangedGroupInfo(Object groupInfo, Object opMember) {
    return 'غير $opMember $groupInfo';
  }

  @override
  String opChangedMemberInfo(Object memberInfo, Object opMember) {
    return 'غير $opMember $memberInfo';
  }

  @override
  String changedGroupNameTo(Object name) {
    return 'تغيير اسم المجموعة إلى $name';
  }

  @override
  String changedGroupDescriptionTo(Object description) {
    return 'تغيير وصف المجموعة إلى $description';
  }

  @override
  String changedGroupAnnouncementTo(Object announcement) {
    return 'تغيير إعلان المجموعة إلى $announcement';
  }

  @override
  String get changedGroupAvatar => 'تغيير صورة المجموعة';

  @override
  String transferredGroupOwnershipTo(Object owner) {
    return 'نقل ملكية المجموعة إلى $owner';
  }

  @override
  String get changedGroupCustomInfo => 'تغيير معلومات المجموعة المخصصة';

  @override
  String get enabledGroupMute => 'تمكين كتم الصوت للمجموعة';

  @override
  String get disabledGroupMute => 'تعطيل كتم الصوت للمجموعة';

  @override
  String changedGroupMessageReceptionTo(Object setting) {
    return 'تغيير إعداد استقبال رسائل المجموعة إلى: $setting';
  }

  @override
  String changedApplyToJoinGroupTo(Object setting) {
    return 'تغيير إعداد التقدم للانضمام إلى المجموعة إلى: $setting';
  }

  @override
  String changedInviteToJoinGroupTo(Object setting) {
    return 'تغيير إعداد الدعوة للانضمام إلى المجموعة إلى: $setting';
  }

  @override
  String opUnmuted(Object user) {
    return '$user إلغاء كتم الصوت';
  }

  @override
  String opMuted(Object duration, Object user) {
    return '$user كتم الصوت لمدة $duration ثانية';
  }

  @override
  String get groupTips => 'نصائح المجموعة';

  @override
  String get receiveMessages => 'استلام الرسائل';

  @override
  String get doNotReceiveMessages => 'عدم استلام الرسائل';

  @override
  String get receiveMessagesWhenOnlineOnly => 'استلام الرسائل عند الاتصال فقط';

  @override
  String get disallowJoinGroup => 'عدم السماح بالانضمام إلى المجموعة';

  @override
  String get joinGroupNeedApproval => 'يتطلب الموافقة من المشرف للانضمام إلى المجموعة';

  @override
  String get joinGroupDirectly => 'الانضمام إلى المجموعة مباشرة بعد التقدم';

  @override
  String get disallowInviting => 'عدم السماح بالدعوة للانضمام إلى المجموعة';

  @override
  String get requireApprovalForInviting => 'يتطلب الموافقة من المشرف للدعوة للانضمام إلى المجموعة';

  @override
  String get joinDirectlyBeenInvited => 'الانضمام إلى المجموعة مباشرة بعد تلقي الدعوة';

  @override
  String get unmuted => 'إلغاء كتم الصوت';

  @override
  String muteTime(Object duration) {
    return 'كتم الصوت لمدة $duration ثانية';
  }

  @override
  String get poll => 'استطلاع';

  @override
  String callDuration(Object duration) {
    return 'مدة المكالمة: $duration';
  }

  @override
  String get selectMembers => 'اختر الأعضاء';

  @override
  String numSelectMembers(int num) {
    String _temp0 = intl.Intl.pluralLogic(
      num,
      locale: localeName,
      other: '$num مختار',
      zero: 'اختر الأعضاء',
    );
    return '$_temp0';
  }

  @override
  String get searchMembers => 'البحث عن أعضاء';

  @override
  String get startCall => 'بدء المكالمة';

  @override
  String get clear => 'مسح';

  @override
  String groupSubtitle(Object count, Object name) {
    return '$name و $count آخرين';
  }

  @override
  String get markAsUnread => 'وضع علامة كغير مقروء';

  @override
  String get hide => 'إخفاء';

  @override
  String get unreadMessagesBelow => 'رسائل غير مقروءة أدناه';

  @override
  String get ar => 'اَلْعَرَبِيَّةُ';

  @override
  String get tencentCloudChat => 'Tencent Cloud Chat';

  @override
  String get changeTheme => 'تغيير المظهر';

  @override
  String get deleteAccountNotification => 'بعد حذف الحساب، لن تتمكن من استخدام حسابك الحالي، وسيتم حذف البيانات المتعلقة ولا يمكن استردادها.';

  @override
  String get restartAppForLanguage => 'يرجى إعادة تشغيل التطبيق لتفعيل تغيير اللغة';

  @override
  String get deleteAllMessages => 'حذف جميع الرسائل';

  @override
  String get downloading => 'جارٍ التنزيل...';

  @override
  String get viewFullImage => 'عرض الصورة بالكامل';

  @override
  String get messageRecall => 'استرجاع الرسالة';

  @override
  String get messageRecallConfirmation => 'هل أنت متأكد من أنك تريد استرجاع هذه الرسالة؟';

  @override
  String get quit => 'مغادرة المجموعة';

  @override
  String get quitAndDelete => 'إنهاء وحذف';

  @override
  String get setGroupName => 'تعيين اسم المجموعة';

  @override
  String get groupAddAny => 'أي';

  @override
  String get groupAddAuth => 'يحتاج إلى الموافقة';

  @override
  String get groupAddForbid => 'ممنوع';

  @override
  String get groupOwner => 'مالك المجموعة';

  @override
  String get groupMember => 'عضو';

  @override
  String get dismissAdmin => 'فصل المشرف';

  @override
  String get welcomeToTencentCloudChat => 'مرحبًا بك في Tencent Cloud Chat';

  @override
  String get draft => 'مسودة';

  @override
  String get openInNewWindow => 'افتح في نافذة جديدة';

  @override
  String get selectAChat => 'اختر محادثة';

  @override
  String get noConversationSelected => 'لم يتم تحديد محادثة';

  @override
  String get unavailableToSendMessage => 'غير قادر على إرسال رسالة';

  @override
  String get noSuchGroup => 'لا يوجد مجموعة من هذا النوع';

  @override
  String get notGroupMember => 'لست عضوًا في المجموعة';

  @override
  String get userNotFound => 'المستخدم غير موجود';

  @override
  String get userBlockedYou => 'المستخدم قام بحظرك';

  @override
  String get muted => 'تم كتم الصوت';

  @override
  String get groupMuted => 'تم كتم صوت المجموعة';

  @override
  String get cantSendMessage => 'لا يمكن إرسال الرسالة';

  @override
  String get media => 'وسائل الإعلام';

  @override
  String sendToSomeChat(String name) {
    return 'إرسال إلى $name';
  }

  @override
  String get unableToSendWithFolders => 'تعذر إرسال الملفات بسبب تضمين المجلدات. يرجى تحديد الملفات الفردية فقط.';

  @override
  String get channelSwitch => 'القناة: ';

  @override
  String get weChat => 'وي تشات';

  @override
  String get tGWA => 'تيليجرام و واتساب';

  @override
  String get contactUsIfQuestions => 'في حال وجود أي أسئلة أو أفكار أخرى، لا تتردد في الاتصال بنا!';

  @override
  String get chatNow => 'دردش الآن';

  @override
  String get onlineServiceTimeFrom10To20 => 'وقت الخدمة عبر الإنترنت: من الساعة 10 صباحًا حتى الساعة 8 مساءً، من الاثنين إلى الجمعة';

  @override
  String get officialWebsite => 'الموقع الرسمي';

  @override
  String get allSDKs => 'جميع SDK';

  @override
  String get sourceCode => 'الكود المصدري';

  @override
  String get personalInformationCollectionList => 'قائمة جمع المعلومات الشخصية';

  @override
  String get thirdPartyInformationSharingList => 'قائمة مشاركة المعلومات من طرف ثالث';

  @override
  String get version => 'الإصدار';

  @override
  String get feedback => 'تعليق';

  @override
  String get me => 'أنا';

  @override
  String get about => 'يقدم';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get unpin => 'إلغاء التثبيت';

  @override
  String mentionedMessages(num count) {
    return '$count رسائل ذكرتني';
  }

  @override
  String get longPressToNavigate => 'اضغط واستمر لعرض';

  @override
  String get permissionDeniedTitle => 'تم رفض الإذن';

  @override
  String permissionDeniedContent(Object permissionString) {
    return 'يرجى الانتقال إلى الإعدادات وتمكين إذن $permissionString.';
  }

  @override
  String get goToSettingsButtonText => 'الانتقال إلى الإعدادات';

  @override
  String get originalMessageNotFound => 'لم يتم العثور على الرسالة الأصلية';

  @override
  String get markAsRead => 'وضع علامة مقروء';

  @override
  String get reEdit => 'إعادة تحرير';
}
