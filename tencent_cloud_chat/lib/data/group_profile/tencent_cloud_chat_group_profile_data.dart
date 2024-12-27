import 'dart:math';

import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_group_profile_config.dart';
import 'package:tencent_cloud_chat/components/component_event_handlers/tencent_cloud_chat_group_profile_event_handlers.dart';
import 'package:tencent_cloud_chat/components/components_definition/tencent_cloud_chat_component_base_controller.dart';
import 'package:tencent_cloud_chat/components/components_definition/tencent_cloud_chat_component_builder.dart';
import 'package:tencent_cloud_chat/data/tencent_cloud_chat_data_abstract.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_lru.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_full_info.dart';

enum TencentCloudChatGroupProfileDataKeys { none, config, builder, membersChange, quitGroup }

class TencentCloudChatGroupProfileData<T> extends TencentCloudChatDataAB<T> {
  TencentCloudChatGroupProfileData(super.currentUpdatedFields);

  /// === Group Profile Config ===
  TencentCloudChatGroupProfileConfig _groupProfileConfig = TencentCloudChatGroupProfileConfig();

  TencentCloudChatGroupProfileConfig get groupProfileConfig => _groupProfileConfig;

  set groupProfileConfig(TencentCloudChatGroupProfileConfig value) {
    _groupProfileConfig = value;
    notifyListener(TencentCloudChatGroupProfileDataKeys.config as T);
  }

  /// ==== Event Handlers ====
  TencentCloudChatGroupProfileEventHandlers? groupProfileEventHandlers;

  /// === Group Profile Builder ===
  TencentCloudChatComponentBuilder? _groupProfileBuilder;

  TencentCloudChatComponentBuilder? get groupProfileBuilder => _groupProfileBuilder;

  String updateGroupID = "";

  set groupProfileBuilder(TencentCloudChatComponentBuilder? value) {
    _groupProfileBuilder = value;
    notifyListener(TencentCloudChatGroupProfileDataKeys.builder as T);
  }

  /// === Controller ===
  TencentCloudChatComponentBaseController? groupProfileController;

  TencentLRUCache<String, List<V2TimGroupMemberFullInfo?>> groupMemberListCache = TencentLRUCache<String, List<V2TimGroupMemberFullInfo?>>(capacity: 5);
  TencentLRUCache<String, V2TimGroupInfo?> groupInfoCache = TencentLRUCache<String, V2TimGroupInfo?>(capacity: 5);

  setGroupInfo(String? groupID, V2TimGroupInfo? groupInfo) {
    if (groupID != null && groupInfo != null) {
      groupInfoCache.set(groupID, groupInfo);
    }
  }

  Future<V2TimGroupInfo?> loadGroupInfo(String? groupID) async {
    if (TencentCloudChatUtils.checkString(groupID) != null) {
      final groupInfoList =
          await TencentCloudChat.instance.chatSDKInstance.groupSDK.getGroupsInfo(groupIDList: [groupID ?? ""]);
      setGroupInfo(groupID!, groupInfoList?.first.groupInfo);
      return groupInfoList?.first.groupInfo;
    }
    return null;
  }

  updateGroupMemberInfo(String groupID, List<V2TimGroupMemberChangeInfo> groupMemberList ) async {
    final targetList = getGroupMemberList(groupID);
    if(targetList.isNotEmpty) {
      final memberIDs = groupMemberList.map((e) => e.userID).whereType<String>().toList();
      final fullMemberInfo = await _getGroupMemberFullInfo(memberIDs, groupID);
      if(fullMemberInfo.isNotEmpty) {
        for (var memberInfo in fullMemberInfo) {
          final targetIndex = targetList.indexWhere((e) => e?.userID == memberInfo.userID);
          if(targetIndex > -1) {
            targetList[targetIndex] = memberInfo;
          }
        }
        updateGroupID = groupID;
        groupMemberListCache.set(groupID, targetList);
        notifyListener(TencentCloudChatGroupProfileDataKeys.membersChange as T);
      }
    }
  }

  deleteGroupMember(String groupID, List<V2TimGroupMemberInfo> groupMemberList) {
    final targetList = getGroupMemberList(groupID);
    if(targetList.isNotEmpty) {
      final memberList = groupMemberList.map((e) => e.userID).whereType<String>().toList();
      targetList.removeWhere((e) => memberList.contains(e?.userID));
      updateGroupID = groupID;
      groupMemberListCache.set(groupID, targetList);
      notifyListener(TencentCloudChatGroupProfileDataKeys.membersChange as T);
    }
  }

