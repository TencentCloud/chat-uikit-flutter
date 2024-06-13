// ignore_for_file: non_constant_identifier_names, iterable_contains_unrelated_type

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_full_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_extension.dart';
import 'package:tencent_cloud_chat_vote_plugin/common/color_manager.dart';
import 'package:tencent_cloud_chat_vote_plugin/common/fontsize_manager.dart';
import 'package:tencent_cloud_chat_vote_plugin/model/vote_message_model.dart';
import 'package:tencent_cloud_chat_vote_plugin/tencent_cloud_chat_vote_plugin.dart';

class TencentCloudChatVoteMessageOptions extends StatefulWidget {
  const TencentCloudChatVoteMessageOptions({Key? key, required this.msgID}) : super(key: key);
  final String msgID;
  @override
  State<StatefulWidget> createState() => TencentCloudChatVoteMessageOptionsState();
}

class TencentCloudChatVoteMessageOptionsState extends State<TencentCloudChatVoteMessageOptions> {
  @override
  void initState() {
    super.initState();
  }

  setUnFold() {
    TencentCloudChatVoteLogic? originData = Provider.of<TencentCloudChatVoteMessageModel>(
      context,
      listen: false,
    ).getTencentCloudChatVoteLogic(widget.msgID);
    if (originData == null) {
      return;
    }
    originData.setIsFold(false);
    Provider.of<TencentCloudChatVoteMessageModel>(
      context,
      listen: false,
    ).updateTencentCloudChatVoteLogic(originData);
  }

