// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:tencent_im_base/tencent_im_base.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/life_cycle/profile_life_cycle.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/model/profile_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_friendship_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/conversation/conversation_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/core_services_implements.dart';
import 'package:tencent_cloud_chat_uikit/data_services/friendShip/friendship_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/message/message_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';

class TUIProfileViewModel extends ChangeNotifier {
  final ConversationService _conversationService =
      serviceLocator<ConversationService>();
  final FriendshipServices _friendshipServices =
      serviceLocator<FriendshipServices>();
  final TUIFriendShipViewModel _friendShipViewModel =
      serviceLocator<TUIFriendShipViewModel>();
  final CoreServicesImpl _coreServices = serviceLocator<CoreServicesImpl>();
  final MessageService _messageService = serviceLocator<MessageService>();

  UserProfile? _userProfile;
  ProfileLifeCycle? _lifeCycle;
  bool? _shouldAddToBlackList;
  int _friendType = 0;
  bool? _isDisturb;

  UserProfile? get userProfile {
    return _userProfile;
  }

  set userProfile(UserProfile? value) {
    _userProfile = value;
    notifyListeners();
  }

  bool? get isDisturb {
    return _isDisturb;
  }

  bool? get isAddToBlackList {
    return _shouldAddToBlackList;
  }

  int get friendType {
    return _friendType;
  }

  set lifeCycle(ProfileLifeCycle? value) {
    _lifeCycle = value;
  }

  loadData({required String userID, bool isNeedConversation = true}) async {
    if(userID.isEmpty){
      return;
    }
    V2TimFriendInfo? friendUserInfo;
    V2TimConversation? conversation;
    final userInfoList =
        await _friendshipServices.getFriendsInfo(userIDList: [userID]);
    final checkFriend = await _friendshipServices.checkFriend(
        userIDList: [userID],
        checkType: FriendTypeEnum.V2TIM_FRIEND_TYPE_SINGLE);

    if (checkFriend != null) {
      final res = checkFriend.first;
      if (res.resultCode == 0) {
        _friendType = res.resultType;
      }
    }

    if (userInfoList != null) {
      friendUserInfo = userInfoList[0].friendInfo;
    }

    if (isNeedConversation) {
      conversation = await _conversationService.getConversation(
          conversationID: "c2c_$userID");
      _isDisturb = conversation?.recvOpt == 2;
    }

    final friendInfo =
        await _lifeCycle?.didGetFriendInfo(friendUserInfo) ?? friendUserInfo;

    _isDisturb = conversation?.recvOpt == 2;
    _userProfile =
        UserProfile(friendInfo: friendInfo, conversation: conversation);

    _shouldAddToBlackList = _friendShipViewModel.blockList
            .indexWhere((element) => element.userID == userID) >
        -1;

    notifyListeners();
  }

  Future<V2TimCallback> pinedConversation(bool isPined, String convID) async {
    final res = await _conversationService.pinConversation(
        conversationID: convID, isPinned: isPined);
    _userProfile?.conversation!.isPinned = isPined;
    notifyListeners();
    return res;
  }

  Future<List<V2TimFriendOperationResult>?> addToBlackList(
      bool shouldAdd, String userID) async {
    if (_lifeCycle?.shouldAddToBlockList != null &&
        await _lifeCycle!.shouldAddToBlockList(userID) == false) {
      return null;
    }
    if (shouldAdd) {
      final res =
          await _friendshipServices.addToBlackList(userIDList: [userID]);
      if (res != null && res.isNotEmpty) {
        final result = res.first;
        if (result.resultCode == 0) {
          _shouldAddToBlackList = true;
          _friendType = 0;
        }
      }
      notifyListeners();
      return res;
    } else {
      final res =
          await _friendshipServices.deleteFromBlackList(userIDList: [userID]);
      if (res != null && res.isNotEmpty) {
        final result = res.first;
        if (result.resultCode == 0) {
          _shouldAddToBlackList = false;
          final checkFriend = await _friendshipServices.checkFriend(
              userIDList: [userID],
              checkType: FriendTypeEnum.V2TIM_FRIEND_TYPE_SINGLE);
          if (checkFriend != null) {
            final res = checkFriend.first;
            _friendType = res.resultType;
          }
        }
      }
      _friendShipViewModel.loadBlockListData();
      notifyListeners();
      return res;
    }
  }

  Future<V2TimFriendOperationResult?> deleteFriend(String userID) async {
    if (_lifeCycle?.shouldDeleteFriend != null &&
        await _lifeCycle!.shouldDeleteFriend(userID) == false) {
      return null;
    }
    final res = await _friendshipServices.deleteFromFriendList(
        userIDList: [userID],
        deleteType: FriendTypeEnum.V2TIM_FRIEND_TYPE_BOTH);
    if (res != null) {
      loadData(userID: userID);
      return res.first;
    }
    return null;
  }

