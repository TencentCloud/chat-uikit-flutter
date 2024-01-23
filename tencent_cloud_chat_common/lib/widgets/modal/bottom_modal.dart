import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';

class TencentCloudChatModalAction {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  TencentCloudChatModalAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });
}

void showTencentCloudChatBottomModal({
  required BuildContext context,
  required List<TencentCloudChatModalAction> actions,
}) {
  showModalBottomSheet(
    context: context,
    useSafeArea: true,
    builder: (BuildContext context) {
      return TencentCloudChatThemeWidget(
          build: (context, colorTheme, textStyle) => Container(
                padding: EdgeInsets.only(
                  top: 0,
                  right: 0,
                  left: 0,
                  bottom: MediaQuery.paddingOf(context).bottom,
                ),
                color: colorTheme.inputAreaBackground,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ...actions.map(
                      (e) => Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            e.onTap();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ListTile(
                              leading: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colorTheme.primaryColor,
                                  border: Border.all(
                                      color: colorTheme.primaryColor, width: 8),
                                ),
                                child: Icon(
                                  e.icon,
                                  color: colorTheme.backgroundColor,
                                  size: textStyle.standardLargeText,
                                ),
                              ),
                              title: Text(e.label),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ));
    },
  );
}
