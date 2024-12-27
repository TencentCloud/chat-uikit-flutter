import 'package:tencent_cloud_chat/components/components_definition/tencent_cloud_chat_component_base_controller.dart';
import 'package:tencent_cloud_chat/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_code_info.dart';
import 'package:tencent_cloud_chat_group_profile/model/tencent_cloud_chat_group_presenter.dart';

class TencentCloudChatGroupProfileController extends TencentCloudChatComponentBaseController {
  static TencentCloudChatGroupProfileController? _instance;

  TencentCloudChatGroupProfileController._internal();

  static TencentCloudChatGroupProfileController get instance {
    _instance ??= TencentCloudChatGroupProfileController._internal();
    return _instance!;
  }

  late V2TimGroupListener groupListener;
  TencentCloudChatGroupPresenter groupPresenter = TencentCloudChatGroupPresenter();

  void init() {
    groupListener = V2TimGroupListener(
      onAllGroupMembersMuted: (groupID, isMute) {},
      onApplicationProcessed: (groupID, opUser, isAgreeJoin, opReason) {},
      onGrantAdministrator: (groupID, opUser, memberList) {},
      onGroupAttributeChanged: (groupID, groupAttributeMap) {},
      onGroupCounterChanged: (groupID, key, newValue) {},
      onGroupCreated: (groupID) {},
      onGroupDismissed: (groupID, opUser) {
        handleQuitFromGroup(groupID);
      },
      onGroupInfoChanged: (groupID, changeInfos) {
        List<V2TimConversation> conversationList = TencentCloudChat.instance.dataInstance.conversation.conversationList;
        int index = conversationList.indexWhere((element) => element.conversationID == "group_${groupID}");
        if (index > -1) {
          V2TimConversation conversation = conversationList[index];
          for (int i = 0; i < changeInfos.length; i++) {
            switch (changeInfos[i].type) {
              case 1:
                conversation.showName = changeInfos[i].value;
                break;
              case 4:
                conversation.faceUrl = changeInfos[i].value;
                break;
              default:
                break;
            }
          }
          TencentCloudChat.instance.dataInstance.conversation
              .buildConversationList([conversation], "onGroupInfoChanged");
        }
      },
      onGroupRecycled: (groupID, opUser) {},
      onMemberEnter: (groupID, memberList) async {
        handleMemberEnter(groupID, memberList);
      },
      onMemberInfoChanged: (groupID, v2TIMGroupMemberChangeInfoList) {
        TencentCloudChat.instance.dataInstance.groupProfile
            .updateGroupMemberInfo(groupID, v2TIMGroupMemberChangeInfoList);
      },
      onMemberInvited: (groupID, opUser, memberList) {
        TencentCloudChat.instance.dataInstance.groupProfile.addGroupMember(groupID, memberList);
      },
      onMemberKicked: (groupID, opUser, memberList) {
        TencentCloudChat.instance.dataInstance.groupProfile.deleteGroupMember(groupID, memberList);
      },
      onMemberLeave: (groupID, member) {
        TencentCloudChat.instance.dataInstance.groupProfile.deleteGroupMember(groupID, [member]);
      },
      onMemberMarkChanged: (groupID, memberIDList, markType, enableMark) {},
      onQuitFromGroup: (groupID) {
        handleQuitFromGroup(groupID);
      },
      onReceiveJoinApplication: (groupID, member, opReason) {},
      onReceiveRESTCustomData: (groupID, customData) {},
      onRevokeAdministrator: (groupID, opUser, memberList) {},
    );

    TencentImSDKPlugin.v2TIMManager.addGroupListener(listener: groupListener);
  }

  void handleQuitFromGroup(String groupID) {
    TencentCloudChat.instance.dataInstance.groupProfile.notifyQuitOrDismissGroup(groupID);
  }

  void handleMemberEnter(String groupID, List<V2TimGroupMemberInfo> memberList) async {
    TencentCloudChat.instance.dataInstance.groupProfile.addGroupMember(groupID, memberList);
    for (var member in memberList) {
      if (member.userID == TencentCloudChat.instance.dataInstance.basic.currentUser?.userID) {
        var result = await groupPresenter.getGroupsInfo(groupIDList: [groupID]);
        if (result != null) {
          V2TimGroupInfoResult groupInfoResult = result[0];
          V2TimGroupInfo? groupInfo = groupInfoResult.groupInfo;
          if (groupInfo?.owner == member.userID) {
            return;
          }

          String groupName = groupInfo?.groupName ?? groupInfo?.groupID ?? '';
          TencentCloudChat.instance.callbacks.onUserNotificationEvent(
              TencentCloudChatComponentsEnum.contact,
              TencentCloudChatUserNotificationEvent(
                eventCode: 0,
                text: '${tL10n.joinedTip}$groupName',
              ));
        }
      }
    }
  }
}
