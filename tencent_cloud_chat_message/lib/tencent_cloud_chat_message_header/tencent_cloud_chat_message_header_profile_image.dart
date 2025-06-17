import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/components/component_options/tencent_cloud_chat_group_profile_options.dart';
import 'package:tencent_cloud_chat_common/components/component_options/tencent_cloud_chat_user_profile_options.dart';
import 'package:tencent_cloud_chat_common/router/tencent_cloud_chat_navigator.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/builders/tencent_cloud_chat_common_builders.dart';
import 'package:tencent_cloud_chat_common/widgets/avatar/tencent_cloud_chat_avatar.dart';

class TencentCloudChatMessageHeaderProfileImage extends StatefulWidget {
  final V2TimConversation? conversation;
  final List<V2TimGroupMemberFullInfo> Function() getGroupMembersInfo;
  final VoidCallback? startVoiceCall;
  final VoidCallback? startVideoCall;

  const TencentCloudChatMessageHeaderProfileImage({
    super.key,
    required this.getGroupMembersInfo,
    this.conversation,
    this.startVoiceCall,
    this.startVideoCall,
  });

  @override
  State<TencentCloudChatMessageHeaderProfileImage> createState() =>
      _TencentCloudChatMessageHeaderProfileImageState();
}

class _TencentCloudChatMessageHeaderProfileImageState
    extends TencentCloudChatState<TencentCloudChatMessageHeaderProfileImage> {
  List<String> getConversationFaceURL(V2TimConversation? conversation) {
    if (conversation == null) {
      return [""];
    }

    return [
      TencentCloudChatUtils.checkString(conversation.faceUrl) == null
          ? ""
          : conversation.faceUrl!
    ];
  }

  @override
  Widget? desktopBuilder(BuildContext context) {
    return GestureDetector(
      onTap: TencentCloudChatUtils.checkString(widget.conversation?.userID) !=
              null
          ? () => navigateToUserProfile(
                context: context,
                options: TencentCloudChatUserProfileOptions(
                  userID: widget.conversation!.userID!,
                  startVideoCall: widget.startVideoCall,
                  startVoiceCall: widget.startVoiceCall,
                ),
              )
          : TencentCloudChatUtils.checkString(widget.conversation?.groupID) !=
                  null
              ? () {
                Object? result = navigateToGroupProfile(
                  context: context,
                  options: TencentCloudChatGroupProfileOptions(
                    groupID: widget.conversation!.groupID!,
                  ),
                );
              }
              : null,
      child: TencentCloudChatCommonBuilders.getCommonAvatarBuilder(
        scene: TencentCloudChatAvatarScene.messageHeader,
        imageList: getConversationFaceURL(widget.conversation),
        width: getSquareSize(34),
        height: getSquareSize(34),
        borderRadius: getSquareSize(17),
      ),
    );
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (mounted) {
          if (TencentCloudChatUtils.checkString(widget.conversation?.userID) != null) {
            Object? result = await navigateToUserProfile(
              context: context,
              options: TencentCloudChatUserProfileOptions(
                userID: widget.conversation!.userID!,
                startVideoCall: widget.startVideoCall,
                startVoiceCall: widget.startVoiceCall,
              ),
            );

            if (result != null && (result is bool && result == true) && mounted) {
              Navigator.pop(context);
            }
          } else if (TencentCloudChatUtils.checkString(widget.conversation?.groupID) != null) {
            Object? result = await navigateToGroupProfile(
              context: context,
              options: TencentCloudChatGroupProfileOptions(
                groupID: widget.conversation!.groupID!,
              ),
            );

            if (result != null && (result is bool && result == true) && mounted) {
              Navigator.pop(context);
            }
          }
        }
      },
      child: TencentCloudChatCommonBuilders.getCommonAvatarBuilder(
        scene: TencentCloudChatAvatarScene.messageHeader,
        imageList: getConversationFaceURL(widget.conversation),
        width: getSquareSize(34),
        height: getSquareSize(34),
        borderRadius: getSquareSize(17),
      ),
    );
  }
}
