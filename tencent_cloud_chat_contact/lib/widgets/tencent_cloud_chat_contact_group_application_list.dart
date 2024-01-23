import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/chat_sdk/components/tencent_cloud_chat_contact_sdk.dart';
import 'package:tencent_cloud_chat/data/theme/color/color_base.dart';
import 'package:tencent_cloud_chat/data/theme/text_style/text_style.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_contact/tencent_cloud_chat_contact_builders.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_leading.dart';

class TencentCloudChatContactGroupApplicationList extends StatefulWidget {
  final List<V2TimGroupApplication> groupApplicationList;

  const TencentCloudChatContactGroupApplicationList({super.key, required this.groupApplicationList});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactGroupApplicationListState();
}

class TencentCloudChatContactGroupApplicationListState extends TencentCloudChatState<TencentCloudChatContactGroupApplicationList> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Scaffold(
        appBar: AppBar(
          leadingWidth: getWidth(100),
          leading: const TencentCloudChatContactLeading(),
          title: Text(
            tL10n.groupChatNotifications,
            style: TextStyle(fontSize: textStyle.fontsize_16, fontWeight: FontWeight.w600, color: colorTheme.contactItemFriendNameColor),
          ),
          centerTitle: true,
          backgroundColor: colorTheme.contactBackgroundColor,
        ),
        body: Container(
          color: colorTheme.contactApplicationBackgroundColor,
          child: Center(
            child: TencentCloudChatThemeWidget(
              build: (context, colorTheme, textStyle) => widget.groupApplicationList.isNotEmpty
                  ? ListView.builder(
                      itemBuilder: (context, index) {
                        var application = widget.groupApplicationList[index];
                        return TencentCloudChatContactGroupApplicationItem(
                          groupApplication: application,
                        );
                      },
                      itemCount: widget.groupApplicationList.length,
                    )
                  : Center(
                      child: Text(
                        tL10n.noNewApplication,
                        style: TextStyle(
                          fontSize: textStyle.fontsize_12,
                          color: colorTheme.secondaryTextColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Scaffold(
        body: Container(
          color: colorTheme.contactApplicationBackgroundColor,
          child: Center(
            child: TencentCloudChatThemeWidget(
              build: (context, colorTheme, textStyle) => widget.groupApplicationList.isNotEmpty
                  ? ListView.builder(
                      itemBuilder: (context, index) {
                        var application = widget.groupApplicationList[index];
                        return TencentCloudChatContactGroupApplicationItem(
                          groupApplication: application,
                        );
                      },
                      itemCount: widget.groupApplicationList.length,
                    )
                  : Center(
                      child: Text(
                        tL10n.noNewApplication,
                        style: TextStyle(
                          fontSize: textStyle.fontsize_12,
                          color: colorTheme.secondaryTextColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class TencentCloudChatContactGroupApplicationItem extends StatefulWidget {
  final V2TimGroupApplication groupApplication;

  const TencentCloudChatContactGroupApplicationItem({super.key, required this.groupApplication});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactGroupApplicationItemState();
}

class TencentCloudChatContactGroupApplicationItemState extends TencentCloudChatState<TencentCloudChatContactGroupApplicationItem> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Container(
              color: colorTheme.backgroundColor,
              margin: EdgeInsets.only(top: getHeight(16)),
              padding: EdgeInsets.symmetric(
                vertical: getHeight(8),
                horizontal: getWidth(16),
              ),
              child: Row(
                children: [
                  TencentCloudChatContactBuilders.getContactGroupApplicationItemGroupNameBuilder(widget.groupApplication),
                  TencentCloudChatContactBuilders.getContactGroupApplicationItemContentBuilder(
                    widget.groupApplication,
                  ),
                  TencentCloudChatContactBuilders.getContactGroupApplicationItemButtonBuilder(widget.groupApplication)
                ],
              ),
            ));
  }
}

class TencentCloudChatContactGroupApplicationItemGroupName extends StatefulWidget {
  final V2TimGroupApplication application;

  const TencentCloudChatContactGroupApplicationItemGroupName({super.key, required this.application});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactGroupApplicationItemGroupNameState();
}

class TencentCloudChatContactGroupApplicationItemGroupNameState extends TencentCloudChatState<TencentCloudChatContactGroupApplicationItemGroupName> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Text(
              widget.application.groupID,
              style: TextStyle(fontSize: textStyle.fontsize_16, fontWeight: FontWeight.w600, color: colorTheme.contactItemFriendNameColor),
            ));
  }
}

class TencentCloudChatContactGroupApplicationItemContent extends StatefulWidget {
  final V2TimGroupApplication application;

  const TencentCloudChatContactGroupApplicationItemContent({super.key, required this.application});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactGroupApplicationItemContentState();
}

class TencentCloudChatContactGroupApplicationItemContentState extends TencentCloudChatState<TencentCloudChatContactGroupApplicationItemContent> {
  Widget getAddWording(TencentCloudChatThemeColors colorTheme, TencentCloudChatTextStyle textStyle) {
    String addwording = "";
    if (widget.application.requestMsg != null) {
      addwording = widget.application.requestMsg!;
    }
    Widget w = addwording.isEmpty
        ? Container()
        : Text(
            addwording,
            style: TextStyle(color: colorTheme.contactItemTabItemNameColor, fontSize: textStyle.fontsize_12, fontWeight: FontWeight.w400),
          );
    return w;
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    widget.application.fromUserNickName ?? widget.application.fromUser ?? "",
                    style: TextStyle(fontSize: textStyle.fontsize_14, fontWeight: FontWeight.w400, color: colorTheme.contactItemFriendNameColor),
                  ),
                  getAddWording(colorTheme, textStyle)
                ],
              ),
            ));
  }
}

class TencentCloudChatContactGroupApplicationItemButton extends StatefulWidget {
  final V2TimGroupApplication application;

  const TencentCloudChatContactGroupApplicationItemButton({super.key, required this.application});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactGroupApplicationItemButtonState();
}

class TencentCloudChatContactGroupApplicationItemButtonState extends TencentCloudChatState<TencentCloudChatContactGroupApplicationItemButton> {
  bool showButton = true;
  String showName = "";

  onAcceptApplication() {
    TencentCloudChatContactSDK.acceptGroupApplication(widget.application);
    safeSetState(() {
      showButton = false;
      showName = tL10n.accepted;
    });
  }

  onRefuseApplication() {
    TencentCloudChatContactSDK.refuseGroupApplication(widget.application);
    safeSetState(() {
      showButton = false;
      showName = tL10n.declined;
    });
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    if (showButton == false) {
      return TencentCloudChatThemeWidget(
          build: (context, colorTheme, textStyle) => Container(
                padding: EdgeInsets.symmetric(horizontal: getWidth(16), vertical: getHeight(5)),
                child: Text(
                  showName,
                  style: TextStyle(color: colorTheme.contactItemTabItemNameColor, fontSize: textStyle.fontsize_12, fontWeight: FontWeight.w400),
                ),
              ));
    }
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: getWidth(10)),
                  padding: EdgeInsets.symmetric(horizontal: getWidth(16), vertical: getHeight(5)),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(getSquareSize(2)), color: colorTheme.contactAgreeButtonColor, boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.04),
                      offset: Offset(0, 2),
                    )
                  ]),
                  child: GestureDetector(
                    onTap: onAcceptApplication,
                    child: Text(
                      tL10n.agree,
                      style: TextStyle(color: colorTheme.contactBackgroundColor, fontSize: textStyle.fontsize_14, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: getWidth(16), vertical: getHeight(5)),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(getSquareSize(2)), border: Border.all(color: colorTheme.contactTabItemIconColor), color: colorTheme.contactBackgroundColor, boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.04),
                      offset: Offset(0, 2),
                    )
                  ]),
                  child: GestureDetector(
                    onTap: onRefuseApplication,
                    child: Text(
                      tL10n.refuse,
                      style: TextStyle(color: colorTheme.contactItemFriendNameColor, fontSize: textStyle.fontsize_14, fontWeight: FontWeight.w400),
                    ),
                  ),
                )
              ],
            ));
  }
}

class TencentCloudChatContactGroupApplicationListData {
  final List<V2TimGroupApplication> applicationList;

  TencentCloudChatContactGroupApplicationListData({required this.applicationList});

  Map<String, dynamic> toMap() {
    return {'applicationList': applicationList.toString()};
  }

  static TencentCloudChatContactGroupApplicationListData fromMap(Map<String, dynamic> map) {
    return TencentCloudChatContactGroupApplicationListData(applicationList: map['applicationList'] as List<V2TimGroupApplication>);
  }
}
