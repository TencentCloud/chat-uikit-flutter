import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/components/component_options/tencent_cloud_chat_message_options.dart';
import 'package:tencent_cloud_chat_common/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat_common/data/theme/text_style/text_style.dart';
import 'package:tencent_cloud_chat_common/router/tencent_cloud_chat_navigator.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/error_message_converter.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_code_info.dart';
import 'package:tencent_cloud_chat_contact/model/contact_presenter.dart';
import 'package:tencent_cloud_chat_contact/widgets/group_types_selector.dart';

class CreateGroupChat extends StatefulWidget {
  final List<V2TimFriendInfo> selectedMembers;

  CreateGroupChat({Key? key, required this.selectedMembers}) : super(key: key);

  @override
  State<CreateGroupChat> createState() {
    return _CreateGroupChatState();
  }
}

class _CreateGroupChatState extends TencentCloudChatState<CreateGroupChat> {
  ContactPresenter contactPresenter = ContactPresenter();
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController groupIdController = TextEditingController();
  String groupName = '';
  String groupID = '';
  String groupType = GroupType.Work;
  List<String> groupAvatars = [];
  int selectedAvatarIndex = 0;
  bool isCreating = false;

  Widget _buildTextField({required TextEditingController controller, required String hintText}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[500]),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!, width: 0.5),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!, width: 0.5),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!, width: 0.5),
        ),
      ),
    );
  }

  Widget _buildGroupTypeSelector() {
    return GestureDetector(
      onTap: () async {
        String selectGroupType = await Navigator.push(
            context, MaterialPageRoute(builder: (context) => GroupTypesSelector(selectedGroupType: groupType)));
        setState(() {
          groupType = selectGroupType;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tL10n.groupOfType,
              style: const TextStyle(fontSize: 16),
            ),
            Row(
              children: [
                Text(
                  groupType,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarList() {
    return SizedBox(
      height: 150,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
        itemCount: groupAvatars.length,
        itemBuilder: (context, index) {
          final isSelected = index == selectedAvatarIndex;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedAvatarIndex = index;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.transparent,
                        width: 2,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(groupAvatars[index]),
                      onBackgroundImageError: (_, __) {},
                      child: Container(),
                    ),
                  ),
                  if (isSelected)
                    const Positioned(
                      right: 0,
                      bottom: 0,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.check, size: 12, color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectedMemberList(TencentCloudChatTextStyle textStyle) {
    return Visibility(
      visible: widget.selectedMembers.isNotEmpty,
      child: SizedBox(
        height: 80,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.selectedMembers.length,
          itemBuilder: (context, index) {
            final member = widget.selectedMembers[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey[200],
                        child: ClipOval(
                          child: FadeInImage(
                            placeholder: const AssetImage(
                              'images/default_user_icon.png',
                              package: 'tencent_cloud_chat_common',
                            ),
                            image: NetworkImage(member.userProfile?.faceUrl ?? ''),
                            fit: BoxFit.cover,
                            imageErrorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                              return Image.asset(
                                'images/default_user_icon.png',
                                package: 'tencent_cloud_chat_common',
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.selectedMembers.removeAt(index);
                            });
                          },
                          child: const CircleAvatar(
                            radius: 6,
                            backgroundColor: Colors.red,
                            child: Icon(Icons.close, size: 8, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 50,
                    child: Text(
                      _getMemberName(member),
                      style: TextStyle(fontSize: textStyle.fontsize_12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  static String _getMemberName(V2TimFriendInfo friendInfo) {
    if (friendInfo.friendRemark != null && friendInfo.friendRemark!.isNotEmpty) {
      return friendInfo.friendRemark!;
    } else if (friendInfo.userProfile != null) {
      if (friendInfo.userProfile!.nickName != null &&
          friendInfo.userProfile!.nickName != null &&
          friendInfo.userProfile!.nickName!.isNotEmpty) {
        return friendInfo.userProfile!.nickName!;
      }
    }

    return friendInfo.userID;
  }

  _createGroup() async {
    if (isCreating) {
      return;
    }

    setState(() {
      groupName = groupNameController.text;
      groupID = groupIdController.text.isNotEmpty ? groupIdController.text : '';
    });

    if (groupType == GroupType.Community) {
      if (groupID.startsWith('@TGS#_')) {
        TencentCloudChat.instance.callbacks.onUserNotificationEvent(
            TencentCloudChatComponentsEnum.contact,
            TencentCloudChatUserNotificationEvent(
              eventCode: -1,
              text: tL10n.communityIDEditFormatTips,
            ));
      }
    } else {
      if (groupID.startsWith('@TGS#')) {
        TencentCloudChat.instance.callbacks.onUserNotificationEvent(
            TencentCloudChatComponentsEnum.contact,
            TencentCloudChatUserNotificationEvent(
              eventCode: -1,
              text: tL10n.groupIDEditFormatTips,
            ));
      }
    }

    if (groupID.length > 48) {
      TencentCloudChat.instance.callbacks.onUserNotificationEvent(
          TencentCloudChatComponentsEnum.contact,
          TencentCloudChatUserNotificationEvent(
            eventCode: -1,
            text: tL10n.groupIDEditExceedTips,
          ));
    }

    isCreating = true;

    List<V2TimGroupMember> memberList = [];
    for (var selectedMember in widget.selectedMembers) {
      V2TimGroupMember memberInfo =
          V2TimGroupMember(userID: selectedMember.userID, role: GroupMemberRoleTypeEnum.V2TIM_GROUP_MEMBER_ROLE_MEMBER);
      memberList.add(memberInfo);
    }
    final result = await contactPresenter.createGroup(
        groupType, groupID, groupName, groupAvatars[selectedAvatarIndex], memberList.isNotEmpty ? memberList : null);
    if (result.code == 0 && mounted) {
      Navigator.of(context).pop();
      navigateToMessage(
        context: context,
        options: TencentCloudChatMessageOptions(userID: null, groupID: result.data),
      );
    } else {
      isCreating = false;
      TencentCloudChat.instance.callbacks.onSDKFailed(
        "createGroup",
        result.code,
        ErrorMessageConverter.getErrorMessage(result.code, result.desc),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < TencentCloudChat.instance.dataInstance.contact.groupFaceCount; i++) {
      groupAvatars
          .add(TencentCloudChat.instance.dataInstance.contact.groupFaceURL.replaceAll('%s', (i + 1).toString()));
    }

    V2TimUserFullInfo? selfInfo = TencentCloudChat.instance.dataInstance.basic.currentUser;
    if (selfInfo != null) {
      groupName = '${selfInfo.nickName ?? selfInfo.userID}...';
    }

    groupNameController.text = groupName;
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Scaffold(
              backgroundColor: colorTheme.backgroundColor,
              appBar: AppBar(
                backgroundColor: colorTheme.backgroundColor,
                leading: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    tL10n.cancel,
                    style: TextStyle(color: colorTheme.primaryColor),
                  ),
                ),
                title: Center(
                  child: Text(
                    tL10n.createGroupTips,
                    style: TextStyle(fontSize: textStyle.fontsize_16, color: Colors.black),
                  ),
                ),
                centerTitle: true,
                actions: [
                  TextButton(
                    onPressed: _createGroup,
                    child: Text(
                      tL10n.create,
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
                elevation: 0,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(
                        controller: groupNameController,
                        hintText: tL10n.groupName,
                      ),
                      _buildTextField(
                        controller: groupIdController,
                        hintText: tL10n.groupIDOption,
                      ),
                      _buildGroupTypeSelector(),
                      Divider(height: 0.5, color: Colors.grey[300]),
                      const SizedBox(height: 20),
                      Text(
                        tL10n.groupFaceUrl,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      _buildAvatarList(),
                      const SizedBox(height: 20),
                      Text(
                        tL10n.groupMemberSelected,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      _buildSelectedMemberList(textStyle),
                    ],
                  ),
                ),
              ),
            ));
  }

  @override
  void dispose() {// TODO: implement dispose
    super.dispose();
    groupNameController.dispose();
    groupIdController.dispose();
  }
}
