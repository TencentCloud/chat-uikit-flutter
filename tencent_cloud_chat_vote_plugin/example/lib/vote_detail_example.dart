import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_vote_plugin/tencent_cloud_chat_vote_plugin.dart';

class VoteDetailExample extends StatelessWidget {
  final TencentCloudChatVoteDataOptoin option;
  final TencentCloudChatVoteLogic data;
  const VoteDetailExample({
    super.key,
    required this.option,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(option.option),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TencentCloudChatVoteDetail(
          option: option,
          data: data,
        ),
      ),
    );
  }
}
