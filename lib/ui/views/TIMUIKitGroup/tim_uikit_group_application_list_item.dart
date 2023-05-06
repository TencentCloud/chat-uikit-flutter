import 'package:flutter/material.dart';
import 'package:tencent_im_base/tencent_im_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';

import 'package:tencent_cloud_chat_uikit/ui/widgets/avatar.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';

enum ApplicationStatus {
  none,
  accept,
  refuse,
}

class TIMUIKitGroupApplicationListItem extends StatefulWidget {
  final V2TimGroupApplication applicationInfo;

  const TIMUIKitGroupApplicationListItem(
      {Key? key, required this.applicationInfo})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      TIMUIKitGroupApplicationListItemState();
}

class TIMUIKitGroupApplicationListItemState
    extends TIMUIKitState<TIMUIKitGroupApplicationListItem> {
  ApplicationStatus applicationStatus = ApplicationStatus.none;


  String _getUserName() {
    if (widget.applicationInfo.fromUserNickName != null &&
        widget.applicationInfo.fromUserNickName!.isNotEmpty &&
        widget.applicationInfo.fromUserNickName !=
            widget.applicationInfo.fromUser) {
      return "${widget.applicationInfo.fromUserNickName} (${widget.applicationInfo.fromUser})";
    } else {
      return "${widget.applicationInfo.fromUser}";
    }
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: SizedBox(
              height: 40,
              width: 40,
              child: Avatar(
                  faceUrl: widget.applicationInfo.fromUserFaceUrl ?? "",
                  showName: widget.applicationInfo.fromUserNickName ??
                      widget.applicationInfo.fromUser ??
                      ""),
            ),
          ),
          Column(
            children: [
              Text(
                _getUserName(),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.darkTextColor),
              ),
              Text(
                _getUserName(),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.darkTextColor),
              ),
            ],
          )
        ],
      ),
    );
  }
}
