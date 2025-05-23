// ignore_for_file: unnecessary_getters_setters

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:tencent_chat_i18n_tool/tencent_chat_i18n_tool.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimGroupListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/group_change_info_type.dart';
import 'package:tencent_cloud_chat_sdk/manager/v2_tim_manager.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_change_info.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_group_change_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_info.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_group_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_info_result.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_group_info_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_info.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_group_member_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_topic_info.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_topic_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_value_callback.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/group/group_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

enum UpdateType { groupInfo, memberList, joinApplicationList, groupDismissed, kickedFromGroup }

class NeedUpdate {
  final String groupID;
  final UpdateType updateType;
  final String extraData;
  int? groupInfoSubType;
  String? ownerID;

  NeedUpdate(this.groupID, this.updateType, this.extraData);
}

class TUIGroupListenerModel extends ChangeNotifier {
  final GroupServices _groupServices = serviceLocator<GroupServices>();
  V2TimGroupListener? _groupListener;
  NeedUpdate? _needUpdate;
  final TUIChatGlobalModel chatViewModel = serviceLocator<TUIChatGlobalModel>();
  late CoreServicesImpl coreInstance = TIMUIKitCore.getInstance();
  late V2TIMManager sdkInstance = TIMUIKitCore.getSDKInstance();

  NeedUpdate? get needUpdate => _needUpdate;

  set needUpdate(NeedUpdate? value) {
    Future.delayed(const Duration(seconds: 0), () {
      _needUpdate = value;
    });
  }

  TUIGroupListenerModel() {
    _groupListener = V2TimGroupListener(onMemberInvited: (groupID, opUser, memberList) {
      _needUpdate = NeedUpdate(groupID, UpdateType.memberList, "");
      notifyListeners();
    }, onMemberKicked: (groupID, opUser, memberList) async {
      if (_isLoginUserKickedFromGroup(groupID, memberList)) {
        _deleteGroupConversation(groupID);

        final groupName = await _getGroupName(groupID);
        _needUpdate = NeedUpdate(groupID, UpdateType.kickedFromGroup, groupName);
        notifyListeners();
      }
    }, onMemberEnter: (String groupID, List<V2TimGroupMemberInfo> memberList) {
      _needUpdate = NeedUpdate(groupID, UpdateType.memberList, "");
      notifyListeners();
    }, onMemberLeave: (String groupID, V2TimGroupMemberInfo member) {
      _needUpdate = NeedUpdate(groupID, UpdateType.memberList, "");
      notifyListeners();
    }, onGroupInfoChanged: (groupID, changeInfos) {
      _needUpdate = NeedUpdate(groupID, UpdateType.groupInfo, "");
      for (V2TimGroupChangeInfo info in changeInfos) {
        if (info.type == GroupChangeInfoType.V2TIM_GROUP_INFO_CHANGE_TYPE_OWNER) {
          _needUpdate!.groupInfoSubType = GroupChangeInfoType.V2TIM_GROUP_INFO_CHANGE_TYPE_OWNER;
          _needUpdate!.ownerID = info.value;
        }
      }
      notifyListeners();
    }, onReceiveJoinApplication: (String groupID, V2TimGroupMemberInfo member, String opReason) async {
      _onReceiveJoinApplication(groupID, member, opReason);
      chatViewModel.refreshGroupApplicationList();
      notifyListeners();
    }, onGroupDismissed: (String groupID, V2TimGroupMemberInfo opUser) async {
      _deleteGroupConversation(groupID);
      final groupName = await _getGroupName(groupID);
      _needUpdate = NeedUpdate(groupID, UpdateType.groupDismissed, groupName);
      notifyListeners();
    });
  }

  setGroupListener() {
    _groupServices.addGroupListener(listener: _groupListener!);
  }

  removeGroupListener() {
    _groupServices.removeGroupListener(listener: _groupListener!);
  }

  getCommunityCategoryList(String groupID) async {
    final Map<String, String>? customInfo = await getCommunityCustomInfo(groupID);
    if (customInfo != null) {
      final String? categoryListString = customInfo["categoryList"];
      if (categoryListString != null && categoryListString.isNotEmpty) {
        return jsonDecode(categoryListString);
      }
    }
  }

  Future<Map<String, String>?> getCommunityCustomInfo(String groupID) async {
    V2TimValueCallback<List<V2TimGroupInfoResult>> res =
        await TencentImSDKPlugin.v2TIMManager.getGroupManager().getGroupsInfo(groupIDList: [groupID]);
    if (res.code != 0) {
      final V2TimGroupInfoResult? groupInfo = res.data?[0];
      if (groupInfo != null) {
        Map<String, String>? customInfo = groupInfo.groupInfo?.customInfo;
        return customInfo;
      }
    }
    return null;
  }

  setCommunityCategoryList(String groupID, String groupType, List<String> newCategoryList) async {
    final Map<String, String>? customInfo = await getCommunityCustomInfo(groupID);
    customInfo?["categoryList"] = jsonEncode(newCategoryList);
    TencentImSDKPlugin.v2TIMManager.getGroupManager().setGroupInfo(
            info: V2TimGroupInfo(
          customInfo: customInfo,
          groupID: groupID,
          groupType: groupType,
          // ...其他资料
        ));
  }

  addCategoryForTopic(String groupID, String categoryName) {
    TencentImSDKPlugin.v2TIMManager.getGroupManager().setTopicInfo(
          topicInfo: V2TimTopicInfo(customString: categoryName),
        );
  }

  _onReceiveJoinApplication(String groupID, V2TimGroupMemberInfo member, String opReason) {
    Future.delayed(const Duration(milliseconds: 500), () => chatViewModel.refreshGroupApplicationList());
  }

  Future<String> _getGroupName(String groupID) async {
    final groupInfoList = await sdkInstance.getGroupManager().getGroupsInfo(groupIDList: [groupID]);
    String groupName = TIM_t("群组");
    if (groupInfoList.data != null) {
      groupName = groupInfoList.data!.first!.groupInfo!.groupName!;
    }
    return groupName;
  }

  void _deleteGroupConversation(String groupID) async {
    sdkInstance.getConversationManager().deleteConversation(conversationID: "group_${groupID}");
  }

  bool _isLoginUserKickedFromGroup(String groupID, List<V2TimGroupMemberInfo> memberList) {
    final loginUserInfo = coreInstance.loginInfo;
    int index = memberList.indexWhere((element) => element.userID == loginUserInfo.userID);
    if (index > -1) {
      return true;
    }
    return false;
  }
}
