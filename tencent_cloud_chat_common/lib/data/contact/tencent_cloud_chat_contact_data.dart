import 'package:tencent_cloud_chat_common/components/component_config/tencent_cloud_chat_contact_config.dart';
import 'package:tencent_cloud_chat_common/components/component_event_handlers/tencent_cloud_chat_contact_event_handlers.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_base_controller.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_builder.dart';
import 'package:tencent_cloud_chat_common/data/group_profile/tencent_cloud_chat_group_profile_data.dart';
import 'package:tencent_cloud_chat_common/data/tencent_cloud_chat_data_abstract.dart';
import 'package:tencent_cloud_chat_common/eventbus/tencent_cloud_chat_eventbus.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';

/// An enumeration of contact data keys for TencentCloudChat Contact component
enum TencentCloudChatContactDataKeys {
  none,
  applicationList,
  groupNotificationList,
  groupList,
  blockList,
  contactList,
  applicationCount,
  applicationCode,
  userStatusList,
  deleteConversationCode,
  friendGroup,
  groupApplicationList,
  config,
  eventHandlers,
  builder,
}

/// A class that manages data for TencentCloudChat Contact component.
///
/// This class extends [TencentCloudChatUIKitCoreDataAB] and provides
/// functionality for managing the status of the UIKit Contact component.
class TencentCloudChatContactData<T> extends TencentCloudChatDataAB<T> {
  TencentCloudChatContactData(super.currentUpdatedFields);

  final String _groupFaceURL = "https://im.sdk.qcloud.com/download/tuikit-resource/group-avatar/group_avatar_%s.png";
  final int _groupFaceCount = 24;

  String get groupFaceURL => _groupFaceURL;

  int get groupFaceCount => _groupFaceCount;

  /// === Config ===
  TencentCloudChatContactConfig _contactConfig = TencentCloudChatContactConfig();

  TencentCloudChatContactConfig get contactConfig => _contactConfig;

  set contactConfig(TencentCloudChatContactConfig value) {
    _contactConfig = value;
    notifyListener(TencentCloudChatContactDataKeys.config as T);
  }

  /// === Event Handlers ===
  TencentCloudChatContactEventHandlers? contactEventHandlers;

  /// === Contact Builder ===
  TencentCloudChatComponentBuilder? _contactBuilder;

  TencentCloudChatComponentBuilder? get contactBuilder => _contactBuilder;

  set contactBuilder(TencentCloudChatComponentBuilder? value) {
    _contactBuilder = value;
    notifyListener(TencentCloudChatContactDataKeys.builder as T);
  }

  /// === Controller ===
  TencentCloudChatComponentBaseController? contactController;

  /// === friend application list ===
  final List<V2TimFriendApplication> _applicationList = [];

  void buildApplicationList(List<V2TimFriendApplication> applicationList, String action) {
    for (var element in applicationList) {
      if (element.type == 1) {
        var index = _applicationList.indexWhere((ele) => element.userID == ele.userID);
        if (index > -1) {
          _applicationList[index] = element;
        } else {
          _applicationList.add(element);
        }
      }
    }
    console(
      logs:
          "$action buildApplicationList ${applicationList.length} changed. total application length is ${_applicationList.length}",
    );
    notifyListener(TencentCloudChatContactDataKeys.applicationList as T);
  }

  void deleteApplicationList(List<String> applicationList, String action) {
    for (String id in applicationList) {
      var index = _applicationList.indexWhere((element) => element.userID == id);
      if (index > -1) {
        _applicationList.removeAt(index);
      }
    }
    console(
      logs:
          "$action buildApplicationList ${applicationList.length} changed. total application length is ${_applicationList.length}",
    );
    notifyListener(TencentCloudChatContactDataKeys.applicationList as T);
  }

  /// === friend response type ===
  FriendResponseTypeEnum responseType = FriendResponseTypeEnum.V2TIM_FRIEND_ACCEPT_AGREE_AND_ADD;

  /// === friend application type ===
  FriendApplicationTypeEnum applicationType = FriendApplicationTypeEnum.V2TIM_FRIEND_APPLICATION_COME_IN;

