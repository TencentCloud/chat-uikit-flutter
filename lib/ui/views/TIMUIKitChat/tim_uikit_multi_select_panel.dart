import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_chat_i18n_tool/tencent_chat_i18n_tool.dart';
import 'package:tencent_cloud_chat_sdk/enum/message_status.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_statelesswidget.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/tim_uikit_wide_modal_operation_key.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/forward_message_screen.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/wide_popup.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_callback.dart';
import 'package:tencent_cloud_chat_uikit/theme/color.dart';
import 'package:tencent_cloud_chat_uikit/theme/tui_theme.dart';

class MultiSelectPanel extends TIMUIKitStatelessWidget {
  final int forwardMsgNumLimit = 30;

  final ConvType conversationType;

  MultiSelectPanel({Key? key, required this.conversationType})
      : super(key: key);

  _handleForwardMessage(BuildContext context, bool isMergerForward,
      TUIChatSeparateViewModel model) {

    // 是否有选中消息
    if (model.getSelectedMessageList().isEmpty) {
      onTIMCallback(TIMCallback(
          type: TIMCallbackType.INFO,
          infoRecommendText: TIM_t("请选择要操作的消息！")));
      return;
    }

    for (var v2TimMessage in model.getSelectedMessageList()) {
      // 失败消息不支持转发
      if (v2TimMessage.status == MessageStatus.V2TIM_MSG_STATUS_SEND_FAIL) {
        onTIMCallback(TIMCallback(
            type: TIMCallbackType.INFO,
            infoRecommendText: TIM_t("发送失败消息不支持转发！")));
        return;
      }

      // 投票消息不支持转发
      if (model.isVoteMessage(v2TimMessage)) {
        onTIMCallback(TIMCallback(
          type: TIMCallbackType.INFO,
          infoRecommendText: TIM_t("投票消息不支持转发！")));
        return;
      }
    }

    // 逐条转发限制在 30 条以内
    if (!isMergerForward && model.getSelectedMessageList().length > forwardMsgNumLimit) {
      _showForwardLimitDialog(context);
      return;
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ForwardMessageScreen(
                  model: model,
                  isMergerForward: isMergerForward,
                  conversationType: conversationType,
                )));
  }

  // 弹出逐条转发超限的对话框
  Future<bool?> _showForwardLimitDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(TIM_t("转发消息过多，暂不支持逐条转发")),
          actions: [
            CupertinoDialogAction(
              child: Text(TIM_t("确定")),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            CupertinoDialogAction(
              child: Text(TIM_t("取消")),
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _handleForwardMessageWide(BuildContext context, bool isMergerForward,
      TUIChatSeparateViewModel model) {
    TUIKitWidePopup.showPopupWindow(
        operationKey: TUIKitWideModalOperationKey.forward,
        context: context,
        isDarkBackground: false,
        title: TIM_t("转发"),
        submitWidget: Text(TIM_t("发送")),
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.8,
        onSubmit: (){
          forwardMessageScreenKey.currentState?.handleForwardMessage();
        },
        child: (onClose) => Container(
          padding: const EdgeInsets.symmetric( horizontal: 10),
          child: ForwardMessageScreen(
            model: model,
            key: forwardMessageScreenKey,
            onClose: onClose,
            isMergerForward: isMergerForward,
            conversationType: conversationType,
          ),
        )
    );
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;
    final TUIChatSeparateViewModel model =
        Provider.of<TUIChatSeparateViewModel>(context);

    return TUIKitScreenUtils.getDeviceWidget(
      context: context,
      desktopWidget: Container(
        decoration: BoxDecoration(
          color: theme.selectPanelBgColor ?? theme.primaryColor,
          border: Border(
            top: BorderSide(
              color: theme.weakDividerColor ?? Colors.grey,
              width: 1.0,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              spacing: 64,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: Image.asset('images/forward.png',
                          package: 'tencent_cloud_chat_uikit',
                          color: theme.selectPanelTextIconColor),
                      iconSize: 30,
                      onPressed: () {
                        _handleForwardMessageWide(context, false, model);
                      },
                    ),
                    Text(TIM_t("逐条转发"),
                        style: TextStyle(
                            color: hexToColor("646a73"), fontSize: 12))
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Image.asset('images/merge_forward.png',
                          package: 'tencent_cloud_chat_uikit',
                          color: theme.selectPanelTextIconColor),
                      iconSize: 30,
                      onPressed: () {
                        _handleForwardMessageWide(context, true, model);
                      },
                    ),
                    Text(
                      TIM_t("合并转发"),
                      style:
                          TextStyle(color: theme.selectPanelTextIconColor, fontSize: 12),
                    )
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Image.asset('images/delete.png',
                          package: 'tencent_cloud_chat_uikit',
                          color: theme.selectPanelTextIconColor),
                      iconSize: 30,
                      onPressed: () {
                        TUIKitWidePopup.showSecondaryConfirmDialog(
                            operationKey: TUIKitWideModalOperationKey.confirmDeleteMessages,
                            context: context,
                            text: TIM_t("确定删除已选消息"),
                            theme: theme,
                            onCancel: () {},
                            onConfirm: () async {
                              model.deleteSelectedMsg();
                              model.updateMultiSelectStatus(false);
                            });
                      },
                    ),
                    Text(TIM_t("删除"),
                        style: TextStyle(
                            color: theme.selectPanelTextIconColor, fontSize: 12))
                  ],
                ),
                InkWell(
                  onTap: (){
                    model.updateMultiSelectStatus(false);
                  },
                  child: Icon(Icons.close, color: theme.darkTextColor,),
                )
              ],
            ))
          ],
        ),
      ),
      defaultWidget: Container(
        decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: theme.weakDividerColor ??
                      CommonColor.weakDividerColor)),
          color: theme.selectPanelBgColor ?? theme.primaryColor,
        ),
        padding: const EdgeInsets.only(top: 12, bottom: 48),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                IconButton(
                  icon: Image.asset('images/forward.png',
                      package: 'tencent_cloud_chat_uikit', color: theme.selectPanelTextIconColor),
                  iconSize: 40,
                  onPressed: () {
                    _handleForwardMessage(context, false, model);
                  },
                ),
                Text(TIM_t("逐条转发"),
                    style: TextStyle(color: theme.selectPanelTextIconColor, fontSize: 12))
              ],
            ),
            Column(
              children: [
                IconButton(
                  icon: Image.asset('images/merge_forward.png',
                      package: 'tencent_cloud_chat_uikit', color: theme.selectPanelTextIconColor),
                  iconSize: 40,
                  onPressed: () {
                    _handleForwardMessage(context, true, model);
                  },
                ),
                Text(
                  TIM_t("合并转发"),
                  style: TextStyle(color: theme.selectPanelTextIconColor, fontSize: 12),
                )
              ],
            ),
            Column(
              children: [
                IconButton(
                  icon: Image.asset('images/delete.png',
                      package: 'tencent_cloud_chat_uikit', color: theme.selectPanelTextIconColor),
                  iconSize: 40,
                  onPressed: () {
                    showCupertinoModalPopup<String>(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoActionSheet(
                          title: Text(TIM_t("确定删除已选消息")),
                          cancelButton: CupertinoActionSheetAction(
                            onPressed: () {
                              Navigator.pop(
                                context,
                                "cancel",
                              );
                            },
                            child: Text(TIM_t("取消")),
                            isDefaultAction: false,
                          ),
                          actions: [
                            CupertinoActionSheetAction(
                              onPressed: () {
                                model.deleteSelectedMsg();
                                model.updateMultiSelectStatus(false);
                                Navigator.pop(
                                  context,
                                  "cancel",
                                );
                              },
                              child: Text(
                                TIM_t("删除"),
                                style: TextStyle(color: theme.cautionColor),
                              ),
                              isDefaultAction: false,
                            )
                          ],
                        );
                      },
                    );
                  },
                ),
                Text(TIM_t("删除"),
                    style: TextStyle(color: theme.selectPanelTextIconColor, fontSize: 12))
              ],
            )
          ],
        ),
      ),
    );
  }
}
