import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_vote_plugin/common/color_manager.dart';
import 'package:tencent_cloud_chat_vote_plugin/common/fontsize_manager.dart';
import 'package:tencent_cloud_chat_vote_plugin/model/vote_message_model.dart';
import 'package:tencent_cloud_chat_vote_plugin/struct/vote_custom_struct.dart';

class TencentCloudChatVoteMessageMemberInfo extends StatefulWidget {
  const TencentCloudChatVoteMessageMemberInfo({
    Key? key,
    required this.msgID,
  }) : super(key: key);
  final String msgID;
  @override
  State<StatefulWidget> createState() => TencentCloudChatVoteMessageMemberInfoState();
}

class TencentCloudChatVoteMessageMemberInfoState extends State<TencentCloudChatVoteMessageMemberInfo> {
  @override
  Widget build(BuildContext context) {
    TencentCloudChatVoteLogic? data = Provider.of<TencentCloudChatVoteMessageModel>(
      context,
      listen: true,
    ).getTencentCloudChatVoteLogic(widget.msgID);
    int option1 = 0; // 应参与人数，为了国际化叫option1
    int option2 = 0; // 实际参与人数，为了国际化叫option2
    if (data != null) {
      option1 = data.groupMemberCount;
      option2 = data.messageExts.takeWhile((e) => e.extensionKey != "closed").toList().length;
    }
    return SizedBox(
      height: 34,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "应参与人数：$option1",
              style: TextStyle(
                fontSize: VoteFontSizeManager.voteMessageOptionIteMemberInfoTextFontSize,
                fontWeight: FontWeight.w400,
                color: VoteColorsManager.voteMessageMessageInfoTextColor,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "实际参与人数：$option2",
              style: TextStyle(
                fontSize: VoteFontSizeManager.voteMessageOptionIteMemberInfoTextFontSize,
                fontWeight: FontWeight.w400,
                color: VoteColorsManager.voteMessageMessageInfoTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
