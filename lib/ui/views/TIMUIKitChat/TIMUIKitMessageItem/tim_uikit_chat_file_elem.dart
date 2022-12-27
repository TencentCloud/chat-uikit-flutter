// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tencent_open_file/tencent_open_file.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tencent_im_base/tencent_im_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';

import 'package:tencent_cloud_chat_uikit/ui/utils/permission.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';

import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitMessageItem/TIMUIKitMessageReaction/tim_uikit_message_reaction_wrapper.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitMessageItem/tim_uikit_chat_file_icon.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/textSize.dart';
import 'package:url_launcher/url_launcher.dart';

class TIMUIKitFileElem extends StatefulWidget {
  final String? messageID;
  final V2TimFileElem? fileElem;
  final bool isSelf;
  final bool isShowJump;
  final VoidCallback? clearJump;
  final V2TimMessage message;
  final bool? isShowMessageReaction;
  final TUIChatSeparateViewModel chatModel;

  const TIMUIKitFileElem(
      {Key? key,
      required this.chatModel,
      required this.messageID,
      required this.fileElem,
      required this.isSelf,
      required this.isShowJump,
      this.clearJump,
      required this.message,
      this.isShowMessageReaction})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TIMUIKitFileElemState();
}

class _TIMUIKitFileElemState extends TIMUIKitState<TIMUIKitFileElem> {
  String filePath = "";
  bool isDownloading = false;
  final TUIChatGlobalModel model = serviceLocator<TUIChatGlobalModel>();

