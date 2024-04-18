// A typedef for a function that takes optional named parameters userID and groupID,
// and returns a boolean value.
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_message_common_defines.dart';
import 'package:tencent_cloud_chat/data/message/tencent_cloud_chat_message_data.dart';
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

// This class represents the configuration for Tencent Cloud Chat Message component.
//
// It includes various configuration options such as useGroupMessageReadReceipt,
// showSelfAvatar, and showOthersAvatar. Each option can be customized using a
// TencentCloudChatMessageBoolConfig or other function like this, which takes optional named parameters
// userID and groupID, and returns a value.
class TencentCloudChatMessageConfig {
  /// A configuration option that determines whether to show the avatar of the current user.
  TencentCloudChatMessageValueConfig<bool> _showSelfAvatar;

  TencentCloudChatMessageValueConfig<bool> get showSelfAvatar =>
      _showSelfAvatar;

  /// A configuration option that determines whether to show the avatar of other users.
  TencentCloudChatMessageValueConfig<bool> _showOthersAvatar;

  /// A configuration option that determines whether to show the time indicator for each messages.
  TencentCloudChatMessageValueConfig<bool> _showMessageTimeIndicator;

  /// A configuration option that determines whether to show the status indicator for each messages.
  TencentCloudChatMessageValueConfig<bool> _showMessageStatusIndicator;

  /// A configuration option that determines whether allow message sender to delete the message for everyone, this feature only works with Premium Edition.
  TencentCloudChatMessageValueConfig<bool> _enableMessageDeleteForEveryone;

  /// The offline push info for sending message, fields with null specify will use default configurations.
  TencentCloudChatMessageValueConfigWithMessage<OfflinePushInfo>
      _messageOfflinePushInfo;

  TencentCloudChatMessageValueConfig<TencentCloudChatTimeDividerConfig>
      _timeDividerConfig;

  TencentCloudChatMessageValueConfig<
          List<TencentCloudChatMessageGeneralOptionItem>>
      _additionalAttachmentOptionsForMobile;

  TencentCloudChatMessageValueConfig<
          List<TencentCloudChatMessageGeneralOptionItem>>
      _additionalInputControlBarOptionsForDesktop;

  /// Determines whether to enable specific or all options in the default message selection operation menu.
  /// This configuration class can be used to customize the selection menu.
  TencentCloudChatMessageValueConfig<
          TencentCloudChatMessageDefaultMessageSelectionOptionsConfig>
      _defaultMessageSelectionOperationsConfig;

  /// Determines whether to enable specific or all options in the default message menu.
  /// This configuration class can be used
  /// in conjunction with `defaultMessageMenuConfig` to customize the message menu.
  TencentCloudChatMessageValueConfig<
          TencentCloudChatMessageDefaultMessageMenuConfig>
      _defaultMessageMenuConfig;

  /// Allows adding additional message menu options through this list.
  /// This can be used in conjunction with
  /// `defaultMessageMenuConfig` to further customize the message menu.
  TencentCloudChatMessageValueConfig<
          List<TencentCloudChatMessageGeneralOptionItem>>
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
  TencentCloudChatMessageValueConfig<List<String>>
      _enabledGroupTypesForMessageReadReceipt;

  /// Determines whether to use the built-in QQ-style emoji set.
  ///
  /// When set to `true`, it will enable the built-in QQ-style
  /// emoji set, which consists of small icons that can be embedded within
  /// text messages. Users can choose from these emojis to enhance their
  /// communication and express their emotions in a more engaging way.
  TencentCloudChatMessageValueConfig<bool> _enableDefaultEmojis;