  Future<V2TimCallback> changeFriendVerificationMethod(int allowType) async {
    final res = await _coreServices.setSelfInfo(
      userFullInfo: V2TimUserFullInfo.fromJson(
        {"allowType": allowType},
      ),
    );
    if (res.code == 0) {
      _userProfile?.friendInfo!.userProfile!.allowType = allowType;
      notifyListeners();
    }
    return res;
  }

  // 1：男 女：2
  Future<V2TimCallback> updateGender(int gender) async {
    final res = await _coreServices.setSelfInfo(
      userFullInfo: V2TimUserFullInfo.fromJson(
        {"gender": gender},
      ),
    );
    if (res.code == 0) {
      _userProfile?.friendInfo!.userProfile!.gender = gender;
      notifyListeners();
    }

    return res;
  }

  Future<V2TimCallback> updateNickName(String nickName) async {
    final res = await _coreServices.setSelfInfo(
      userFullInfo: V2TimUserFullInfo.fromJson(
        {"nickName": nickName},
      ),
    );

    if (res.code == 0) {
      _userProfile?.friendInfo!.userProfile!.nickName = nickName;
      notifyListeners();
    }

    return res;
  }

  Future<V2TimCallback> updateSelfSignature(String selfSignature) async {
    final res = await _coreServices.setSelfInfo(
      userFullInfo: V2TimUserFullInfo.fromJson(
        {"selfSignature": selfSignature},
      ),
    );
    if (res.code == 0) {
      _userProfile?.friendInfo!.userProfile!.selfSignature = selfSignature;
      notifyListeners();
    }
    return res;
  }

  Future<V2TimFriendOperationResult?> addFriend(String userID) async {
    if (_lifeCycle?.shouldAddFriend != null &&
        await _lifeCycle!.shouldAddFriend(userID) == false) {
      return null;
    }
    final res = await _friendshipServices.addFriend(
        userID: userID, addType: FriendTypeEnum.V2TIM_FRIEND_TYPE_BOTH);
    if (res.code == 0) {
      loadData(userID: userID);
      return res.data;
    }
    return null;
  }

  Future<V2TimCallback> updateRemarks(String userID, String remark) async {
    final res = await _friendshipServices.setFriendInfo(
        userID: userID, friendRemark: remark);

    if (res.code == 0) {
      _userProfile?.friendInfo!.friendRemark = remark;
      notifyListeners();
    }
    return res;
  }

  Future<V2TimCallback> setMessageDisturb(String userID, bool isDisturb) async {
    final res = await _messageService.setC2CReceiveMessageOpt(
        userIDList: [userID],
        opt: isDisturb
            ? ReceiveMsgOptEnum.V2TIM_RECEIVE_NOT_NOTIFY_MESSAGE
            : ReceiveMsgOptEnum.V2TIM_RECEIVE_MESSAGE);
    if (res.code == 0) {
      _isDisturb = isDisturb;
    }
    notifyListeners();
    return res;
  }

  updateUserInfo(String key, dynamic value) {
    if (key == "nickName") {
      _userProfile?.friendInfo!.userProfile?.nickName = value;
    }
    if (key == "faceUrl") {
      _userProfile?.friendInfo!.userProfile?.faceUrl = value;
    }
    if (key == "nickName") {
      _userProfile?.friendInfo!.userProfile?.nickName = value;
    }
    if (key == "selfSignature") {
      _userProfile?.friendInfo!.userProfile?.selfSignature = value;
    }
    if (key == "gender") {
      _userProfile?.friendInfo!.userProfile?.gender = value;
    }
    if (key == "allowType") {
      _userProfile?.friendInfo!.userProfile?.allowType = value;
    }
    if (key == "customInfo") {
      _userProfile?.friendInfo!.userProfile?.customInfo = value;
    }
    if (key == "role") {
      _userProfile?.friendInfo!.userProfile?.role = value;
    }
    if (key == "level") {
      _userProfile?.friendInfo!.userProfile?.level = value;
    }
    if (key == "birthday") {
      _userProfile?.friendInfo!.userProfile?.birthday = value;
    }
  }

  Future<V2TimCallback> updateSelfInfo(Map<String, dynamic> newSelfInfo) async {
    final res = await _coreServices.setSelfInfo(
      userFullInfo: V2TimUserFullInfo.fromJson(
        newSelfInfo,
      ),
    );
    if (res.code == 0) {
      newSelfInfo.forEach((key, value) {
        updateUserInfo(key, value);
      });

      notifyListeners();
    }
    return res;
  }
}
