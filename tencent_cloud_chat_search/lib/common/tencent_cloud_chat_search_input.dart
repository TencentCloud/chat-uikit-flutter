import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';

class TencentCloudChatSearchInput extends StatefulWidget{
  final TextEditingController textEditingController;
  const TencentCloudChatSearchInput({super.key, required this.textEditingController});

  @override
  State<TencentCloudChatSearchInput> createState() => _TencentCloudChatSearchInputState();
}

class _TencentCloudChatSearchInputState extends TencentCloudChatState<TencentCloudChatSearchInput> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TextField(
      maxLines: 1,
      controller: widget.textEditingController,
      style: const TextStyle(fontSize: 12),
      decoration: InputDecoration(
        hintText: tL10n.search,
        filled: true,
        isDense: true,
        hintStyle: const TextStyle(fontSize: 12),
        prefixIcon: const Icon(Icons.search),
        suffixIcon: widget.textEditingController.text.isNotEmpty
            ? IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            setState(() {
              widget.textEditingController.clear();
            });
          },
        )
            : null,
        border: const OutlineInputBorder(borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.all(0),
      ),
      onChanged: (value) {
        setState(() {});
      },
    );
  }
}