import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_vote_plugin/common/color_manager.dart';
import 'package:tencent_cloud_chat_vote_plugin/common/fontsize_manager.dart';
import 'package:tencent_cloud_chat_vote_plugin/common/local_image_manager.dart';
import 'package:tencent_cloud_chat_vote_plugin/model/vote_create_model.dart';
import 'package:tencent_cloud_chat_vote_plugin/struct/vote_custom_struct.dart';

class TencentCloudChatVoteCreateOptions extends StatefulWidget {
  const TencentCloudChatVoteCreateOptions({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatVoteCreateOptionsState();
}

class TencentCloudChatVoteCreateOptionsState extends State<TencentCloudChatVoteCreateOptions> {
  List<TencentCloudChatVoteDataOptoin> getOptions() {
    TencentCloudChatVoteCreateModel pv = Provider.of<TencentCloudChatVoteCreateModel>(
      context,
      listen: true,
    );
    return pv.options;
  }

  Key getUniqueKeyByIndex(int index) {
    return ValueKey(index);
  }

  List<Widget> getOptionsWidget(List<TencentCloudChatVoteDataOptoin> options) {
    return [
      ...options
          .map(
            (e) => TencentCloudChatVoteCreateOptionsItem(
              key: getUniqueKeyByIndex(e.index),
              text: e.option,
              index: e.index,
              options: options,
            ),
          )
          .toList(),
      ...[
        TencentCloudChatVoteCreateOptionsAdd(
          options: options,
        )
      ]
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<TencentCloudChatVoteDataOptoin> options = getOptions();
    return Container(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: getOptionsWidget(options),
      ),
    );
  }
}

class TencentCloudChatVoteCreateOptionsItem extends StatefulWidget {
  final String text;
  final int index;
  final List<TencentCloudChatVoteDataOptoin> options;
  const TencentCloudChatVoteCreateOptionsItem({
    Key? key,
    required this.text,
    required this.index,
    required this.options,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatVoteCreateOptionsItemState();
}

class TencentCloudChatVoteCreateOptionsItemState extends State<TencentCloudChatVoteCreateOptionsItem> {
  handleIconClick() {
    if (canDelete()) {
      List<TencentCloudChatVoteDataOptoin> nowOptions = widget.options;
      nowOptions.removeWhere((element) => element.index == widget.index);

      TencentCloudChatVoteCreateModel pv = Provider.of<TencentCloudChatVoteCreateModel>(
        context,
        listen: false,
      );
      pv.setOptions(nowOptions);
    }
  }

  textFieldChange(String value) {
    TencentCloudChatVoteCreateModel pv = Provider.of<TencentCloudChatVoteCreateModel>(
      context,
      listen: false,
    );
    List<TencentCloudChatVoteDataOptoin> originList = List<TencentCloudChatVoteDataOptoin>.from(pv.options);
    int idx = originList.indexWhere((element) => element.index == widget.index);
    originList[idx] = TencentCloudChatVoteDataOptoin(
      index: widget.index,
      option: value,
    );
    pv.setOptions(originList);
    opController.text = value;
    opController.selection = TextSelection(
      baseOffset: value.length,
      extentOffset: value.length,
    );
  }

  bool canDelete() {
    return widget.options.length > 2;
  }

  TextEditingController opController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
        onChanged: textFieldChange,
        controller: opController,
        decoration: InputDecoration(
          hintStyle: TextStyle(
            fontSize: VoteFontSizeManager.voteOptionsItemHintFontSize,
            color: VoteColorsManager.voteOptionsItemHintColor,
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: VoteColorsManager.voteOptionsItemUnderBorderColor,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              style: BorderStyle.solid,
              color: VoteColorsManager.voteTitleInputFoucsBorderColor,
              width: 2,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(maxWidth: 36),
          prefixIcon: GestureDetector(
            onTap: handleIconClick,
            child: Container(
              margin: const EdgeInsets.only(
                right: 14,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  canDelete()
                      ? VoteLocalImageManager.voteOptionsItemDelete(
                          width: 22,
                          height: 22,
                        )
                      : VoteLocalImageManager.voteOptionsItemDefaultIcon(
                          width: 22,
                          height: 22,
                        )
                ],
              ),
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 14,
          ),
          hintText: ('请输入选项'),
        ),
      ),
    );
  }
}

class TencentCloudChatVoteCreateOptionsAdd extends StatefulWidget {
  final List<TencentCloudChatVoteDataOptoin> options;
  const TencentCloudChatVoteCreateOptionsAdd({
    Key? key,
    required this.options,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatVoteCreateOptionsAddState();
}

class TencentCloudChatVoteCreateOptionsAddState extends State<TencentCloudChatVoteCreateOptionsAdd> {
  handleIconClick() {
    if (canAddOptions()) {
      int nowIndex = Provider.of<TencentCloudChatVoteCreateModel>(
        context,
        listen: false,
      ).nowIndex;
      List<TencentCloudChatVoteDataOptoin> nowOptions = widget.options;
      int latestIndex = ++nowIndex;
      nowOptions.add(
        TencentCloudChatVoteDataOptoin(
          index: latestIndex,
          option: "",
        ),
      );
      TencentCloudChatVoteCreateModel pv = Provider.of<TencentCloudChatVoteCreateModel>(
        context,
        listen: false,
      );
      pv.setOptions(nowOptions);
      pv.setNowIndex(latestIndex);
    }
  }

  bool canAddOptions() {
    return widget.options.first.option.isNotEmpty && widget.options[1].option.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    bool isDisable = canAddOptions();

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: VoteColorsManager.voteOptionsItemAddUnderBorderColor,
          ),
        ),
      ),
      height: 50,
      child: InkWell(
        onTap: handleIconClick,
        child: Row(
          children: [
            SizedBox(
              width: 36,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  isDisable
                      ? VoteLocalImageManager.voteOptionsItemAddenable(
                          width: 22,
                          height: 22,
                        )
                      : VoteLocalImageManager.voteOptionsItemAddDisable(
                          width: 22,
                          height: 22,
                        )
                ],
              ),
            ),
            Expanded(
              child: Text(
                ('新增选项'),
                style: TextStyle(
                  fontSize: VoteFontSizeManager.voteOptionsAddHintFontSize,
                  color: VoteColorsManager.voteOptionsAddHintColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
