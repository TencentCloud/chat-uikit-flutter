import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/core_services_implements.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_im_base/tencent_im_base.dart';

class TIMUIKitState<T extends StatefulWidget> extends TIMState<T> {
  final CoreServicesImpl _coreServices = serviceLocator<CoreServicesImpl>();

  ////////////////// 优化 setState //////////////////
  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }
  ////////////////// 优化 setState //////////////////

  @override
  void onTIMCallback(TIMCallback callbackValue) {
    super.onTIMCallback(callbackValue);
    _coreServices.callOnCallback(callbackValue);
  }

  @override
  Widget timBuild(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
            value: serviceLocator<TUIThemeViewModel>()),
      ],
      builder: (BuildContext context, Widget? w) {
        final theme = Provider.of<TUIThemeViewModel>(context).theme;
        final value = TUIKitBuildValue(theme: theme);
        return tuiBuild(context, value);
      },
    );
  }

  @required
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    return Container();
  }
}
