import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';

class TencentCloudChatEmptyPage extends StatefulWidget {
  final String primaryText;
  final String? secondaryText;
  final IconData icon;
  const TencentCloudChatEmptyPage(
      {super.key,
      required this.primaryText,
      this.secondaryText,
      required this.icon});

  @override
  State<TencentCloudChatEmptyPage> createState() =>
      _TencentCloudChatEmptyPageState();
}

class _TencentCloudChatEmptyPageState
    extends TencentCloudChatState<TencentCloudChatEmptyPage> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Row(
              children: [
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: FractionalOffset.topLeft,
                      end: FractionalOffset.bottomRight,
                      colors: <Color>[
                        colorTheme.desktopBackgroundColorLinearGradientOne,
                        colorTheme.desktopBackgroundColorLinearGradientTwo,
                        colorTheme.desktopBackgroundColorLinearGradientOne
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        widget.icon,
                        size: getSquareSize(80),
                        color: colorTheme.secondaryTextColor,
                      ),
                      SizedBox(height: getSquareSize(50)),
                      Text(
                        widget.primaryText,
                        style: TextStyle(
                            color: colorTheme.primaryColor, fontSize: 18),
                      ),
                      if (TencentCloudChatUtils.checkString(
                              widget.secondaryText) !=
                          null)
                        SizedBox(height: getSquareSize(10)),
                      if (TencentCloudChatUtils.checkString(
                              widget.secondaryText) !=
                          null)
                        Text(
                          widget.secondaryText!,
                          style: TextStyle(
                              color: colorTheme.secondaryTextColor,
                              fontSize: 14),
                        )
                    ],
                  ),
                ))
              ],
            ));
  }
}