  Future<bool?> showOpenFileConfirmDialog(
      BuildContext context, String path, TUITheme? theme) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String option2 = packageInfo.appName;
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(widget.fileElem!.fileName!),
          content: Text(TIM_t_para("“{{option2}}”暂不可以打开此类文件，你可以使用其他应用打开并预览",
              "“$option2”暂不可以打开此类文件，你可以使用其他应用打开并预览")(option2: option2)),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(TIM_t("取消"),
                  style: TextStyle(color: theme?.secondaryColor)),
              onPressed: () => Navigator.of(context).pop(), // 关闭对话框
            ),
            CupertinoDialogAction(
              child: Text(TIM_t("用其他应用打开"),
                  style: TextStyle(color: theme?.primaryColor)),
              onPressed: () {
                //关闭对话框并返回true
                Navigator.of(context).pop();
                try {
                  OpenFile.open(path);
                } catch (e) {
                  print(e);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (!PlatformUtils().isWeb) {
      Future.delayed(const Duration(microseconds: 10), () {
        hasFile();
      });
    }
  }

  Future<String> getSavePath() async {
    String savePathWithAppPath =
        '/storage/emulated/0/Android/data/com.tencent.flutter.tuikit/cache/' +
            (widget.message.msgID ?? "") +
            widget.fileElem!.fileName!;
    return savePathWithAppPath;
  }

  Future<bool> hasFile() async {
    if (PlatformUtils().isWeb) {
      return true;
    }

    if (model.getMessageProgress(widget.messageID) == 100) {
      String savePath = widget.message.fileElem!.localUrl ??
          model.getFileMessageLocation(widget.messageID);
      File f = File(savePath);
      if (f.existsSync() && widget.messageID != null) {
        filePath = savePath;
        // model.setFileMessageLocation(widget.messageID!, filePath);
        return true;
      }
      return false;
    }
    // String savePath = await getSavePath();
    String savePath = widget.message.fileElem!.localUrl ?? '';
    File f = File(savePath);
    if (f.existsSync() && widget.messageID != null) {
      filePath = savePath;
      model.setMessageProgress(widget.messageID!, 100);
      // model.setFileMessageLocation(widget.messageID!, filePath);
      return true;
    }
    return false;
  }

  String showFileSize(int fileSize) {
    if (fileSize < 1024) {
      return fileSize.toString() + "B";
    } else if (fileSize < 1024 * 1024) {
      return (fileSize / 1024).toStringAsFixed(2) + "KB";
    } else if (fileSize < 1024 * 1024 * 1024) {
      return (fileSize / 1024 / 1024).toStringAsFixed(2) + "MB";
    } else {
      return (fileSize / 1024 / 1024 / 1024).toStringAsFixed(2) + "GB";
    }
  }

  addUrlToWaitingPath() async {
    model.addWaitingList(widget.messageID!);
    print("add path success");
  }

  checkIsWaiting() {
    bool res = false;
    try {
      if (widget.messageID!.isNotEmpty) {
        res = model.isWaiting(widget.messageID!);
      }
    } catch (err) {
      // err
    }
    return res;
  }

  downloadFile(TUITheme theme) async {
    if (!await Permissions.checkPermission(
        context, Permission.storage.value, theme)) {
      return;
    }
    await model.downloadFile();
  }

  tryOpenFile(context, theme) async {
    if (!await Permissions.checkPermission(
        context, Permission.storage.value, theme)) {
      return;
    }
    showOpenFileConfirmDialog(context, filePath, theme);
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final theme = value.theme;
    return TIMUIKitMessageReactionWrapper(
        chatModel: widget.chatModel,
        isShowJump: widget.isShowJump,
        clearJump: widget.clearJump,
        isFromSelf: widget.message.isSelf ?? true,
        isShowMessageReaction: widget.isShowMessageReaction ?? true,
        message: widget.message,
        child: ChangeNotifierProvider.value(
            value: model,
            child:
                Consumer<TUIChatGlobalModel>(builder: (context, value, child) {
              final received = value.getMessageProgress(widget.messageID);
              final fileName = widget.fileElem!.fileName ?? "";
              final fileSize = widget.fileElem!.fileSize;
              final borderRadius = widget.isSelf
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(2),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))
                  : const BorderRadius.only(
                      topLeft: Radius.circular(2),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10));
              String? fileFormat;
              if (widget.fileElem?.fileName != null &&
                  widget.fileElem!.fileName!.isNotEmpty) {
                final String fileName = widget.fileElem!.fileName!;
                fileFormat =
                    fileName.split(".")[max(fileName.split(".").length - 1, 0)];
              }
              return GestureDetector(
                  onTap: () async {
                    if (PlatformUtils().isWeb) {
                      launchUrl(
                        Uri.parse(widget.fileElem?.path ?? ""),
                        mode: LaunchMode.externalApplication,
                      );
                      return;
                    }
                    if (await hasFile()) {
                      if (received == 100) {
                        tryOpenFile(context, theme);
                      } else {
                        // 正在下载中，文件可能不完整
                        onTIMCallback(
                          TIMCallback(
                            type: TIMCallbackType.INFO,
                            infoRecommendText: TIM_t("正在下载中"),
                            infoCode: 6660411,
                          ),
                        );
                      }
                      return;
                    }

                    if (checkIsWaiting()) {
                      onTIMCallback(
                        TIMCallback(
                            type: TIMCallbackType.INFO,
                            infoRecommendText: TIM_t("已加入待下载队列，其他文件下载中"),
                            infoCode: 6660413),
                      );
                      return;
                    } else {
                      await addUrlToWaitingPath();
                    }
                    await downloadFile(theme);
                  },
                  child: Container(
                    width: 237,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: theme.weakDividerColor ??
                              CommonColor.weakDividerColor,
                        ),
                        borderRadius: borderRadius),
                    child: Stack(children: [
                      ClipRRect(
                        //剪裁为圆角矩形
                        borderRadius: borderRadius,
                        child: LinearProgressIndicator(
                            minHeight: 66,
                            value: (received == 100 ? 0 : received) / 100,
                            backgroundColor: received == 100
                                ? theme.weakBackgroundColor
                                : Colors.white,
                            valueColor: AlwaysStoppedAnimation(
                                theme.lightPrimaryMaterialColor.shade50)),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          child: Row(
                              mainAxisAlignment: widget.isSelf
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      constraints:
                                          const BoxConstraints(maxWidth: 160),
                                      child: LayoutBuilder(
                                        builder:
                                            (buildContext, boxConstraints) {
                                          return CustomText(
                                            fileName,
                                            width: boxConstraints.maxWidth,
                                            style: TextStyle(
                                              color: theme.darkTextColor,
                                              fontSize: 16,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    if (fileSize != null)
                                      Text(
                                        showFileSize(fileSize),
                                        // "${received > 0 ? (received / 1024).ceil() : (received / 1024).ceil()} KB",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: theme.weakTextColor),
                                      )
                                  ],
                                )),
                                TIMUIKitFileIcon(
                                  fileFormat: fileFormat,
                                ),
                              ])),
                    ]),
                  ));
            })));
  }
}
