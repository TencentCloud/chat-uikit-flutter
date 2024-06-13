import 'package:example/config.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_vote_plugin/components/vote_create/vote_create.dart';

class VoteCreateExample extends StatefulWidget {
  const VoteCreateExample({super.key});

  @override
  State<StatefulWidget> createState() => VoteCreateExampleState();
}

class VoteCreateExampleState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("创建投票"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: TencentCloudChatVoteCreate(
          groupID: ExampleConfig.testGruopID,
          onCreateVoteSuccess: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
