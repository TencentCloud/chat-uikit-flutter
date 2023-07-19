import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:fc_native_video_thumbnail/fc_native_video_thumbnail.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_setting_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/tim_uikit_wide_modal_operation_key.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/message.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/optimize_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_shot.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/wide_popup.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitTextField/special_text/DefaultSpecialTextSpanBuilder.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitTextField/tim_uikit_emoji_panel.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/drag_widget.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: unnecessary_import
import 'dart:typed_data';

class DesktopControlBarItem {
  final String item;
  final IconData? icon;
  final String? imgPath;
  final String? svgPath;
  final Color? color;
  final ValueChanged<Offset?> onClick;
  final String? showName;
  final double? size;

  DesktopControlBarItem(
      {required this.item,
      this.icon,
      this.color,
      this.imgPath,
      this.svgPath,
      required this.onClick,
      this.showName,
      this.size})
      : assert(icon != null ||
            TencentUtils.checkString(imgPath) != null ||
            TencentUtils.checkString(svgPath) != null);
}

class DesktopControlBarConfig {
  final bool showStickerPanel;
  final bool showScreenshotButton;
  final bool showSendFileButton;
  final bool showSendImageButton;
  final bool showSendVideoButton;
  final bool showMessageHistoryButton;

  DesktopControlBarConfig({
    this.showStickerPanel = true,
    this.showScreenshotButton = true,
    this.showSendFileButton = true,
    this.showSendImageButton = true,
    this.showSendVideoButton = true,
    this.showMessageHistoryButton = true,
  });
}

class TIMUIKitTextFieldLayoutWide extends StatefulWidget {
  /// sticker panel customization
  final CustomStickerPanel? customStickerPanel;
  final VoidCallback onEmojiSubmitted;
  final Function(int, String) onCustomEmojiFaceSubmitted;
  final Function(String, bool) handleSendEditStatus;
  final VoidCallback backSpaceText;
  final ValueChanged<String> addStickerToText;
  final TUITheme theme;
  final ValueChanged<String> handleAtText;

  /// Whether to use the default emoji
  final bool isUseDefaultEmoji;

  final TUIChatSeparateViewModel model;

  /// background color
  final Color? backgroundColor;

  /// control input field behavior
  final TIMUIKitInputTextFieldController? controller;

  /// config for more panel
  final MorePanelConfig? morePanelConfig;

  final String languageType;

  final TextEditingController textEditingController;

  /// conversation id
  final String conversationID;

  /// conversation type
  final ConvType conversationType;

  final FocusNode focusNode;

  /// show more panel
  final bool showMorePanel;

  /// hint text for textField widget
  final String? hintText;

  final int? currentCursor;

  final ValueChanged<int?> setCurrentCursor;

  final VoidCallback onCursorChange;

  /// show send audio icon
  final bool showSendAudio;

  final TIMUIKitChatConfig chatConfig;

  /// on text changed
  final void Function(String)? onChanged;

  final V2TimMessage? repliedMessage;

  /// show send emoji icon
  final bool showSendEmoji;

  final String? forbiddenText;

  final VoidCallback onSubmitted;

  final VoidCallback goDownBottom;

  final List customEmojiStickerList;

  /// Conversation need search
  final V2TimConversation currentConversation;

  const TIMUIKitTextFieldLayoutWide(
      {Key? key,
      this.customStickerPanel,
      required this.onEmojiSubmitted,
      required this.onCustomEmojiFaceSubmitted,
      required this.backSpaceText,
      required this.addStickerToText,
      required this.isUseDefaultEmoji,
      required this.languageType,
      required this.textEditingController,
      this.morePanelConfig,
      required this.conversationID,
      required this.conversationType,
      required this.focusNode,
      this.currentCursor,
      required this.setCurrentCursor,
      required this.onCursorChange,
      required this.model,
      this.backgroundColor,
      this.onChanged,
      required this.handleSendEditStatus,
      required this.handleAtText,
      this.repliedMessage,
      this.forbiddenText,
      required this.onSubmitted,
      required this.goDownBottom,
      required this.showSendAudio,
      required this.showSendEmoji,
      required this.showMorePanel,
      this.hintText,
      required this.customEmojiStickerList,
      this.controller,
      required this.currentConversation,
      required this.theme,
      required this.chatConfig})
      : super(key: key);

