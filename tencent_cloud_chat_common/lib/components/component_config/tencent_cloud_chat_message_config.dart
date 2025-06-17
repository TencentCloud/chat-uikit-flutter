// A typedef for a function that takes optional named parameters userID and groupID,
// and returns a boolean value.
import 'package:tencent_cloud_chat_common/components/component_config/tencent_cloud_chat_message_common_defines.dart';
import 'package:tencent_cloud_chat_common/data/message/tencent_cloud_chat_message_data.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';

typedef TencentCloudChatMessageValueConfig<T> = T Function({String? userID, String? groupID, String? topicID});

typedef TencentCloudChatMessageValueConfigWithMessage<T> = T Function(
    {String? userID, String? groupID, String? topicID, V2TimMessage? message});

// A factory function that creates a default TencentCloudChatMessageBoolConfig function.
// The created function returns the specified boolean [value] when called.
TencentCloudChatMessageValueConfig<T> createDefaultValue<T>(T value) {
  return ({userID, groupID, topicID}) => value;
}

TencentCloudChatMessageValueConfigWithMessage<T> createDefaultValueWithMessage<T>(T value) {
  return ({userID, groupID, topicID, message}) => value;
}

// This class represents the configuration for Tencent Cloud Chat Message component.
//
// It includes various configuration options such as useGroupMessageReadReceipt,
// showSelfAvatar, and showOthersAvatar. Each option can be customized using a
// TencentCloudChatMessageBoolConfig or other function like this, which takes optional named parameters
// userID, groupID and topicID, and returns a value.
class TencentCloudChatMessageConfig {
  /// A configuration option that determines whether to show the avatar of the current user.
  TencentCloudChatMessageValueConfig<bool> _showSelfAvatar;

  /// A configuration option that determines whether to show the avatar of other users.
  TencentCloudChatMessageValueConfig<bool> _showOthersAvatar;

  /// A configuration option that determines whether to display the sender's name for messages.
  /// Please note that if the message sender is the current user, the sender's name will be hidden.
  /// Using this feature will align the avatar with the top of the message.
  TencentCloudChatMessageValueConfig<bool> _showMessageSenderName;

  /// A configuration option that determines whether to show the time indicator for each messages.
  TencentCloudChatMessageValueConfig<bool> _showMessageTimeIndicator;

  /// A configuration option that determines whether to show the status indicator for each messages.
  TencentCloudChatMessageValueConfig<bool> _showMessageStatusIndicator;

  /// A configuration option that determines whether allow message sender to delete the message for everyone, this feature only works with Premium Edition.
  TencentCloudChatMessageValueConfig<bool> _enableMessageDeleteForEveryone;

  /// A configuration option that determines whether allow report read status for coming messages automatically for messages in current conversation.
  TencentCloudChatMessageValueConfig<bool> _enableAutoReportReadStatusForComingMessages;

  /// A configuration option that determines whether to parse and render text messages as Markdown formatted content.
  TencentCloudChatMessageValueConfig<bool> _enableParseMarkdown;

  /// A configuration option that controls whether to enable Emoji reactions for messages.
  /// The `tencent_cloud_chat_sticker` package is required to use this feature, so it must be imported first.
  TencentCloudChatMessageValueConfig<bool> _enableMessageReaction;
  /// A configuration option that determines whether allow mention group admins and owner only.
  TencentCloudChatMessageValueConfig<bool> _mentionGroupAdminAndOwnerOnly;

  /// A configuration option that specifies the message referencing behavior.
  /// If set to true, the message context menu will display a `Reply` option, which, when used in group chats, will automatically mention (@) the sender of the original message.
  /// If set to false, the message context menu will display a `Quote` option, without automatically mentioning (@) the sender of the original message.
  /// [Default]: true
  TencentCloudChatMessageValueConfig<bool> _enableQuoteWithMention;

  /// The offline push info for sending message, fields with null specify will use default configurations.
  TencentCloudChatMessageValueConfigWithMessage<OfflinePushInfo> _messageOfflinePushInfo;

  /// A configuration option that determines whether to show some of the default attachment options in the message attachment menu.
  /// This configuration class can be used to customize the attachment menu.
  TencentCloudChatMessageValueConfig<TencentCloudChatMessageAttachmentConfig> _attachmentConfig;

