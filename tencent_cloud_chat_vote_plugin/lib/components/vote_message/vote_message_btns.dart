import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_extension.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_extension_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_msg_create_info_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:tencent_cloud_chat_vote_plugin/common/color_manager.dart';
import 'package:tencent_cloud_chat_vote_plugin/model/vote_message_model.dart';
import 'package:tencent_cloud_chat_vote_plugin/tencent_cloud_chat_vote_plugin.dart';

class TencentCloudChatVoteMessageBtns extends StatefulWidget {
  const TencentCloudChatVoteMessageBtns({
    Key? key,
    required this.msgID,
  }) : super(key: key);
  final String msgID;

  @override
  State<StatefulWidget> createState() => TencentCloudChatVoteMessageBtnsState();
}

class TencentCloudChatVoteMessageBtnsState extends State<TencentCloudChatVoteMessageBtns> {
  List<Widget> getEndStatusWidget(bool isFold, bool isClosed, bool isVoted) {
    if (isFold) {
      return [];
    }
    return isClosed
        ? [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            VoteColorsManager.voteMessageBtnVoteDisableBgColor,
                          ),
                        ),
                        onPressed: null,
                        child: Text(
                          isVoted ? "已投票" : "立即投票",
                          style: const TextStyle(
                            color: VoteColorsManager.voteMessageBtnOneVoteNowTextColor,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: null,
                        child: Text("投票已结束"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]
        : [];
  }

  vote() async {
    TencentCloudChatVoteLogic? data = Provider.of<TencentCloudChatVoteMessageModel>(
      context,
      listen: false,
    ).getTencentCloudChatVoteLogic(widget.msgID);
    if (data != null) {
      if (data.optionsBox.isEmpty) {
        debugPrint("no select ,please check");
        return;
      }
      String userID = "${TencentCloudChatVotePlugin.currentUser}_0";
      List<V2TimMessageExtension> extensions = List<V2TimMessageExtension>.from([]);

      String extensionValue = data.optionsBox.keys.join("_");

      extensions.add(
        V2TimMessageExtension(
          extensionKey: userID,
          extensionValue: extensionValue,
        ),
      );
      V2TimValueCallback<List<V2TimMessageExtensionResult>> setExtRes = await TencentImSDKPlugin.v2TIMManager.getMessageManager().setMessageExtensions(
            msgID: _isValidateOriginMessagID(data) ?? widget.msgID,
            extensions: extensions,
          );
      debugPrint(json.encode(setExtRes.toJson()));
      if (setExtRes.code == 0) {
        if (setExtRes.data != null) {
          List<V2TimMessageExtension> newExt = List<V2TimMessageExtension>.from([]);
          newExt.addAll(data.messageExts);
          newExt.add(setExtRes.data!.first.extension!);
          await data.setMessageExt(newExt);
          data.setIsVoting(false);

          Provider.of<TencentCloudChatVoteMessageModel>(
            context,
            listen: false,
          ).updateTencentCloudChatVoteLogic(data);
        }
      }
    }
  }

  String? _isValidateOriginMessagID(TencentCloudChatVoteLogic data) {
    if (data.voteData.content.original_msg_id != null && data.voteData.content.original_msg_id!.isNotEmpty) {
      return data.voteData.content.original_msg_id;
    }
    return null;
  }

  reSend() async {
    TencentCloudChatVoteLogic? data = Provider.of<TencentCloudChatVoteMessageModel>(
      context,
      listen: false,
    ).getTencentCloudChatVoteLogic(widget.msgID);
    if (data == null) {
      return;
    }
    int seq = int.parse(data.msg.seq!);

    if (data.voteData.content.original_msg_id == null || data.voteData.content.original_msg_id!.isEmpty) {
      data.voteData.content.original_msg_id = widget.msgID;
    }
    if (data.voteData.content.original_msg_seq == null || data.voteData.content.original_msg_seq == 0) {
      data.voteData.content.original_msg_seq = seq;
    }
    if (data.isFormSelf) {
      V2TimValueCallback<V2TimMsgCreateInfoResult> createdMessageRes = await TencentImSDKPlugin.v2TIMManager.getMessageManager().createCustomMessage(
            data: json.encode(
              data.voteData.toJson(),
            ),
          );
      if (createdMessageRes.data != null) {
        String? id = createdMessageRes.data!.id;
        if (id != null && data.msg.groupID != null) {
          await TencentImSDKPlugin.v2TIMManager.getMessageManager().sendMessage(
                id: id,
                receiver: "",
                groupID: data.msg.groupID!,
                isSupportMessageExtension: true,
              );
        }
      }
    }
  }

  endVote() async {
    TencentCloudChatVoteLogic? data = Provider.of<TencentCloudChatVoteMessageModel>(
      context,
      listen: false,
    ).getTencentCloudChatVoteLogic(widget.msgID);
    if (data != null) {
      List<V2TimMessageExtension> extensions = List<V2TimMessageExtension>.from([]);

      extensions.add(
        V2TimMessageExtension(
          extensionKey: "closed",
          extensionValue: "1",
        ),
      );
      V2TimValueCallback<List<V2TimMessageExtensionResult>> setExtRes = await TencentImSDKPlugin.v2TIMManager.getMessageManager().setMessageExtensions(
            msgID: _isValidateOriginMessagID(data) ?? widget.msgID,
            extensions: extensions,
          );
      if (setExtRes.code == 0) {
        if (setExtRes.data != null) {
          List<V2TimMessageExtension> newExt = List<V2TimMessageExtension>.from([]);
          newExt.addAll(data.messageExts);
          newExt.add(setExtRes.data!.first.extension!);
          await data.setMessageExt(newExt);

          Provider.of<TencentCloudChatVoteMessageModel>(
            context,
            listen: false,
          ).updateTencentCloudChatVoteLogic(data);
        }
      }
    }
  }

  List<Widget> getSelfVoteStatusWidget(
    bool isFold,
    bool isFromSelf,
    bool isVoting,
    bool isVoted,
    bool isClosed,
  ) {
    List<Widget> wid = [];
    if (isFold) {
      return wid;
    }
    if (isFromSelf) {
      wid.addAll([
        isVoting
            ? Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                VoteColorsManager.voteMessageBtnVoteSureBgColor,
                              ),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(
                                    color: VoteColorsManager.voteMessageBtnOneMoreVoteBorderColor,
                                  ),
                                ),
                              ),
                            ),
                            onPressed: vote,
                            child: Text(
                              ("确定"),
                              style: const TextStyle(
                                color: VoteColorsManager.voteMessageBtnOneMoreVoteTextColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              VoteColorsManager.voteMessageBtnVoteCancelBgColor,
                            ),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(
                                  color: VoteColorsManager.voteMessageBtnOneMoreVoteBorderColor,
                                ),
                              ),
                            ),
                          ),
                          onPressed: voteCancel,
                          child: Text(
                            ("取消"),
                            style: const TextStyle(
                              color: VoteColorsManager.voteMessageBtnOneMoreVoteTextColor,
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              )
            : isClosed
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                  isVoted ? VoteColorsManager.voteMessageBtnVoteDisableBgColor : VoteColorsManager.voteMessageBtnVoteBgColor,
                                ),
                              ),
                              onPressed: isVoted ? null : voteNow,
                              child: isVoted
                                  ? Text(
                                      ("已投票"),
                                      style: const TextStyle(
                                        color: VoteColorsManager.voteMessageBtnOneVoteNowTextColor,
                                      ),
                                    )
                                  : Text(
                                      ("立即投票"),
                                      style: const TextStyle(
                                        color: VoteColorsManager.voteMessageBtnOneVoteNowTextColor,
                                      ),
                                    ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
        !isClosed
            ? Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                VoteColorsManager.voteMessageBtnOneMoreVoteBgColor,
                              ),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(
                                    color: VoteColorsManager.voteMessageBtnOneMoreVoteBorderColor,
                                  ),
                                ),
                              ),
                            ),
                            onPressed: reSend,
                            child: const Text(
                              ("再次发送"),
                              style: TextStyle(
                                color: VoteColorsManager.voteMessageBtnOneMoreVoteTextColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 12,
                          ),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                VoteColorsManager.voteMessageBtnVoteEndBgColor,
                              ),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(
                                    color: VoteColorsManager.voteMessageBtnOneMoreVoteBorderColor,
                                  ),
                                ),
                              ),
                            ),
                            onPressed: endVote,
                            child: const Text(
                              ("结束投票"),
                              style: TextStyle(
                                color: VoteColorsManager.voteMessageBtnOneMoreVoteTextColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container(),
      ]);
    } else {
      wid.addAll([
        isVoting
            ? Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 114,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              VoteColorsManager.voteMessageBtnVoteSureBgColor,
                            ),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(
                                  color: VoteColorsManager.voteMessageBtnOneMoreVoteBorderColor,
                                ),
                              ),
                            ),
                          ),
                          onPressed: vote,
                          child: const Text(
                            ("确定"),
                            style: TextStyle(
                              color: VoteColorsManager.voteMessageBtnOneMoreVoteTextColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 114,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              VoteColorsManager.voteMessageBtnVoteCancelBgColor,
                            ),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(
                                  color: VoteColorsManager.voteMessageBtnOneMoreVoteBorderColor,
                                ),
                              ),
                            ),
                          ),
                          onPressed: voteCancel,
                          child: const Text(
                            ("取消"),
                            style: TextStyle(
                              color: VoteColorsManager.voteMessageBtnOneMoreVoteTextColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : isClosed
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                  isVoted ? VoteColorsManager.voteMessageBtnVoteDisableBgColor : VoteColorsManager.voteMessageBtnVoteBgColor,
                                ),
                              ),
                              onPressed: isVoted ? null : voteNow,
                              child: isVoted
                                  ? const Text(
                                      ("已投票"),
                                      style: TextStyle(
                                        color: VoteColorsManager.voteMessageBtnOneVoteNowTextColor,
                                      ),
                                    )
                                  : const Text(
                                      ("立即投票"),
                                      style: TextStyle(
                                        color: VoteColorsManager.voteMessageBtnOneVoteNowTextColor,
                                      ),
                                    ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
      ]);
    }
    return wid;
  }

  voteNow() {
    TencentCloudChatVoteLogic? originData = Provider.of<TencentCloudChatVoteMessageModel>(
      context,
      listen: false,
    ).getTencentCloudChatVoteLogic(widget.msgID);
    if (originData == null) {
      return;
    }
    originData.setIsVoting(true);
    Provider.of<TencentCloudChatVoteMessageModel>(
      context,
      listen: false,
    ).updateTencentCloudChatVoteLogic(originData);
  }

  voteCancel() {
    TencentCloudChatVoteLogic? originData = Provider.of<TencentCloudChatVoteMessageModel>(
      context,
      listen: false,
    ).getTencentCloudChatVoteLogic(widget.msgID);
    if (originData == null) {
      return;
    }
    originData.setIsVoting(false);
    Provider.of<TencentCloudChatVoteMessageModel>(
      context,
      listen: false,
    ).updateTencentCloudChatVoteLogic(originData);
  }

  voteSure() {}

  @override
  Widget build(BuildContext context) {
    TencentCloudChatVoteLogic? data = Provider.of<TencentCloudChatVoteMessageModel>(
      context,
      listen: true,
    ).getTencentCloudChatVoteLogic(widget.msgID);
    if (data == null) {
      return const Column(
        children: [],
      );
    }

    bool isFromSelf = data.isFormSelf;
    bool isClosed = data.isClose;
    bool isVoting = data.isVoting;
    bool isFold = data.isFold;
    bool isVoted = data.isVoted;
    return Column(
      children: [
        ...getEndStatusWidget(isFold, isClosed, isVoted), // 所有人的结束状态一样
        ...getSelfVoteStatusWidget(
          isFold,
          isFromSelf,
          isVoting,
          isVoted,
          isClosed,
        )
      ],
    );
  }
}