  /// === handle application code and userID===
  int _applicationCode = 0;
  String _applicationUserID = "";

  void setApplicationCode(int code, String userID) {
    _applicationCode = code;
    _applicationUserID = userID;
    notifyListener(TencentCloudChatContactDataKeys.applicationCode as T);
  }

  /// === joined group list ===
  final List<V2TimGroupInfo> _groupList = [];

  void buildGroupList(List<V2TimGroupInfo> groupList, String action) {
    _groupList.clear();
    _groupList.addAll(groupList);
    notifyListener(TencentCloudChatContactDataKeys.groupList as T);
  }

  void addGroupInfoToJoinedGroupList(V2TimGroupInfo groupInfo) {
    int index = _groupList.indexWhere((element) => element.groupID == groupInfo.groupID);
    if (index < 0) {
      _groupList.add(groupInfo);
    }

    var groupProfileEvent = TencentCloudChatGroupProfileData(TencentCloudChatGroupProfileDataKeys.joinGroup);
    groupProfileEvent.updateGroupInfo = groupInfo;
    TencentCloudChat.instance.eventBusInstance.fire(groupProfileEvent, TencentCloudChatEventBus.eventNameGroup);
  }

  void deleteGroupInfoFromJoinedGroupList(String groupID) {
    _groupList.removeWhere((element) => element.groupID == groupID);

    var groupProfileEvent = TencentCloudChatGroupProfileData(TencentCloudChatGroupProfileDataKeys.quitGroup);
    groupProfileEvent.updateGroupID = groupID;
    TencentCloudChat.instance.eventBusInstance.fire(groupProfileEvent, TencentCloudChatEventBus.eventNameGroup);
  }

  void updateGroupInfo(String groupID, List<V2TimGroupChangeInfo> changeInfoList) {
    int index = _groupList.indexWhere((groupInfo) => groupInfo.groupID == groupID);
    if (index >= 0) {
      var groupInfo = _groupList[index];
      for (V2TimGroupChangeInfo changeInfo in changeInfoList) {
        if (changeInfo.type == GroupChangeInfoType.V2TIM_GROUP_INFO_CHANGE_TYPE_NAME) {
          groupInfo.groupName = changeInfo.value;
        } else if (changeInfo.type == GroupChangeInfoType.V2TIM_GROUP_INFO_CHANGE_TYPE_FACE_URL) {
          groupInfo.faceUrl = changeInfo.value;
        } else if (changeInfo.type == GroupChangeInfoType.V2TIM_GROUP_INFO_CHANGE_TYPE_INTRODUCTION) {
          groupInfo.introduction = changeInfo.value;
        } else if (changeInfo.type == GroupChangeInfoType.V2TIM_GROUP_INFO_CHANGE_TYPE_NOTIFICATION) {
          groupInfo.notification = changeInfo.value;
        } else if (changeInfo.type == GroupChangeInfoType.V2TIM_GROUP_INFO_CHANGE_TYPE_SHUT_UP_ALL) {
          groupInfo.isAllMuted = changeInfo.boolValue;
        } else if (changeInfo.type == GroupChangeInfoType.V2TIM_GROUP_INFO_CHANGE_TYPE_RECEIVE_MESSAGE_OPT) {
          groupInfo.recvOpt = changeInfo.intValue;
        } else if (changeInfo.type == GroupChangeInfoType.V2TIM_GROUP_INFO_CHANGE_TYPE_GROUP_ADD_OPT) {
          groupInfo.groupAddOpt = changeInfo.intValue;
        } else if (changeInfo.type == GroupChangeInfoType.V2TIM_GROUP_INFO_CHANGE_TYPE_OWNER) {
          groupInfo.owner = changeInfo.value;
        } else if (changeInfo.type == GroupChangeInfoType.V2TIM_GROUP_INFO_CHANGE_TYPE_CUSTOM) {
          if (changeInfo.key != null) {
            groupInfo.customInfo?[changeInfo.key!] = changeInfo.value ?? '';
          }
        }
      }

      var groupProfileEvent = TencentCloudChatGroupProfileData(TencentCloudChatGroupProfileDataKeys.updateGroupInfo);
      groupProfileEvent.updateGroupID = groupID;
      groupProfileEvent.updateGroupInfo = groupInfo;
      TencentCloudChat.instance.eventBusInstance.fire(groupProfileEvent, TencentCloudChatEventBus.eventNameGroup);
    }
  }

