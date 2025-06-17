import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_builder_definitions.dart';
import 'package:tencent_cloud_chat_common/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/builders/tencent_cloud_chat_common_builders.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat_common.dart';

class TencentCloudChatMessageForward extends StatefulWidget {
  final MessageForwardBuilderWidgets? widgets;
  final MessageForwardBuilderData data;
  final MessageForwardBuilderMethods methods;

  const TencentCloudChatMessageForward({
    super.key,
    required this.data,
    required this.methods,
    this.widgets,
  });

  @override
  State<TencentCloudChatMessageForward> createState() => _TencentCloudChatMessageForwardState();
}

class _TencentCloudChatMessageForwardState extends TencentCloudChatState<TencentCloudChatMessageForward> {
  final List<({String? userID, String? groupID})> _selectedConversations = [];

  bool _matchChats(({String? userID, String? groupID}) chat1, ({String? userID, String? groupID}) chat2) {
    final conversationUserID = TencentCloudChatUtils.checkString(chat1.userID);
    final conversationGroupID = TencentCloudChatUtils.checkString(chat1.groupID);

    final recordUserID = TencentCloudChatUtils.checkString(chat2.userID);
    final recordGroupID = TencentCloudChatUtils.checkString(chat2.groupID);

    return (conversationUserID != null && conversationUserID == recordUserID) ||
        (conversationGroupID != null && conversationGroupID == recordGroupID);
  }

  Widget _renderHeader() => TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Padding(
          padding: EdgeInsets.only(top: getHeight(8), left: getWidth(4), right: getWidth(4)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: widget.methods.onCancel,
                child: Text(
                  tL10n.cancel,
                  style: TextStyle(fontSize: textStyle.fontsize_14, color: colorTheme.primaryColor),
                ),
              ),
              Text(
                widget.data.type == TencentCloudChatForwardType.individually
                    ? tL10n.forwardIndividually
                    : tL10n.forwardCombined,
                style: TextStyle(fontSize: textStyle.fontsize_16),
              ),
              TextButton(
                onPressed: () {
                  widget.methods.onSelectConversations(_selectedConversations);
                },
                child: Text(
                  tL10n.send,
                  style: TextStyle(fontSize: textStyle.fontsize_14, color: colorTheme.primaryColor),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _chatItem({required ({String? userID, String? groupID}) conversation, String? showName, String? faceUrl}) {
    final isSelected = _selectedConversations.any((element) => _matchChats(conversation, element));
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => AnimatedContainer(
        padding: EdgeInsets.symmetric(horizontal: getWidth(8), vertical: getHeight(8)),
        color: isSelected ? colorTheme.messageBeenChosenBackgroundColor : Colors.transparent,
        duration: const Duration(milliseconds: 300),
        child: InkWell(
            onTap: () {
              if (!isSelected) {
                _selectedConversations.add(conversation);
              } else {
                _selectedConversations.removeWhere((element) => _matchChats(conversation, element));
              }
              setState(() {});
            },
            child: Row(
              children: [
                Checkbox(
                  value: isSelected,
                  visualDensity: const VisualDensity(vertical: -4, horizontal: -2),
                  activeColor: colorTheme.primaryColor,
                  checkColor: colorTheme.backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  onChanged: (bool? value) {
                    if ((value ?? false)) {
                      _selectedConversations.add(conversation);
                    } else {
                      _selectedConversations.removeWhere((element) => _matchChats(conversation, element));
                    }
                    setState(() {});
                  },
                ),
                SizedBox(
                  width: getWidth(8),
                ),
                TencentCloudChatCommonBuilders.getCommonAvatarBuilder(
                    scene: TencentCloudChatAvatarScene.chatsSelector,
                    width: getHeight(40),
                    height: getHeight(40),
                    borderRadius: getHeight(20),
                    imageList: [faceUrl]),
                SizedBox(
                  width: getWidth(8),
                ),
                Text(TencentCloudChatUtils.checkString(showName) ??
                    TencentCloudChatUtils.checkString(conversation.groupID) ??
                    TencentCloudChatUtils.checkString(conversation.userID) ??
                    tL10n.chat),
              ],
            )),
      ),
    );
  }

  Widget _renderConversationList() {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => ListView.builder(
        itemCount: widget.data.conversationList.length,
        itemBuilder: (context, index) {
          final conversation = widget.data.conversationList[index];
          return _chatItem(conversation: (
            userID: TencentCloudChatUtils.checkString(conversation.userID),
            groupID: TencentCloudChatUtils.checkString(conversation.groupID)
          ), showName: conversation.showName, faceUrl: conversation.faceUrl);
        },
      ),
    );
  }

  Widget _renderContactList() {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => ListView.builder(
        itemCount: widget.data.contactList.length,
        itemBuilder: (context, index) {
          final contact = widget.data.contactList[index];
          return _chatItem(
            conversation: (userID: TencentCloudChatUtils.checkString(contact.userID), groupID: null),
            showName: TencentCloudChatUtils.checkString(contact.friendRemark) ??
                TencentCloudChatUtils.checkString(contact.userProfile?.nickName) ??
                TencentCloudChatUtils.checkString(contact.userID),
            faceUrl: contact.userProfile?.faceUrl,
          );
        },
      ),
    );
  }

