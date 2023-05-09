import 'package:flutter/material.dart';
import 'package:tencent_im_base/tencent_im_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_statelesswidget.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/avatar.dart';

class TIMUIKitProfileUserInfoCardWide extends TIMUIKitStatelessWidget {
  /// User info
  final V2TimUserFullInfo? userInfo;
  final bool isJumpToPersonalProfile;
  final VoidCallback? onClickAvatar;

  /// If shows the arrow icon on the right
  final bool showArrowRightIcon;

  TIMUIKitProfileUserInfoCardWide(
      {Key? key,
      this.userInfo,
      this.onClickAvatar,
      @Deprecated("This info card can no longer navigate to default personal profile page automatically, please deal with it manually.")
          this.isJumpToPersonalProfile = false,
      this.showArrowRightIcon = false})
      : super(key: key);

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;
    final faceUrl = userInfo?.faceUrl ?? "";
    final nickName = userInfo?.nickName ?? "";
    final signature = userInfo?.selfSignature;
    final showName = nickName != "" ? nickName : userInfo?.userID;

    return Container(
      padding: const EdgeInsets.only(bottom: 10, left: 16, right: 16),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: SelectableText(
                    showName ?? "",
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  margin: const EdgeInsets.only(right: 10),
                ),
                Row(
                  children: [
                    Text(
                      "ID:  ",
                      style:
                          TextStyle(fontSize: 12, color: theme.weakTextColor),
                    ),
                    Expanded(child: SelectableText(
                      userInfo?.userID ?? "",
                      style:
                      TextStyle(fontSize: 12, color: theme.weakTextColor),
                    )),
                  ],
                ),
                if (signature != null)
                  Container(
                    margin: const EdgeInsets.only(top: 18),
                    child: SelectableText(signature,
                        style: TextStyle(
                            fontSize: 14, color: hexToColor("7f7f7f"))),
                  )
              ],
            ),
          ),
          Row(
            children: [
              const SizedBox(
                width: 40,
              ),
              SizedBox(
                width: 80,
                height: 80,
                child: InkWell(
                  onTap: onClickAvatar,
                  child: Avatar(
                    faceUrl: faceUrl,
                    isShowBigWhenClick: onClickAvatar == null,
                    showName: showName ?? "",
                    type: 1,
                  ),
                ),
              ),
              showArrowRightIcon
                  ? const Icon(Icons.keyboard_arrow_right)
                  : Container()
            ],
          )
        ],
      ),
    );
  }
}