  V2TimGroupInfo getGroupInfo(String groupID) {
    int index = _groupList.indexWhere((element) => element.groupID == groupID);
    if (index >= 0) {
      return _groupList[index];
    } else {
      V2TimGroupInfo groupInfo = V2TimGroupInfo(groupID: groupID, groupType: GroupType.Work);
      return groupInfo;
    }
  }

  /// === block list ===
  final List<V2TimFriendInfo> _blockList = [];

  void buildBlockList(List<V2TimFriendInfo> blockList, String action) {
    for (var element in blockList) {
      var index = _blockList.indexWhere((ele) => element.userID == ele.userID);
      if (index > -1) {
        _blockList[index] = element;
      } else {
        _blockList.add(element);
      }
    }
    notifyListener(TencentCloudChatContactDataKeys.blockList as T);
  }

  void deleteFromBlockList(List<String> blockList, String action) {
    for (var element in blockList) {
      var index = _blockList.indexWhere((ele) => ele.userID == element);
      if (index > -1) {
        _blockList.removeAt(index);
      }
    }
    notifyListener(TencentCloudChatContactDataKeys.blockList as T);
  }

  /// === friend list ===
  final List<V2TimFriendInfo> _contactList = [];

  void buildFriendList(List<V2TimFriendInfo> contactList, String action) {
    for (var element in contactList) {
      var index = _contactList.indexWhere((ele) => element.userID == ele.userID);
      if (index > -1) {
        _contactList[index] = element;
      } else {
        _contactList.add(element);
      }
    }
    console(
      logs: "$action buildFriendList ${contactList.length} changed. total contactList length is ${_contactList.length}",
    );
    notifyListener(TencentCloudChatContactDataKeys.contactList as T);
  }

  void deleteFromFriendList(List<String> contactList, String action) {
    bool needNotify = false;
    for (var element in contactList) {
      var index = _contactList.indexWhere((ele) => ele.userID == element);
      if (index > -1) {
        _contactList.removeAt(index);
        needNotify = true;
      }
    }

    if (needNotify) {
      console(
        logs:
            "$action deleteFromFriendList ${contactList.length} deleted. total contactList length is ${_contactList.length}",
      );
      notifyListener(TencentCloudChatContactDataKeys.contactList as T);
    }
  }

  /// === user online status ===
  final List<V2TimUserStatus> _userStatus = [];

  /// ===  friend group list ===
  final List<V2TimFriendGroup> _friendGroup = [];

  /// === group application list ===
  final List<V2TimGroupApplication> _groupApplicationList = [];

  /// === searched user list ===
  final List<V2TimUserFullInfo> _searchUserList = [];

  /// === total application unread count ===
  int _applicationUnreadCount = 0;

  /// === delete conversation result code ===
  int _deleteConversationCode = 0;

  void setApplicationUnreadCount(List<V2TimFriendApplication>? applicationList) {
    List<V2TimFriendApplication> filteredList = [];
    if (applicationList != null && applicationList.length > 0) {
      filteredList = applicationList.where((e) => e.type == 1).toList();
    }
    _applicationUnreadCount = filteredList.length;
    notifyListener(TencentCloudChatContactDataKeys.applicationCount as T);
  }

  List<V2TimFriendApplication> get applicationList => _applicationList;

  List<V2TimGroupInfo> get groupList => _groupList;

  List<V2TimFriendInfo> get blockList => _blockList;

  List<V2TimFriendInfo> get contactList => _contactList;

  List<V2TimUserStatus> get userStatus => _userStatus;

  List<V2TimFriendGroup> get friendGroup => _friendGroup;

  List<V2TimGroupApplication> get groupApplicationList => _groupApplicationList;

  List<V2TimUserFullInfo> get searchUserList => _searchUserList;

  int get applicationUnreadCount => _applicationUnreadCount;

