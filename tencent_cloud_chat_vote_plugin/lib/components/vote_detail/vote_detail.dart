// ignore_for_file: iterable_contains_unrelated_type

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_vote_plugin/common/color_manager.dart';
import 'package:tencent_cloud_chat_vote_plugin/struct/vote_custom_struct.dart';

///
class TencentCloudChatVoteDetail extends StatefulWidget {
  final TencentCloudChatVoteDataOptoin option;
  final TencentCloudChatVoteLogic data;
  const TencentCloudChatVoteDetail({
    Key? key,
    required this.option,
    required this.data,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatVoteDetailState();
}

class TencentCloudChatVoteDetailState extends State<TencentCloudChatVoteDetail> {
  int getallvote() {
    int v = 0;
    var lst = widget.data.messageExts;
    var index = widget.option.index.toString();
    for (var i = 0; i < lst.length; i++) {
      var it = lst[i];
      if (it.extensionKey == 'closed') {
        continue;
      }

      if (it.extensionValue.split("_").contains(index)) {
        v++;
      }
    }
    return v;
  }

  String getPercent() {
    var lst = widget.data.messageExts.takeWhile((e) => e.extensionKey != 'closed').toList();
    int tatalvotes = lst.length;
    int currentv = 0;
    for (var element in lst) {
      bool isEq = element.extensionValue.split("_").contains(
            widget.option.index.toString(),
          );

      if (isEq) {
        currentv++;
      }
    }
    double per = tatalvotes == 0
        ? 0
        : double.parse(
            (currentv / tatalvotes).toStringAsFixed(1),
          );
    return "${per * 100}%";
  }

  Widget getAvatar(String uid) {
    var ginfos = widget.data.groupInfos;

    var defaultava = SizedBox(
      height: 40,
      width: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              uid.substring(uid.length - 3),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
    if (ginfos[uid] != null) {
      var ginfo = ginfos[uid]!;
      if (ginfo.faceUrl == null) {
        return defaultava;
      }
      if (ginfo.faceUrl!.isEmpty) {
        return defaultava;
      }
      return Image.network(
        ginfo.faceUrl!,
        width: 40,
        height: 40,
        fit: BoxFit.contain,
      );
    }
    return defaultava;
  }

  Widget getName(String uid) {
    var ginfos = widget.data.groupInfos;

    String name = uid;
    if (ginfos[uid] != null) {
      var ginfo = ginfos[uid]!;
      if (ginfo.nameCard != null && ginfo.nameCard!.isNotEmpty) {
        name = ginfo.nameCard!;
      } else if (ginfo.friendRemark != null && ginfo.friendRemark!.isNotEmpty) {
        name = ginfo.friendRemark!;
      } else if (ginfo.nickName != null && ginfo.nickName!.isNotEmpty) {
        name = ginfo.nickName!;
      }
    }
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Text(name),
      ),
    );
  }

  List<Widget> getAddBottom() {
    List<Widget> res = [];
    List<String> users = [];
    var lst = widget.data.messageExts.takeWhile((e) => e.extensionKey != 'closed').toList();
    var index = widget.option.index.toString();

    for (var i = 0; i < lst.length; i++) {
      if (lst[i].extensionValue.split("_").contains(index)) {
        users.add(lst[i].extensionKey.split("_").first);
      }
    }

    res = users
        .map(
          (e) => Container(
            decoration: const BoxDecoration(
              color: VoteColorsManager.voteDetailItemBgColor,
              border: Border(
                bottom: BorderSide(
                  color: VoteColorsManager.voteDetailItemBorderColor,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                getAvatar(e),
                getName(e),
              ],
            ),
          ),
        )
        .toList();
    return [
      ...res,
      SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text.rich(
                TextSpan(text: ("已投"), children: [
                  TextSpan(
                    text: getallvote().toString(),
                    style: const TextStyle(
                      color: VoteColorsManager.voteDetailTextColor,
                    ),
                  ),
                  const TextSpan(text: ("票，")),
                  const TextSpan(text: ("占比")),
                  TextSpan(
                    text: getPercent(),
                    style: const TextStyle(
                      color: VoteColorsManager.voteDetailTextColor,
                    ),
                  ),
                ]),
                style: const TextStyle(),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    widget.data.messageExts;
    widget.data.groupInfos;
    return Column(
      children: getAddBottom(),
    );
  }
}
