import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_statelesswidget.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_group_profile_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/tim_uikit_wide_modal_operation_key.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/controller/tim_uikit_chat_controller.dart';

import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/wide_popup.dart';

class GroupProfileButtonArea extends TIMUIKitStatelessWidget {
  final String groupID;
  final TUIGroupProfileModel model;
  final sdkInstance = TIMUIKitCore.getSDKInstance();
  final coreInstance = TIMUIKitCore.getInstance();
  final TIMUIKitChatController _timuiKitChatController =
      TIMUIKitChatController();

  GroupProfileButtonArea(this.groupID, this.model, {Key? key})
      : super(key: key);

  final _operationList = [
    {"label": TIM_t("清空消息"), "id": "clearHistory"},
    {"label": TIM_t("转让群主"), "id": "transimitOwner"},
    {"label": TIM_t("退出群组"), "id": "quitGroup"},
    {"label": TIM_t("解散群组"), "id": "dismissGroup"}
  ];

  _clearHistory(BuildContext context, theme) async {
    final isDesktopScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;

    if (isDesktopScreen) {
      TUIKitWidePopup.showSecondaryConfirmDialog(
          operationKey: TUIKitWideModalOperationKey.confirmClearChatHistory,
          context: context,
          text: TIM_t("清空聊天记录"),
          theme: theme,
          onCancel: () {},
          onConfirm: () async {
            if (PlatformUtils().isWeb) {
              final res = await sdkInstance
                  .getConversationManager()
                  .deleteConversation(conversationID: "group_$groupID");
              if (res.code == 0) {
                _timuiKitChatController.clearHistory(groupID);
              }
            } else {
              final res = await sdkInstance
                  .getMessageManager()
                  .clearGroupHistoryMessage(groupID: groupID);
              if (res.code == 0) {
                _timuiKitChatController.clearHistory(groupID);
              }
            }
          });
    } else {
      showCupertinoModalPopup<String>(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
              child: Text(TIM_t("取消")),
              isDefaultAction: false,
            ),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () async {
                  Navigator.pop(
                    context,
                  );
                  if (PlatformUtils().isWeb) {
                    final res = await sdkInstance
                        .getConversationManager()
                        .deleteConversation(conversationID: "group_$groupID");
                    if (res.code == 0) {
                      _timuiKitChatController.clearHistory(groupID);
                    }
                  } else {
                    final res = await sdkInstance
                        .getMessageManager()
                        .clearGroupHistoryMessage(groupID: groupID);
                    if (res.code == 0) {
                      _timuiKitChatController.clearHistory(groupID);
                    }
                  }
                },
                child: Text(
                  TIM_t("清空聊天记录"),
                  style: TextStyle(color: theme.cautionColor),
                ),
                isDefaultAction: false,
              )
            ],
          );
        },
      );
    }
  }

  _quitGroup(BuildContext context, TUITheme theme) async {
    final isDesktopScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;

    if (isDesktopScreen) {
      TUIKitWidePopup.showSecondaryConfirmDialog(
          operationKey: TUIKitWideModalOperationKey.confirmExitGroup,
          context: context,
          text: TIM_t("退出后不会接收到此群聊消息"),
          theme: theme,
          onCancel: () {},
          onConfirm: () async {
            final res = await sdkInstance.quitGroup(groupID: groupID);
            if (res.code == 0) {
              final deleteConvRes = await sdkInstance
                  .getConversationManager()
                  .deleteConversation(conversationID: "group_$groupID");
              if (deleteConvRes.code == 0) {
                model.lifeCycle?.didLeaveGroup();
              }
            }
          });
    } else {
      showCupertinoModalPopup<String>(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(TIM_t("退出后不会接收到此群聊消息")),
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
              child: Text(TIM_t("取消")),
              isDefaultAction: false,
            ),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () async {
                  Navigator.pop(
                    context,
                  );
                  final res = await sdkInstance.quitGroup(groupID: groupID);
                  if (res.code == 0) {
                    final deleteConvRes = await sdkInstance
                        .getConversationManager()
                        .deleteConversation(conversationID: "group_$groupID");
                    if (deleteConvRes.code == 0) {
                      model.lifeCycle?.didLeaveGroup();
                    }
                  }
                },
                child: Text(
                  TIM_t("确定"),
                  style: TextStyle(color: theme.cautionColor),
                ),
                isDefaultAction: false,
              )
            ],
          );
        },
      );
    }
  }

  _dismissGroup(BuildContext context, theme) async {
    final isDesktopScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;

    if (isDesktopScreen) {
      TUIKitWidePopup.showSecondaryConfirmDialog(
          operationKey: TUIKitWideModalOperationKey.confirmDisbandGroup,
          context: context,
          text: TIM_t("解散后不会接收到此群聊消息"),
          theme: theme,
          onCancel: () {},
          onConfirm: () async {
            final res = await sdkInstance.dismissGroup(groupID: groupID);
            if (res.code == 0) {
              await sdkInstance
                  .getConversationManager()
                  .deleteConversation(conversationID: "group_$groupID");
              model.lifeCycle?.didLeaveGroup();
            }
          });
    } else {
      showCupertinoModalPopup<String>(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(TIM_t("解散后不会接收到此群聊消息")),
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
              child: Text(TIM_t("取消")),
              isDefaultAction: false,
            ),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () async {
                  Navigator.pop(
                    context,
                  );
                  final res = await sdkInstance.dismissGroup(groupID: groupID);
                  if (res.code == 0) {
                    await sdkInstance
                        .getConversationManager()
                        .deleteConversation(conversationID: "group_$groupID");
                    model.lifeCycle?.didLeaveGroup();
                  }
                },
                child: Text(
                  TIM_t("确定"),
                  style: TextStyle(color: theme.cautionColor),
                ),
                isDefaultAction: false,
              )
            ],
          );
        },
      );
    }
  }

  _transmitOwner(BuildContext context, String groupID) async {
    final isDesktopScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;

    if (isDesktopScreen) {
      TUIKitWidePopup.showPopupWindow(
        operationKey: TUIKitWideModalOperationKey.setAdmins,
        context: context,
        title: TIM_t("转让群主"),
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.8,
        onSubmit: () {
          selectNewGroupOwnerKey.currentState?.onSubmit();
        },
        child: (onClose) => SelectNewGroupOwner(
          model: model,
          key: selectNewGroupOwnerKey,
          groupID: groupID,
          onSelectedMember: (selectedMember) async {
            if (selectedMember.isNotEmpty) {
              final userID = selectedMember.first.userID;
              await sdkInstance
                  .getGroupManager()
                  .transferGroupOwner(groupID: groupID, userID: userID);
            }
          },
        ),
      );
    } else {
      List<V2TimGroupMemberFullInfo>? selectedMember = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectNewGroupOwner(
            model: model,
            groupID: groupID,
          ),
        ),
      );
      if (selectedMember != null) {
        final userID = selectedMember.first.userID;
        await sdkInstance
            .getGroupManager()
            .transferGroupOwner(groupID: groupID, userID: userID);
      }
    }
  }

  List<Widget> _renderGroupOperation(
      BuildContext context, TUITheme theme, bool isOwner, String groupType) {
    final isDesktopScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
    return _operationList
        .where((element) {
          if (!isOwner) {
            return ["quitGroup", "clearHistory"].contains(element["id"]);
          } else {
            if (groupType == "Work") {
              return ["clearHistory", "quitGroup", "transimitOwner"]
                  .contains(element["id"]);
            }
            if (groupType != "Work") {
              return ["clearHistory", "dismissGroup", "transimitOwner"]
                  .contains(element["id"]);
            }
            return true;
          }
        })
        .map((e) => isDesktopScreen
            ? OutlinedButton(
                onPressed: () {
                  if (e["id"]! == "clearHistory") {
                    _clearHistory(context, theme);
                  } else if (e["id"] == "quitGroup") {
                    _quitGroup(context, theme);
                  } else if (e["id"] == "dismissGroup") {
                    _dismissGroup(context, theme);
                  } else if (e["id"] == "transimitOwner") {
                    _transmitOwner(context, groupID);
                  }
                },
                child: Text(
                  e["label"]!,
                  style: TextStyle(color: theme.cautionColor),
                ))
            : InkWell(
                onTap: () {
                  if (e["id"]! == "clearHistory") {
                    _clearHistory(context, theme);
                  } else if (e["id"] == "quitGroup") {
                    _quitGroup(context, theme);
                  } else if (e["id"] == "dismissGroup") {
                    _dismissGroup(context, theme);
                  } else if (e["id"] == "transimitOwner") {
                    _transmitOwner(context, groupID);
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(
                              color: theme.weakDividerColor ??
                                  CommonColor.weakDividerColor))),
                  child: Text(
                    e["label"]!,
                    style: TextStyle(color: theme.cautionColor, fontSize: 17),
                  ),
                ),
              ))
        .toList();
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final theme = value.theme;
    final groupInfo = model.groupInfo;

    final isDesktopScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
    if (isDesktopScreen) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Wrap(
          spacing: 28,
          children: [
            ..._renderGroupOperation(
                context,
                theme,
                groupInfo?.owner == coreInstance.loginUserInfo?.userID,
                groupInfo?.groupType ?? "")
          ],
        ),
      );
    }

    return Column(
      children: [
        ..._renderGroupOperation(
            context,
            theme,
            groupInfo?.owner == coreInstance.loginUserInfo?.userID,
            groupInfo?.groupType ?? "")
      ],
    );
  }
}
