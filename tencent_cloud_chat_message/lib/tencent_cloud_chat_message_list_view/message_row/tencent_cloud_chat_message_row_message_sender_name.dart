import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_builder_definitions.dart';
import 'package:tencent_cloud_chat_common/data/theme/color/color_base.dart';
import 'package:tencent_cloud_chat_common/data/theme/text_style/text_style.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';

class TencentCloudChatMessageRowMessageSenderName extends StatefulWidget {
  final MessageRowMessageSenderNameBuilderData data;
  final MessageRowMessageSenderNameBuilderMethods methods;

  const TencentCloudChatMessageRowMessageSenderName({super.key, required this.data, required this.methods});

  @override
  State<TencentCloudChatMessageRowMessageSenderName> createState() =>
      _TencentCloudChatMessageRowMessageSenderNameState();
}

class _TencentCloudChatMessageRowMessageSenderNameState
    extends TencentCloudChatState<TencentCloudChatMessageRowMessageSenderName> {
  @override
  Widget defaultBuilder(BuildContext context) {
    final isSelf = widget.data.message.isSelf ?? true;
    return isSelf
        ? Container()
        : TencentCloudChatThemeWidget(
            build:
                (BuildContext context, TencentCloudChatThemeColors colorTheme, TencentCloudChatTextStyle textStyle) =>
                    Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        TencentCloudChatUtils.getMessageSenderName(widget.data.message),
                        style: TextStyle(
                          height: 1,
                          color: colorTheme.secondaryTextColor,
                          fontSize: textStyle.fontsize_12,
                        ),
                      ),
                    ),
          );
  }
}
