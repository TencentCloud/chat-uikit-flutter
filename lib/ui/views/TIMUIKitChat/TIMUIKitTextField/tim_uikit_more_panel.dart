// ignore_for_file: unused_field, avoid_print, unused_import

import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fc_native_video_thumbnail/fc_native_video_thumbnail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitTextField/tim_uikit_call_invite_list.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_self_info_view_model.dart';
import 'package:path/path.dart' as p;
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/message.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/permission.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitTextField/intl_camer_picker.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';

// ignore: unnecessary_import
import 'dart:typed_data';
import 'package:universal_html/html.dart' as html;
import 'package:tencent_cloud_chat_uikit/ui/utils/logger.dart';

class MorePanelConfig {
  final bool showGalleryPickAction;
  final bool showCameraAction;
  final bool showFilePickAction;
  final bool showWebImagePickAction;
  final bool showWebVideoPickAction;
  final bool showVoiceCall;
  final bool showVideoCall;
  final List<MorePanelItem>? extraAction;
  final Widget Function(MorePanelItem item)? actionBuilder;

  MorePanelConfig({
    this.showFilePickAction = true,
    this.showGalleryPickAction = true,
    this.showCameraAction = true,
    this.showWebImagePickAction = true,
    this.showWebVideoPickAction = true,
    this.showVoiceCall = true,
    this.showVideoCall = true,
    this.extraAction,
    this.actionBuilder,
  });
}

class MorePanelItem {
  final String title;
  final String id;
  final Widget icon;
  final Function(BuildContext context)? onTap;

  MorePanelItem(
      {this.onTap, required this.icon, required this.id, required this.title});
}

class MorePanel extends StatefulWidget {
  /// 会话ID
  final String conversationID;

  /// 会话类型
  final ConvType conversationType;

  final MorePanelConfig? morePanelConfig;

  const MorePanel(
      {required this.conversationID,
      required this.conversationType,
      Key? key,
      this.morePanelConfig})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MorePanelState();
}

class _MorePanelState extends TIMUIKitState<MorePanel> {
  final ImagePicker _picker = ImagePicker();
  final TUISelfInfoViewModel _selfInfoViewModel =
      serviceLocator<TUISelfInfoViewModel>();
  Uint8List? fileContent;
  String? fileName;
  File? tempFile;
  final _tUICore = TUICore();
  final _tUILogin = TUILogin();
  bool isInstallCallkit = false;
  final ScrollController _scrollController = ScrollController();
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  @override
  void initState() {
    super.initState();
    if (PlatformUtils().isMobile) {
      _tUICore.getService(TUICALLKIT_SERVICE_NAME).then((value) {
        setState(() {
          isInstallCallkit = value;
        });
      });
    }
  }

  List<MorePanelItem> itemList(TUIChatSeparateViewModel model, TUITheme theme) {
    final config = widget.morePanelConfig ?? MorePanelConfig();
    return [
      if (PlatformUtils().isMobile)
        MorePanelItem(
            id: "screen",
            title: TIM_t("拍摄"),
            onTap: (c) {
              _onFeatureTap("screen", c, model, theme);
            },
            icon: Container(
              height: 64,
              width: 64,
              margin: const EdgeInsets.only(bottom: 4),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: SvgPicture.asset(
                "images/screen.svg",
                package: 'tencent_cloud_chat_uikit',
                height: 64,
                width: 64,
              ),
            )),
      if (!PlatformUtils().isWeb)
        MorePanelItem(
            id: "photo",
            title: TIM_t("照片"),
            onTap: (c) {
              _onFeatureTap(
                "photo",
                c,
                model,
                theme,
              );
            },
            icon: Container(
              height: 64,
              width: 64,
              margin: const EdgeInsets.only(bottom: 4),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: SvgPicture.asset(
                "images/photo.svg",
                package: 'tencent_cloud_chat_uikit',
                height: 64,
                width: 64,
              ),
            )),
      if (PlatformUtils().isWeb)
        MorePanelItem(
            id: "image",
            title: TIM_t("图片"),
            onTap: (c) {
              _onFeatureTap(
                "image",
                c,
                model,
                theme,
              );
            },
            icon: Container(
              height: 64,
              width: 64,
              margin: const EdgeInsets.only(bottom: 4),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: SvgPicture.asset(
                "images/photo.svg",
                package: 'tencent_cloud_chat_uikit',
                height: 64,
                width: 64,
              ),
            )),
      if (PlatformUtils().isWeb)
        MorePanelItem(
            id: "video",
            title: TIM_t("视频"),
            onTap: (c) {
              _onFeatureTap(
                "video",
                c,
                model,
                theme,
              );
            },
            icon: Container(
              height: 64,
              width: 64,
              margin: const EdgeInsets.only(bottom: 4),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child:
                  Icon(Icons.video_file, color: hexToColor("5c6168"), size: 26),
            )),
      MorePanelItem(
          id: "file",
          title: TIM_t("文件"),
          onTap: (c) {
            _onFeatureTap(
              "file",
              c,
              model,
              theme,
            );
          },
          icon: Container(
            height: 64,
            width: 64,
            margin: const EdgeInsets.only(bottom: 4),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: SvgPicture.asset(
              "images/file.svg",
              package: 'tencent_cloud_chat_uikit',
              height: 64,
              width: 64,
            ),
          )),
      if (isInstallCallkit && PlatformUtils().isMobile)
        MorePanelItem(
            id: "videoCall",
            title: TIM_t("视频通话"),
            onTap: (c) {
              _onFeatureTap(
                "videoCall",
                c,
                model,
                theme,
              );
            },
            icon: Container(
              height: 64,
              width: 64,
              margin: const EdgeInsets.only(bottom: 4),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: SvgPicture.asset(
                "images/video-call.svg",
                package: 'tencent_cloud_chat_uikit',
                height: 64,
                width: 64,
              ),
            )),
      if (isInstallCallkit && PlatformUtils().isMobile)
        MorePanelItem(
            id: "voiceCall",
            title: TIM_t("语音通话"),
            onTap: (c) {
              _onFeatureTap(
                "voiceCall",
                c,
                model,
                theme,
              );
            },
            icon: Container(
              height: 64,
              width: 64,
              margin: const EdgeInsets.only(bottom: 4),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: SvgPicture.asset(
                "images/voice-call.svg",
                package: 'tencent_cloud_chat_uikit',
                height: 64,
                width: 64,
              ),
            )),
      if (config.extraAction != null) ...?config.extraAction,
    ].where((element) {
      if (element.id == "screen") {
        return config.showCameraAction;
      }

      if (element.id == "file") {
        return config.showFilePickAction;
      }

      if (element.id == "photo") {
        return config.showGalleryPickAction;
      }

      if (element.id == "image") {
        return config.showWebImagePickAction;
      }

      if (element.id == "video") {
        return config.showWebVideoPickAction;
      }
      if (element.id == "voiceCall") {
        return config.showVoiceCall;
      }
      if (element.id == "videoCall") {
        return config.showVideoCall;
      }
      return true;
    }).toList();
  }