  int get applicationCode => _applicationCode;

  String get applicationUserID => _applicationUserID;

  int get deleteConversationCode => _deleteConversationCode;

  bool getOnlineStatusByUserId({required String userID}) {
    bool res = false;
    int idx = _userStatus.indexWhere((element) => element.userID == userID);
    if (idx > -1) {
      if (_userStatus[idx].statusType == 1) {
        res = true;
      }
    }
    return res;
  }

  void buildUserStatusList(List<V2TimUserStatus> list, String action) {
    for (var element in list) {
      var index = _userStatus.indexWhere((ele) => element.userID == ele.userID);
      if (index > -1) {
        _userStatus[index] = element;
      } else {
        _userStatus.add(element);
      }
    }
    console(
      logs:
          "$action buildUserStatusList ${_userStatus.length} changed. total userStatus length is ${_userStatus.length}",
    );
    notifyListener(TencentCloudChatContactDataKeys.userStatusList as T);
  }

  void setDeleteConversationCode(int code) {
    _deleteConversationCode = code;
    notifyListener(TencentCloudChatContactDataKeys.deleteConversationCode as T);
  }

  void buildFriendGroup(List<V2TimFriendGroup> friendGroup, String action) {
    for (var element in friendGroup) {
      var index = _friendGroup.indexWhere((ele) => element.name == ele.name);
      if (index > -1) {
        _friendGroup[index] = element;
      } else {
        _friendGroup.add(element);
      }
    }
    notifyListener(TencentCloudChatContactDataKeys.blockList as T);
  }

  void buildGroupApplicationList(List<V2TimGroupApplication> groupApplicationList, String action) {
    _groupApplicationList.clear();
    for (var groupApplication in groupApplicationList) {
      if (groupApplication.handleStatus == GroupApplicationHandleStatus.V2TIM_GROUP_APPLICATION_HANDLE_STATUS_UNHANDLED) {
        _groupApplicationList.add(groupApplication);
      }
    }
    notifyListener(TencentCloudChatContactDataKeys.groupApplicationList as T);
  }

  void buildSearchUserList(List<V2TimUserFullInfo> userList, String aciton) {
    _searchUserList.clear();
    for (var element in userList) {
      _searchUserList.add(element);
    }
  }

  @override
  void notifyListener(T key) {
    var event = TencentCloudChatContactData<T>(key);
    event._contactConfig = _contactConfig;
    event.contactEventHandlers = contactEventHandlers;
    event._contactBuilder = _contactBuilder;
    event.contactController = contactController;
    event._applicationList.addAll(_applicationList);
    event.responseType = responseType;
    event.applicationType = applicationType;
    event._applicationCode = _applicationCode;
    event._applicationUserID = _applicationUserID;
    event._groupList.addAll(_groupList);
    event._blockList.addAll(_blockList);
    event._contactList.addAll(_contactList);
    event._userStatus.addAll(_userStatus);
    event._friendGroup.addAll(_friendGroup);
    event._groupApplicationList.addAll(_groupApplicationList);
    event._searchUserList.addAll(_searchUserList);
    event._applicationUnreadCount = _applicationUnreadCount;
    event._deleteConversationCode = _deleteConversationCode;

    TencentCloudChat.instance.eventBusInstance.fire(event, "TencentCloudChatContactData");
  }

  @override
  void clear() {
    _applicationList.clear();
    _groupList.clear();
    _blockList.clear();
    _contactList.clear();
    _userStatus.clear();
    _friendGroup.clear();
    _groupApplicationList.clear();
    _searchUserList.clear();
    _applicationUnreadCount = 0;
    _deleteConversationCode = 0;
    _applicationCode = 0;
    _applicationUserID = "";
  }

  @override
  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from({
      "applicationList": _applicationList.map((e) => e.toJson()).toList(),
      "responseType": responseType,
      "applicationType": applicationType,
      "groupList": _groupList.map((e) => e.toJson()).toList(),
      "blockList": _blockList.map((e) => e.toJson()).toList(),
      "contactList": _contactList.map((e) => e.toJson()).toList(),
      "applicationCount": applicationUnreadCount,
    });
  }
}
