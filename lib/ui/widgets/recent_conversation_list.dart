import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_conversation_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';

import 'package:tencent_cloud_chat_uikit/ui/widgets/avatar.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/az_list_view.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/radio_button.dart';
import 'package:tencent_im_base/tencent_im_base.dart';

import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';

class RecentForwardList extends StatefulWidget {
  final bool isMultiSelect;
  final Function(List<V2TimConversation> conversationList)? onChanged;

  const RecentForwardList({
    Key? key,
    this.isMultiSelect = true,
    this.onChanged,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RecentForwardListState();
}

class _RecentForwardListState extends TIMUIKitState<RecentForwardList> {
  final TUIConversationViewModel _conversationViewModel =
      serviceLocator<TUIConversationViewModel>();
  final List<V2TimConversation> _selectedConversation = [];

  List<ISuspensionBeanImpl<V2TimConversation?>> _buildMemberList(
      List<V2TimConversation?> conversationList) {
    final List<ISuspensionBeanImpl<V2TimConversation?>> showList =
        List.empty(growable: true);
    for (var i = 0; i < conversationList.length; i++) {
      final item = conversationList[i];
      showList.add(ISuspensionBeanImpl(memberInfo: item, tagIndex: "#"));
    }
    return showList;
  }

  Widget _buildItem(V2TimConversation conversation) {
    final isDesktopScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;

    final faceUrl = conversation.faceUrl ?? "";
    final showName = conversation.showName ?? "";

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (widget.isMultiSelect)
          Container(
            padding: EdgeInsets.only(left: isDesktopScreen ? 8 : 16.0, top: isDesktopScreen ? 10 : 0),
            child: CheckBoxButton(
              isChecked: _selectedConversation.contains(conversation),
              onChanged: (value) {
                if (value) {
                  _selectedConversation.add(conversation);
                } else {
                  _selectedConversation.remove(conversation);
                }
                setState(() {});
                if (widget.onChanged != null) {
                  widget.onChanged!(_selectedConversation);
                }
              },
            ),
          ),
        Expanded(
            child: InkWell(
          onTap: () {
            if (widget.isMultiSelect) {
              final isSelected = _selectedConversation.contains(conversation);
              if (isSelected) {
                _selectedConversation.remove(conversation);
              } else {
                _selectedConversation.add(conversation);
              }
              if (widget.onChanged != null) {
                widget.onChanged!(_selectedConversation);
              }
              setState(() {});
            } else {
              if (widget.onChanged != null) {
                widget.onChanged!([conversation]);
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.only(top: 10, left: 16),
            child: Row(
              children: [
                Container(
                  height: isDesktopScreen ? 30 : 40,
                  width: isDesktopScreen ? 30 : 40,
                  margin: const EdgeInsets.only(right: 12),
                  child: Avatar(
                    faceUrl: faceUrl,
                    showName: showName,
                    type: conversation.type,
                  ),
                ),
                Expanded(
                    child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 10, bottom: isDesktopScreen ? 12 : 19),
                  decoration: isDesktopScreen ? null : const BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Color(0xFFDBDBDB)))),
                  child: Text(
                    showName,
                    // textAlign: TextAlign.center,
                    style:
                    TextStyle(color: const Color(0xFF111111), fontSize: isDesktopScreen ? 16 : 18),
                  ),
                ))
              ],
            ),
          ),
        ))
      ],
    );
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;

    if (!widget.isMultiSelect) {
      _selectedConversation.clear();
    }
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _conversationViewModel),
      ],
      builder: (context, w) {
        final recentConvList =
            serviceLocator<TUIConversationViewModel>().conversationList;
        final showList = _buildMemberList(recentConvList);
        final isDesktopScreen =
            TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;

        return AZListViewContainer(
          memberList: showList,
          isShowIndexBar: false,
          susItemBuilder: (context, index) {
            return isDesktopScreen ? Container() : Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 16.0),
              color: theme.weakDividerColor,
              alignment: Alignment.centerLeft,
              child: Text(
                TIM_t("最近联系人"),
                softWrap: true,
                style: TextStyle(
                  fontSize: 14.0,
                  color: theme.weakTextColor,
                ),
              ),
            );
          },
          itemBuilder: (context, index) {
            final conversation = showList[index].memberInfo;
            if (conversation != null) {
              return _buildItem(conversation);
            } else {
              return Container();
            }
          },
        );
      },
    );
  }
}
