import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';

class TencentCloudChatMessageTipsCommon extends StatefulWidget {
  final String text;
  final V2TimMessage? message;
  final ({String text, VoidCallback onTap})? buttonText;

  const TencentCloudChatMessageTipsCommon({
    super.key,
    required this.text,
    this.message,
    this.buttonText,
  });

  @override
  State<TencentCloudChatMessageTipsCommon> createState() => _TencentCloudChatMessageTipsCommonState();
}

class _TencentCloudChatMessageTipsCommonState extends TencentCloudChatState<TencentCloudChatMessageTipsCommon> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => TencentCloudChatUtils.checkString(widget.text) != null
          ? Container(
              margin: EdgeInsets.symmetric(vertical: getSquareSize(4), horizontal: getSquareSize(4)),
              padding: EdgeInsets.symmetric(vertical: getSquareSize(4), horizontal: getSquareSize(8)),
              decoration: BoxDecoration(
                color: colorTheme.messageTipsBackgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(getSquareSize(16))),
              ),
              constraints: BoxConstraints(
                // margin(horizontal) x 2 + padding(horizontal) x 2
                maxWidth: MediaQuery.of(context).size.width - getSquareSize(24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      widget.text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: textStyle.standardSmallText,
                        color: colorTheme.secondaryTextColor,
                      ),
                    ),
                  ),
                  if (widget.buttonText != null)
                    Container(
                      margin: EdgeInsets.only(left: getWidth(12)),
                      child: InkWell(
                          onTap: widget.buttonText!.onTap,
                          child: Text(
                            widget.buttonText!.text,
                            style: TextStyle(
                                fontSize: textStyle.fontsize_12,
                                fontWeight: FontWeight.w500,
                                color: colorTheme.primaryColor.withOpacity(0.8)),
                          )),
                    )
                ],
              ),
            )
          : Container(),
    );
  }
}
