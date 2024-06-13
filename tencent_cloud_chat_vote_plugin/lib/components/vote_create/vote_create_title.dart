import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_vote_plugin/common/color_manager.dart';
import 'package:tencent_cloud_chat_vote_plugin/common/fontsize_manager.dart';
import 'package:tencent_cloud_chat_vote_plugin/model/vote_create_model.dart';

class TencentCloudChatVoteCreateTitle extends StatefulWidget {
  const TencentCloudChatVoteCreateTitle({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatVoteCreateTitleState();
}

class TencentCloudChatVoteCreateTitleState extends State<TencentCloudChatVoteCreateTitle> {
  @override
  void initState() {
    super.initState();
    String title = Provider.of<TencentCloudChatVoteCreateModel>(
      context,
      listen: false,
    ).title;
    titleContraller.text = title;
  }

  setTitle(String t) {
    Provider.of<TencentCloudChatVoteCreateModel>(
      context,
      listen: false,
    ).setTitle(t);
    titleContraller.text = t;
    titleContraller.selection = TextSelection(
      baseOffset: t.length,
      extentOffset: t.length,
    );
  }

  late TextEditingController titleContraller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 46,
            child: TextField(
              controller: titleContraller,
              maxLines: 1,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  fontSize: VoteFontSizeManager.voteTitleHintFontSize,
                  color: VoteColorsManager.voteTitleHintColor,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    style: BorderStyle.solid,
                    color: VoteColorsManager.voteTitleInputFoucsBorderColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    style: BorderStyle.solid,
                    color: VoteColorsManager.voteTitleInputBorderColor,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                hintText: ('请输入投票主题'),
              ),
              onChanged: setTitle,
            ),
          ),
        )
      ],
    );
  }
}