  addGroupMember(String groupID, List<V2TimGroupMemberInfo> groupMemberList) async {
    final targetList = getGroupMemberList(groupID);
    if(targetList.isNotEmpty) {
      final memberList = groupMemberList.map((e) => e.userID).whereType<String>().toList();
      final membersFullInfo = await _getGroupMemberFullInfo(memberList, groupID);
      if(membersFullInfo.isNotEmpty) {
         targetList.addAll(membersFullInfo);
         updateGroupID = groupID;
         groupMemberListCache.set(groupID, targetList);
         notifyListener(TencentCloudChatGroupProfileDataKeys.membersChange as T);
      }
    }
  }

  Future<List<V2TimGroupMemberFullInfo>> _getGroupMemberFullInfo(List<String> memberIDs, String groupID) async {
    final V2TimValueCallback(code: code, data: data) = await TencentCloudChat.instance.chatSDKInstance.groupSDK.getGroupMembersInfo(groupID: groupID, memberList: memberIDs);
    if(code == 0) {
      return data ?? [];
    }
    return [];
  }

  removeGroupInfo(String? groupID) {
    // 因为有了 LRU 所以暂时留空
  }

  V2TimGroupInfo? getGroupInfo(String? groupID) {
    return TencentCloudChatUtils.checkString(groupID) != null ? groupInfoCache.get(groupID!) : null;
  }

  setGroupMemberList(String groupID, List<V2TimGroupMemberFullInfo?> groupMemberList){
    groupMemberListCache.set(groupID, groupMemberList);
  }

  Future<List<V2TimGroupMemberFullInfo?>> loadGroupMemberList({String? groupID, required bool loadGroupAdminAndOwnerOnly, String nextSeq = "0",}) async {
    if (TencentCloudChatUtils.checkString(groupID) == null) {
      return [];
    }
    final res = await TencentCloudChat.instance.chatSDKInstance.groupSDK.getGroupMemberList(
      groupID: groupID!,
      filter: loadGroupAdminAndOwnerOnly
          ? GroupMemberFilterTypeEnum.V2TIM_GROUP_MEMBER_FILTER_ADMIN
          : GroupMemberFilterTypeEnum.V2TIM_GROUP_MEMBER_FILTER_ALL,
      nextSeq: nextSeq,
    );
    List<V2TimGroupMemberFullInfo?> list = [];
    if (res?.code == 0) {
      final result = res?.data;
      final List<V2TimGroupMemberFullInfo?> tempMemberList = result?.memberInfoList ?? [];
      list.addAll(tempMemberList);
      if (TencentCloudChatUtils.checkString(result?.nextSeq) != null && result!.nextSeq != "0") {
        list.addAll(await loadGroupMemberList(
          nextSeq: result.nextSeq!,
          groupID: groupID,
          loadGroupAdminAndOwnerOnly: loadGroupAdminAndOwnerOnly,
        ));
      }
    }

    if (nextSeq == "0") {
      if (loadGroupAdminAndOwnerOnly) {
        final res = await TencentCloudChat.instance.chatSDKInstance.groupSDK.getGroupMemberList(
          groupID: groupID,
          filter: GroupMemberFilterTypeEnum.V2TIM_GROUP_MEMBER_FILTER_OWNER,
          nextSeq: nextSeq,
        );
        list.insertAll(0, res?.data?.memberInfoList ?? []);
      }
      groupMemberListCache.set(groupID, list);
      updateGroupID = groupID;
      notifyListener(TencentCloudChatGroupProfileDataKeys.membersChange as T);
    }
    return list;
  }

  removeGroupMemberList(String? groupID) {
    if(TencentCloudChatUtils.checkString(groupID) != null){
      final targetList = getGroupMemberList(groupID);
      if(targetList.isNotEmpty){
        setGroupMemberList(groupID!, targetList.getRange(0, min(targetList.length - 1, 20)).toList());
      }
    }
  }

  List<V2TimGroupMemberFullInfo?> getGroupMemberList(String? groupID) {
    return (TencentCloudChatUtils.checkString(groupID) != null ? groupMemberListCache.get(groupID!) : []) ?? [];
  }

  void notifyQuitOrDismissGroup(String groupID) {
    updateGroupID = groupID;
    notifyListener(TencentCloudChatGroupProfileDataKeys.quitGroup as T);
  }

  @override
  void notifyListener(T key) {
    currentUpdatedFields = key;
    var event = TencentCloudChatGroupProfileData<T>(key);
    event.updateGroupID = updateGroupID;
    event._groupProfileConfig = _groupProfileConfig;
    event.groupProfileEventHandlers = groupProfileEventHandlers;
    event._groupProfileBuilder = _groupProfileBuilder;
    event.groupProfileController = groupProfileController;
    event.groupMemberListCache = groupMemberListCache;
    event.groupInfoCache = groupInfoCache;

    TencentCloudChat.instance.eventBusInstance.fire(event, "TencentCloudChatGroupProfileData");
  }

  @override
  void clear() {
    updateGroupID = "";
    groupMemberListCache.clear();
    groupInfoCache.clear();

  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}

