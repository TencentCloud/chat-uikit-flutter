import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_vote_plugin/common/color_manager.dart';
import 'package:tencent_cloud_chat_vote_plugin/common/local_image_manager.dart';
import 'package:tencent_cloud_chat_vote_plugin/model/vote_message_model.dart';
import 'package:tencent_cloud_chat_vote_plugin/struct/vote_custom_struct.dart';

class TencentCloudChatVoteMessageTitle extends StatefulWidget {
  final String msgID;
  const TencentCloudChatVoteMessageTitle({
    Key? key,
    required this.msgID,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatVoteMessageTitleState();
}

class TencentCloudChatVoteMessageTitleState extends State<TencentCloudChatVoteMessageTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: VoteColorsManager.voteMessageTitleBgColor,
      height: 66,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const TencentCloudChatVoteMessageTitleIcon(),
            TencentCloudChatVoteMessageTitleText(
              msgID: widget.msgID,
            ),
            TencentCloudChatVoteMessageTitleConfig(
              msgID: widget.msgID,
            ),
          ],
        ),
      ),
    );
  }
}

class TencentCloudChatVoteMessageTitleIcon extends StatelessWidget {
  const TencentCloudChatVoteMessageTitleIcon({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return VoteLocalImageManager.voteMessageTitleIcon(
      width: 16,
      height: 16,
    );
  }
}

class TencentCloudChatVoteMessageTitleText extends StatelessWidget {
  const TencentCloudChatVoteMessageTitleText({Key? key, required this.msgID}) : super(key: key);
  final String msgID;
  @override
  Widget build(BuildContext context) {
    TencentCloudChatVoteLogic? data = Provider.of<TencentCloudChatVoteMessageModel>(
      context,
      listen: true,
    ).getTencentCloudChatVoteLogic(msgID);
    String title = "";
    if (data != null) {
      title = data.voteData.title;
    }
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: VoteColorsManager.voteMessageTitleColor,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class TencentCloudChatVoteMessageTitleConfig extends StatelessWidget {
  const TencentCloudChatVoteMessageTitleConfig({
    Key? key,
    required this.msgID,
  }) : super(key: key);
  final String msgID;
  @override
  Widget build(BuildContext context) {
    TencentCloudChatVoteLogic? data = Provider.of<TencentCloudChatVoteMessageModel>(
      context,
      listen: true,
    ).getTencentCloudChatVoteLogic(msgID);

    bool allow_multi_vote = false;
    bool public = false;
    bool anonymous = false;
    if (data != null) {
      allow_multi_vote = data.voteData.config.allow_multi_vote;
      public = data.voteData.config.public;
      anonymous = data.voteData.config.anonymous;
    }

    return SizedBox(
      width: 80,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  allow_multi_vote ? ("[多选]") : ("[单选]"),
                  style: const TextStyle(
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  public ? ("[公开]") : ("[私有]"),
                  style: const TextStyle(
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  anonymous ? ("[匿名]") : ("[实名]"),
                  style: const TextStyle(
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
