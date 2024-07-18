import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';

class TencentCloudChatMessageReactionListItem extends StatefulWidget{
  final bool selected;
  const TencentCloudChatMessageReactionListItem({super.key, required this.selected});

  @override
  State<TencentCloudChatMessageReactionListItem> createState() => _TencentCloudChatMessageReactionListItemState();
}

class _TencentCloudChatMessageReactionListItemState extends TencentCloudChatState<TencentCloudChatMessageReactionListItem> {
  
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(build: (context, colorTheme, textStyle) =>  Container(
      height: getHeight(20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
        border: Border.all(width: 1, color: widget.selected ? colorTheme.primaryColor : colorTheme.dividerColor.withOpacity(0.3)),
        color: colorTheme.dividerColor.withOpacity(0.3),
      ),
    ),);
  }
}