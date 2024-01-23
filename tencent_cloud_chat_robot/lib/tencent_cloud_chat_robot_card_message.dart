import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_robot/tencent_cloud_chat_robot_model.dart';
import 'package:tencent_cloud_chat_robot/tencent_cloud_chat_robot_utils.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_msg_create_info_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';

class TencentCloudChatRobotCardMessage extends StatefulWidget {
  final TencentCloudChatRobotData robotData;
  const TencentCloudChatRobotCardMessage({
    super.key,
    required this.robotData,
  });

  @override
  State<StatefulWidget> createState() =>
      TencentCloudChatRobotCardMessageState();
}

class TencentCloudChatRobotCardMessageState
    extends State<TencentCloudChatRobotCardMessage> {
  sendMessage(String content) async {
    V2TimValueCallback<V2TimMsgCreateInfoResult> createRes =
        await TencentImSDKPlugin.v2TIMManager
            .getMessageManager()
            .createTextMessage(text: content);
    bool? sendFailed;
    if (createRes.code == 0) {
      if (createRes.data != null) {
        if (createRes.data!.id != null) {
          var id = createRes.data!.id!;
          TencentCloudChatRobotUtils.emitPluginEvent(
            TencentCloudChatRobotPluginEventType.onCreateMessageSuccess,
            Map<String, dynamic>.from({
              "desc": "ok",
              "data": json.encode(createRes.data!.messageInfo?.toJson()),
            }),
          );
          var sendRes = await TencentImSDKPlugin.v2TIMManager
              .getMessageManager()
              .sendMessage(
                  id: id, receiver: widget.robotData.robotID, groupID: "");
          if (sendRes.code == 0 && sendRes.data != null) {
            TencentCloudChatRobotUtils.emitPluginEvent(
              TencentCloudChatRobotPluginEventType.onSendMessageToRobotSuccess,
              Map<String, dynamic>.from({
                "desc": "ok",
                "data": json.encode(sendRes.data!.toJson()),
              }),
            );
            return;
          } else {
            sendFailed = false;
          }
        }
      }
    }
    TencentCloudChatRobotUtils.emitPluginEvent(
      TencentCloudChatRobotPluginEventType.onError,
      Map<String, dynamic>.from({
        "desc": "sendmessage to robot error",
        "dara": json.encode(createRes.toJson()),
        "sendFailed": sendFailed,
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      // decoration: BoxDecoration(
      //   color: const Color(0xFFFFFFFF),
      //   border: Border.all(
      //     color: const Color(0xFFECEBEB),
      //   ),
      //   borderRadius: const BorderRadius.only(
      //     topLeft: Radius.circular(16),
      //     topRight: Radius.circular(16),
      //     bottomLeft: Radius.circular(0),
      //     bottomRight: Radius.circular(16),
      //   ),
      // ),
      width: 290,
      child: Row(
        children: [
          Expanded(
            child: Container(
              color: const Color(0xFFFFFFFF),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.question_answer_outlined),
                      const SizedBox(
                        width: 6,
                      ),
                      Expanded(
                        child: Text(
                          widget.robotData.content.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0XFF000000),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (widget.robotData.content.content.isNotEmpty)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            widget.robotData.content.content,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0XFF666666),
                            ),
                          ),
                        ),
                      ],
                    ),
                  const Divider(
                    color: Color(0xFFECEBEB),
                  ),
                  ...widget.robotData.content.items
                      .map(
                        (e) => InkWell(
                          onTap: () async {
                            sendMessage(e.content);
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(3),
                                  ),
                                  color: Color(0XFF666666),
                                ),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Expanded(
                                child: Text(
                                  e.content,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(0XFF666666),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right_sharp,
                                color: Color(0XFF666666),
                              )
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  // ListTile(
                  //   title: Text(widget.robotData.content.title),
                  //   subtitle: Text(widget.robotData.content.content),
                  //   leading: const Icon(Icons.question_answer_rounded),
                  // ),
                  // const Divider(),
                  // ...widget.robotData.content.items
                  //     .map(
                  //       (e) => ListTile(
                  //         subtitle: Text(e.content),
                  //       ),
                  //     )
                  //     .toList(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
