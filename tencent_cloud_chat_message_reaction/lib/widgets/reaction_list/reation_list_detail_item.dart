import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/widgets/desktop_popup/operation_key.dart';
import 'package:tencent_cloud_chat_common/widgets/desktop_popup/tencent_cloud_chat_desktop_popup.dart';
import 'package:tencent_cloud_chat_intl/tencent_cloud_chat_intl.dart';
import 'package:tencent_cloud_chat_message_reaction/widgets/reaction_detail/reaction_detail.dart';

class TencentCloudChatMessageReactionListDetailItem extends StatelessWidget {
  final String msgID;
  final int borderColor;
  final int primaryColor;
  final int textColor;
  final String platformMode;

  const TencentCloudChatMessageReactionListDetailItem({
    super.key,
    required this.borderColor,
    required this.textColor,
    required this.platformMode,
    required this.msgID,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(borderColor)),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Material(
          color: Color(borderColor).withOpacity(0.36),
          child: InkWell(
            onTap: () {
              if (platformMode == 'desktop') {
                TencentCloudChatDesktopPopup.showPopupWindow(
                  title: tL10n.reactionList,
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.6,
                  operationKey: TencentCloudChatPopupOperationKey.custom,
                  context: context,
                  child: (closeFunc) => TencentCloudChatMessageReactionDetail(
                    msgID: msgID,
                    primaryColor: primaryColor,
                    borderColor: borderColor,
                    textColor: textColor,
                  ),
                );
              } else {
                showModalBottomSheet<int>(
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.66,
                        minHeight: MediaQuery.of(context).size.height * 0.2,
                      ),
                      child: Column(children: [
                        SizedBox(
                          height: 50,
                          child: Stack(
                            textDirection: TextDirection.rtl,
                            children: [
                              Center(
                                child: Text(
                                  tL10n.reactionList,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                                ),
                              ),
                              IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TencentCloudChatMessageReactionDetail(
                            msgID: msgID,
                            primaryColor: primaryColor,
                            borderColor: borderColor,
                            textColor: textColor,
                          ),
                        ),
                      ]),
                    );
                  },
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 1,
                horizontal: 2,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.more_horiz_outlined),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
