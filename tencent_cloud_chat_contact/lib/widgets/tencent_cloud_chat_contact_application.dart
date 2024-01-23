import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat_common.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_application_list.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_leading.dart';

class TencentCloudChatContactApplication extends StatefulWidget {
  final List<V2TimFriendApplication> applicationList;

  const TencentCloudChatContactApplication({super.key, required this.applicationList});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactApplicationState();
}

class TencentCloudChatContactApplicationState extends TencentCloudChatState<TencentCloudChatContactApplication> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Scaffold(
        appBar: AppBar(
          leadingWidth: getWidth(100),
          leading: const TencentCloudChatContactLeading(),
          title: Text(
            tL10n.numNewApplications(widget.applicationList.length),
            style: TextStyle(fontSize: textStyle.fontsize_16, fontWeight: FontWeight.w600, color: colorTheme.contactItemFriendNameColor),
          ),
          centerTitle: true,
          backgroundColor: colorTheme.contactBackgroundColor,
        ),
        body: Container(
          color: colorTheme.contactApplicationBackgroundColor,
          child: Center(
            child: TencentCloudChatContactApplicationList(applicationList: widget.applicationList),
          ),
        ),
      ),
    );
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Scaffold(
        appBar: AppBar(
          title: Text(
            tL10n.numNewApplications(widget.applicationList.length),
            style: TextStyle(fontSize: textStyle.fontsize_16, fontWeight: FontWeight.w600, color: colorTheme.contactItemFriendNameColor),
          ),
          centerTitle: false,
          backgroundColor: colorTheme.contactBackgroundColor,
        ),
        body: Container(
          color: colorTheme.contactApplicationBackgroundColor,
          child: Center(
            child: TencentCloudChatContactApplicationList(applicationList: widget.applicationList),
          ),
        ),
      ),
    );
  }
}

class TencentCloudChatContactApplicationData {
  final List<V2TimFriendApplication> applicationList;

  TencentCloudChatContactApplicationData({required this.applicationList});

  Map<String, dynamic> toMap() {
    return {'applicationList': applicationList.toString()};
  }

  static TencentCloudChatContactApplicationData fromMap(Map<String, dynamic> map) {
    return TencentCloudChatContactApplicationData(applicationList: map['applicationList'] as List<V2TimFriendApplication>);
  }
}
