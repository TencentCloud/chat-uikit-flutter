import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/common_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKItMessageList/tim_uikit_chat_history_message_list_item.dart';
import 'package:tencent_im_base/tencent_im_base.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/message/message_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';

import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitMessageItem/main.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitMessageItem/tim_uikit_chat_face_elem.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/tim_uikit_cloud_custom_data.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/avatar.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';

class MergerMessageScreen extends StatefulWidget {
  final TUIChatSeparateViewModel model;
  final String msgID;
  final MessageItemBuilder? messageItemBuilder;

  const MergerMessageScreen(
      {Key? key,
      required this.model,
      required this.msgID,
      this.messageItemBuilder})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => MergerMessageScreenState();
}

class MergerMessageScreenState extends TIMUIKitState<MergerMessageScreen> {
  final MessageService _messageService = serviceLocator<MessageService>();

  List<V2TimMessage> messageList = [];

  @override
  initState() {
    super.initState();
    initMessageList();
  }

  void initMessageList() async {
    final mergerMessageList =
        await _messageService.downloadMergerMessage(msgID: widget.msgID);
    setState(() {
      messageList = mergerMessageList ?? [];
    });
  }

  bool isReplyMessage(V2TimMessage message) {
    final hasCustomData =
        message.cloudCustomData != null && message.cloudCustomData != "";
    if (hasCustomData) {
      try {
        final CloudCustomData messageCloudCustomData = CloudCustomData.fromJson(json.decode(
            TencentUtils.checkString(message.cloudCustomData) != null
                ? message.cloudCustomData!
                : "{}"));
        if (messageCloudCustomData.messageReply != null) {
          MessageRepliedData.fromJson(messageCloudCustomData.messageReply!);
          return true;
        }
        return false;
      } catch (error) {
        return false;
      }
    }
    return false;
  }

  Widget _getMsgItem(V2TimMessage message) {
    final type = message.elemType;
    final isFromSelf = message.isSelf ?? true;

    switch (type) {
      case MessageElemType.V2TIM_ELEM_TYPE_CUSTOM:
        if (widget.messageItemBuilder?.customMessageItemBuilder != null) {
          return widget.messageItemBuilder!.customMessageItemBuilder!(
            message,
            false,
            () {},
          )!;
        }
        return Text(TIM_t("[自定义]"));
      case MessageElemType.V2TIM_ELEM_TYPE_SOUND:
        if (widget.messageItemBuilder?.soundMessageItemBuilder != null) {
          return widget.messageItemBuilder!.soundMessageItemBuilder!(
            message,
            false,
            () {},
          )!;
        }
        return TIMUIKitSoundElem(
            chatModel: widget.model,
            isShowMessageReaction: false,
            message: message,
            soundElem: message.soundElem!,
            msgID: message.msgID ?? "",
            isFromSelf: isFromSelf,
            localCustomInt: message.localCustomInt);
      case MessageElemType.V2TIM_ELEM_TYPE_TEXT:
        if (isReplyMessage(message)) {
          if (widget.messageItemBuilder?.textReplyMessageItemBuilder != null) {
            return widget.messageItemBuilder!.textReplyMessageItemBuilder!(
              message,
              false,
              () {},
            )!;
          }
          return TIMUIKitReplyElem(
              isShowMessageReaction: false,
              chatModel: widget.model,
              message: message,
              scrollToIndex: () {},
              clearJump: () {});
        }
        if (widget.messageItemBuilder?.textMessageItemBuilder != null) {
          return widget.messageItemBuilder!.textMessageItemBuilder!(
            message,
            false,
            () {},
          )!;
        }
        return TIMUIKitTextElem(
          chatModel: widget.model,
          message: message,
          isFromSelf: message.isSelf ?? true,
          clearJump: () {},
          isShowJump: false,
          isShowMessageReaction: false,
        );
      case MessageElemType.V2TIM_ELEM_TYPE_FACE:
        if (widget.messageItemBuilder?.faceMessageItemBuilder != null) {
          return widget.messageItemBuilder!.faceMessageItemBuilder!(
            message,
            false,
            () {},
          )!;
        }
        return TIMUIKitFaceElem(
            model: widget.model,
            isShowJump: false,
            isShowMessageReaction: false,
            path: message.faceElem?.data ?? "",
            message: message);
      case MessageElemType.V2TIM_ELEM_TYPE_FILE:
        if (widget.messageItemBuilder?.fileMessageItemBuilder != null) {
          return widget.messageItemBuilder!.fileMessageItemBuilder!(
            message,
            false,
            () {},
          )!;
        }
        return TIMUIKitFileElem(
            chatModel: widget.model,
            isShowMessageReaction: false,
            message: message,
            messageID: message.msgID,
            fileElem: message.fileElem,
            isSelf: isFromSelf,
            isShowJump: false);
      case MessageElemType.V2TIM_ELEM_TYPE_IMAGE:
        if (widget.messageItemBuilder?.imageMessageItemBuilder != null) {
          return widget.messageItemBuilder!.imageMessageItemBuilder!(
            message,
            false,
            () {},
          )!;
        }
        return TIMUIKitImageElem(
          chatModel: widget.model,
          isShowMessageReaction: false,
          message: message,
          isFrom: "merger",
          key: Key("${message.seq}_${message.timestamp}"),
        );
      case MessageElemType.V2TIM_ELEM_TYPE_VIDEO:
        if (widget.messageItemBuilder?.videoMessageItemBuilder != null) {
          return widget.messageItemBuilder!.videoMessageItemBuilder!(
            message,
            false,
            () {},
          )!;
        }
        return TIMUIKitVideoElem(message,
            chatModel: widget.model,
            isFrom: "merger",
            isShowMessageReaction: false);
      case MessageElemType.V2TIM_ELEM_TYPE_LOCATION:
        if (widget.messageItemBuilder?.locationMessageItemBuilder != null) {
          return widget.messageItemBuilder!.locationMessageItemBuilder!(
            message,
            false,
            () {},
          )!;
        }
        return Text(TIM_t("[位置]"));
      case MessageElemType.V2TIM_ELEM_TYPE_MERGER:
        if (widget.messageItemBuilder?.mergerMessageItemBuilder != null) {
          return widget.messageItemBuilder!.mergerMessageItemBuilder!(
            message,
            false,
            () {},
          )!;
        }
        return TIMUIKitMergerElem(
            model: widget.model,
            isShowJump: false,
            isShowMessageReaction: false,
            message: message,
            mergerElem: message.mergerElem!,
            isSelf: isFromSelf,
            messageID: message.msgID!);
      default:
        return Text(TIM_t("未知消息"));
    }
  }

