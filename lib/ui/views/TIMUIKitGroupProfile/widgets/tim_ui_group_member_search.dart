import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_statelesswidget.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/optimize_utils.dart';


import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitSearch/pureUI/tim_uikit_search_input.dart';
import 'package:tencent_im_base/tencent_im_base.dart';

class GroupMemberSearchTextField extends TIMUIKitStatelessWidget {
  final Function(String text) onTextChange;
  GroupMemberSearchTextField({Key? key, required this.onTextChange})
      : super(key: key);

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;
    final isDesktopScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
    final FocusNode focusNode = FocusNode();

    var debounceFunc = OptimizeUtils.debounce(
        (text) => onTextChange(text), const Duration(milliseconds: 300));

    return Container(
      color: Colors.white,
      child: Column(children: [
        if(!isDesktopScreen) Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              border: Border.all(color: theme.weakBackgroundColor!, width: 12)),
          child: TextField(
            onChanged: debounceFunc,
            decoration: InputDecoration(
              hintText: TIM_t("搜索"),
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ),
        if(isDesktopScreen) TIMUIKitSearchInput(prefixIcon: Icon(
          Icons.search,
          size: 16,
          color: hexToColor("979797"),
        ),
          onChange: (text){
          focusNode.requestFocus();
            debounceFunc(text);
          }, focusNode: focusNode,
        ),
        Divider(
            thickness: 1,
            indent: 74,
            endIndent: 0,
            color: theme.weakBackgroundColor,
            height: 0)
      ]),
    );
  }
}