  TencentCloudChatMessageValueConfig<TencentCloudChatTimeDividerConfig> _timeDividerConfig;

  TencentCloudChatMessageValueConfig<List<TencentCloudChatMessageGeneralOptionItem>>
      _additionalAttachmentOptionsForMobile;

  TencentCloudChatMessageValueConfig<List<TencentCloudChatMessageGeneralOptionItem>>
      _additionalInputControlBarOptionsForDesktop;

  /// Determines whether to enable specific or all options in the default message selection operation menu.
  /// This configuration class can be used to customize the selection menu.
  TencentCloudChatMessageValueConfig<TencentCloudChatMessageDefaultMessageSelectionOptionsConfig>
      _defaultMessageSelectionOperationsConfig;

  /// Determines whether to enable specific or all options in the default message menu.
  /// This configuration class can be used
  /// in conjunction with `defaultMessageMenuConfig` to customize the message menu.
  TencentCloudChatMessageValueConfig<TencentCloudChatMessageDefaultMessageMenuConfig> _defaultMessageMenuConfig;

  /// Allows adding additional message menu options through this list.
  /// This can be used in conjunction with
  /// `defaultMessageMenuConfig` to further customize the message menu.
  TencentCloudChatMessageValueConfigWithMessage<List<TencentCloudChatMessageGeneralOptionItem>>
      _additionalMessageMenuOptions;

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
  /// TencentCloudChatMessageConfig(enabledGroupTypesForMessageReadReceipt: ({userID, groupID}) => [
  ///   GroupType.Work,
  ///   GroupType.Public,
  /// ]);
  /// ```
  TencentCloudChatMessageValueConfig<List<String>> _enabledGroupTypesForMessageReadReceipt;

  /// A list of custom sticker sets provided by you.
  ///
  /// You can add your own sticker sets to the application by including
  /// them in this list. Each sticker set should be an instance of the
  /// `TencentCloudChatStickerSet` class. These additional sticker sets
  /// allow users to further personalize their chat experience and use
  /// their favorite stickers for expressive communication.
  TencentCloudChatMessageValueConfig<List<TencentCloudChatStickerSet>> _additionalStickerSets;

  /// The number of lines for the message input box on the desktop platform.
  /// This value determines the height of the message input box.
  TencentCloudChatMessageValueConfig<int> _desktopMessageInputLines;

  /// The maximum time limit for recalling a self-sent message.
  /// You must first set this time limit on the Tencent Cloud Chat console,
  /// and then specify this field if you wish to use a different time limit than the default one.
  ///
  /// [Default]: 120
  /// [Unit]: Seconds
  TencentCloudChatMessageValueConfig<int> _recallTimeLimit;

