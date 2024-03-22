// A typedef for a function that takes optional named parameters userID and groupID,
// and returns a boolean value.
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_message_common_defines.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';

typedef TencentCloudChatMessageValueConfig<T> = T Function(
    {String? userID, String? groupID});

typedef TencentCloudChatMessageValueConfigWithMessage<T> = T Function(
    {String? userID, String? groupID, V2TimMessage? message});

// A factory function that creates a default TencentCloudChatMessageBoolConfig function.
// The created function returns the specified boolean [value] when called.
TencentCloudChatMessageValueConfig<T> createDefaultValue<T>(T value) {
  return ({userID, groupID}) => value;
}

TencentCloudChatMessageValueConfigWithMessage<T>
    createDefaultValueWithMessage<T>(T value) {
  return ({userID, groupID, message}) => value;
}

// This class represents the configuration for  Tencent Cloud Chat Message component.
//
// It includes various configuration options such as useGroupMessageReadReceipt,
// showSelfAvatar, and showOthersAvatar. Each option can be customized using a
// TencentCloudChatMessageBoolConfig or other function like this, which takes optional named parameters
// userID and groupID, and returns a value.
class TencentCloudChatMessageConfig {
  // A configuration option that determines whether to show the avatar of the current user.
  final TencentCloudChatMessageValueConfig<bool> showSelfAvatar;

  // A configuration option that determines whether to show the avatar of other users.
  final TencentCloudChatMessageValueConfig<bool> showOthersAvatar;

  // A configuration option that determines whether to show the time indicator for each messages.
  final TencentCloudChatMessageValueConfig<bool> showMessageTimeIndicator;

  // A configuration option that determines whether to show the status indicator for each messages.
  final TencentCloudChatMessageValueConfig<bool> showMessageStatusIndicator;

  // A configuration option that determines whether allow message sender to delete the message for everyone, this feature only works with Premium Edition.
  final TencentCloudChatMessageValueConfig<bool> enableMessageDeleteForEveryone;

  // The offline push info for sending message, fields with null specify will use default configurations.
  final TencentCloudChatMessageValueConfigWithMessage<OfflinePushInfo>
      messageOfflinePushInfo;

  final TencentCloudChatMessageValueConfig<TencentCloudChatTimeDividerConfig>
      timeDividerConfig;

  final TencentCloudChatMessageValueConfig<
          List<TencentCloudChatMessageGeneralOptionItem>>
      additionalAttachmentOptionsForMobile;

  final TencentCloudChatMessageValueConfig<
          List<TencentCloudChatMessageGeneralOptionItem>>
      additionalInputControlBarOptionsForDesktop;

  final TencentCloudChatMessageValueConfig<
          List<TencentCloudChatMessageGeneralOptionItem>>
      additionalMessageMenuOptions;

  /// A list of `GroupType` enums specifying which group types should have
  /// the message read receipt feature enabled.
  ///
  /// The message read receipt feature allows group members to see if their
  /// messages have been read by other members and the following details. By including specific group
  /// types in this list, you can enable this feature only for those groups.
  ///
  /// For example, if you want to enable the message read receipt feature
  /// for Work and Public groups, but not for Meeting, AVChatRoom,
  /// or Community groups, you can create a `TencentCloudChatMessageConfig` instance like this:
  ///
  /// ```
  /// final config = TencentCloudChatMessageConfig(enabledGroupTypesForMessageReadReceipt: ({userID, groupID}) => [
  ///   GroupType.Work,
  ///   GroupType.Public,
  /// ]);
  /// ```
  final TencentCloudChatMessageValueConfig<List<String>>
      enabledGroupTypesForMessageReadReceipt;

  /// Determines whether to use the built-in QQ-style emoji set.
  ///
  /// When set to `true`, it will enable the built-in QQ-style
  /// emoji set, which consists of small icons that can be embedded within
  /// text messages. Users can choose from these emojis to enhance their
  /// communication and express their emotions in a more engaging way.
  final TencentCloudChatMessageValueConfig<bool> enableDefaultEmojis;

  /// A list of custom sticker sets provided by you.
  ///
  /// You can add your own sticker sets to the application by including
  /// them in this list. Each sticker set should be an instance of the
  /// `TencentCloudChatStickerSet` class. These additional sticker sets
  /// allow users to further personalize their chat experience and use
  /// their favorite stickers for expressive communication.
  final TencentCloudChatMessageValueConfig<List<TencentCloudChatStickerSet>>
      additionalStickerSets;

