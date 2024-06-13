// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimAdvancedMsgListener.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_info_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_extension.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:tencent_cloud_chat_vote_plugin/components/vote_message/vote_message_btns.dart';
import 'package:tencent_cloud_chat_vote_plugin/components/vote_message/vote_message_header.dart';
import 'package:tencent_cloud_chat_vote_plugin/components/vote_message/vote_message_member_info.dart';
import 'package:tencent_cloud_chat_vote_plugin/components/vote_message/vote_message_option.dart';
import 'package:tencent_cloud_chat_vote_plugin/model/vote_message_model.dart';
import 'package:tencent_cloud_chat_vote_plugin/tencent_cloud_chat_vote_plugin.dart';

typedef OnOptionsItemTap = Function(
  TencentCloudChatVoteDataOptoin option,
  TencentCloudChatVoteLogic data,
);

///
class TencentCloudChatVoteMessage extends StatefulWidget {
  final V2TimMessage message;
  final OnOptionsItemTap? onTap;
  const TencentCloudChatVoteMessage({
    Key? key,
    required this.message,
    this.onTap,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatVoteMessageState();
}

class TencentCloudChatVoteMessageState extends State<TencentCloudChatVoteMessage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool hasInited = TencentCloudChatVotePlugin.hasInited;
    return hasInited
        ? ChangeNotifierProvider(
            create: (context) => TencentCloudChatVoteMessageModel(
              message: widget.message,
              onTap: widget.onTap,
            ),
            child: TencentCloudChatVoteMessageWithProvider(
              message: widget.message,
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TencentCloudChatVoteMessageTitle(
                      msgID: widget.message.msgID!,
                    ),
                    TencentCloudChatVoteMessageOptions(
                      msgID: widget.message.msgID!,
                    ),
                    TencentCloudChatVoteMessageMemberInfo(
                      msgID: widget.message.msgID!,
                    ),
                    TencentCloudChatVoteMessageBtns(
                      msgID: widget.message.msgID!,
                    ),
                  ],
                ),
              ),
            ),
          )
        : const Center(
            child: Text(("未初始化投票插件，请先初始化")),
          );
  }
}