  Widget _renderGroupList() {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => ListView.builder(
        itemCount: widget.data.groupList.length,
        itemBuilder: (context, index) {
          final group = widget.data.groupList[index];
          return _chatItem(
            conversation: (userID: null, groupID: TencentCloudChatUtils.checkString(group.groupID)),
            showName: group.groupName,
            faceUrl: group.faceUrl,
          );
        },
      ),
    );
  }

  Widget _renderTabBar() {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Container(
        decoration: BoxDecoration(
          color: colorTheme.backgroundColor,
          border: Border(
            bottom: BorderSide(
              color: colorTheme.dividerColor,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TabBar(
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              labelColor: colorTheme.primaryTextColor,
              unselectedLabelColor: colorTheme.secondaryTextColor,
              labelStyle: TextStyle(fontSize: textStyle.fontsize_14),
              indicatorColor: colorTheme.primaryColor,
              indicatorWeight: 2,
              tabs: [
                Tab(text: tL10n.recent),
                Tab(text: tL10n.contacts),
                Tab(text: tL10n.groups),
              ],
            ),
            Container(
              margin: EdgeInsets.only(right: getWidth(16)),
              child: Text(
                tL10n.numChats(_selectedConversations.length),
                style: TextStyle(fontSize: textStyle.fontsize_12, color: colorTheme.secondaryTextColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Container(
        color: Colors.transparent,
        child: DefaultTabController(
          length: 3,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _renderHeader(),
              _renderTabBar(),
              Expanded(
                  child: TabBarView(children: [
                _renderConversationList(),
                _renderContactList(),
                _renderGroupList(),
              ])),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    double contentHeight = MediaQuery.of(context).size.height * 0.8;
    double headerHeight = getHeight(100);
    double listItemHeight = getHeight(46);
    double listHeight =
        max(widget.data.groupList.length, max(widget.data.contactList.length, widget.data.conversationList.length)) * listItemHeight;
    double maxHeight = headerHeight + listHeight;
    double heightFactor = maxHeight < contentHeight ? maxHeight / MediaQuery.of(context).size.height : 0.8;

    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: FractionallySizedBox(
          heightFactor: heightFactor,
          child: Container(
            color: colorTheme.backgroundColor,
            child: DefaultTabController(
              length: 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _renderHeader(),
                  _renderTabBar(),
                  Expanded(
                      child: TabBarView(children: [
                    _renderConversationList(),
                    _renderContactList(),
                    _renderGroupList(),
                  ])),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
