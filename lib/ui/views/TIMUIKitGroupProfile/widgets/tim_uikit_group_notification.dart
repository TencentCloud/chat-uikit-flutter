import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_im_base/tencent_im_base.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_group_profile_model.dart';

import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';

class GroupProfileNotification extends StatefulWidget {
  final bool isHavePermission;

  const GroupProfileNotification({Key? key, this.isHavePermission = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => GroupProfileNotificationState();
}

class GroupProfileNotificationState
    extends TIMUIKitState<GroupProfileNotification> {
  bool isShowEditBox = false;
  final TextEditingController _controller = TextEditingController();


  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;
    final isDesktopScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;

    final model = Provider.of<TUIGroupProfileModel>(context);
    final String notification = (model.groupInfo?.notification != null &&
            model.groupInfo!.notification!.isNotEmpty)
        ? model.groupInfo!.notification!
        : TIM_t("暂无群公告");

    _setGroupNotification() async {
      setState(() {
        isShowEditBox = false;
      });
      final notification = _controller.text;
      await model.setGroupNotification(notification);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          border: isDesktopScreen
              ? null
              : Border(
                  bottom: BorderSide(
                      color: theme.weakDividerColor ??
                          CommonColor.weakDividerColor))),
      child: InkWell(
        onTap: !widget.isHavePermission
            ? null
            : (() {
                final isDesktopScreen =
                    TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
                if (!isDesktopScreen) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GroupProfileNotificationPage(
                              model: model, notification: notification)));
                } else {
                  setState(() {
                    isShowEditBox = !isShowEditBox;
                    if (isShowEditBox) {
                      _controller.text = notification;
                    }
                  });
                }
              }),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    TIM_t("群公告"),
                    style: TextStyle(
                        color: theme.darkTextColor,
                        fontSize: isDesktopScreen ? 14 : 16),
                  ),
                ),
                if (widget.isHavePermission)
                  AnimatedRotation(
                    turns: isShowEditBox ? 0.25 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.keyboard_arrow_right,
                        color: theme.weakTextColor),
                  )
              ],
            ),
            if (!isShowEditBox)
              Padding(
                padding: EdgeInsets.only(top: isDesktopScreen ? 4 : 0),
                child: SelectableText(notification,
                    // overflow: isDesktopScreen ? null : TextOverflow.ellipsis,
                    // softWrap: true,
                    style: TextStyle(color: theme.weakTextColor, fontSize: 12)),
              ),
            if (isShowEditBox)
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                // height: 150,
                child: TextField(
                    minLines: 1,
                    maxLines: 6,
                    controller: _controller,
                    keyboardType: TextInputType.multiline,
                    autofocus: true,
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: theme.weakDividerColor ?? Colors.grey,
                            )),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: theme.weakDividerColor ?? Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          //选中时外边框颜色
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: theme.weakTextColor ?? Colors.grey,
                          ),
                        ),
                        hintStyle: const TextStyle(
                          color: Color(0xFFAEA4A3),
                        ),
                        hintText: '')),
              ),
            if (isShowEditBox)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                      onPressed: _setGroupNotification,
                      child: Text(
                        TIM_t("保存"),
                        style:
                            TextStyle(fontSize: 13, color: theme.primaryColor),
                      ))
                ],
              )
          ],
        ),
      ),
    );
  }
}

class GroupProfileNotificationPage extends StatefulWidget {
  final String notification;
  final TUIGroupProfileModel model;

  const GroupProfileNotificationPage(
      {Key? key, required this.notification, required this.model})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _GroupProfileNotificationPageState();
}

class _GroupProfileNotificationPageState
    extends TIMUIKitState<GroupProfileNotificationPage> {
  final TextEditingController _controller = TextEditingController();
  bool isUpdated = false;

  _setGroupNotification() async {
    final notification = _controller.text;
    await widget.model.setGroupNotification(notification);
    setState(() {
      isUpdated = true;
    });
  }

  @override
  void initState() {
    _controller.text = widget.notification;
    super.initState();
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          TIM_t("群公告"),
          style: TextStyle(color: theme.appbarTextColor, fontSize: 17),
        ),
        backgroundColor: theme.appbarBgColor ??
            theme.primaryColor,
        shadowColor: theme.weakDividerColor,
        iconTheme: IconThemeData(
          color: theme.appbarTextColor,
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (isUpdated) {
                setState(() {
                  isUpdated = false;
                });
              } else {
                _setGroupNotification();
              }
            },
            child: Text(
              isUpdated ? TIM_t("编辑") : TIM_t("完成"),
              style: TextStyle(
                color: theme.appbarTextColor,
                fontSize: 14,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextField(
            readOnly: isUpdated,
            minLines: 1,
            maxLines: 4,
            controller: _controller,
            keyboardType: TextInputType.multiline,
            autofocus: true,
            decoration: const InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(
                  // fontSize: 10,
                  color: Color(0xFFAEA4A3),
                ),
                hintText: '')),
      ),
    );
  }
}
