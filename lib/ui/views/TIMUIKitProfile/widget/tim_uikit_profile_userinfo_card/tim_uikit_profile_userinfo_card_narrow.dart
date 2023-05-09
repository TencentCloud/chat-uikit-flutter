import 'package:flutter/material.dart';
import 'package:tencent_im_base/tencent_im_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_statelesswidget.dart';

import 'package:tencent_cloud_chat_uikit/ui/widgets/avatar.dart';

class TIMUIKitProfileUserInfoCardNarrow extends TIMUIKitStatelessWidget {
  /// User info
  final V2TimUserFullInfo? userInfo;
  final bool isJumpToPersonalProfile;
  final VoidCallback? onClickAvatar;

  /// If shows the arrow icon on the right
  final bool showArrowRightIcon;

  TIMUIKitProfileUserInfoCardNarrow(
      {Key? key,
      this.onClickAvatar,
      this.userInfo,
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
    final option1 = signature;
    final signatureText = option1 != null
        ? TIM_t_para("个性签名: {{option1}}", "个性签名: $option1")(option1: option1)
        : TIM_t("暂无个性签名");

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: GestureDetector(
              onTap: onClickAvatar,
              child: Avatar(
                faceUrl: faceUrl,
                isShowBigWhenClick: onClickAvatar == null,
                showName: showName ?? "",
                type: 1,
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: SelectableText(
                    showName ?? "",
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text(
                        "ID:  ",
                        style:
                            TextStyle(fontSize: 13, color: theme.weakTextColor),
                      ),
                      SelectableText(
                        userInfo?.userID ?? "",
                        style:
                            TextStyle(fontSize: 13, color: theme.weakTextColor),
                      ),
                    ],
                  ),
                ),
                SelectableText(signatureText,
                    style: TextStyle(fontSize: 13, color: theme.weakTextColor))
              ],
            ),
          ),
          showArrowRightIcon
              ? const Icon(Icons.keyboard_arrow_right)
              : Container()
        ],
      ),
    );
  }
}
