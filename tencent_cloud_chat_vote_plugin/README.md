### 插件内容

从[tencent_cloud_chat_sdk](https://pub.dev/packages/tencent_cloud_chat_sdk) 5.1.5版本之后，您可以集成腾讯云即时通信官方提供的投票插件[tencent_cloud_chat_vote_plugin]()，此插件为闭源插件，集成后，您可以在群里（Community和AVChatRoom除外）集成投票功能。投票功能包括发起（单选、多选）投票、查看投票结果，参与投票等。Flutter端与Native、Web端的投票能力互通。

> 注意，投票是增值付费功能，当前处于内测阶段，请联系腾讯云商务为您开通后体验完整功能。

### 环境与版本

本插件依赖插件以及环境

- Fluter 3.10.0及以上
- [tencent_cloud_chat_sdk](https://pub.dev/packages/tencent_cloud_chat_sdk) 5.1.5及以上

### 插件引入

通过pub可将投票插件引入到项目中，插件地址：https://pub.dev/packages/tencent_cloud_chat_vote_plugin

```dart
// 集成最新版本
pub add tencent_cloud_chat_vote_plugin
 
// 集成指定版本，在项目pubspec.yaml中dependencies字段加入
tencent_cloud_chat_vote_plugin: "version" 

```

### 核心组件

1. TencentCloudChatVoteCreate 创建投票
2. TencentCloudChatVoteMessage 投票消息解析
3. TencentCloudChatVoteDetail 投票详情展示

### 插件集成

#### 创建投票

用户点击投票按钮，可创建投票

```dart
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

```

TencentCloudChatVoteCreate参数说明

1. groupID：需要创建投票的群ID，同IM群ID，Community和AVChatRoom除外
2. onCreateVoteSuccess 创建投票成功回调

#### 投票消息解析

```dart
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

```

TencentCloudChatVoteMessage参数说明

1. message：投票消息，V2TimMessage类型。
2. onTap：点击投票回调，当投票为公开且实名时，可以打开群投票详情

#### 投票详情查看

```dart
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

```

TencentCloudChatVoteDetail 参数说明

1. option：TencentCloudChatVoteDataOptoin类型，投票详情数据，由TencentCloudChatVoteMessage点击时获取
2. data：TencentCloudChatVoteLogic类型由TencentCloudChatVoteMessage点击时获取
