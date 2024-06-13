import 'package:example/config.dart';
import 'package:example/vote_create_example.dart';
import 'package:example/vote_message_example.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimSDKListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/log_level_enum.dart';
import 'package:tencent_cloud_chat_sdk/enum/v2_tim_plugins.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_callback.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:tencent_cloud_chat_vote_plugin/tencent_cloud_chat_vote_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    initIMSDK();
  }

  bool isLogined = false;
  final int sdkAppID = ExampleConfig.sdkAppID;
  final LogLevelEnum loglevel = ExampleConfig.loglevel;
  final V2TimSDKListener listener = V2TimSDKListener(
    onConnectFailed: (code, error) {},
    onConnectSuccess: () {
      print("connect to tencent cloud chat server successed");
    },
    onConnecting: () {
      print("connect to tencent cloud chat server...");
    },
    onKickedOffline: () {
      print("you are kicked");
    },
    onUserSigExpired: () {
      print("your usersig was expored");
    },
  );
  final String userID = ExampleConfig.userID;
  final String userSig = ExampleConfig.userSig;
  // 无UISDK 初始化登录imSDK
  initIMSDK() async {
    V2TimValueCallback<bool> initres = await TencentImSDKPlugin.v2TIMManager.initSDK(
      sdkAppID: sdkAppID,
      loglevel: loglevel,
      listener: listener,
      plugins: List.from([
        V2TimPlugins.Vote,
      ]),
    );
    if (initres.code == 0 && initres.data!) {
      V2TimCallback loginRes = await TencentImSDKPlugin.v2TIMManager.login(
        userID: userID,
        userSig: userSig,
      );
      if (loginRes.code == 0) {
        // 初始化投票插件
        await TencentCloudChatVotePlugin.initPlugin();
        setState(() {
          isLogined = true;
        });
      }
    }
  }

  openVoteTestPage(String pageName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => pageName == "create"
            ? const VoteCreateExample()
            : pageName == "mesasge"
                ? const VoteMessageExample()
                : Container(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: isLogined
          ? Center(
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
              child: Column(
                // Column is also a layout widget. It takes a list of children and
                // arranges them vertically. By default, it sizes itself to fit its
                // children horizontally, and tries to be as tall as its parent.
                //
                // Invoke "debug painting" (press "p" in the console, choose the
                // "Toggle Debug Paint" action from the Flutter Inspector in Android
                // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
                // to see the wireframe for each widget.
                //
                // Column has various properties to control how it sizes itself and
                // how it positions its children. Here we use mainAxisAlignment to
                // center the children vertically; the main axis here is the vertical
                // axis because Columns are vertical (the cross axis would be
                // horizontal).
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            openVoteTestPage("create");
                          },
                          child: const Text("创建投票"),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            openVoteTestPage("mesasge");
                          },
                          child: const Text("投票消息体"),
                        ),
                      )
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: ElevatedButton(
                  //         onPressed: () {
                  //           openVoteTestPage("detail");
                  //         },
                  //         child: const Text("投票详情"),
                  //       ),
                  //     )
                  //   ],
                  // ),
                ],
              ),
            )
          : const Center(
              child: Text("正在登录腾讯云即时通信，请稍候"),
            ),
    );
  }
}