  @override
  Widget build(BuildContext context) {
    TencentCloudChatVoteLogic? data = Provider.of<TencentCloudChatVoteMessageModel>(
      context,
      listen: true,
    ).getTencentCloudChatVoteLogic(widget.msgID);

    bool isFold = true;
    List<TencentCloudChatVoteDataOptoin> optionList = [];
    int optionListLength = optionList.length;
    bool isVoting = false;

    if (data != null) {
      isFold = data.isFold;
      optionList = data.voteData.content.option_list;
      optionListLength = optionList.length;
      isVoting = data.isVoting;
    }
    return Container(
      color: VoteColorsManager.voteMessageOptionsBgColor,
      child: Column(
        children: [
          ...optionList
              .take(
                isFold ? 3 : optionListLength,
              )
              .map(
                (e) => TencentCloudChatVoteMessageOptionsItem(
                  optoin: e,
                  isVoting: isVoting,
                  msgID: widget.msgID,
                ),
              )
              .toList(),
          isFold
              ? Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              VoteColorsManager.voteMessageOptionsItemMoreBgColor,
                            ),
                          ),
                          onPressed: setUnFold,
                          child: Text(
                            ("查看全部选项"),
                            style: TextStyle(
                              color: VoteColorsManager.voteMessageOptionsItemMoreTextColor,
                              fontSize: VoteFontSizeManager.voteMessageOptionItemMoreFontSize,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

class TencentCloudChatVoteMessageOptionsItem extends StatefulWidget {
  final TencentCloudChatVoteDataOptoin optoin;
  final bool isVoting;
  final String msgID;
  const TencentCloudChatVoteMessageOptionsItem({
    Key? key,
    required this.optoin,
    required this.isVoting,
    required this.msgID,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatVoteMessageOptionsItemState();
}

class TencentCloudChatVoteMessageOptionsItemState extends State<TencentCloudChatVoteMessageOptionsItem> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isVoting
        ? TencentCloudChatVoteMessageOptionsItemActive(
            optoin: widget.optoin,
            msgID: widget.msgID,
          )
        : TencentCloudChatVoteMessageOptionsItemResult(
            optoin: widget.optoin,
            msgID: widget.msgID,
          );
  }
}

class TencentCloudChatVoteMessageOptionsItemActive extends StatefulWidget {
  final TencentCloudChatVoteDataOptoin optoin;
  final String msgID;
  const TencentCloudChatVoteMessageOptionsItemActive({
    Key? key,
    required this.optoin,
    required this.msgID,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatVoteMessageOptionsItemActiveState();
}

class TencentCloudChatVoteMessageOptionsItemActiveState extends State<TencentCloudChatVoteMessageOptionsItemActive> {
  setOptionsBox(value) {
    TencentCloudChatVoteLogic? data = Provider.of<TencentCloudChatVoteMessageModel>(
      context,
      listen: false,
    ).getTencentCloudChatVoteLogic(widget.msgID);
    if (data == null) {
      return;
    }
    if (data.voteData.config.allow_multi_vote) {
      if (value) {
        data.setOptionsBox(widget.optoin.index);
      } else {
        data.removeOptionsBox(widget.optoin.index);
      }
    } else {
      data.setOptionsBox(value);
    }

    Provider.of<TencentCloudChatVoteMessageModel>(
      context,
      listen: false,
    ).updateTencentCloudChatVoteLogic(data);
  }

  @override
  Widget build(BuildContext context) {
    TencentCloudChatVoteLogic? data = Provider.of<TencentCloudChatVoteMessageModel>(
      context,
      listen: true,
    ).getTencentCloudChatVoteLogic(widget.msgID);
    bool isCheck = false;
    bool allow_muti = false;
    if (data != null) {
      isCheck = data.optionsBox.keys.contains(widget.optoin.index);
      allow_muti = data.voteData.config.allow_multi_vote;
    }
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: VoteColorsManager.voteMessageOptionsItemBgColor,
        border: Border(
          bottom: BorderSide(
            color: VoteColorsManager.voteMessageOptionsItemBorderColor,
          ),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(widget.optoin.index.toString()),
          ),
          Expanded(
            child: Text(
              widget.optoin.option,
              style: TextStyle(
                fontSize: VoteFontSizeManager.voteMessageOptionItemFontSize,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 40,
            child: allow_muti
                ? Checkbox(
                    activeColor: VoteColorsManager.voteOptionsItemCheckBoxBgColor,
                    value: isCheck,
                    onChanged: setOptionsBox,
                  )
                : Radio(
                    value: widget.optoin.index,
                    onChanged: setOptionsBox,
                    activeColor: VoteColorsManager.voteOptionsItemCheckBoxBgColor,
                    groupValue: isCheck ? widget.optoin.index : '',
                  ),
          )
        ],
      ),
    );
  }
}

class TencentCloudChatVoteMessageOptionsItemResult extends StatefulWidget {
  final TencentCloudChatVoteDataOptoin optoin;
  final String msgID;
  const TencentCloudChatVoteMessageOptionsItemResult({
    Key? key,
    required this.optoin,
    required this.msgID,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatVoteMessageOptionsItemResultState();
}

class TencentCloudChatVoteMessageOptionsItemResultState extends State<TencentCloudChatVoteMessageOptionsItemResult> {
  @override
  Widget build(BuildContext context) {
    TencentCloudChatVoteLogic? data = Provider.of<TencentCloudChatVoteMessageModel>(
      context,
      listen: true,
    ).getTencentCloudChatVoteLogic(widget.msgID);
    OnOptionsItemTap? onTapFn = Provider.of<TencentCloudChatVoteMessageModel>(
      context,
      listen: true,
    ).getMessageOnTap(widget.msgID);
    double progress = 0;
    int tatalvotes = 0;
    int currentv = 0;
    List<V2TimMessageExtension> messageExts = List<V2TimMessageExtension>.from([]);
    List<V2TimMessageExtension> voteList = List<V2TimMessageExtension>.from([]);
    bool hasVoteItem = false;
    List<String> voteUsers = List<String>.from([]);
    bool isPublic = false;
    String users = "";
    bool showVoteUser = false;
    bool isAnonymous = false;
    if (data != null) {
      messageExts = data.messageExts.takeWhile((e) => e.extensionKey != 'closed').toList();
      tatalvotes = messageExts.length;

      for (var element in messageExts) {
        bool isEq = element.extensionValue.split("_").contains(
              widget.optoin.index.toString(),
            );

        if (isEq) {
          currentv++;
          voteList.add(element);
          hasVoteItem = true;
          voteUsers.add(element.extensionKey.split("_").first);
        }
      }
      progress = tatalvotes == 0
          ? 0
          : double.parse(
              (currentv / tatalvotes).toStringAsFixed(1),
            );
      isAnonymous = data.voteData.config.anonymous;
      isPublic = data.voteData.config.public;
      users = voteUsers.map(
        (e) {
          String nick = "";
          V2TimGroupMemberFullInfo? ginfo = data.groupInfos[e];
          if (ginfo == null) {
            return nick;
          }
          if (data.groupInfos[e]?.nameCard != null && ginfo.nameCard!.isNotEmpty) {
            nick = ginfo.nameCard!;
          } else if (ginfo.friendRemark != null && ginfo.friendRemark!.isNotEmpty) {
            nick = ginfo.friendRemark!;
          } else if (ginfo.nickName != null && ginfo.nickName!.isNotEmpty) {
            nick = ginfo.nickName!;
          }
          return nick;
        },
      ).join(";");
      showVoteUser = hasVoteItem && !isAnonymous;
    }
    final option1 = currentv;

    // print("当前index ${widget.optoin.index} 投票的人有 $voteUsers");
    return Container(
      height: showVoteUser ? 60 : 50,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: VoteColorsManager.voteMessageOptionsItemBgColor,
      ),
      child: GestureDetector(
        onTap: () {
          if (!isAnonymous && isPublic && hasVoteItem) {
            if (onTapFn == null) {
              return;
            }
            if (data == null) {
              return;
            }
            onTapFn(widget.optoin, data);
          }
        },
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                      child: Text(widget.optoin.index.toString()),
                    ),
                    Expanded(
                      child: Text(
                        widget.optoin.option,
                        style: TextStyle(
                          fontSize: VoteFontSizeManager.voteMessageOptionItemFontSize,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: 70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "$option1 票",
                            style: const TextStyle(
                              fontSize: 8,
                              color: VoteColorsManager.voteMessageOptionProgressValueTextColor,
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Text(
                            "${progress * 100}%",
                            style: const TextStyle(
                              fontSize: 8,
                              color: VoteColorsManager.voteMessageOptionProgressValueTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                LinearProgressIndicator(
                  minHeight: 3,
                  value: progress,
                  backgroundColor: VoteColorsManager.voteMessageOptionProgressBgColor,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    VoteColorsManager.voteMessageOptionProgressValueBgColor,
                  ),
                ),
                showVoteUser
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                users,
                                style: const TextStyle(
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          )
                        ],
                      )
                    : Container(),
                // 如果不是匿名，把用户的名字展示出来
              ],
            ),
          ],
        ),
      ),
    );
  }
}