  /// Constructor for TencentCloudChatMessageConfig.
  TencentCloudChatMessageConfig({
    TencentCloudChatMessageValueConfig<bool>? useGroupMessageReadReceipt,
    TencentCloudChatMessageValueConfig<bool>? showSelfAvatar,
    TencentCloudChatMessageValueConfig<bool>? enableAutoReportReadStatusForComingMessages,
    TencentCloudChatMessageValueConfig<bool>? enableParseMarkdown,
    TencentCloudChatMessageValueConfig<bool>? enableReplyWithMention,
    TencentCloudChatMessageValueConfig<bool>? mentionGroupAdminAndOwnerOnly,
    TencentCloudChatMessageValueConfig<int>? desktopMessageInputLines,
    TencentCloudChatMessageValueConfig<int>? recallTimeLimit,
    TencentCloudChatMessageValueConfig<bool>? showOthersAvatar,
    TencentCloudChatMessageValueConfig<bool>? showMessageSenderName,
    TencentCloudChatMessageValueConfig<bool>? showMessageTimeIndicator,
    TencentCloudChatMessageValueConfig<bool>? showMessageStatusIndicator,
    TencentCloudChatMessageValueConfig<bool>? enableMessageDeleteForEveryone,
    TencentCloudChatMessageValueConfig<bool>? enableMessageReaction,
    TencentCloudChatMessageValueConfigWithMessage<OfflinePushInfo>? messageOfflinePushInfo,
    TencentCloudChatMessageValueConfig<List<TencentCloudChatStickerSet>>? additionalStickerSets,
    TencentCloudChatMessageValueConfig<TencentCloudChatMessageAttachmentConfig>? attachmentConfig,
    TencentCloudChatMessageValueConfig<List<TencentCloudChatMessageGeneralOptionItem>>?
        additionalAttachmentOptionsForMobile,
    TencentCloudChatMessageValueConfig<List<TencentCloudChatMessageGeneralOptionItem>>?
        additionalInputControlBarOptionsForDesktop,
    TencentCloudChatMessageValueConfig<TencentCloudChatMessageDefaultMessageSelectionOptionsConfig>?
        defaultMessageSelectionOperationsConfig,
    TencentCloudChatMessageValueConfig<TencentCloudChatMessageDefaultMessageMenuConfig>? defaultMessageMenuConfig,
    TencentCloudChatMessageValueConfigWithMessage<List<TencentCloudChatMessageGeneralOptionItem>>?
        additionalMessageMenuOptions,
    TencentCloudChatMessageValueConfig<TencentCloudChatTimeDividerConfig>? timeDividerConfig,
    TencentCloudChatMessageValueConfig<List<String>>? enabledGroupTypesForMessageReadReceipt,
  })  : _showSelfAvatar = showSelfAvatar ?? createDefaultValue(false),
        _showOthersAvatar = showOthersAvatar ?? createDefaultValue(true),
        _mentionGroupAdminAndOwnerOnly = mentionGroupAdminAndOwnerOnly ?? createDefaultValue(false),
        _enableParseMarkdown = enableParseMarkdown ?? createDefaultValue(false),
        _enableQuoteWithMention = enableReplyWithMention ?? createDefaultValue(true),
        _enableAutoReportReadStatusForComingMessages =
            enableAutoReportReadStatusForComingMessages ?? createDefaultValue(true),
        _showMessageTimeIndicator = showMessageTimeIndicator ?? createDefaultValue(true),
        _showMessageStatusIndicator = showMessageStatusIndicator ?? createDefaultValue(true),
        _showMessageSenderName = showMessageSenderName ?? createDefaultValue(false),
        _desktopMessageInputLines = desktopMessageInputLines ?? createDefaultValue(5),
        _recallTimeLimit = recallTimeLimit ?? createDefaultValue(120),
        _enableMessageDeleteForEveryone = enableMessageDeleteForEveryone ?? createDefaultValue(true),
        _enableMessageReaction = enableMessageReaction ?? createDefaultValue(true),
        _attachmentConfig = attachmentConfig ??
            createDefaultValue<TencentCloudChatMessageAttachmentConfig>(TencentCloudChatMessageAttachmentConfig()),
        _messageOfflinePushInfo = messageOfflinePushInfo ?? createDefaultValueWithMessage(OfflinePushInfo()),
        _additionalStickerSets = additionalStickerSets ?? createDefaultValue<List<TencentCloudChatStickerSet>>([]),
        _defaultMessageSelectionOperationsConfig = defaultMessageSelectionOperationsConfig ??
            createDefaultValue<TencentCloudChatMessageDefaultMessageSelectionOptionsConfig>(
                TencentCloudChatMessageDefaultMessageSelectionOptionsConfig()),
        _defaultMessageMenuConfig = defaultMessageMenuConfig ??
            createDefaultValue<TencentCloudChatMessageDefaultMessageMenuConfig>(
                TencentCloudChatMessageDefaultMessageMenuConfig()),
        _additionalMessageMenuOptions = additionalMessageMenuOptions ??
            createDefaultValueWithMessage<List<TencentCloudChatMessageGeneralOptionItem>>([]),
        _timeDividerConfig = timeDividerConfig ??
            createDefaultValue<TencentCloudChatTimeDividerConfig>(TencentCloudChatTimeDividerConfig()),
        _enabledGroupTypesForMessageReadReceipt =
            enabledGroupTypesForMessageReadReceipt ?? createDefaultValue<List<String>>([GroupType.Work, GroupType.Public, GroupType.Meeting]),
        _additionalInputControlBarOptionsForDesktop = additionalInputControlBarOptionsForDesktop ??
            createDefaultValue<List<TencentCloudChatMessageGeneralOptionItem>>([]),
        _additionalAttachmentOptionsForMobile = additionalAttachmentOptionsForMobile ??
            createDefaultValue<List<TencentCloudChatMessageGeneralOptionItem>>([]);