class TencentCloudChatVoteMessageWithProvider extends StatefulWidget {
  final Widget child;
  final V2TimMessage message;
  const TencentCloudChatVoteMessageWithProvider({
    Key? key,
    required this.child,
    required this.message,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatVoteMessageWithProviderState();
}

class TencentCloudChatVoteMessageWithProviderState extends State<TencentCloudChatVoteMessageWithProvider> {
  late final V2TimAdvancedMsgListener messageListener = V2TimAdvancedMsgListener(
    onRecvMessageExtensionsChanged: (msgID, extensions) async {
      print("advance message listener exec");

      TencentCloudChatVoteLogic? originData = Provider.of<TencentCloudChatVoteMessageModel>(
        context,
        listen: false,
      ).getTencentCloudChatVoteLogic(widget.message.msgID ?? "");
      if (originData == null) {
        return;
      }

      if (msgID != widget.message.msgID && msgID != originData.voteData.content.original_msg_id) {
        return;
      }
      // if(originData.voteData.content.original_msg_id == msgID){
      //   // 原消息
      // }
      List<V2TimMessageExtension> allExt = [...originData.messageExts, ...extensions];
      List<V2TimMessageExtension> resExt = [];

      for (var i = 0; i < allExt.length; i++) {
        V2TimMessageExtension item = allExt[i];
        int index = resExt.indexWhere((element) => element.extensionKey == item.extensionKey);
        if (index > -1) {
          resExt[index] = item;
        } else {
          resExt.add(item);
        }
      }

      await originData.setMessageExt(resExt);
      Provider.of<TencentCloudChatVoteMessageModel>(
        context,
        listen: false,
      ).updateTencentCloudChatVoteLogic(originData);
    },
  );
  @override
  void initState() {
    super.initState();
    getMessageExtDatas();
    getGroupsInfo();
    addMessageEventListener();
  }

  @override
  void dispose() {
    print("remove messalistenr");
    TencentImSDKPlugin.v2TIMManager.getMessageManager().removeAdvancedMsgListener(
          listener: messageListener,
        );
    super.dispose();
  }

  void addMessageEventListener() {
    print("add messalistenr");
    TencentImSDKPlugin.v2TIMManager.getMessageManager().addAdvancedMsgListener(
          listener: messageListener,
        );
  }

  void getMessageExtDatas() async {
    if (widget.message.msgID == null) {
      return;
    }
    String msgID = widget.message.msgID!;
    TencentCloudChatVoteLogic? originData = Provider.of<TencentCloudChatVoteMessageModel>(
      context,
      listen: false,
    ).getTencentCloudChatVoteLogic(msgID);
    if (originData == null) {
      return;
    }
    String originmsgId = originData.voteData.content.original_msg_id ?? "";
    int originMsgSeq = originData.voteData.content.original_msg_seq ?? 0;

    V2TimValueCallback<List<V2TimMessageExtension>> extRes = await TencentImSDKPlugin.v2TIMManager.getMessageManager().getMessageExtensions(
          msgID: msgID,
        );
    List<V2TimMessageExtension> originExtList = List<V2TimMessageExtension>.from([]);
    if (extRes.code == 0) {
      if (extRes.data != null) {
        if (originmsgId.isNotEmpty && originMsgSeq != 0) {
          // 这是个重复发的消息，需要把原始消息的扩展设置过来
          V2TimValueCallback<List<V2TimMessageExtension>> originExtRes = await TencentImSDKPlugin.v2TIMManager.getMessageManager().getMessageExtensions(
                msgID: originmsgId,
              );
          if (originExtRes.code == 0) {
            if (originExtRes.data != null) {
              if (originExtRes.data!.isNotEmpty) {
                originExtList = originExtRes.data!;
                await TencentImSDKPlugin.v2TIMManager.getMessageManager().setMessageExtensions(
                      msgID: msgID,
                      extensions: originExtRes.data!,
                    );
              }
            }
          }
        }

        // if (extRes.data!.isNotEmpty) {
        List<V2TimMessageExtension> extList = extRes.data!;

        await originData.setMessageExt(
          originExtList.isNotEmpty ? originExtList : extList,
        );
        Provider.of<TencentCloudChatVoteMessageModel>(context, listen: false).updateTencentCloudChatVoteLogic(originData);
        // }
      }
    }
  }

  void getGroupsInfo() async {
    if (widget.message.msgID == null) {
      return;
    }
    String msgID = widget.message.msgID!;
    TencentCloudChatVoteLogic? originData = Provider.of<TencentCloudChatVoteMessageModel>(context, listen: false).getTencentCloudChatVoteLogic(msgID);
    if (originData == null) {
      return;
    }
    if (originData.groupMemberCount > 0) {
      return;
    }
    String? groupID = widget.message.groupID;
    if (groupID == null || groupID.isEmpty) {
      return;
    }

    V2TimValueCallback<List<V2TimGroupInfoResult>> groupsInfoRes = await TencentImSDKPlugin.v2TIMManager.getGroupManager().getGroupsInfo(
      groupIDList: [groupID],
    );

    if (groupsInfoRes.code == 0) {
      if (groupsInfoRes.data != null) {
        if (groupsInfoRes.data!.isNotEmpty) {
          var groupInfo = groupsInfoRes.data!.first;
          if (groupInfo.resultCode == 0) {
            if (groupInfo.groupInfo != null) {
              int? memberCount = groupInfo.groupInfo!.memberCount;

              originData.setGroupMemberCount(memberCount ?? 0);

              Provider.of<TencentCloudChatVoteMessageModel>(context, listen: false).updateTencentCloudChatVoteLogic(originData);
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    TencentCloudChatVoteLogic? votedata = Provider.of<TencentCloudChatVoteMessageModel>(
      context,
      listen: true,
    ).getTencentCloudChatVoteLogic(widget.message.msgID!);

    if (votedata == null) {
      return Center(
        child: Text(("非投票消息，请检查")),
      );
    }
    if (!votedata.isValidateVoteMessage) {
      return Center(
        child: Text(("非投票消息，请检查")),
      );
    }
    return widget.child;
  }
}
