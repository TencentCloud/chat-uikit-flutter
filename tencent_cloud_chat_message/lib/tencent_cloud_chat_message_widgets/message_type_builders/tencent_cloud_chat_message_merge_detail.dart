import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_message/model/tencent_cloud_chat_message_separate_data.dart';
import 'package:tencent_cloud_chat_message/model/tencent_cloud_chat_message_separate_data_notifier.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_list_view/message_row/tencent_cloud_chat_message_row_container.dart';

class TencentCloudChatMessageMergeDetail extends StatefulWidget {
  final V2TimMessage message;

  const TencentCloudChatMessageMergeDetail({
    super.key,
    required this.message,
  });

  @override
  State<StatefulWidget> createState() =>
      TencentCloudChatMessageMergeDetailState();
}

class TencentCloudChatMessageMergeDetailState
    extends TencentCloudChatState<TencentCloudChatMessageMergeDetail> {
  final String _tag = "TencentCloudChatMessageMergeDetail";

  console(String log) {
    TencentCloudChat.instance.logInstance.console(
      componentName: _tag,
      logs: json.encode(
        {
          "msgID": widget.message.msgID,
          "log": log,
        },
      ),
    );
  }

  List<V2TimMessage> messages = [];

  getAllMergeMessage() async {
    var msgs = await TencentCloudChat.instance.chatSDKInstance.messageSDK.getMergeMessages(
        msgID: widget.message.msgID ?? widget.message.id ?? "");
    console("download merge message success. length ${msgs.length}");
    if (msgs.isNotEmpty) {
      safeSetState(() {
        messages = msgs;
      });
    }
  }

  String getMergeMessageTitle() {
    String res = "";
    if (widget.message.mergerElem != null) {
      var elem = widget.message.mergerElem!;
      res = elem.title ?? "";
    }
    return res;
  }

  final TencentCloudChatMessageSeparateDataProvider
      _messageSeparateDataProvider =
      TencentCloudChatMessageSeparateDataProvider();

  @override
  void dispose() {
    super.dispose();
    _messageSeparateDataProvider.dispose();
  }

  @override
  void initState() {
    super.initState();
    _messageSeparateDataProvider.init(
      userID: widget.message.userID,
      groupID: widget.message.groupID,
    );
    getAllMergeMessage();
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatMessageDataProviderInherited(
      dataProvider: _messageSeparateDataProvider,
      child: Scaffold(
        appBar: AppBar(title: Text(getMergeMessageTitle())),
        body: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: LayoutBuilder(
            builder: (context, constraints) => ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return TencentCloudChatMessageRowContainer(
                  messageRowWidth: constraints.maxWidth,
                  message: messages[index],
                  inMergerMessagePreviewMode: true,
                );
              },
              itemCount: messages.length,
            ),
          ),
        ),
      ),
    );
  }
}