  void setConfigs({
    TencentCloudChatMessageValueConfig<bool>? useGroupMessageReadReceipt,
    TencentCloudChatMessageValueConfig<bool>? showSelfAvatar,
    TencentCloudChatMessageValueConfig<int>? desktopMessageInputLines,
    TencentCloudChatMessageValueConfig<int>? recallTimeLimit,
    TencentCloudChatMessageValueConfig<bool>? showOthersAvatar,
    TencentCloudChatMessageValueConfig<bool>? enableAutoReportReadStatusForComingMessages,
    TencentCloudChatMessageValueConfig<bool>? enableParseMarkdown,
    TencentCloudChatMessageValueConfig<TencentCloudChatMessageAttachmentConfig>? attachmentConfig,
    TencentCloudChatMessageValueConfig<bool>? showMessageTimeIndicator,
    TencentCloudChatMessageValueConfig<bool>? enableMessageReaction,
    TencentCloudChatMessageValueConfig<bool>? showMessageStatusIndicator,
    enableMessageDeleteForEveryone,
    TencentCloudChatMessageValueConfig<bool>? enableDefaultEmojis,
    TencentCloudChatMessageValueConfig<bool>? enableReplyWithMention,
    TencentCloudChatMessageValueConfig<bool>? showMessageSenderName,
    TencentCloudChatMessageValueConfig<bool>? enableMessageTranslate,
    TencentCloudChatMessageValueConfigWithMessage<OfflinePushInfo>? messageOfflinePushInfo,
    TencentCloudChatMessageValueConfig<List<TencentCloudChatStickerSet>>? additionalStickerSets,
    TencentCloudChatMessageValueConfig<List<TencentCloudChatMessageGeneralOptionItem>>?
        additionalAttachmentOptionsForMobile,
    TencentCloudChatMessageValueConfig<bool>? mentionGroupAdminAndOwnerOnly,
    TencentCloudChatMessageValueConfig<List<TencentCloudChatMessageGeneralOptionItem>>?
        additionalInputControlBarOptionsForDesktop,
    TencentCloudChatMessageValueConfig<TencentCloudChatMessageDefaultMessageSelectionOptionsConfig>?
        defaultMessageSelectionOperationsConfig,
    TencentCloudChatMessageValueConfig<TencentCloudChatMessageDefaultMessageMenuConfig>? defaultMessageMenuConfig,
    TencentCloudChatMessageValueConfigWithMessage<List<TencentCloudChatMessageGeneralOptionItem>>?
        additionalMessageMenuOptions,
    TencentCloudChatMessageValueConfig<TencentCloudChatTimeDividerConfig>? timeDividerConfig,
    TencentCloudChatMessageValueConfig<List<String>>? enabledGroupTypesForMessageReadReceipt,
  }) {
    _showSelfAvatar = showSelfAvatar ?? _showSelfAvatar;
    _showOthersAvatar = showOthersAvatar ?? _showOthersAvatar;
    _showMessageTimeIndicator = showMessageTimeIndicator ?? _showMessageTimeIndicator;
    _showMessageStatusIndicator = showMessageStatusIndicator ?? _showMessageStatusIndicator;
    _desktopMessageInputLines = desktopMessageInputLines ?? _desktopMessageInputLines;
    _enableParseMarkdown = enableParseMarkdown ?? createDefaultValue(false);
    _enableMessageReaction = enableMessageReaction ?? createDefaultValue(true);
    _recallTimeLimit = recallTimeLimit ?? _recallTimeLimit;
    _enableAutoReportReadStatusForComingMessages =
        enableAutoReportReadStatusForComingMessages ?? createDefaultValue(true);
    _mentionGroupAdminAndOwnerOnly = mentionGroupAdminAndOwnerOnly ?? createDefaultValue(false);
    _enableMessageDeleteForEveryone = enableMessageDeleteForEveryone ?? _enableMessageDeleteForEveryone;
    _enableQuoteWithMention = enableReplyWithMention ?? createDefaultValue(true);
    _attachmentConfig = attachmentConfig ??
        createDefaultValue<TencentCloudChatMessageAttachmentConfig>(TencentCloudChatMessageAttachmentConfig());
    _messageOfflinePushInfo = messageOfflinePushInfo ?? _messageOfflinePushInfo;
    _showMessageSenderName = showMessageSenderName ?? createDefaultValue(false);
    _additionalStickerSets = additionalStickerSets ?? _additionalStickerSets;
    _defaultMessageSelectionOperationsConfig =
        defaultMessageSelectionOperationsConfig ?? _defaultMessageSelectionOperationsConfig;
    _defaultMessageMenuConfig = defaultMessageMenuConfig ?? _defaultMessageMenuConfig;
    _additionalMessageMenuOptions = additionalMessageMenuOptions ?? _additionalMessageMenuOptions;
    _timeDividerConfig = timeDividerConfig ?? _timeDividerConfig;
    _enabledGroupTypesForMessageReadReceipt =
        enabledGroupTypesForMessageReadReceipt ?? _enabledGroupTypesForMessageReadReceipt;
    _additionalInputControlBarOptionsForDesktop =
        additionalInputControlBarOptionsForDesktop ?? _additionalInputControlBarOptionsForDesktop;
    _additionalAttachmentOptionsForMobile =
        additionalAttachmentOptionsForMobile ?? _additionalAttachmentOptionsForMobile;
    TencentCloudChat.instance.dataInstance.messageData.notifyListener(TencentCloudChatMessageDataKeys.config);
  }

