import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_msg_create_info_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:tencent_cloud_chat_vote_plugin/common/color_manager.dart';
import 'package:tencent_cloud_chat_vote_plugin/model/vote_create_model.dart';
import 'package:tencent_cloud_chat_vote_plugin/struct/vote_custom_struct.dart';

class TencentCloudChatVoteCreatePublish extends StatefulWidget {
  const TencentCloudChatVoteCreatePublish({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatVoteCreatePublishState();
}

class TencentCloudChatVoteCreatePublishState extends State<TencentCloudChatVoteCreatePublish> {
  publish() async {
    TencentCloudChatVoteCreateModel pv = Provider.of<TencentCloudChatVoteCreateModel>(context, listen: false);

    List<TencentCloudChatVoteDataOptoin> optionList = List<TencentCloudChatVoteDataOptoin>.from([]);

    for (var i = 0; i < pv.options.length; i++) {
      optionList.add(
        TencentCloudChatVoteDataOptoin(
          index: i + 1,
          option: pv.options[i].option,
        ),
      );
    }
    TencentCloudChatVoteData data = TencentCloudChatVoteData(
      title: pv.title,
      config: TencentCloudChatVoteDataConfig(
        allow_multi_vote: pv.allow_multi_vote,
        public: pv.public,
        anonymous: pv.anonymous,
      ),
      content: TencentCloudChatVoteDataContent(
        option_list: optionList,
      ),
    );
    V2TimValueCallback<V2TimMsgCreateInfoResult> createdMessageRes = await TencentImSDKPlugin.v2TIMManager.getMessageManager().createCustomMessage(
          data: json.encode(
            data.toJson(),
          ),
        );
    if (createdMessageRes.code == 0) {
      if (createdMessageRes.data != null) {
        String? id = createdMessageRes.data!.id;
        if (id != null) {
          V2TimValueCallback<V2TimMessage> sendRes = await TencentImSDKPlugin.v2TIMManager.getMessageManager().sendMessage(
                id: id,
                receiver: "",
                groupID: pv.groupID,
                isSupportMessageExtension: true,
              );
          if (sendRes.code == 0) {
            pv.onCreateVoteSuccess();
          } else {
            if (pv.onCreateVoteError != null) {
              pv.onCreateVoteError!(sendRes.code, sendRes.desc);
            }
          }
        }
      } else {
        if (pv.onCreateVoteError != null) {
          pv.onCreateVoteError!(
            createdMessageRes.code,
            "create message id is null. please check.",
          );
        }
      }
    } else {
      if (pv.onCreateVoteError != null) {
        pv.onCreateVoteError!(createdMessageRes.code, createdMessageRes.desc);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 30,
        left: 15,
        right: 15,
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(VoteColorsManager.votePublishButtonBgColor),
                ),
                onPressed: publish,
                child: const Text(
                  ("发布"),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
