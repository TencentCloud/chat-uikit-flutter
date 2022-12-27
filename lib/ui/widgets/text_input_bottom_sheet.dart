import 'package:flutter/material.dart';
import 'package:tencent_im_base/tencent_im_base.dart';

class TextInputBottomSheet {
  static showTextInputBottomSheet(BuildContext context, String title,
      String tips, Function(String text) onSubmitted, TUITheme theme) {
    TextEditingController _selectionController = TextEditingController();

    showModalBottomSheet(
        isScrollControlled: true, // !important
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
              child: Container(
            padding: EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 30,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16)),
                ),
                Divider(height: 2, color: theme.weakDividerColor),
                TextField(
                  controller: _selectionController,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      height: 40,
                      child: Text(
                        tips,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                      ),
                      onPressed: () {
                        String text = _selectionController.text;
                        // if (text == "") {
                        //   _coreService.callOnCallback(TIMCallback(
                        //       type: TIMCallbackType.INFO,
                        //       infoRecommendText: TIM_t("输入不能为空"),
                        //       infoCode: 6661401));
                        //   return;
                        // }
                        onSubmitted(text);
                        Navigator.pop(context);
                      },
                      child: Text(TIM_t("确定"))),
                ),
              ],
            ),
          ));
        });
  }
}
