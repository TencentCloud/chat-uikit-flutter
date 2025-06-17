import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_builder_definitions.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_screen_adapter.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';

class TencentCloudChatMessageListViewDynamicButton extends StatefulWidget {
  final MessageDynamicButtonBuilderData data;
  final MessageDynamicButtonBuilderMethods methods;
  const TencentCloudChatMessageListViewDynamicButton({super.key, required this.data, required this.methods});

  @override
  State<TencentCloudChatMessageListViewDynamicButton> createState() => _TencentCloudChatMessageListViewDynamicButtonState();
}

class _TencentCloudChatMessageListViewDynamicButtonState extends TencentCloudChatState<TencentCloudChatMessageListViewDynamicButton> {

  final isDesktopScreen = TencentCloudChatScreenAdapter.deviceScreenType ==
      DeviceScreenType.desktop;

  @override
  Widget defaultBuilder(BuildContext context) {
    return GestureDetector(
      onTap: widget.methods.triggerDefaultButtonTappedEvent,
      child: MouseRegion(
        cursor: isDesktopScreen ? SystemMouseCursors.click : MouseCursor.defer,
        child: TencentCloudChatThemeWidget(
          build: (context, colorTheme, textStyle) => AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
                color: colorTheme.backgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: colorTheme.dividerColor.withOpacity(0.8),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: const BorderRadius.all(Radius.circular(30))),
            child: Row(
              children: [
                if (TencentCloudChatUtils.checkString(widget.data.text) != null && !widget.data.isLoading)
                  SizedBox(
                    height: 40,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 15),
                        child: Text(
                          widget.data.text!,
                          style: TextStyle(color: colorTheme.primaryColor),
                        ),
                      ),
                    ),
                  ),
                if (widget.data.iconData != null && !widget.data.isLoading)
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8),
                        child: Icon(
                          widget.data.iconData,
                          color: colorTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                if (widget.data.isLoading)
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              colorTheme.primaryColor),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}