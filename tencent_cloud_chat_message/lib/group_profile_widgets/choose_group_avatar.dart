import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';

class ChooseGroupAvatar extends StatefulWidget {
  String groupID;
  String groupType;
  String selectedAvatarUrl;

  ChooseGroupAvatar({Key? key, required this.groupID, required this.groupType, required this.selectedAvatarUrl})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ChooseGroupAvatarState();
}

class ChooseGroupAvatarState extends TencentCloudChatState<ChooseGroupAvatar> {
  List<String> groupAvatars = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < TencentCloudChat.instance.dataInstance.contact.groupFaceCount; i++) {
      groupAvatars
          .add(TencentCloudChat.instance.dataInstance.contact.groupFaceURL.replaceAll('%s', (i + 1).toString()));
    }
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Scaffold(
              appBar: AppBar(
                leadingWidth: getWidth(100),
                leading: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Row(children: [
                    Padding(padding: EdgeInsets.only(left: getWidth(10))),
                    Icon(
                      Icons.arrow_back_ios_outlined,
                      color: colorTheme.contactBackButtonColor,
                      size: getSquareSize(24),
                    ),
                  ]),
                ),
                scrolledUnderElevation: 0.0,
                title: Text(
                  tL10n.chooseAvatar,
                  style: TextStyle(
                      fontSize: textStyle.fontsize_16,
                      fontWeight: FontWeight.w600,
                      color: colorTheme.settingTitleColor),
                ),
                centerTitle: true,
                actions: [
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    onPressed: () {
                      _submitAvatar();
                    },
                    child: Text(
                      tL10n.confirm,
                    ),
                  )
                ],
                backgroundColor: colorTheme.settingBackgroundColor,
              ),
              body: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 1.0),
                itemCount: groupAvatars.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.selectedAvatarUrl = groupAvatars[index];
                      });
                    },
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: widget.selectedAvatarUrl == groupAvatars[index]
                                    ? Theme.of(context).primaryColor
                                    : Colors.transparent,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.network(
                              groupAvatars[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                        if (widget.selectedAvatarUrl == groupAvatars[index])
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ));
  }

  _submitAvatar() async {
    if (widget.selectedAvatarUrl.isNotEmpty) {
      final result = await TencentCloudChat.instance.chatSDKInstance.groupSDK
          .setGroupInfo(groupID: widget.groupID, groupType: widget.groupType, faceUrl: widget.selectedAvatarUrl);
      if (result?.code == 0) {
        if (mounted) {
          Navigator.of(context).pop(widget.selectedAvatarUrl);
        }
      }
    }
  }
}
