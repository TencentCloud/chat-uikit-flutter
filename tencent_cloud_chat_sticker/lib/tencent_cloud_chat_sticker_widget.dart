import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:tencent_cloud_chat_sticker/tencent_cloud_chat_sticker.dart';
import 'package:tencent_cloud_chat_sticker/tencent_cloud_chat_sticker_model.dart';
import 'package:tencent_cloud_chat_sticker/tencent_cloud_chat_sticker_utils.dart';

class TencentCloudChatStickerPanel extends StatefulWidget {
  const TencentCloudChatStickerPanel({super.key});

  @override
  State<StatefulWidget> createState() => TencentCloudChatStickerPanelState();
}

typedef OnTabClickCallback = void Function(int currentIndex);

class TencentCloudChatStickerPanelState extends State<TencentCloudChatStickerPanel> with SingleTickerProviderStateMixin {
  int activeTabIndex = 0;
  late OnTabClickCallback onTabClickCallback;
  late AnimationController _controller;

  void handleTabClick(int index) {
    if (index != activeTabIndex) {
      setState(() {
        activeTabIndex = index;
      });
    } else {
      TencentCloudChatStickerUtils.log("activeIndex is same. do nothing");
    }
  }

  @override
  void initState() {
    super.initState();
    onTabClickCallback = handleTabClick;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool> delay300() async {
    await Future.delayed(const Duration(milliseconds: 60));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (TencentCloudChatStickerPlugin.initData.userID == null) {
      return const TencentCloudChatStickerError();
    } else {
      if (TencentCloudChatStickerPlugin.initData.userID!.isEmpty) {
        return const TencentCloudChatStickerError();
      }
    }
    if (TencentCloudChatStickerPlugin.initData.customStickerLists == null) {
      return const TencentCloudChatStickerError();
    }
    if (TencentCloudChatStickerPlugin.initData.customStickerLists!.isEmpty) {
      return const TencentCloudChatStickerError();
    }
    return FutureBuilder(
        future: delay300(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.data == true) {
            return Container(
              child: Column(
              children: [
                TencentCloudChatStickerTab(
                  onTabClickCallback: onTabClickCallback,
                  activeTabIndex: activeTabIndex,
                ),
                TencentCloudChatStickerContent(
                  activeTabIndex: activeTabIndex,
                ),
              ],
              ),
            );
          }
          return Container();
        });
  }
}

class TencentCloudChatStickerError extends StatelessWidget {
  const TencentCloudChatStickerError({super.key});
  @override
  Widget build(BuildContext context) {
    return const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Padding(
        padding: EdgeInsets.only(right: 10),
        child: Icon(Icons.error_outline),
      ),
      Text("暂无表情"),
    ]);
  }
}

class TencentCloudChatStickerTab extends StatefulWidget {
  final OnTabClickCallback onTabClickCallback;
  final int activeTabIndex;
  const TencentCloudChatStickerTab({
    super.key,
    required this.onTabClickCallback,
    required this.activeTabIndex,
  });
  @override
  State<StatefulWidget> createState() => TencentCloudChatStickerTabState();
}

class TencentCloudChatStickerTabState extends State<TencentCloudChatStickerTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.099))),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: TencentCloudChatStickerPlugin.initData.customStickerLists!.map(
            (e) {
              int index = TencentCloudChatStickerPlugin.initData.customStickerLists!.indexOf(e);
              bool showActiveStyle = index == widget.activeTabIndex;
              bool isLastIndex = index == TencentCloudChatStickerPlugin.initData.customStickerLists!.length - 1;
              
              return GestureDetector(
                onTap: () {
                  widget.onTabClickCallback(index);
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: showActiveStyle ? const Color(0XFFF4F7FD) : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  margin: EdgeInsets.only(right: isLastIndex ? 0 : 10),
                  child: Align(
                    alignment: Alignment.center,
                    child: Image(
                      image: AssetImage(e.iconPath, package: "tencent_cloud_chat_sticker"),
                      width: e.iconSize,
                    ),
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}

class TencentCloudChatStickerContent extends StatefulWidget {
  final int activeTabIndex;
  const TencentCloudChatStickerContent({
    super.key,
    required this.activeTabIndex,
  });
  @override
  State<StatefulWidget> createState() => TencentCloudChatStickerContentState();
}

class TencentCloudChatStickerContentState extends State<TencentCloudChatStickerContent> {
  sendStickerMessage(int type, String name, int stickerIndex) {
    TencentImSDKPlugin.v2TIMManager.emitUIKitListener(
      data: Map<String, dynamic>.from(
        {
          "type": type,
          "name": name,
          "stickerIndex": stickerIndex,
          "eventType": "stickClick",
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<TencentCloudChatCustomStickerItem> currentStickerList = [];
    int crossAxisCount = 7;
    int stickerType = 0;
    int stickerIndex = 0;
    if (TencentCloudChatStickerPlugin.initData.customStickerLists != null) {
      if (TencentCloudChatStickerPlugin.initData.customStickerLists!.elementAtOrNull(widget.activeTabIndex) != null) {
        currentStickerList = TencentCloudChatStickerPlugin.initData.customStickerLists![widget.activeTabIndex].stickers;
        crossAxisCount = TencentCloudChatStickerPlugin.initData.customStickerLists![widget.activeTabIndex].rowNum;
        stickerType = TencentCloudChatStickerPlugin.initData.customStickerLists![widget.activeTabIndex].type;
        stickerIndex = TencentCloudChatStickerPlugin.initData.customStickerLists![widget.activeTabIndex].index;
      }
    }
    return Expanded(
      child: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            height: 220 - MediaQuery.of(context).padding.bottom,
            padding: const EdgeInsets.all(10),
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 1.0,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              children: currentStickerList
                  .map(
                    (e) => GestureDetector(
                      onTap: () {
                        sendStickerMessage(
                          stickerType,
                          e.name,
                          stickerIndex,
                        );
                      },
                      child: Image(
                        image: AssetImage(e.path, package: "tencent_cloud_chat_sticker"),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
