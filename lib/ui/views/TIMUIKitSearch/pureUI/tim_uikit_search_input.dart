import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_im_base/tencent_im_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';

class TIMUIKitSearchInput extends StatefulWidget {
  final ValueChanged<String> onChange;
  final String? initValue;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? prefixText;
  final bool? isAutoFocus;
  final FocusNode focusNode;

  const TIMUIKitSearchInput({
    required this.onChange,
    this.initValue,
    this.controller,
    Key? key,
    this.prefixIcon,
    this.isAutoFocus = true,
    this.prefixText,
    required this.focusNode,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TIMUIKitSearchInputState();
}

class TIMUIKitSearchInputState extends TIMUIKitState<TIMUIKitSearchInput> {
  late TextEditingController textEditingController =
      widget.controller ?? TextEditingController();
  bool isEmptyInput = true;

  @override
  void initState() {
    super.initState();
    textEditingController.text = widget.initValue ?? "";
    isEmptyInput = textEditingController.text.isEmpty;
  }

  hideAllPanel() {
    widget.focusNode.unfocus();
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;
    final isDesktopScreen = TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
    return Container(
      // height: 64,
      padding: EdgeInsets.fromLTRB(16, isDesktopScreen ? 16 : 8, 16, 16),
      margin: isDesktopScreen ? const EdgeInsets.only(bottom: 2) : null,
      decoration: BoxDecoration(
          color: isDesktopScreen
              ? theme.wideBackgroundColor
              : theme.primaryColor,
          boxShadow: [
            BoxShadow(
              color: theme.weakBackgroundColor ?? hexToColor("E6E9EB"),
              offset: const Offset(0.0, 2.0),
            )
          ]
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: isDesktopScreen ? 30 : 36),
            child: TextField(
              autofocus: widget.isAutoFocus ?? true,
              onChanged: (value) async {
                final trimValue = value.trim();
                final isEmpty = trimValue.isEmpty;
                if(isEmpty != isEmptyInput){
                  setState(() {
                    isEmptyInput = isEmpty ? true : false;
                  });
                }
                widget.onChange(trimValue);
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              maxLines: 4,
              minLines: 1,
              focusNode: widget.focusNode,
              controller: textEditingController,
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.start,
              style: isDesktopScreen ? const TextStyle(
                fontSize: 12
              ) : null,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(0),
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                hintStyle: TextStyle(
                  fontSize: isDesktopScreen ? 12 : 14,
                  color: hexToColor("CCCCCC"),
                ),
                fillColor: isDesktopScreen ? hexToColor("f3f3f4") : Colors.white,
                filled: true,
                isDense: true,
                hintText: TIM_t("搜索"),
                prefix: widget.prefixText != null
                    ? Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.2),
                          child: widget.prefixText,
                        ),
                      )
                    : null,
                prefixIcon: widget.prefixIcon,
                suffixIcon: isEmptyInput
                    ? null
                    : IconButton(
                        onPressed: () {
                          textEditingController.clear();
                          setState(() {
                            isEmptyInput = true;
                          });
                          widget.onChange("");
                        },
                        icon: Icon(Icons.cancel, color: hexToColor("979797")),
                      ),
              ),
            ),
          )),
          if(!isDesktopScreen) Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(TIM_t("取消"),
                    style: const TextStyle(
                      color: Colors.white,
                    )),
              ))
        ],
      ),
    );
  }
}
