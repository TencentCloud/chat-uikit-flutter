import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat_common.dart';
import 'package:tencent_cloud_chat_message_reaction/tencent_cloud_chat_message_reaction.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_reaction.dart';

class TencentCloudChatMessageReactionDetail extends StatefulWidget {
  final String msgID;
  final int primaryColor;
  final int borderColor;
  final int textColor;

  const TencentCloudChatMessageReactionDetail(
      {super.key, required this.msgID, required this.primaryColor, required this.borderColor, required this.textColor});

  @override
  State<TencentCloudChatMessageReactionDetail> createState() => _TencentCloudChatMessageReactionDetailState();
}

class _TencentCloudChatMessageReactionDetailState extends State<TencentCloudChatMessageReactionDetail>
    with SingleTickerProviderStateMixin {
  List<V2TimMessageReaction> _messageReactions = [];
  late final TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _messageReactions = TencentCloudChatMessageReaction.instance.reactionData.messageReactionMap[widget.msgID] ?? [];
    _tabController = TabController(
      length: _messageReactions.length,
      vsync: this,
      initialIndex: _currentIndex,
    );
    _loadUserList(_currentIndex);
    _tabController.addListener(_tabBarListener);
  }

  void _tabBarListener() async {
    _loadUserList(_tabController.index);
  }

  void _loadUserList(int index) async {
    final String reactionID = _messageReactions[index].reactionID;
    await TencentCloudChatMessageReaction.instance.reactionData.loadAllUserListOfMessageReaction(
      msgID: widget.msgID,
      reactionID: reactionID,
    );
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    _messageReactions = TencentCloudChatMessageReaction.instance.reactionData.messageReactionMap[widget.msgID] ?? [];
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(widget.borderColor),
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: TabBar(
              controller: _tabController,
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              dividerColor: Color(widget.borderColor),
              indicatorColor: Color(widget.primaryColor),
              labelColor: Color(widget.textColor),
              unselectedLabelColor: Color(widget.textColor).withOpacity(0.7),
              labelStyle: const TextStyle(fontSize: 14),
              indicatorWeight: 2,
              tabs: _messageReactions.map((reaction) {
                int index = _messageReactions.indexOf(reaction);
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? Color(widget.primaryColor).withOpacity(0.1)
                        : Color(widget.borderColor).withOpacity(0.28),
                    border: Border.all(
                        color: _currentIndex == index
                            ? Color(widget.primaryColor).withOpacity(0.3)
                            : Color(widget.borderColor).withOpacity(0.68)),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  margin: const EdgeInsets.only(bottom: 10, top: 6),
                  child: Row(
                    children: [
                      Image.asset(
                        TencentCloudChatMessageReaction
                                .instance.reactionData.messageReactionLabelToAsset[reaction.reactionID] ??
                            "",
                        package: "tencent_cloud_chat_sticker",
                        height: 20,
                        width: 20,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        reaction.totalUserCount.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(widget.textColor).withOpacity(0.7),
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _messageReactions.map((reaction) {
                return ListView(
                  children: reaction.partialUserList.map((user) {
                    return Container(
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: TencentCloudChatAvatar(
                              width: 36,
                              height: 36,
                              imageList: [user.faceUrl],
                              scene: TencentCloudChatAvatarScene.custom,
                            ),
                          ),
                          Text(user.nickName ?? user.userID),
                        ],
                      ),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
