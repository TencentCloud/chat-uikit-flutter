import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_statelesswidget.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/tim_uikit_wide_modal_operation_key.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/media_download_util.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/forward_message_screen.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/wide_popup.dart';
import 'package:tencent_im_base/tencent_im_base.dart';

import '../../../data_services/core/core_services_implements.dart';
import '../../../data_services/services_locatar.dart';

class MultiSelectPanel extends TIMUIKitStatelessWidget {
  final ConvType conversationType;

  MultiSelectPanel({Key? key, required this.conversationType})
      : super(key: key);

  _handleForwardMessage(BuildContext context, bool isMergerForward,
      TUIChatSeparateViewModel model) {
    for (var message in model.multiSelectedMessageList) {
      if (model.chatConfig.messageCanLongPres != null) {
        if (!model.chatConfig.messageCanLongPres!(message)) {
          final CoreServicesImpl _coreServices =
              serviceLocator<CoreServicesImpl>();
          _coreServices.callOnCallback(TIMCallback(
            type: TIMCallbackType.INFO,
            infoRecommendText: "包含不支持转发的消息",
          ));
          return;
        }
      }
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
        onSubmit: () {
          forwardMessageScreenKey.currentState?.handleForwardMessage();
        },
        child: (onClose) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ForwardMessageScreen(
                model: model,
                key: forwardMessageScreenKey,
                onClose: onClose,
                isMergerForward: isMergerForward,
                conversationType: conversationType,
              ),
            ));
  }

  Future<void> _downMedia(
      BuildContext context, TUIChatSeparateViewModel model, theme) async {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (context) => UnconstrainedBox(
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const CupertinoActivityIndicator(
            color: Colors.black,
            radius: 15,
          ),
        ),
      ),
    );

    final List<V2TimMessage> imgMsgs = List.from(model.multiSelectedMessageList
        .where((msg) => msg.elemType == MessageElemType.V2TIM_ELEM_TYPE_IMAGE));
    final List<V2TimMessage> videoMsgs = List.from(model
        .multiSelectedMessageList
        .where((msg) => msg.elemType == MessageElemType.V2TIM_ELEM_TYPE_VIDEO));
    if (imgMsgs.isEmpty && videoMsgs.isEmpty) {
      onTIMCallback(
        TIMCallback(
          type: TIMCallbackType.INFO,
          infoRecommendText: 'Only pictures and videos can be downloaded',
        ),
      );
      Navigator.of(context).pop();
      return;
    }

    try {
      for (var msg in imgMsgs) {
        await MediaDownloadUtil.of.saveImg(
          context,
          theme,
          cusMsg: msg,
          showSuccessTip: false,
        );
      }

      for (var msg in videoMsgs) {
        if (msg.videoElem != null) {
          await MediaDownloadUtil.of.saveVideo(
            context,
            videoElement: msg.videoElem!,
            message: msg,
            showSuccessTip: false,
          );
        }
      }

      Navigator.of(context).pop();

      onTIMCallback(
        TIMCallback(
          type: TIMCallbackType.INFO,
          infoRecommendText: TIM_t("Download successfully"),
        ),
      );
    } catch (e) {
      Navigator.of(context).pop();
    }
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
                      style: TextStyle(
                          color: theme.selectPanelTextIconColor, fontSize: 12),
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
                            operationKey: TUIKitWideModalOperationKey
                                .confirmDeleteMessages,
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
                            color: theme.selectPanelTextIconColor,
                            fontSize: 12))
                  ],
                ),
                InkWell(
                  onTap: () {
                    model.updateMultiSelectStatus(false);
                  },
                  child: Icon(
                    Icons.close,
                    color: theme.darkTextColor,
                  ),
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
                  color:
                      theme.weakDividerColor ?? CommonColor.weakDividerColor)),
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
                      package: 'tencent_cloud_chat_uikit',
                      color: theme.selectPanelTextIconColor),
                  iconSize: 40,
                  onPressed: () {
                    _handleForwardMessage(context, false, model);
                  },
                ),
                Text(TIM_t("逐条转发"),
                    style: TextStyle(
                        color: theme.selectPanelTextIconColor, fontSize: 12))
              ],
            ),
            Column(
              children: [
                IconButton(
                  icon: Image.asset('images/merge_forward.png',
                      package: 'tencent_cloud_chat_uikit',
                      color: theme.selectPanelTextIconColor),
                  iconSize: 40,
                  onPressed: () {
                    _handleForwardMessage(context, true, model);
                  },
                ),
                Text(
                  TIM_t("合并转发"),
                  style: TextStyle(
                      color: theme.selectPanelTextIconColor, fontSize: 12),
                )
              ],
            ),
            Column(
              children: [
                IconButton(
                  icon: Image.asset('images/delete.png',
                      package: 'tencent_cloud_chat_uikit',
                      color: theme.selectPanelTextIconColor),
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
                    style: TextStyle(
                        color: theme.selectPanelTextIconColor, fontSize: 12))
              ],
            ),
            Column(
              children: [
                IconButton(
                  icon: Image.asset(
                    'images/multi_select_download.png',
                    package: 'tencent_cloud_chat_uikit',
                    color: theme.selectPanelTextIconColor,
                  ),
                  iconSize: 40,
                  onPressed: () {
                    _downMedia(context, model, theme);
                  },
                ),
                Text(
                  TIM_t("下载"),
                  style: TextStyle(
                      color: theme.selectPanelTextIconColor, fontSize: 12),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
