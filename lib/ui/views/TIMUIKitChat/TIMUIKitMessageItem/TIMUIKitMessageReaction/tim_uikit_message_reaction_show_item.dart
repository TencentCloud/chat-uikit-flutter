// ignore_for_file: unused_field

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_statelesswidget.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_self_info_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/message/message_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';

import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitMessageItem/TIMUIKitMessageReaction/tim_uikit_message_reaction_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/extended_wrap/extended_wrap.dart';

class TIMUIKitMessageReactionShowItem extends TIMUIKitStatelessWidget {
  /// the unicode of the emoji
  final int sticker;

  /// the list contains the name who choose the current emoji
  final List nameList;

  /// current message
  final V2TimMessage message;

  /// show the details of message reaction
  final Function(int sticker) onShowDetail;

  /// the member in current chat
  final List<V2TimGroupMemberFullInfo?> memberList;

  TIMUIKitMessageReactionShowItem(
      {required this.message,
      required this.sticker,
      required this.memberList,
      required this.onShowDetail,
      required this.nameList,
      Key? key})
      : super(key: key);

  final TUISelfInfoViewModel selfInfoModel =
      serviceLocator<TUISelfInfoViewModel>();
  final MessageService _messageService = serviceLocator<MessageService>();

  clickOnCurrentSticker() async {
    for (int i = 0; i < 5; i++) {
      final res = await modifySticker();
      if (res.code == 0) {
        break;
      }
    }
  }

  Future<V2TimValueCallback<V2TimMessageChangeInfo>> modifySticker() async {
    return await Future.delayed(const Duration(milliseconds: 50), () async {
      return await MessageReactionUtils.clickOnSticker(message, sticker);
    });
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final theme = value.theme;
    final option1 = nameList.length;
    final TUIChatSeparateViewModel model =
        Provider.of<TUIChatSeparateViewModel>(context);

    final List<String> userIDs = [];
    for (final user in nameList) {
      final V2TimGroupMemberFullInfo? memberInfo = memberList
          .firstWhereOrNull((element) => element?.userID == user && TencentUtils.checkString(user) != null);
      if((memberInfo == null || TencentUtils.checkString(memberInfo.userID) == null) && TencentUtils.checkString(user.toString()) != null){
        userIDs.add(user.toString());
      }
    }
    if(userIDs.isNotEmpty){
      model.getUserShowName(userIDs);
    }


    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        decoration: const BoxDecoration(
          color: Color(0x19727271),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: clickOnCurrentSticker,
              child: Container(
                margin: EdgeInsets.only(
                    bottom: (!PlatformUtils().isIOS) ? 4 : 2,
                    top: (!PlatformUtils().isIOS) ? 4 : 0),
                child: Text(
                  String.fromCharCode(sticker),
                  style: TextStyle(
                      fontSize: (!PlatformUtils().isIOS) ? 12 : 16,
                      color: hexToColor("f9453d")),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 6, right: 6),
              child: SizedBox(
                width: 1,
                height: 14,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: theme.weakTextColor),
                ),
              ),
            ),
            Container(
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth * 0.8,
              ),
              child: ExtendedWrap(
                maxLines: 1,
                spacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                overflowWidget: GestureDetector(
                  onTap: () {
                    onShowDetail(sticker);
                  },
                  child: Text(
                    TIM_t_para("...共{{option1}}人", "...共$option1人")(
                        option1: option1),
                    style: TextStyle(fontSize: 12, color: hexToColor("616669")),
                  ),
                ),
                children: [
                  ...nameList.map((e) {
                    String showName = e;
                    if (memberList.isNotEmpty) {
                      try {
                        final V2TimGroupMemberFullInfo? memberInfo = memberList
                            .firstWhere((element) => element?.userID == e);
                        if (memberInfo != null) {
                          if (memberInfo.friendRemark != null &&
                              memberInfo.friendRemark!.isNotEmpty) {
                            showName = memberInfo.friendRemark!;
                          } else if (memberInfo.nameCard != null &&
                              memberInfo.nameCard!.isNotEmpty) {
                            showName = memberInfo.nameCard!;
                          } else if (memberInfo.nickName != null &&
                              memberInfo.nickName!.isNotEmpty) {
                            showName = memberInfo.nickName!;
                          } else {
                            showName = memberInfo.userID;
                          }
                        }else{
                          final String? data = model.groupUserShowName[e];
                          if(TencentUtils.checkString(data) != null){
                            showName = data ?? e;
                          }
                        }
                      } catch (error) {
                        final String? data = model.groupUserShowName[e];
                        if(TencentUtils.checkString(data) != null){
                          showName = data ?? e;
                        }
                      }
                    }else{
                      final String? data = model.groupUserShowName[e];
                      if(TencentUtils.checkString(data) != null){
                        showName = data ?? e;
                      }
                    }
                    return InkWell(
                      onTapDown: (tapDetails) {
                        if (model.onTapAvatar != null) {
                          if (e != selfInfoModel.loginInfo?.userID) {
                            model.onTapAvatar!(e, tapDetails);
                          }
                        }
                      },
                      child: Text(
                        showName,
                        style: TextStyle(
                            fontSize: 12, color: hexToColor("616669")),
                      ),
                    );
                  })
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