  double getMaxWidth(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    return width - 150;
  }

  Widget _itemBuilder(V2TimMessage message, BuildContext context) {
    final faceUrl = message.faceUrl ?? "";
    final showName = message.nickName ?? message.userID ?? "";
    final theme = Provider.of<TUIThemeViewModel>(context).theme;
    final isSelf = message.isSelf ?? false;
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if(!isSelf) SizedBox(
            width: 40,
            height: 40,
            child: Avatar(faceUrl: faceUrl, showName: showName),
          ),
          if(!isSelf) const SizedBox(
            width: 12,
          ),
          Column(
            crossAxisAlignment: isSelf ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(showName,
                  style: TextStyle(fontSize: 12, color: theme.weakTextColor)),
              const SizedBox(
                height: 4,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: getMaxWidth(context)),
                child: _getMsgItem(message),
              )
            ],
          ),
          if(isSelf) const SizedBox(
            width: 12,
          ),
          if(isSelf) SizedBox(
            width: 40,
            height: 40,
            child: Avatar(faceUrl: faceUrl, showName: showName),
          ),
        ],
      ),
    );
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;

    final isDesktopScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;

    Widget messageListPage() {
      return messageList.isEmpty
          ? Row(
              children: [
                Expanded(
                    child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoadingAnimationWidget.staggeredDotsWave(
                      color: theme.weakTextColor ?? Colors.grey,
                      size: 48,
                    ),
                    const SizedBox(height: 20),
                    Text(TIM_t("消息列表加载中"))
                  ],
                ))
              ],
            )
          : Container(
              padding: isDesktopScreen ? null : const EdgeInsets.all(16),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: messageList.length,
                itemBuilder: (context, index) {
                  final message = messageList[index];
                  return _itemBuilder(message, context);
                },
              ),
            );
    }

    return TUIKitScreenUtils.getDeviceWidget(
        context: context,
        desktopWidget: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: messageListPage(),
        ),
        defaultWidget: Scaffold(
          appBar: AppBar(
              title: Text(
                TIM_t("聊天记录"),
                style: TextStyle(color: theme.appbarTextColor, fontSize: 17),
              ),
              shadowColor: theme.weakDividerColor,
              backgroundColor: theme.appbarBgColor ??
                  theme.primaryColor,
              iconTheme: IconThemeData(
                color: theme.appbarTextColor,
              )),
          body: messageListPage(),
        ));
  }
}