  /// The number of lines for the message input box on the desktop platform.
  /// This value determines the height of the message input box.
  final TencentCloudChatMessageValueConfig<int> desktopMessageInputLines;

  /// The maximum time limit for recalling a self-sent message.
  /// You must first set this time limit on the Tencent Cloud Chat console,
  /// and then specify this field if you wish to use a different time limit than the default one.
  ///
  /// [Default]: 120
  /// [Unit]: Seconds
  final TencentCloudChatMessageValueConfig<int> recallTimeLimit;

  /// Constructor for TencentCloudChatMessageConfig.
  TencentCloudChatMessageConfig({
    TencentCloudChatMessageValueConfig<bool>? useGroupMessageReadReceipt,
    TencentCloudChatMessageValueConfig<bool>? showSelfAvatar,
    TencentCloudChatMessageValueConfig<int>? desktopMessageInputLines,
    TencentCloudChatMessageValueConfig<int>? recallTimeLimit,
    TencentCloudChatMessageValueConfig<bool>? showOthersAvatar,
    TencentCloudChatMessageValueConfig<bool>? showMessageTimeIndicator,
    TencentCloudChatMessageValueConfig<bool>? showMessageStatusIndicator,
    TencentCloudChatMessageValueConfig<bool>? enableMessageDeleteForEveryone,
    TencentCloudChatMessageValueConfig<bool>? enableDefaultEmojis,
    TencentCloudChatMessageValueConfigWithMessage<OfflinePushInfo>?
        messageOfflinePushInfo,
    TencentCloudChatMessageValueConfig<List<TencentCloudChatStickerSet>>?
        additionalStickerSets,
    TencentCloudChatMessageValueConfig<
            List<TencentCloudChatMessageGeneralOptionItem>>?
        additionalAttachmentOptionsForMobile,
    TencentCloudChatMessageValueConfig<
            List<TencentCloudChatMessageGeneralOptionItem>>?
        additionalInputControlBarOptionsForDesktop,
    TencentCloudChatMessageValueConfig<
            List<TencentCloudChatMessageGeneralOptionItem>>?
        additionalMessageMenuOptions,
    TencentCloudChatMessageValueConfig<TencentCloudChatTimeDividerConfig>?
        timeDividerConfig,
    TencentCloudChatMessageValueConfig<List<String>>?
        enabledGroupTypesForMessageReadReceipt,
  })  : showSelfAvatar = showSelfAvatar ?? createDefaultValue(false),
        showOthersAvatar = showOthersAvatar ?? createDefaultValue(true),
        showMessageTimeIndicator = showMessageTimeIndicator ?? createDefaultValue(true),
        showMessageStatusIndicator = showMessageStatusIndicator ?? createDefaultValue(true),
        desktopMessageInputLines =
            desktopMessageInputLines ?? createDefaultValue(5),
        recallTimeLimit = recallTimeLimit ?? createDefaultValue(120),
        enableMessageDeleteForEveryone =
            enableMessageDeleteForEveryone ?? createDefaultValue(true),
        enableDefaultEmojis = enableDefaultEmojis ?? createDefaultValue(true),
        messageOfflinePushInfo = messageOfflinePushInfo ??
            createDefaultValueWithMessage(OfflinePushInfo()),
        additionalStickerSets = additionalStickerSets ??
            createDefaultValue<List<TencentCloudChatStickerSet>>([]),
        additionalMessageMenuOptions = additionalMessageMenuOptions ??
            createDefaultValue<List<TencentCloudChatMessageGeneralOptionItem>>(
                []),
        timeDividerConfig = timeDividerConfig ??
            createDefaultValue<TencentCloudChatTimeDividerConfig>(
                TencentCloudChatTimeDividerConfig()),
        enabledGroupTypesForMessageReadReceipt =
            enabledGroupTypesForMessageReadReceipt ??
                createDefaultValue<List<String>>(
                    [GroupType.Work, GroupType.Public, GroupType.Meeting]),
        additionalInputControlBarOptionsForDesktop =
            additionalInputControlBarOptionsForDesktop ??
                createDefaultValue<
                    List<TencentCloudChatMessageGeneralOptionItem>>([]),
        additionalAttachmentOptionsForMobile =
            additionalAttachmentOptionsForMobile ??
                createDefaultValue<
                    List<TencentCloudChatMessageGeneralOptionItem>>([]);
}
