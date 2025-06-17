import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:url_launcher/url_launcher.dart';

class GroupTypesSelector extends StatefulWidget {
  static const String imProductDocURLEN = "https://www.tencentcloud.com/products/im?lang=en&pg=";

  String selectedGroupType = GroupType.Work;

  GroupTypesSelector({super.key, required this.selectedGroupType});

  @override
  State<GroupTypesSelector> createState() {
    return _GroupTypesSelectorState();
  }
}

class _GroupTypesSelectorState extends TencentCloudChatState<GroupTypesSelector> {
  List<String> groupTypes = [GroupType.Work, GroupType.Public, GroupType.Meeting, GroupType.Community];

  String _getGroupTypeName(String type) {
    switch (type) {
      case GroupType.Work:
        return tL10n.groupWorkType;
      case GroupType.Public:
        return tL10n.groupPublicType;
      case GroupType.Meeting:
        return tL10n.groupMeetingType;
      case GroupType.Community:
        return tL10n.groupCommunityType;
      default:
        return tL10n.groupWorkType;
    }
  }

  String _getGroupTypeDescription(String type) {
    switch (type) {
      case GroupType.Work:
        return tL10n.groupWorkDesc;
      case GroupType.Public:
        return tL10n.groupPublicDesc;
      case GroupType.Meeting:
        return tL10n.groupMeetingDesc;
      case GroupType.Community:
        return tL10n.groupCommunityDesc;
      default:
        return tL10n.groupWorkDesc;
    }
  }

  void _launchProductDocUrl() async {
    if (await canLaunchUrl(Uri.parse(GroupTypesSelector.imProductDocURLEN))) {
      await launchUrl(Uri.parse(GroupTypesSelector.imProductDocURLEN));
    } else {
      throw 'Could not launch $widget.imProductDocURLEN';
    }
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Scaffold(
              backgroundColor: colorTheme.backgroundColor,
              appBar: AppBar(
                backgroundColor: colorTheme.backgroundColor,
                title: Center(child: Text(tL10n.groupType, style: TextStyle(fontSize: textStyle.fontsize_16))),
                leading: TextButton(
                  onPressed: () => Navigator.pop(context, widget.selectedGroupType),
                  child: Text(
                    tL10n.cancel,
                    style: TextStyle(color: colorTheme.primaryColor),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, widget.selectedGroupType);
                    },
                    child: Text(
                      tL10n.confirm,
                      style: TextStyle(color: colorTheme.primaryColor),
                    ),
                  ),
                ],
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: groupTypes.length,
                      itemBuilder: (context, index) {
                        String type = groupTypes[index];
                        bool isSelected = widget.selectedGroupType == type;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.selectedGroupType = type;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: colorTheme.backgroundColor,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: isSelected ? colorTheme.primaryColor : Colors.grey[300]!,
                                width: 1.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        if (isSelected) Icon(Icons.check, color: colorTheme.primaryColor, size: 20),
                                        SizedBox(width: isSelected ? 8.0 : 0),
                                        Text(
                                          _getGroupTypeName(type),
                                          style: TextStyle(
                                              color: colorTheme.primaryTextColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4.0),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width - 64,
                                      child: Text(
                                        _getGroupTypeDescription(type),
                                        style: TextStyle(fontSize: 12, color: colorTheme.secondaryTextColor),
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onTap: () {
                        _launchProductDocUrl();
                      },
                      child: Text(
                        tL10n.groupTypeContentButton,
                        style: TextStyle(color: colorTheme.primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }
}
