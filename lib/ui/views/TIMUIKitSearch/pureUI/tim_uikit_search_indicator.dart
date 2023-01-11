import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_statelesswidget.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

enum SearchType { contact, group, history }

class TIMUIKitSearchIndicator extends TIMUIKitStatelessWidget {
  final List<SearchType> typeList;
  final ValueChanged<List<SearchType>> onChange;

  TIMUIKitSearchIndicator(
      {required this.typeList, required this.onChange, Key? key})
      : super(key: key);

  final titleMap = {
    SearchType.contact: "联系人",
    SearchType.group: "群聊",
    SearchType.history: "聊天记录"
  };

  Widget renderItemBox(
      IconData icon, SearchType item, bool isSelect, TUITheme theme) {
    return InkWell(
      onTap: () {
        if (isSelect) {
          typeList.remove(item);
        } else {
          typeList.add(item);
        }
        onChange(typeList);
      },
      child: Container(
        padding: const EdgeInsets.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    icon,
                    color: theme.weakTextColor,
                    size: 30,
                  ),
                ),
                if (isSelect)
                  Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: theme.primaryColor),
                        child: const Icon(
                          Icons.check,
                          size: 8,
                          color: Colors.white,
                        ),
                      ))
              ],
            ),
            const SizedBox(height: 4),
            Text(
              TIM_t(titleMap[item]!),
              style: TextStyle(color: theme.textColor, fontSize: 13),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final theme = value.theme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(TIM_t("搜索指定内容"),
                    style: TextStyle(color: theme.weakTextColor, fontSize: 12)),
              )
            ],
          ),
          const SizedBox(height: 1),
          Divider(thickness: 0.8, color: theme.weakDividerColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              renderItemBox(Icons.person, SearchType.contact,
                  typeList.contains(SearchType.contact), theme),
              renderItemBox(Icons.people, SearchType.group,
                  typeList.contains(SearchType.group), theme),
              renderItemBox(Icons.message, SearchType.history,
                  typeList.contains(SearchType.history), theme),
            ],
          )
        ],
      ),
    );
  }
}