  /// A list of custom sticker sets provided by you.
  ///
  /// You can add your own sticker sets to the application by including
  /// them in this list. Each sticker set should be an instance of the
  /// `TencentCloudChatStickerSet` class. These additional sticker sets
  /// allow users to further personalize their chat experience and use
  /// their favorite stickers for expressive communication.
  TencentCloudChatMessageValueConfig<List<TencentCloudChatStickerSet>>
      _additionalStickerSets;

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
    TencentCloudChatMessageValueConfig<int>? desktopMessageInputLines,
    TencentCloudChatMessageValueConfig<int>? recallTimeLimit,
    TencentCloudChatMessageValueConfig<bool>? showOthersAvatar,
    TencentCloudChatMessageValueConfig<bool>? showMessageTimeIndicator,
    TencentCloudChatMessageValueConfig<bool>? showMessageStatusIndicator,
    enableMessageDeleteForEveryone,
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
            TencentCloudChatMessageDefaultMessageSelectionOptionsConfig>?
        defaultMessageSelectionOperationsConfig,
    TencentCloudChatMessageValueConfig<
            TencentCloudChatMessageDefaultMessageMenuConfig>?
        defaultMessageMenuConfig,
    TencentCloudChatMessageValueConfig<
            List<TencentCloudChatMessageGeneralOptionItem>>?
        additionalMessageMenuOptions,
    TencentCloudChatMessageValueConfig<TencentCloudChatTimeDividerConfig>?
        timeDividerConfig,
    TencentCloudChatMessageValueConfig<List<String>>?
        enabledGroupTypesForMessageReadReceipt,
  })  : _showSelfAvatar = showSelfAvatar ?? createDefaultValue(false),
        _showOthersAvatar = showOthersAvatar ?? createDefaultValue(true),
        _showMessageTimeIndicator =
            showMessageTimeIndicator ?? createDefaultValue(true),
        _showMessageStatusIndicator =
            showMessageStatusIndicator ?? createDefaultValue(true),
        _desktopMessageInputLines =
            desktopMessageInputLines ?? createDefaultValue(5),
        _recallTimeLimit = recallTimeLimit ?? createDefaultValue(120),
        _enableMessageDeleteForEveryone =
            enableMessageDeleteForEveryone ?? createDefaultValue(true),
        _enableDefaultEmojis = enableDefaultEmojis ?? createDefaultValue(true),
        _messageOfflinePushInfo = messageOfflinePushInfo ??
            createDefaultValueWithMessage(OfflinePushInfo()),
        _additionalStickerSets = additionalStickerSets ??
            createDefaultValue<List<TencentCloudChatStickerSet>>([]),
        _defaultMessageSelectionOperationsConfig =
            defaultMessageSelectionOperationsConfig ??
                createDefaultValue<
                        TencentCloudChatMessageDefaultMessageSelectionOptionsConfig>(
                    TencentCloudChatMessageDefaultMessageSelectionOptionsConfig()),
        _defaultMessageMenuConfig = defaultMessageMenuConfig ??
            createDefaultValue<TencentCloudChatMessageDefaultMessageMenuConfig>(
                TencentCloudChatMessageDefaultMessageMenuConfig()),
        _additionalMessageMenuOptions = additionalMessageMenuOptions ??
            createDefaultValue<List<TencentCloudChatMessageGeneralOptionItem>>(
                []),
        _timeDividerConfig = timeDividerConfig ??
            createDefaultValue<TencentCloudChatTimeDividerConfig>(
                TencentCloudChatTimeDividerConfig()),
        _enabledGroupTypesForMessageReadReceipt =
            enabledGroupTypesForMessageReadReceipt ??
                createDefaultValue<List<String>>([]),
        _additionalInputControlBarOptionsForDesktop =
            additionalInputControlBarOptionsForDesktop ??
                createDefaultValue<
                    List<TencentCloudChatMessageGeneralOptionItem>>([]),
        _additionalAttachmentOptionsForMobile =
            additionalAttachmentOptionsForMobile ??
                createDefaultValue<
                    List<TencentCloudChatMessageGeneralOptionItem>>([]);

  void setConfigs({
    TencentCloudChatMessageValueConfig<bool>? useGroupMessageReadReceipt,
    TencentCloudChatMessageValueConfig<bool>? showSelfAvatar,
    TencentCloudChatMessageValueConfig<int>? desktopMessageInputLines,
    TencentCloudChatMessageValueConfig<int>? recallTimeLimit,
    TencentCloudChatMessageValueConfig<bool>? showOthersAvatar,
    TencentCloudChatMessageValueConfig<bool>? showMessageTimeIndicator,
    TencentCloudChatMessageValueConfig<bool>? showMessageStatusIndicator,
    enableMessageDeleteForEveryone,
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
            TencentCloudChatMessageDefaultMessageSelectionOptionsConfig>?
        defaultMessageSelectionOperationsConfig,
    TencentCloudChatMessageValueConfig<
            TencentCloudChatMessageDefaultMessageMenuConfig>?
        defaultMessageMenuConfig,
    TencentCloudChatMessageValueConfig<
            List<TencentCloudChatMessageGeneralOptionItem>>?
        additionalMessageMenuOptions,
    TencentCloudChatMessageValueConfig<TencentCloudChatTimeDividerConfig>?
        timeDividerConfig,
    TencentCloudChatMessageValueConfig<List<String>>?
        enabledGroupTypesForMessageReadReceipt,
  }) {
    _showSelfAvatar = showSelfAvatar ?? _showSelfAvatar;
    _showOthersAvatar = showOthersAvatar ?? _showOthersAvatar;
    _showMessageTimeIndicator =
        showMessageTimeIndicator ?? _showMessageTimeIndicator;
    _showMessageStatusIndicator =
        showMessageStatusIndicator ?? _showMessageStatusIndicator;
    _desktopMessageInputLines =
        desktopMessageInputLines ?? _desktopMessageInputLines;
    _recallTimeLimit = recallTimeLimit ?? _recallTimeLimit;
    _enableMessageDeleteForEveryone =
        enableMessageDeleteForEveryone ?? _enableMessageDeleteForEveryone;
    _enableDefaultEmojis = enableDefaultEmojis ?? _enableDefaultEmojis;
    _messageOfflinePushInfo = messageOfflinePushInfo ?? _messageOfflinePushInfo;
    _additionalStickerSets = additionalStickerSets ?? _additionalStickerSets;
    _defaultMessageSelectionOperationsConfig =
        defaultMessageSelectionOperationsConfig ??
            _defaultMessageSelectionOperationsConfig;
    _defaultMessageMenuConfig =
        defaultMessageMenuConfig ?? _defaultMessageMenuConfig;
    _additionalMessageMenuOptions =
        additionalMessageMenuOptions ?? _additionalMessageMenuOptions;
    _timeDividerConfig = timeDividerConfig ?? _timeDividerConfig;
    _enabledGroupTypesForMessageReadReceipt =
        enabledGroupTypesForMessageReadReceipt ??
            _enabledGroupTypesForMessageReadReceipt;
    _additionalInputControlBarOptionsForDesktop =
        additionalInputControlBarOptionsForDesktop ??
            _additionalInputControlBarOptionsForDesktop;
    _additionalAttachmentOptionsForMobile =
        additionalAttachmentOptionsForMobile ??
            _additionalAttachmentOptionsForMobile;
    TencentCloudChat.instance.dataInstance.messageData
        .notifyListener(TencentCloudChatMessageDataKeys.config);
  }

  TencentCloudChatMessageValueConfig<bool> get showOthersAvatar =>
      _showOthersAvatar;

  TencentCloudChatMessageValueConfig<bool> get showMessageTimeIndicator =>
      _showMessageTimeIndicator;

  TencentCloudChatMessageValueConfig<bool> get showMessageStatusIndicator =>
      _showMessageStatusIndicator;

  TencentCloudChatMessageValueConfig<bool> get enableMessageDeleteForEveryone =>
      _enableMessageDeleteForEveryone;

  TencentCloudChatMessageValueConfigWithMessage<OfflinePushInfo>
      get messageOfflinePushInfo => _messageOfflinePushInfo;

  TencentCloudChatMessageValueConfig<TencentCloudChatTimeDividerConfig>
      get timeDividerConfig => _timeDividerConfig;

  TencentCloudChatMessageValueConfig<
          List<TencentCloudChatMessageGeneralOptionItem>>
      get additionalAttachmentOptionsForMobile =>
          _additionalAttachmentOptionsForMobile;

  TencentCloudChatMessageValueConfig<
          List<TencentCloudChatMessageGeneralOptionItem>>
      get additionalInputControlBarOptionsForDesktop =>
          _additionalInputControlBarOptionsForDesktop;

  TencentCloudChatMessageValueConfig<
          TencentCloudChatMessageDefaultMessageSelectionOptionsConfig>
      get defaultMessageSelectionOperationsConfig =>
          _defaultMessageSelectionOperationsConfig;

  TencentCloudChatMessageValueConfig<
          TencentCloudChatMessageDefaultMessageMenuConfig>
      get defaultMessageMenuConfig => _defaultMessageMenuConfig;

  TencentCloudChatMessageValueConfig<
          List<TencentCloudChatMessageGeneralOptionItem>>
      get additionalMessageMenuOptions => _additionalMessageMenuOptions;

  TencentCloudChatMessageValueConfig<List<String>>
      get enabledGroupTypesForMessageReadReceipt =>
          _enabledGroupTypesForMessageReadReceipt;

  TencentCloudChatMessageValueConfig<bool> get enableDefaultEmojis =>
      _enableDefaultEmojis;

  TencentCloudChatMessageValueConfig<List<TencentCloudChatStickerSet>>
      get additionalStickerSets => _additionalStickerSets;

  TencentCloudChatMessageValueConfig<int> get desktopMessageInputLines =>
      _desktopMessageInputLines;

  TencentCloudChatMessageValueConfig<int> get recallTimeLimit =>
      _recallTimeLimit;
}
