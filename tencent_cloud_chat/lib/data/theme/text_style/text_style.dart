import 'package:tencent_cloud_chat/cross_platforms_adapter/tencent_cloud_chat_screen_adapter.dart';

class TencentCloudChatTextStyle {
  TencentCloudChatTextStyle({
    double? inputAreaIcon,
    double? auxiliaryText,
    double? messageBody,
    double? messageSnippet,
    double? contactTitle,
    double? navigationTitle,
    double? sectionHeader,
    double? buttonLabel,
    double? mediaCaption,
    double? textFieldPlaceholder,
    double? infoLabel,
    double? subtitle,
    double? emphasizedText,
    double? standardText,
    double? standardLargeText,
    double? standardSmallText,
    double? fontsize_8,
    double? fontsize_10,
    double? fontsize_12,
    double? fontsize_13,
    double? fontsize_14,
    double? fontsize_16,
    double? fontsize_18,
    double? fontsize_20,
    double? fontsize_22,
    double? fontsize_24,
    double? fontsize_34,
  })  : _auxiliaryText =
            auxiliaryText ?? TencentCloudChatScreenAdapter.getFontSize(12),
        _messageBody =
            messageBody ?? TencentCloudChatScreenAdapter.getFontSize(14),
        _messageSnippet =
            messageSnippet ?? TencentCloudChatScreenAdapter.getFontSize(16),
        _contactTitle =
            contactTitle ?? TencentCloudChatScreenAdapter.getFontSize(18),
        _navigationTitle =
            navigationTitle ?? TencentCloudChatScreenAdapter.getFontSize(20),
        _sectionHeader =
            sectionHeader ?? TencentCloudChatScreenAdapter.getFontSize(24),
        _buttonLabel =
            buttonLabel ?? TencentCloudChatScreenAdapter.getFontSize(16),
        _mediaCaption =
            mediaCaption ?? TencentCloudChatScreenAdapter.getFontSize(14),
        _textFieldPlaceholder = textFieldPlaceholder ??
            TencentCloudChatScreenAdapter.getFontSize(14),
        _infoLabel = infoLabel ?? TencentCloudChatScreenAdapter.getFontSize(14),
        _subtitle = subtitle ?? TencentCloudChatScreenAdapter.getFontSize(16),
        _emphasizedText =
            emphasizedText ?? TencentCloudChatScreenAdapter.getFontSize(18),
        _standardLargeText =
            standardLargeText ?? TencentCloudChatScreenAdapter.getFontSize(16),
        _standardSmallText =
            standardSmallText ?? TencentCloudChatScreenAdapter.getFontSize(12),
        _standardText =
            standardText ?? TencentCloudChatScreenAdapter.getFontSize(14),
        _inputAreaIcon =
            inputAreaIcon ?? TencentCloudChatScreenAdapter.getFontSize(24),
        _fontsize_8 =
            fontsize_8 ?? TencentCloudChatScreenAdapter.getFontSize(8),
        _fontsize_10 =
            fontsize_10 ?? TencentCloudChatScreenAdapter.getFontSize(10),
        _fontsize_12 =
            fontsize_12 ?? TencentCloudChatScreenAdapter.getFontSize(12),
        _fontsize_13 =
            fontsize_13 ?? TencentCloudChatScreenAdapter.getFontSize(13),
        _fontsize_14 =
            fontsize_14 ?? TencentCloudChatScreenAdapter.getFontSize(14),
        _fontsize_16 =
            fontsize_16 ?? TencentCloudChatScreenAdapter.getFontSize(16),
        _fontsize_18 =
            fontsize_18 ?? TencentCloudChatScreenAdapter.getFontSize(18),
        _fontsize_20 =
            fontsize_20 ?? TencentCloudChatScreenAdapter.getFontSize(20),
        _fontsize_22 =
            fontsize_22 ?? TencentCloudChatScreenAdapter.getFontSize(22),
        _fontsize_24 =
            fontsize_24 ?? TencentCloudChatScreenAdapter.getFontSize(24),
        _fontsize_34 =
            fontsize_34 ?? TencentCloudChatScreenAdapter.getFontSize(34);

  final double _inputAreaIcon;
  final double _auxiliaryText;
  final double _messageBody;
  final double _messageSnippet;
  final double _contactTitle;
  final double _navigationTitle;
  final double _sectionHeader;
  final double _buttonLabel;
  final double _mediaCaption;
  final double _textFieldPlaceholder;
  final double _infoLabel;
  final double _subtitle;
  final double _emphasizedText;
  final double _standardText;
  final double _standardSmallText;
  final double _standardLargeText;

  final double _fontsize_8;
  final double _fontsize_10;
  final double _fontsize_12;
  final double _fontsize_13;
  final double _fontsize_14;
  final double _fontsize_16;
  final double _fontsize_18;
  final double _fontsize_20;
  final double _fontsize_22;
  final double _fontsize_24;
  final double _fontsize_34;

  /// Get the Adapted Fontsize 8
  double get fontsize_8 => _fontsize_8;

  /// Get the Adapted Fontsize 10
  double get fontsize_10 => _fontsize_10;

  /// Get the Adapted Fontsize 12
  double get fontsize_12 => _fontsize_12;

  /// Get the Adapted Fontsize 13
  double get fontsize_13 => _fontsize_13;

  /// Get the Adapted Fontsize 14
  double get fontsize_14 => _fontsize_14;

  /// Get the Adapted Fontsize 16
  double get fontsize_16 => _fontsize_16;

  /// Get the Adapted Fontsize 18
  double get fontsize_18 => _fontsize_18;

  /// Get the Adapted Fontsize 20
  double get fontsize_20 => _fontsize_20;

  /// Get the Adapted Fontsize 22
  double get fontsize_22 => _fontsize_22;

  /// Get the Adapted Fontsize 24
  double get fontsize_24 => _fontsize_24;

  double get fontsize_34 => _fontsize_34;

  /// For the icons shows in the message input area
  double get inputAreaIcon => _inputAreaIcon;

  /// For auxiliary information such as timestamps and message status
  double get auxiliaryText => _auxiliaryText;

  /// For text content within chat bubbles
  double get messageBody => _messageBody;

  /// For message previews in the conversation list
  double get messageSnippet => _messageSnippet;

  /// For contact names in the conversation list
  double get contactTitle => _contactTitle;

  /// For navigation bar titles and profile names
  double get navigationTitle => _navigationTitle;

  /// For section headers and page titles
  double get sectionHeader => _sectionHeader;

  /// For text labels within buttons
  double get buttonLabel => _buttonLabel;

  /// For captions of images, videos, and other media content
  double get mediaCaption => _mediaCaption;

  /// For placeholder text in input fields
  double get textFieldPlaceholder => _textFieldPlaceholder;

  /// For informational labels and descriptions
  double get infoLabel => _infoLabel;

  /// For subtitles and secondary headings
  double get subtitle => _subtitle;

  /// For emphasized text that needs to stand out
  double get emphasizedText => _emphasizedText;

  /// For standard-sized text used in general scenarios
  double get standardText => _standardText;

  /// For smaller-sized text used in general scenarios
  double get standardSmallText => _standardSmallText;

  /// For larger-sized text used in general scenarios
  double get standardLargeText => _standardLargeText;
}
