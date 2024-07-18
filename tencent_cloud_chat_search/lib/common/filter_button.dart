import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';

class TencentCloudChatSearchFilterButton extends StatelessWidget {
  final int type;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  TencentCloudChatSearchFilterButton({
    Key? key,
    required this.type,
    required this.isSelected,
    required this.onSelected,
  }) : super(key: key);

  final messageTypeMap = {
    MessageElemType.V2TIM_ELEM_TYPE_TEXT: tL10n.text,
    MessageElemType.V2TIM_ELEM_TYPE_IMAGE: tL10n.image,
    MessageElemType.V2TIM_ELEM_TYPE_VIDEO: tL10n.video,
    MessageElemType.V2TIM_ELEM_TYPE_FILE: tL10n.file,
    MessageElemType.V2TIM_ELEM_TYPE_SOUND: tL10n.sound,
    MessageElemType.V2TIM_ELEM_TYPE_FACE: tL10n.sticker,
  };

  @override
  Widget build(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => GestureDetector(
          onTap: () => onSelected(!isSelected),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorTheme.primaryColor.withOpacity(0.1)
                      : colorTheme.dividerColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: isSelected ? colorTheme.primaryColor.withOpacity(0.5) : colorTheme.dividerColor),
                ),
                child: Text(
                  messageTypeMap[type] ?? "",
                  style: TextStyle(
                      color: isSelected ? colorTheme.primaryColor : colorTheme.primaryTextColor, fontSize: 12),
                ),
              )
            ],
          ),
        ));
  }
}