  _sendVideoMessage(AssetEntity asset, TUIChatSeparateViewModel model) async {
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
        p.basename(originFile.path) +
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
  }

  _sendImageMessage(TUIChatSeparateViewModel model, TUITheme theme) async {
    try {
      if (PlatformUtils().isMobile) {
        if (PlatformUtils().isAndroid) {
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          if ((androidInfo.version.sdkInt) >= 33) {
            final videos = await Permissions.checkPermission(
              context,
              Permission.videos.value,
              theme,
            );
            final photos = await Permissions.checkPermission(
              context,
              Permission.photos.value,
              theme,
            );
            if (!videos && !photos) {
              return;
            }
          } else {
            final storage = await Permissions.checkPermission(
              context,
              Permission.storage.value,
              theme,
            );
            if (!storage) {
              return;
            }
          }
        } else {
          final photos = await Permissions.checkPermission(
            context,
            Permission.photos.value,
            theme,
          );
          if (!photos) {
            return;
          }
        }
      }

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
        FilePickerResult? result =
            await FilePicker.platform.pickFiles(type: FileType.media);
        if (result != null && result.files.isNotEmpty) {
          File file = File(result.files.single.path!);
          final String savePath = file.path;
          final String type = TencentUtils.getFileType(
                  savePath.split(".")[savePath.split(".").length - 1])
              .split("/")[0];

          if (type == "image") {
            MessageUtils.handleMessageError(
                model.sendImageMessage(
                    imagePath: savePath, convID: convID, convType: convType),
                context);
          } else if (type == "video") {
            MessageUtils.handleMessageError(
                model.sendVideoMessage(
                    videoPath: savePath, convID: convID, convType: convType),
                context);
          }
        } else {
          throw TypeError();
        }
      }
    } catch (err) {
      outputLogger.i("err: $err");
    }
  }

  _sendImageFromCamera(
    TUIChatSeparateViewModel model,
    TUITheme theme,
  ) async {
    try {
      if (!await Permissions.checkPermission(
        context,
        Permission.camera.value,
        theme,
      )) {
        return;
      }
      await Permissions.checkPermission(
        context,
        Permission.microphone.value,
        theme,
      );

      if (PlatformUtils().isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        if ((androidInfo.version.sdkInt) >= 33) {
          if (!await Permissions.checkPermission(
            context,
            Permission.photos.value,
            theme,
          )) {
            return;
          }
        } else {
          if (!await Permissions.checkPermission(
            context,
            Permission.storage.value,
            theme,
          )) {
            return;
          }
        }
      } else {
        if (!await Permissions.checkPermission(
          context,
          Permission.photos.value,
          theme,
        )) {
          return;
        }
      }

      final convID = widget.conversationID;
      final convType = widget.conversationType;
      final pickedFile = await CameraPicker.pickFromCamera(context,
          pickerConfig: CameraPickerConfig(
              enableRecording: true,
              textDelegate: IntlCameraPickerTextDelegate()));
      final originFile = await pickedFile?.originFile;
      if (originFile != null) {
        final type = pickedFile!.type;
        if (type == AssetType.image) {
          MessageUtils.handleMessageError(
              model.sendImageMessage(
                  imagePath: originFile.path,
                  convID: convID,
                  convType: convType),
              context);
        }
        if (type == AssetType.video) {
          _sendVideoMessage(pickedFile, model);
        }
      } else {
        // Toast.showToast(ToastType.fail, TIM_t("图片不能为空"), context);
      }
    } catch (error) {
      outputLogger.i("err: $error");
    }
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
      outputLogger.i("_sendFileErr: ${e.toString()}");
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
      outputLogger.i("_sendFileErr: ${e.toString()}");
    }
  }

  _sendFile(
    TUIChatSeparateViewModel model,
    TUITheme theme,
  ) async {
    try {
      final convID = widget.conversationID;
      final convType = widget.conversationType;
      FilePickerResult? result = await FilePicker.platform.pickFiles();
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
          return;
        }

        String? option2 = result.files.single.path ?? "";
        outputLogger
            .i(TIM_t_para("选择成功{{option2}}", "选择成功$option2")(option2: option2));

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
      } else {
        throw TypeError();
      }
    } catch (e) {
      outputLogger.i("_sendFileErr: ${e.toString()}");
    }
  }

  _onFeatureTap(
    String id,
    BuildContext context,
    TUIChatSeparateViewModel model,
    TUITheme theme,
  ) async {
    switch (id) {
      case "photo":
        _sendImageMessage(model, theme);
        break;
      case "screen":
        _sendImageFromCamera(model, theme);
        break;
      case "file":
        _sendFile(model, theme);
        break;
      case "image":
        // only for web
        _sendImageFileOnWeb(model);
        break;
      case "video":
        // only for web
        _sendVideoFileOnWeb(model);
        break;
      case "voiceCall":
        _goToVideoUI(TYPE_AUDIO);
        break;
      case "videoCall":
        _goToVideoUI(TYPE_VIDEO);
        break;
    }
  }

  _goToVideoUI(String type) async {
    if (!PlatformUtils().isWeb) {
      final hasCameraPermission = type == TYPE_VIDEO
          ? await Permissions.checkPermission(context, Permission.camera.value)
          : true;
      final hasMicphonePermission = await Permissions.checkPermission(
          context, Permission.microphone.value);
      if (!hasCameraPermission || !hasMicphonePermission) {
        return;
      }
    }

    final isGroup = widget.conversationType == ConvType.group;
    if (isGroup) {
      List<V2TimGroupMemberFullInfo>? selectedMember = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectCallInviter(
            groupID: widget.conversationID,
          ),
        ),
      );
      if (selectedMember != null) {
        final inviteMember = selectedMember.map((e) => e.userID).toList();
        _tUICore.callService(TUICALLKIT_SERVICE_NAME, METHOD_NAME_CALL, {
          PARAM_NAME_TYPE: type,
          PARAM_NAME_USERIDS: inviteMember,
          PARAM_NAME_GROUPID: widget.conversationType == ConvType.group
              ? widget.conversationID
              : ""
        });
      }
    } else {
      _tUICore.callService(TUICALLKIT_SERVICE_NAME, METHOD_NAME_CALL, {
        PARAM_NAME_TYPE: type,
        PARAM_NAME_USERIDS: [widget.conversationID],
        PARAM_NAME_GROUPID: ""
      });
    }
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;
    final TUIChatSeparateViewModel model =
        Provider.of<TUIChatSeparateViewModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 248,
      decoration: BoxDecoration(
        // color: hexToColor("EBF0F6"),
        border: Border(
          top: BorderSide(width: 1, color: Colors.grey.shade300),
        ),
      ),
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      width: screenWidth,
      child: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Wrap(
            spacing: (screenWidth - (23 * 2) - 64 * 4) / 3,
            runSpacing: 20,
            children: itemList(model, theme)
                .map((item) => InkWell(
                    onTap: () {
                      if (item.onTap != null) {
                        item.onTap!(context);
                      }
                    },
                    child: widget.morePanelConfig?.actionBuilder != null
                        ? widget.morePanelConfig?.actionBuilder!(item)
                        : SizedBox(
                            height: 94,
                            width: 64,
                            child: Column(
                              children: [
                                Container(
                                  height: 64,
                                  width: 64,
                                  margin: const EdgeInsets.only(bottom: 4),
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: item.icon,
                                ),
                                Text(
                                  item.title,
                                  style: TextStyle(
                                      fontSize: 12, color: theme.darkTextColor),
                                )
                              ],
                            ),
                          )))
                .toList(),
          ),
        ),
      ),
    );
  }
}
