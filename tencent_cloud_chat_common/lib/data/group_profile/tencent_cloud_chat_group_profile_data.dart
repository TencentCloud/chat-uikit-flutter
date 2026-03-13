import 'dart:math';
import 'dart:async';

import 'package:tencent_cloud_chat_common/components/component_config/tencent_cloud_chat_group_profile_config.dart';
import 'package:tencent_cloud_chat_common/components/component_event_handlers/tencent_cloud_chat_group_profile_event_handlers.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_base_controller.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_builder.dart';
import 'package:tencent_cloud_chat_common/data/tencent_cloud_chat_data_abstract.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_lru.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_full_info.dart';

enum TencentCloudChatGroupProfileDataKeys { none, config, builder, membersChange, quitGroup, joinGroup, updateGroupInfo, updateMemberRole }

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
  V2TimGroupInfo updateGroupInfo = V2TimGroupInfo(groupID: '', groupType: '');
  List<V2TimGroupMemberInfo> updateMemberList = [];
  int updateMemberRole = GroupMemberRoleType.V2TIM_GROUP_MEMBER_UNDEFINED;

  set groupProfileBuilder(TencentCloudChatComponentBuilder? value) {
    _groupProfileBuilder = value;
    notifyListener(TencentCloudChatGroupProfileDataKeys.builder as T);
  }

  /// === Controller ===
  TencentCloudChatComponentBaseController? groupProfileController;

  TencentLRUCache<String, List<V2TimGroupMemberFullInfo?>> groupMemberListCache = TencentLRUCache<String, List<V2TimGroupMemberFullInfo?>>(capacity: 5);

  // Track loading state per groupID to prevent duplicate calls
  final Map<String, bool> _loadingGroups = {};
  // Track last load time per groupID to prevent rapid successive calls
  final Map<String, DateTime> _lastLoadTime = {};
  // Track pending futures to reuse them
  final Map<String, Future<List<V2TimGroupMemberFullInfo?>>> _pendingLoads = {};
  // Minimum time between loads for the same group (2 seconds to prevent rapid loops)
  static const Duration _minLoadInterval = Duration(seconds: 2);

  updateGroupMemberInfo(String groupID, List<V2TimGroupMemberChangeInfo> groupMemberList) async {
    final targetList = getGroupMemberList(groupID);
    if(targetList.isNotEmpty) {
      final memberIDs = groupMemberList.map((e) => e.userID).whereType<String>().toList();
      final fullMemberInfo = await _getGroupMemberFullInfo(memberIDs, groupID);
      if(fullMemberInfo.isNotEmpty) {
        // Re-read from cache after async call to get the latest state
        final currentList = getGroupMemberList(groupID);
        for (var memberInfo in fullMemberInfo) {
          final targetIndex = currentList.indexWhere((e) => e?.userID == memberInfo.userID);
          if(targetIndex > -1) {
            currentList[targetIndex] = memberInfo;
          }
        }
        updateGroupID = groupID;
        groupMemberListCache.set(groupID, currentList);
        notifyListener(TencentCloudChatGroupProfileDataKeys.membersChange as T);
      }
    }
  }

  updateGroupMemberRole(String groupID, List<V2TimGroupMemberInfo> groupMemberList, int roleType) {
    updateGroupID = groupID;
    updateMemberList = groupMemberList;
    updateMemberRole = roleType;
    notifyListener(TencentCloudChatGroupProfileDataKeys.updateMemberRole as T);
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
      // Deduplicate: only fetch info for members not already in the list
      final existingUserIDs = targetList.map((e) => e?.userID).whereType<String>().toSet();
      final newMemberIDs = memberList.where((id) => !existingUserIDs.contains(id)).toList();
      if (newMemberIDs.isEmpty) return;
      final membersFullInfo = await _getGroupMemberFullInfo(newMemberIDs, groupID);
      if(membersFullInfo.isNotEmpty) {
         // Re-read from cache after async call to get the latest state
         // (cache may have been replaced by loadGroupMemberList during the await)
         final currentList = getGroupMemberList(groupID);
         final currentUserIDs = currentList.map((e) => e?.userID).whereType<String>().toSet();
         final trulyNewMembers = membersFullInfo.where((m) => !currentUserIDs.contains(m.userID)).toList();
         if (trulyNewMembers.isEmpty) return;
         currentList.addAll(trulyNewMembers);
         updateGroupID = groupID;
         groupMemberListCache.set(groupID, currentList);
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

  setGroupMemberList(String groupID, List<V2TimGroupMemberFullInfo?> groupMemberList){
    groupMemberListCache.set(groupID, groupMemberList);
  }

  Future<List<V2TimGroupMemberFullInfo?>> loadGroupMemberList({String? groupID, required bool loadGroupAdminAndOwnerOnly, String nextSeq = "0",}) async {
    if (TencentCloudChatUtils.checkString(groupID) == null) {
      return [];
    }
    
    // Only apply debouncing for initial load (nextSeq == "0")
    if (nextSeq == "0") {
      // Check if already loading for this group
      if (_loadingGroups[groupID!] == true) {
        // Return pending future if exists
        if (_pendingLoads.containsKey(groupID)) {
          return _pendingLoads[groupID]!;
        }
      }

      // Check if we recently loaded this group
      final lastLoadTime = _lastLoadTime[groupID];
      if (lastLoadTime != null) {
        final timeSinceLastLoad = DateTime.now().difference(lastLoadTime);
        if (timeSinceLastLoad < _minLoadInterval) {
          // Too soon, return cached data if available
          final cachedList = getGroupMemberList(groupID);
          if (cachedList.isNotEmpty) {
            // Return cached data to prevent duplicate calls
            return cachedList;
          }
          // If no cache, wait a bit and try again
          await Future.delayed(_minLoadInterval - timeSinceLastLoad);
        }
      }

      // Mark as loading
      _loadingGroups[groupID] = true;
      _lastLoadTime[groupID] = DateTime.now();
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
      // Deduplicate by userID before caching (defense in depth against any source of duplicates)
      final seen = <String>{};
      final dedupedList = <V2TimGroupMemberFullInfo?>[];
      for (final member in list) {
        if (member != null && seen.add(member.userID)) {
          dedupedList.add(member);
        }
      }
      groupMemberListCache.set(groupID, dedupedList);
      updateGroupID = groupID;
      
      // Create and store the future before notifying
      final completedFuture = Future.value(dedupedList);
      _pendingLoads[groupID] = completedFuture;
      
      notifyListener(TencentCloudChatGroupProfileDataKeys.membersChange as T);
      
      // Clear loading state after a delay to prevent rapid successive calls
      Future.delayed(_minLoadInterval, () {
        _loadingGroups[groupID] = false;
        _pendingLoads.remove(groupID);
      });
      return dedupedList;
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
    final cached = TencentCloudChatUtils.checkString(groupID) != null ? groupMemberListCache.get(groupID!) : null;
    // Return a defensive copy to prevent external mutation of the cached list
    return cached != null ? List<V2TimGroupMemberFullInfo?>.from(cached) : [];
  }

  @override
  void notifyListener(T key) {
    currentUpdatedFields = key;
    var event = TencentCloudChatGroupProfileData<T>(key);
    event.updateGroupID = updateGroupID;
    event.updateGroupInfo = updateGroupInfo;
    event.updateMemberList = updateMemberList;
    event.updateMemberRole = updateMemberRole;
    event._groupProfileConfig = _groupProfileConfig;
    event.groupProfileEventHandlers = groupProfileEventHandlers;
    event._groupProfileBuilder = _groupProfileBuilder;
    event.groupProfileController = groupProfileController;
    event.groupMemberListCache = groupMemberListCache;

    TencentCloudChat.instance.eventBusInstance.fire(event, "TencentCloudChatGroupProfileData");
  }

  @override
  void clear() {
    updateGroupID = "";
    groupMemberListCache.clear();
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}

