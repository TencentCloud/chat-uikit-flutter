import 'package:example/config.dart';
import 'package:example/vote_detail_example.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_sdk/enum/history_msg_get_type_enum.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:tencent_cloud_chat_vote_plugin/tencent_cloud_chat_vote_plugin.dart';

class VoteMessageExample extends StatefulWidget {
  const VoteMessageExample({super.key});

  @override
  State<StatefulWidget> createState() => VoteMessageExampleState();
}

class VoteMessageExampleState extends State {
  V2TimMessage? message;
  getTestV2TimMessage() async {
    V2TimValueCallback<List<V2TimMessage>> messageListRes =
        await TencentImSDKPlugin.v2TIMManager
            .getMessageManager()
            .getHistoryMessageList(
              count: 1,
              groupID: ExampleConfig.testGruopID,
              getType: HistoryMsgGetTypeEnum.V2TIM_GET_CLOUD_OLDER_MSG,
            );
    if (messageListRes.code == 0) {
      if (messageListRes.data != null) {
        if (messageListRes.data!.isNotEmpty) {
          setState(() {
            message = messageListRes.data!.first;
          });
        }
      }
    }
  }

  bool isEnd = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(
        const Duration(
          milliseconds: 300,
        ), () {
      setState(() {
        isEnd = true;
      });
    });
    // 页面运动结束再显示组件
    getTestV2TimMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("投票消息体"),
      ),
      body: !isEnd
          ? Container()
          : message != null
              ? TencentCloudChatVoteMessage(
                  message: message!,
                  onTap: (
                    TencentCloudChatVoteDataOptoin option,
                    TencentCloudChatVoteLogic data,
                  ) {
                    print(data.voteData.toJson());
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VoteDetailExample(
                          option: option,
                          data: data,
                        ),
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text("未获取到正确的Message实例"),
                ),
    );
  }
}