  @override
  State<TIMUIKitTextFieldLayoutWide> createState() =>
      _TIMUIKitTextFieldLayoutWideState();
}

class _TIMUIKitTextFieldLayoutWideState
    extends TIMUIKitState<TIMUIKitTextFieldLayoutWide> {
  final TUISettingModel settingModel = serviceLocator<TUISettingModel>();
  OverlayEntry? entry;
  final ImagePicker _picker = ImagePicker();
  Uint8List? fileContent;
  String? fileName;
  File? tempFile;
  Function? setKeyboardHeight;
  double? bottomPadding;
  late ScrollController _scrollController;
  late FocusNode textFocusNode;
  late List<DesktopControlBarItem> defaultControlBarItems;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      widget.controller?.addListener(() {
        final actionType = widget.controller?.actionType;
        if (actionType == ActionType.hideAllPanel) {
          hideAllPanel();
        }
      });
    }
    textFocusNode = FocusNode();
    widget.focusNode.requestFocus();
    _scrollController = ScrollController();
    try {
      if (PlatformUtils().isWeb) {
        html.window.addEventListener('paste', (event) {
          _handlePaste(event as html.ClipboardEvent);
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    generateDefaultControlBarItems();
  }

  Future<void> _handlePaste(html.ClipboardEvent event) async {
    try {
      if (event.clipboardData!.files!.isNotEmpty) {
        html.File imageFile = event.clipboardData!.files![0];
        sendFileUseJs(imageFile);
      }
    } catch (e) {
      // ignore: avoid_print
      print("Paste image failed: ${e.toString()}");
    }
  }

  hideAllPanel() {
    widget.focusNode.unfocus();
    widget.currentCursor == null;
  }

  _debounce(
    Function(String text) fun, [
    Duration delay = const Duration(milliseconds: 30),
  ]) {
    Timer? timer;
    return (String text) {
      if (timer != null) {
        timer?.cancel();
      }

      timer = Timer(delay, () {
        fun(text);
      });
    };
  }

  String getAbstractMessage(V2TimMessage message) {
    final String? customAbstractMessage =
        widget.model.abstractMessageBuilder != null
            ? widget.model.abstractMessageBuilder!(widget.model.repliedMessage!)
            : null;
    return customAbstractMessage ??
        MessageUtils.getAbstractMessageAsync(
            widget.model.repliedMessage!, widget.model.groupMemberList ?? []);
  }

  _buildRepliedMessage(V2TimMessage? repliedMessage) {
    final haveRepliedMessage = repliedMessage != null;
    if (haveRepliedMessage) {
      return Container(
        color: widget.backgroundColor ?? hexToColor("f5f5f6"),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              TIM_t("回复 "),
              style: TextStyle(color: hexToColor("8f959e"), fontSize: 14),
            ),
            Text(
              MessageUtils.getDisplayName(widget.model.repliedMessage!),
              softWrap: true,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: hexToColor("8f959e"),
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Text(
                ": ${getAbstractMessage(repliedMessage)}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: hexToColor("8f959e"),
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            InkWell(
              onTap: () {
                widget.model.repliedMessage = null;
              },
              child: Icon(Icons.cancel, color: hexToColor("8f959e"), size: 18),
            )
          ],
        ),
      );
    }
    return Container();
  }

  _sendEmoji(Offset? offset, TUITheme theme) {
    widget.onCursorChange();
    if (entry != null) {
      entry?.remove();
      entry = null;
    } else {
      entry = OverlayEntry(builder: (BuildContext context) {
        return TUIKitDragArea(
            closeFun: () {
              if (entry != null) {
                entry?.remove();
                entry = null;
              }
            },
            initOffset: offset != null
                ? Offset(offset.dx, max(offset.dy, 16))
                : Offset(MediaQuery.of(context).size.height * 0.5 + 20,
                    MediaQuery.of(context).size.height * 0.5 - 100),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                color: theme.wideBackgroundColor,
                border: Border.all(
                  width: 2,
                  color: theme.weakBackgroundColor ?? const Color(0xFFbebebe),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFFbebebe),
                    offset: Offset(5, 5),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Container(
                child: widget.customStickerPanel != null
                    ? widget.customStickerPanel!(
                        height: widget.chatConfig.desktopStickerPanelHeight,
                        width: 350,
                        sendTextMessage: () {
                          widget.onEmojiSubmitted();
                        },
                        sendFaceMessage: widget.onCustomEmojiFaceSubmitted,
                        deleteText: () {
                          widget.backSpaceText();
                        },
                        addText: (int unicode) {
                          final newText = String.fromCharCode(unicode);
                          widget.addStickerToText(newText);
                          entry?.remove();
                          entry = null;
                        },
                        addCustomEmojiText: ((String singleEmojiName) {
                          String? emojiName = singleEmojiName.split('.png')[0];
                          if (widget.isUseDefaultEmoji &&
                              widget.languageType == 'zh' &&
                              ConstData.emojiMapList[emojiName] != null &&
                              ConstData.emojiMapList[emojiName] != '') {
                            emojiName = ConstData.emojiMapList[emojiName];
                          }
                          final newText = '[$emojiName]';
                          widget.addStickerToText(newText);
                          entry?.remove();
                          entry = null;
                        }),
                        defaultCustomEmojiStickerList:
                            widget.isUseDefaultEmoji ? ConstData.emojiList : [])
                    : EmojiPanel(onTapEmoji: (unicode) {
                        final newText = String.fromCharCode(unicode);
                        widget.addStickerToText(newText);
                      }, onSubmitted: () {
                        widget.onEmojiSubmitted();
                      }, delete: () {
                        widget.backSpaceText();
                      }),
              ),
            ));
      });
      Overlay.of(context).insert(entry!);
    }
  }

  _addGreyOverlay() {
    if (entry != null) {
      _removeOverlay();
      return;
    } else {
      entry = OverlayEntry(builder: (BuildContext context) {
        return Container(
          color: const Color(0x7F000000),
        );
      });
      Overlay.of(context).insert(entry!);
    }
  }

  _removeOverlay() {
    entry?.remove();
    entry = null;
  }

  _sendFile(
    TUIChatSeparateViewModel model,
    TUITheme theme,
  ) async {
    if (!PlatformUtils().isWeb) {
      _addGreyOverlay();
    }
    try {
      final convID = widget.conversationID;
      final convType = widget.conversationType;
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      _removeOverlay();
      if (result != null && result.files.isNotEmpty) {
        if (PlatformUtils().isWeb) {
          html.Node? inputElem;
          inputElem = html.document
              .getElementById("__file_picker_web-file-input")
              ?.querySelector("input");
          fileName = result.files.single.name;

          MessageUtils.handleMessageError(
              model.sendFileMessage(
                  inputElement: inputElem,
                  fileName: fileName,
                  convID: convID,
                  convType: convType),
              context);
        } else {
          File file = File(result.files.single.path!);
          final int size = file.lengthSync();
          final String savePath = file.path;

          MessageUtils.handleMessageError(
              model.sendFileMessage(
                  filePath: savePath,
                  size: size,
                  convID: convID,
                  convType: convType),
              context);
        }
      } else {
        throw TypeError();
      }
    } catch (e) {
      // ignore: avoid_print
      print("_sendFileErr: ${e.toString()}");
    }
  }

  List<Widget> generateBarIcons(
      List<DesktopControlBarItem> items, TUITheme theme) {
    final defaultItems = defaultControlBarItems.map((e) => e.item);
    return items.map((e) {
      final GlobalKey key = GlobalKey();
      return Container(
        margin: const EdgeInsets.only(right: 10),
        child: InkWell(
          onTap: () {
            final alignBox =
                key.currentContext?.findRenderObject() as RenderBox?;
            var offset = alignBox?.localToGlobal(Offset.zero);
            final double? dx = (offset?.dx != null) ? offset!.dx : null;
            final double? dy =
                (offset?.dy != null && alignBox?.size.height != null)
                    ? offset!.dy -
                        (widget.chatConfig.desktopStickerPanelHeight + 20)
                    : null;
            e.onClick((dx != null && dy != null) ? Offset(dx, dy) : null);
          },
          child: Tooltip(
            preferBelow: false,
            textStyle: TextStyle(fontSize: 12, color: theme.white),
            message: e.showName,
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),
              padding: const EdgeInsets.all(4),
              child: () {
                if (TencentUtils.checkString(e.svgPath) != null) {
                  return SvgPicture.asset(
                    e.svgPath!,
                    package: defaultItems.contains(e.item)
                        ? 'tencent_cloud_chat_uikit'
                        : null,
                    key: key,
                    width: e.size ?? 16,
                    height: e.size ?? 16,
                  );
                }
                if (TencentUtils.checkString(e.imgPath) != null) {
                  return Image.asset(
                    e.imgPath!,
                    package: defaultItems.contains(e.item)
                        ? 'tencent_cloud_chat_uikit'
                        : null,
                    key: key,
                    width: e.size ?? 16,
                    height: e.size ?? 16,
                  );
                }
                return Icon(
                  e.icon,
                  key: key,
                  color: e.color ?? hexToColor("646a73"),
                  size: e.size ?? 20,
                );
              }(),
            ),
          ),
        ),
      );
    }).toList();
  }

  _sendImageFileOnWeb(TUIChatSeparateViewModel model) async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      final imageContent = await pickedFile!.readAsBytes();
      fileName = pickedFile.name;
      tempFile = File(pickedFile.path);
      fileContent = imageContent;

      html.Node? inputElem;
      inputElem = html.document
          .getElementById("__image_picker_web-file-input")
          ?.querySelector("input");
      final convID = widget.conversationID;
      final convType = widget.conversationType;
      MessageUtils.handleMessageError(
          model.sendImageMessage(
              inputElement: inputElem,
              imagePath: tempFile?.path,
              convID: convID,
              convType: convType),
          context);
    } catch (e) {
      // ignore: avoid_print
      print("_sendFileErr: ${e.toString()}");
    }
  }

  _sendVideoFileOnWeb(TUIChatSeparateViewModel model) async {
    try {
      final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
      final videoContent = await pickedFile!.readAsBytes();
      fileName = pickedFile.name;
      tempFile = File(pickedFile.path);
      fileContent = videoContent;

      if (fileName!.split(".")[fileName!.split(".").length - 1] != "mp4") {
        onTIMCallback(TIMCallback(
            type: TIMCallbackType.INFO,
            infoRecommendText: TIM_t("视频消息仅限 mp4 格式"),
            infoCode: 6660412));
        return;
      }

      html.Node? inputElem;
      inputElem = html.document
          .getElementById("__image_picker_web-file-input")
          ?.querySelector("input");
      final convID = widget.conversationID;
      final convType = widget.conversationType;
      MessageUtils.handleMessageError(
          model.sendVideoMessage(
              inputElement: inputElem,
              videoPath: tempFile?.path,
              convID: convID,
              convType: convType),
          context);
    } catch (e) {
      // ignore: avoid_print
      print("_sendFileErr: ${e.toString()}");
    }
  }

  _sendVideoMessage(AssetEntity asset, TUIChatSeparateViewModel model) async {
    try {
      final plugin = FcNativeVideoThumbnail();
      final originFile = await asset.originFile;
      final size = await originFile!.length();
      if (size >= 104857600) {
        onTIMCallback(TIMCallback(
            type: TIMCallbackType.INFO,
            infoRecommendText: TIM_t("发送失败,视频不能大于100MB"),
            infoCode: 6660405));
        return;
      }

      final duration = asset.videoDuration.inSeconds;
      final filePath = originFile.path;
      final convID = widget.conversationID;
      final convType = widget.conversationType;

      String tempPath = (await getTemporaryDirectory()).path +
          p.extension(originFile.path, 3) +
          ".jpeg";

      await plugin.getVideoThumbnail(
        srcFile: originFile.path,
        keepAspectRatio: true,
        destFile: tempPath,
        format: 'jpeg',
        width: 128,
        quality: 100,
        height: 128,
      );
      MessageUtils.handleMessageError(
          model.sendVideoMessage(
              videoPath: filePath,
              duration: duration,
              snapshotPath: tempPath,
              convID: convID,
              convType: convType),
          context);
    } catch (e) {
      onTIMCallback(TIMCallback(
          type: TIMCallbackType.INFO,
          infoRecommendText: TIM_t("视频文件异常"),
          infoCode: 6660415));
    }
  }

  _sendMediaMessage(
      TUIChatSeparateViewModel model, TUITheme theme, FileType fileType) async {
    try {
      final convID = widget.conversationID;
      final convType = widget.conversationType;

      if (PlatformUtils().isMobile) {
        final pickedAssets = await AssetPicker.pickAssets(context);

        if (pickedAssets != null) {
          for (var asset in pickedAssets) {
            final originFile = await asset.originFile;
            final filePath = originFile?.path;
            final type = asset.type;
            if (filePath != null) {
              if (type == AssetType.image) {
                MessageUtils.handleMessageError(
                    model.sendImageMessage(
                        imagePath: filePath,
                        convID: convID,
                        convType: convType),
                    context);
              }

              if (type == AssetType.video) {
                _sendVideoMessage(asset, model);
              }
            }
          }
        }
      } else {
        final plugin = FcNativeVideoThumbnail();
        _addGreyOverlay();
        FilePickerResult? result =
            await FilePicker.platform.pickFiles(type: fileType);
        _removeOverlay();
        if (result != null && result.files.isNotEmpty) {
          File file = File(result.files.single.path!);
          final String savePath = file.path;
          final String type = TencentUtils.getFileType(
                  (savePath.split(".")[savePath.split(".").length - 1])
                      .toLowerCase())
              .split("/")[0];

          if (type == "image") {
            MessageUtils.handleMessageError(
                model.sendImageMessage(
                    imagePath: savePath, convID: convID, convType: convType),
                context);
          } else if (type == "video") {
            String tempPath = (await getTemporaryDirectory()).path +
                p.basename(savePath) +
                ".jpeg";
            await plugin.getVideoThumbnail(
              srcFile: savePath,
              keepAspectRatio: true,
              destFile: tempPath,
              format: 'jpeg',
              width: 128,
              quality: 100,
              height: 128,
            );
            MessageUtils.handleMessageError(
                model.sendVideoMessage(
                    videoPath: savePath,
                    convID: convID,
                    convType: convType,
                    snapshotPath: tempPath),
                context);
          }
        } else {
          throw TypeError();
        }
      }
    } catch (err) {
      // ignore: avoid_print
      print("send media err: $err");
      onTIMCallback(TIMCallback(
          type: TIMCallbackType.INFO,
          infoRecommendText: TIM_t("视频文件异常"),
          infoCode: 6660415));
    }
  }

  _sendImageWithConfirmation(
      {String? fileName, Size? fileSize, required String filePath}) async {
    final option1 = widget.currentConversation.showName ??
        (widget.conversationType == ConvType.group ? TIM_t("群聊") : TIM_t("对方"));
    final size = fileSize ?? await ScreenshotHelper.getImageSize(filePath);

    TUIKitWidePopup.showPopupWindow(
        operationKey: TUIKitWideModalOperationKey.beforeSendScreenShot,
        context: context,
        isDarkBackground: false,
        width: 500,
        height: min(500, size.height / 2 + 140),
        title: TIM_t_para("发送给{{option1}}", "发送给$option1")(option1: option1),
        child: (closeFunc) => Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: min(360, size.height / 2),
                    child: InkWell(
                      onTap: () {
                        launchUrl(PlatformUtils().isWeb
                            ? Uri.parse(filePath)
                            : Uri.file(filePath));
                      },
                      child: PlatformUtils().isWeb
                          ? Image.network(
                              filePath,
                              height: min(360, size.height / 2),
                            )
                          : Image.file(
                              File(filePath),
                              height: min(360, size.height / 2),
                            ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      OutlinedButton(
                          onPressed: () {
                            closeFunc();
                          },
                          child: Text(TIM_t("取消"))),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            MessageUtils.handleMessageError(
                                widget.model.sendImageMessage(
                                    imagePath: filePath,
                                    imageName: fileName,
                                    convID: widget.conversationID,
                                    convType: widget.conversationType),
                                context);
                            closeFunc();
                          },
                          child: Text(TIM_t("发送")))
                    ],
                  )
                ],
              ),
            ));
  }

  _sendScreenShot() async {
    final file = await ScreenshotHelper.captureScreen();
    if (file != null) {
      _sendImageWithConfirmation(filePath: file);
    } else {}
  }

  generateDefaultControlBarItems() {
    final DesktopControlBarConfig config =
        widget.chatConfig.desktopControlBarConfig ?? DesktopControlBarConfig();
    final List<DesktopControlBarItem> itemsList = [
      if (config.showStickerPanel)
        DesktopControlBarItem(
            item: "face",
            showName: TIM_t("表情"),
            onClick: (offset) {
              _sendEmoji(offset, widget.theme);
            },
            imgPath: "images/svg/send_face.png"),
      if (config.showScreenshotButton && PlatformUtils().isDesktop)
        DesktopControlBarItem(
            item: "screenShot",
            showName: TIM_t("截图"),
            onClick: (offset) {
              _sendScreenShot();
            },
            svgPath: "images/svg/send_screenshot.svg"),
      if (config.showSendFileButton)
        DesktopControlBarItem(
            item: "file",
            showName: TIM_t("文件"),
            onClick: (offset) {
              _sendFile(widget.model, widget.theme);
            },
            svgPath: "images/svg/send_file.svg"),
      if (config.showSendImageButton)
        DesktopControlBarItem(
            item: "photo",
            showName: TIM_t("图片"),
            onClick: (offset) {
              if (PlatformUtils().isWeb) {
                _sendImageFileOnWeb(widget.model);
              } else {
                _sendMediaMessage(widget.model, widget.theme, FileType.image);
              }
            },
            svgPath: "images/svg/send_image.svg"),
      if (config.showSendVideoButton)
        DesktopControlBarItem(
            item: "video",
            showName: TIM_t("视频"),
            onClick: (offset) {
              if (PlatformUtils().isWeb) {
                _sendVideoFileOnWeb(widget.model);
              } else {
                _sendMediaMessage(widget.model, widget.theme, FileType.video);
              }
            },
            svgPath: "images/svg/send_video.svg"),
      if (config.showMessageHistoryButton)
        DesktopControlBarItem(
            item: "history",
            showName: TIM_t("消息历史"),
            onClick: (offset) {
              TUIKitWidePopup.showPopupWindow(
                  operationKey: TUIKitWideModalOperationKey.chatHistory,
                  context: context,
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.width * 0.5,
                  child: (onClose) => TIMUIKitSearchMsgDetail(
                        currentConversation: widget.currentConversation,
                        keyword: '',
                        initMessageList: widget.model
                            .getOriginMessageList()
                            .getRange(
                                0,
                                min(widget.model.getOriginMessageList().length,
                                    100))
                            .toList(),
                        onTapConversation: (V2TimConversation conversation,
                            V2TimMessage? message) {},
                      ),
                  theme: widget.theme);
            },
            svgPath: "images/svg/message_history.svg"),
    ];
    defaultControlBarItems = itemsList;
  }

  List<Widget> generateControlBar(
      TUIChatSeparateViewModel model, TUITheme theme) {
    final List<DesktopControlBarItem> itemsList = [
      ...defaultControlBarItems,
      ...(widget.chatConfig.additionalDesktopControlBarItems ?? [])
    ];

    return generateBarIcons(itemsList, theme);
  }

  sendFileUseJs(html.File file) {
    final mimeType = file.type.split('/');
    final type = mimeType[0];
    final blobUrl = html.Url.createObjectUrl(file);
    if (type == 'image') {
      _sendImageWithConfirmation(
          filePath: blobUrl,
          fileName: file.name,
          fileSize: const Size(500, 500));
    }
  }

  Future<void> _handleKeyEvent(RawKeyEvent event) async {
    if (PlatformUtils().isDesktop &&
        ((event.isKeyPressed(LogicalKeyboardKey.controlLeft) &&
                event.logicalKey == LogicalKeyboardKey.keyV) ||
            (event.isMetaPressed &&
                event.logicalKey == LogicalKeyboardKey.keyV))) {
      final bytes = await Pasteboard.image;
      if (bytes != null) {
        String directory;
        if (PlatformUtils().isWindows) {
          final String documentsDirectoryPath =
              "${Platform.environment['USERPROFILE']}";
          PackageInfo packageInfo = await PackageInfo.fromPlatform();
          String pkgName = packageInfo.packageName;
          directory = p.join(documentsDirectoryPath, "Documents",
              ".TencentCloudChat", pkgName, "screenshots");
        } else {
          final dic = await getApplicationSupportDirectory();
          directory = dic.path;
        }
        const uuid = Uuid();
        final fileName = 'paste_image_${uuid.v4()}.png';
        final scDirectory = Directory(directory);
        final filePath =
            '${scDirectory.path}${PlatformUtils().isWindows ? "\\" : "/"}$fileName';
        final file = File(filePath);
        if (!await scDirectory.exists()) {
          await scDirectory.create(recursive: true);
        }
        await file.writeAsBytes(bytes.toList());
        _sendImageWithConfirmation(filePath: filePath);
      }
    }
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final theme = value.theme;

    setKeyboardHeight ??= OptimizeUtils.debounce((height) {
      settingModel.keyboardHeight = height;
    }, const Duration(seconds: 1));

    final debounceFunc = _debounce((value) {
      if (widget.onChanged != null) {
        widget.onChanged!(value);
      }
      widget.handleAtText(value);
      widget.handleSendEditStatus(value, true);
    }, const Duration(milliseconds: 80));

    final MediaQueryData data = MediaQuery.of(context);
    EdgeInsets padding = data.padding;
    if (bottomPadding == null || padding.bottom > bottomPadding!) {
      bottomPadding = padding.bottom;
    }

    return RawKeyboardListener(
        focusNode: textFocusNode,
        onKey: _handleKeyEvent,
        child: Container(
          color: widget.backgroundColor ?? theme.desktopChatMessageInputBgColor,
          child: Column(
            children: [
              _buildRepliedMessage(widget.repliedMessage),
              SizedBox(
                  height: 1,
                  child: Container(
                      color: theme.weakDividerColor ?? Colors.black12)),
              if (widget.forbiddenText == null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: generateControlBar(widget.model, theme),
                  ),
                ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                constraints: const BoxConstraints(minHeight: 50),
                child: Row(
                  children: [
                    if (widget.forbiddenText != null)
                      Expanded(
                          child: Container(
                        height: 35,
                        color: widget.backgroundColor ??
                            theme.desktopChatMessageInputBgColor,
                        alignment: Alignment.center,
                        child: Text(
                          TIM_t(widget.forbiddenText!),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: theme.weakTextColor,
                          ),
                        ),
                      )),
                    if (widget.forbiddenText == null)
                      Expanded(
                        child: ExtendedTextField(
                            scrollController: _scrollController,
                            autofocus: true,
                            maxLines:
                                widget.chatConfig.desktopMessageInputFieldLines,
                            minLines:
                                widget.chatConfig.desktopMessageInputFieldLines,
                            focusNode: widget.focusNode,
                            onChanged: debounceFunc,
                            keyboardType: TextInputType.multiline,
                            onEditingComplete: () {
                              //   // widget.onSubmitted();
                            },
                            textAlignVertical: TextAlignVertical.top,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              hoverColor: Colors.transparent,
                              border: InputBorder.none,
                              hintStyle: const TextStyle(
                                color: Color(0xffAEA4A3),
                              ),
                              fillColor: widget.backgroundColor ??
                                  theme.desktopChatMessageInputBgColor ??
                                  hexToColor("fafafa"),
                              filled: true,
                              isDense: true,
                              hintText: widget.hintText ?? '',
                            ),
                            controller: widget.textEditingController,
                            specialTextSpanBuilder: PlatformUtils().isWeb
                                ? null
                                : DefaultSpecialTextSpanBuilder(
                                    isUseDefaultEmoji: widget.isUseDefaultEmoji,
                                    customEmojiStickerList:
                                        widget.customEmojiStickerList,
                                    showAtBackground: true,
                                  )),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
