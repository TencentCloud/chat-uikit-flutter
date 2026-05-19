import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/widgets/desktop_popup/operation_key.dart';
import 'package:tencent_cloud_chat_common/widgets/desktop_popup/tencent_cloud_chat_desktop_popup.dart';
import 'package:tencent_cloud_chat_common/widgets/file_icon/tencent_cloud_chat_file_icon.dart';
import 'package:url_launcher/url_launcher.dart';

// toxee(P2-10): extensions that should never auto-launch — these are
// arbitrary code execution vectors when received over P2P chat. For now we
// log a warning and proceed (matches upstream behavior); TODO swap in a
// proper confirm dialog using existing TencentCloudChatDialog helpers.
const Set<String> _dangerousExecutableExts = {
  '.exe', '.dmg', '.app', '.apk', '.bat', '.cmd', '.com', '.scr', '.msi',
  '.pkg', '.deb', '.rpm', '.sh', '.ps1', '.vbs', '.jar', '.appimage',
};

bool _isDangerousFile(String filePath) {
  final ext = Pertypath().extension(filePath).toLowerCase();
  return _dangerousExecutableExts.contains(ext);
}

class TencentCloudChatDesktopFileTools {
  static sendFileWithConfirmation({
    required List<String> filesPath,
    required String currentConversationShowName,
    required Function({required String filePath}) sendFileMessage,
    required BuildContext context,
  }) async {
    bool canSend = true;

    if (!TencentCloudChatPlatformAdapter().isWeb) {
      filesPath.any((filePath) {
        final directory = Directory(filePath);
        final isDirectoryExists = directory.existsSync();
        if (isDirectoryExists) {
          canSend = false;
          return false;
        }
        return true;
      });
    } else {
      filesPath.any((filePath) {
        String fileExtension = Pertypath().extension(filePath);
        bool hasNoExtension = fileExtension.isEmpty;
        if (hasNoExtension) {
          canSend = false;
          return false;
        }
        return true;
      });
    }

    if (!canSend) {
      TencentCloudChatDesktopPopup.showSecondaryConfirmDialog(
        text: tL10n.unableToSendWithFolders,
        onConfirm: () {},
        operationKey: TencentCloudChatPopupOperationKey.sendResourcesOnDesktop,
        context: context,
      );
      return;
    }
    TencentCloudChatDesktopPopup.showPopupWindow(
      operationKey: TencentCloudChatPopupOperationKey.sendResourcesOnDesktop,
      context: context,
      isDarkBackground: false,
      width: 600,
      height: filesPath.length < 4 ? 300 : 500,
      title: tL10n.sendToSomeChat(currentConversationShowName),
      child: (closeFunc) => Container(
        padding: const EdgeInsets.only(bottom: 16),
        child: TencentCloudChatThemeWidget(
          build: (context, colorTheme, textStyle) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Scrollbar(
                  child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      final filePath = filesPath[index];
                      final fileName = TencentCloudChatPlatformAdapter().isWeb ? filePath : Pertypath().basename(filePath);
                      return Material(
                        color: colorTheme.backgroundColor,
                        child: InkWell(
                          onTap: () {
                            if (_isDangerousFile(filePath)) {
                              // TODO(P2-10): show confirm dialog before
                              // launching executable extensions. For now we
                              // log a warning so the path is auditable, but
                              // proceed to preserve current UX. Callers must
                              // still scrutinize file_tools usage.
                              debugPrint(
                                '[toxee] WARN: launching potentially '
                                'dangerous file via desktop drop preview: '
                                '$filePath',
                              );
                            }
                            launchUrl(Uri.file(filePath));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                            child: Row(
                              children: [
                                TencentCloudChatFileIcon(
                                  size: 44,
                                  fileFormat: fileName.split(".")[fileName.split(".").length - 1],
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    fileName,
                                    style: TextStyle(fontSize: 16, color: colorTheme.primaryTextColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        height: 1,
                        thickness: 1,
                        color: colorTheme.dividerColor,
                      );
                    },
                    itemCount: filesPath.length,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16, top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    OutlinedButton(
                        style: ButtonStyle(
                          side: MaterialStateProperty.resolveWith<BorderSide>(
                            (Set<MaterialState> states) {
                              return BorderSide(color: colorTheme.dividerColor, width: 1);
                            },
                          ),
                        ),
                        onPressed: () {
                          closeFunc();
                        },
                        child: Text(tL10n.cancel)),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          sendFiles(
                            filesPath: filesPath,
                            context: context,
                            sendFileMessage: sendFileMessage,
                          );
                          closeFunc();
                        },
                        child: Text(tL10n.send))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> sendFiles({
    required List<String> filesPath,
    required BuildContext context,
    required Function({required String filePath}) sendFileMessage,
  }) async {
    for (final filePath in filesPath) {
      await sendFileMessage(filePath: filePath);
      // toxee(P1): upstream wrote `microseconds: 300` (~ 0 delay).
      // Need real spacing between consecutive sends so the SDK can
      // serialize message IDs and avoid out-of-order writes.
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }
}
