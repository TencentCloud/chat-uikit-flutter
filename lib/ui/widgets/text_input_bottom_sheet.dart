import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/drag_widget.dart';
import 'package:tencent_im_base/tencent_im_base.dart';

class TextInputBottomSheet {
  static OverlayEntry? entry;

  static Widget inputBoxContent(
      {required BuildContext context,
      required String title,
        String? tips,
      required Function(String text) onSubmitted,
      required TUITheme theme,
      bool isShowCancel = false,
        Offset? initOffset,
        String? initText,
      required TextEditingController selectionController}) {
    final isDesktopScreen = TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
    selectionController.text = initText ?? "";
    return SingleChildScrollView(
        child: Container(
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom:
            isDesktopScreen ? 16 : MediaQuery.of(context).viewInsets.bottom + 30,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
          ),
          Divider(height: 2, color: theme.weakDividerColor),
          TextField(

            onSubmitted: (text) {
              onSubmitted(text);
              if (entry != null) {
                entry?.remove();
                entry = null;
              } else {
                Navigator.pop(context);
              }
            },
            autofocus: true,
            controller: selectionController,
          ),
          if(tips != null) Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                height: 40,
                child: Text(
                  tips,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              )
            ],
          ),
          if (isDesktopScreen)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isShowCancel)
                  Container(
                      margin: const EdgeInsets.only(right: 20),
                      child: SizedBox(
                        width: 84,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  theme.wideBackgroundColor),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                            ),
                            onPressed: () {
                              if (entry != null) {
                                entry?.remove();
                                entry = null;
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              TIM_t("取消"),
                              style: TextStyle(color: theme.darkTextColor),
                            )),
                      )),
                SizedBox(
                  width: 84,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                      ),
                      onPressed: () {
                        String text = selectionController.text;
                        onSubmitted(text);
                        if (entry != null) {
                          entry?.remove();
                          entry = null;
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: Text(TIM_t("保存"))),
                ),
              ],
            ),
          if (!isDesktopScreen)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isShowCancel)
                  Expanded(
                      child: Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              theme.wideBackgroundColor),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                        onPressed: () {
                          if (entry != null) {
                            entry?.remove();
                            entry = null;
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          TIM_t("取消"),
                          style: TextStyle(color: theme.darkTextColor),
                        )),
                  )),
                Expanded(
                    child: SizedBox(
                  child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                      ),
                      onPressed: () {
                        String text = selectionController.text;
                        onSubmitted(text);
                        if (entry != null) {
                          entry?.remove();
                          entry = null;
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: Text(TIM_t("确定"))),
                )),
              ],
            ),
        ],
      ),
    ));
  }

  static showTextInputBottomSheet({
    required BuildContext context,
    required String title,
    String? tips,
    required Function(String text) onSubmitted,
    required TUITheme theme,
    Offset? initOffset,
    String? initText,
  }) {
    TextEditingController _selectionController = TextEditingController();
    final isDesktopScreen = TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
    if (isDesktopScreen) {
      if (entry != null) {
        return;
      }
      entry = OverlayEntry(builder: (BuildContext context) {
        return TUIKitDragArea(
          closeFun: (){
            if(entry != null){
              entry?.remove();
              entry = null;
            }
          },
            initOffset: initOffset ??
                Offset(MediaQuery.of(context).size.height * 0.5 + 20,
                    MediaQuery.of(context).size.height * 0.5 - 100),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                color: theme.wideBackgroundColor,
                border: Border.all(
                  width: 2,
                  color: theme.weakBackgroundColor ?? const Color(0xFFbebebe),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFFbebebe),
                    offset: Offset(5, 5),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: SizedBox(
                width: 350,
                child: inputBoxContent(
                    context: context,
                    isShowCancel: true,
                    title: title,
                    tips: tips,
                    onSubmitted: onSubmitted,
                    theme: theme,
                    initText: initText,
                    selectionController: _selectionController),
              ),
            ));
      });
      Overlay.of(context).insert(entry!);
    } else {
      showModalBottomSheet(
          isScrollControlled: true, // !important
          context: context,
          builder: (BuildContext context) {
            return inputBoxContent(
                context: context,
                title: title,
                tips: tips,
                initText: initText,
                onSubmitted: onSubmitted,
                theme: theme,
                selectionController: _selectionController);
          });
    }
  }
}
