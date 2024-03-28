import 'package:tencent_cloud_chat/data/tencent_cloud_chat_data_abstract.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';

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
  addFriendCode,
  deleteConversationCode,
  friendGroup,
  groupApplicationList
}

/// A class that manages data for TencentCloudChat Contact component.
///
/// This class extends [TencentCloudChatUIKitCoreDataAB] and provides
/// functionality for managing the status of the UIKit Contact component.
class TencentCloudChatContactData<T> extends TencentCloudChatDataAB<T> {
  TencentCloudChatContactData(super.currentUpdatedFields);

  /// === friend application list ===
  final List<V2TimFriendApplication> _applicationList = [];

  void buildApplicationList(List<V2TimFriendApplication> applicationList, String action) {
    for (var element in applicationList) {
      var index = _applicationList.indexWhere((ele) => element.userID == ele.userID);
      if (index > -1) {
        _applicationList[index] = element;
      } else {
        _applicationList.add(element);
      }
    }
    console(
      logs: "$action buildApplicationList ${applicationList.length} changed. total application length is ${_applicationList.length}",
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
      logs: "$action buildApplicationList ${applicationList.length} changed. total application length is ${_applicationList.length}",
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
    for (var element in groupList) {
      var index = _groupList.indexWhere((ele) => element.groupID == ele.groupID);
      if (index > -1) {
        _groupList[index] = element;
      } else {
        _groupList.add(element);
      }
    }
    notifyListener(TencentCloudChatContactDataKeys.groupList as T);
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
    for (var element in contactList) {
      var index = _contactList.indexWhere((ele) => ele.userID == element);
      if (index > -1) {
        _contactList.removeAt(index);
      }
    }
    notifyListener(TencentCloudChatContactDataKeys.contactList as T);
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

  /// === add friend result code and friend ID ===
  int _addFriendCode = 0;
  String _addFriendID = "";

  /// === delete conversation result code ===
  int _deleteConversationCode = 0;

  void setApplicationUnreadCount(int count) {
    _applicationUnreadCount = count;
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

  int get addFriendCode => _addFriendCode;
  String get addFriendID => _addFriendID;
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
      logs: "$action buildUserStatusList ${_userStatus.length} changed. total userStatus length is ${_userStatus.length}",
    );
    notifyListener(TencentCloudChatContactDataKeys.userStatusList as T);
  }

  void setAddFriendCode(int code, String userID) {
    _addFriendCode = code;
    _addFriendID = userID;
    notifyListener(TencentCloudChatContactDataKeys.addFriendCode as T);
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
    for (var element in groupApplicationList) {
      var index = _groupApplicationList.indexWhere((ele) => element.groupID == ele.groupID && element.fromUser == ele.fromUser);
      if (index > -1) {
        _groupApplicationList[index] = element;
      } else {
        _groupApplicationList.add(element);
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
    currentUpdatedFields = key;
    TencentCloudChat.eventBusInstance.fire(this);
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