  TencentCloudChatMessageValueConfig<bool> get enableQuoteWithMention => _enableQuoteWithMention;

  TencentCloudChatMessageValueConfig<bool> get showOthersAvatar => _showOthersAvatar;

  TencentCloudChatMessageValueConfig<bool> get showMessageSenderName => _showMessageSenderName;

  TencentCloudChatMessageValueConfig<bool> get showMessageTimeIndicator => _showMessageTimeIndicator;

  TencentCloudChatMessageValueConfig<bool> get mentionGroupAdminAndOwnerOnly => _mentionGroupAdminAndOwnerOnly;

  TencentCloudChatMessageValueConfig<bool> get showMessageStatusIndicator => _showMessageStatusIndicator;

  TencentCloudChatMessageValueConfig<bool> get enableMessageDeleteForEveryone => _enableMessageDeleteForEveryone;

  TencentCloudChatMessageValueConfig<bool> get enableAutoReportReadStatusForComingMessages =>
      _enableAutoReportReadStatusForComingMessages;

  TencentCloudChatMessageValueConfigWithMessage<OfflinePushInfo> get messageOfflinePushInfo => _messageOfflinePushInfo;

  TencentCloudChatMessageValueConfig<TencentCloudChatTimeDividerConfig> get timeDividerConfig => _timeDividerConfig;

  TencentCloudChatMessageValueConfig<TencentCloudChatMessageAttachmentConfig> get attachmentConfig => _attachmentConfig;

  TencentCloudChatMessageValueConfig<List<TencentCloudChatMessageGeneralOptionItem>>
      get additionalAttachmentOptionsForMobile => _additionalAttachmentOptionsForMobile;

  TencentCloudChatMessageValueConfig<List<TencentCloudChatMessageGeneralOptionItem>>
      get additionalInputControlBarOptionsForDesktop => _additionalInputControlBarOptionsForDesktop;

  TencentCloudChatMessageValueConfig<TencentCloudChatMessageDefaultMessageSelectionOptionsConfig>
      get defaultMessageSelectionOperationsConfig => _defaultMessageSelectionOperationsConfig;

  TencentCloudChatMessageValueConfig<TencentCloudChatMessageDefaultMessageMenuConfig> get defaultMessageMenuConfig =>
      _defaultMessageMenuConfig;

  TencentCloudChatMessageValueConfigWithMessage<List<TencentCloudChatMessageGeneralOptionItem>>
      get additionalMessageMenuOptions => _additionalMessageMenuOptions;

  TencentCloudChatMessageValueConfig<bool> get showSelfAvatar => _showSelfAvatar;

  TencentCloudChatMessageValueConfig<List<String>> get enabledGroupTypesForMessageReadReceipt => _enabledGroupTypesForMessageReadReceipt;

  TencentCloudChatMessageValueConfig<bool> get enableMessageReaction => _enableMessageReaction;

  TencentCloudChatMessageValueConfig<bool> get enableParseMarkdown => _enableParseMarkdown;

  TencentCloudChatMessageValueConfig<int> get desktopMessageInputLines => _desktopMessageInputLines;

  TencentCloudChatMessageValueConfig<int> get recallTimeLimit => _recallTimeLimit;
}
