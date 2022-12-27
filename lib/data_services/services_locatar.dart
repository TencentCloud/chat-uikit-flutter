import 'package:get_it/get_it.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/listener_model/tui_group_listener_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_model_tools.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_conversation_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_friendship_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_setting_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/conversation/conversation_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/conversation/conversation_services_implements.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/core_services_implements.dart';
import 'package:tencent_cloud_chat_uikit/data_services/friendShip/friendship_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/friendShip/friendship_services_implements.dart';
import 'package:tencent_cloud_chat_uikit/data_services/group/group_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/group/group_services_implement.dart';
import 'package:tencent_cloud_chat_uikit/data_services/message/message_service_implement.dart';
import 'package:tencent_cloud_chat_uikit/data_services/message/message_services.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_search_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_self_info_view_model.dart';
import 'package:tencent_im_base/theme/tui_theme_view_model.dart';

final serviceLocator = GetIt.instance;
bool boolIsInitailized = false;

void setupServiceLocator() {
  if (!boolIsInitailized) {
    // setting
    serviceLocator.registerSingleton<TUISettingModel>(TUISettingModel());

    // services
    serviceLocator.registerSingleton<CoreServicesImpl>(CoreServicesImpl());
    serviceLocator
        .registerSingleton<TUISelfInfoViewModel>(TUISelfInfoViewModel());
    serviceLocator
        .registerSingleton<ConversationService>(ConversationServicesImpl());
    serviceLocator.registerSingleton<MessageService>(MessageServiceImpl());
    serviceLocator
        .registerSingleton<FriendshipServices>(FriendshipServicesImpl());
    serviceLocator.registerSingleton<GroupServices>(GroupServicesImpl());

    // view models
    serviceLocator.registerSingleton<TUIChatGlobalModel>(TUIChatGlobalModel());
    serviceLocator.registerSingleton<TUIChatModelTools>(TUIChatModelTools());
    serviceLocator.registerSingleton<TUIConversationViewModel>(
        TUIConversationViewModel());
    serviceLocator
        .registerSingleton<TUIFriendShipViewModel>(TUIFriendShipViewModel());
    serviceLocator.registerSingleton<TUIThemeViewModel>(TUIThemeViewModel());
    serviceLocator.registerSingleton<TUISearchViewModel>(TUISearchViewModel());

    // listener models
    serviceLocator
        .registerSingleton<TUIGroupListenerModel>(TUIGroupListenerModel());
    boolIsInitailized = true;
  }
}
