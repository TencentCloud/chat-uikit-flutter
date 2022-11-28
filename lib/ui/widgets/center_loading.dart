import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_statelesswidget.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';

import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

class CenterLoading extends TIMUIKitStatelessWidget {
  CenterLoading({Key? key, this.messageID}) : super(key: key);
  final String? messageID;
  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;

    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
              value: serviceLocator<TUIChatGlobalModel>()),
        ],
        builder: (context, w) {
          final progress = Provider.of<TUIChatGlobalModel>(context)
              .getMessageProgress(messageID);
          return (progress == 0 || progress == 100)
              ? Container()
              : Center(
                  child: CircularProgressIndicator(
                      value: progress / 100,
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation(theme.primaryColor)));
        });
  }
}
