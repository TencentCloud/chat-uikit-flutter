import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_vote_plugin/components/vote_create/vote_create_config.dart';
import 'package:tencent_cloud_chat_vote_plugin/components/vote_create/vote_create_options.dart';
import 'package:tencent_cloud_chat_vote_plugin/components/vote_create/vote_create_publish.dart';
import 'package:tencent_cloud_chat_vote_plugin/components/vote_create/vote_create_title.dart';
import 'package:tencent_cloud_chat_vote_plugin/model/vote_create_model.dart';

typedef OnCreateVoteSuccess = Function();
typedef OnCreateVoteError = Function(int code, String? desc);

///
class TencentCloudChatVoteCreate extends StatefulWidget {
  final String groupID;
  final OnCreateVoteSuccess onCreateVoteSuccess;
  final OnCreateVoteError? onCreateVoteError;
  const TencentCloudChatVoteCreate({
    Key? key,
    required this.groupID,
    required this.onCreateVoteSuccess,
    this.onCreateVoteError,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatVoteCreateState();
}

class TencentCloudChatVoteCreateState extends State<TencentCloudChatVoteCreate> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TencentCloudChatVoteCreateModel(
        groupID: widget.groupID,
        onCreateVoteSuccess: widget.onCreateVoteSuccess,
        onCreateVoteError: widget.onCreateVoteError,
      ),
      child: Container(
        color: Colors.white,
        child: const Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  // title
                  TencentCloudChatVoteCreateTitle(),
                  // options
                  TencentCloudChatVoteCreateOptions(),
                  // configs
                  TencentCloudChatVoteCreateConfig(),
                  // publish btn
                  TencentCloudChatVoteCreatePublish(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
