import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/life_cycle/profile_life_cycle.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_profile_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_self_info_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitProfile/profile_widget.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitProfile/widget/tim_uikit_profile_widget.dart';

typedef OnSelfAvatarTap = void Function();

typedef ProfileBuilder = Widget Function(
    BuildContext context,
    V2TimFriendInfo userInfo,
    V2TimConversation conversation,
    int friendType,
    bool isMute);

class TIMUIKitProfile extends StatefulWidget {
  /// user ID
  final String userID;

  /// [Deprecated:] the builder for custom operation list.
  /// [operationListBuilder] and [bottomOperationBuilder] merged into [builder], please use it instead.
  final Widget Function(
      BuildContext context,
      V2TimFriendInfo friendInfo,
      V2TimConversation conversation,
      int friendType,
      bool isMute)? operationListBuilder;

  /// [Deprecated:] The builder for custom bottom operation area.
  /// [operationListBuilder] and [bottomOperationBuilder] merged into [builder], please use it instead.
  final Widget Function(BuildContext context, V2TimFriendInfo? friendInfo,
      V2TimConversation? conversation, int friendType)? bottomOperationBuilder;

  /// [Deprecated:] Callback when clicking profile detail card.
  /// This widget will no longer shows the personal info card and can not jump to personal info page automatically,
  /// please navigate to your custom personal info page manually and directly, you may refer to our demo.
  final void Function(BuildContext context, V2TimUserFullInfo? userFullInfo)?
      handleProfileDetailCardTap;

  /// Profile Controller
  final TIMUIKitProfileController? controller;

  /// [Deprecated:] If allows jump to personal profiler page.
  /// This widget will no longer shows the personal info card and can not jump to personal info page automatically,
  /// please navigate to your custom personal info page manually and directly, you may refer to our demo.
  final bool canJumpToPersonalProfile;

  /// [Deprecated:] The callback when clicking self avatar.
  /// This widget will no longer shows the personal info card and will not support to change self avatar,
  /// please navigate to your custom personal info page manually and directly, you may refer to our demo.
  final OnSelfAvatarTap? onSelfAvatarTap;

  /// [If you tend to customize the profile page, use [profileWidgetsBuilder] with [profileWidgetsOrder] as priority.]
  /// The builder for each widgets in profile page,
  /// you can customize some of it by pass your own widget into here.
  /// Or, you can add your custom widget to the three custom widgets.
  final ProfileWidgetBuilder? profileWidgetBuilder;

  /// [If you tend to customize the profile page, use [profileWidgetsBuilder] with [profileWidgetsOrder] as priority.]
  /// If the default widget order can not meet you needs,
  /// you may change the order by this array with widget enum.
  final List<ProfileWidgetEnum>? profileWidgetsOrder;

  /// The builder for the whole profile page, you can use this to customize all the element here.
  /// Mentioned: If you use this builder, [profileWidgetBuilder] and [profileWidgetsOrder] will no longer works.
  final ProfileBuilder? builder;

  /// The life cycle hooks for user profile business logic
  final ProfileLifeCycle? lifeCycle;

  /// Whether the specify user is current logged in user.
  /// Default: [false].
  final bool isSelf;

  /// Whether use the small card mode on Desktop. Usually shows on the Chat page.
  final bool smallCardMode;

  const TIMUIKitProfile(
      {Key? key,
      required this.userID,
      @Deprecated(
          "[operationListBuilder] and [bottomOperationBuilder] merged into [builder], please use it instead")
      this.operationListBuilder,
      @Deprecated(
          "[operationListBuilder] and [bottomOperationBuilder] merged into [builder], please use it instead")
      this.bottomOperationBuilder,
      @Deprecated(
          "This widget will no longer shows the personal info card and can not jump to personal info page automatically, please navigate to your custom personal info page manually and directly, you may refer to our demo")
      this.handleProfileDetailCardTap,
      @Deprecated(
          "This widget will no longer shows the personal info card and can not jump to personal info page automatically, please navigate to your custom personal info page manually and directly, you may refer to our demo")
      this.canJumpToPersonalProfile = false,
      @Deprecated(
          "This widget will no longer shows the personal info card and will not support to change self avatar, please navigate to your custom personal info page manually and directly, you may refer to our demo")
      this.onSelfAvatarTap,
      this.controller,
      this.profileWidgetBuilder,
      this.profileWidgetsOrder,
      this.builder,
      this.isSelf = false,
      this.lifeCycle,
      this.smallCardMode = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TIMUIKitProfileState();
}

class _TIMUIKitProfileState extends TIMUIKitState<TIMUIKitProfile> {
  final TUIProfileViewModel _model = TUIProfileViewModel();
  late TIMUIKitProfileController _controller;

  @override
  void initState() {
    _controller = widget.controller ?? TIMUIKitProfileController();
    _model.lifeCycle = widget.lifeCycle;
    _model.loadData(userID: widget.userID, isNeedConversation: !widget.isSelf);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TIMUIKitProfile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userID != widget.userID ||
        _model.userProfile?.friendInfo?.userID != widget.userID) {
      _model.userProfile = null;
      _model.loadData(
          userID: widget.userID, isNeedConversation: !widget.isSelf);
    }
  }

  final List<ProfileWidgetEnum> _defaultWidgetOrder = [
    ProfileWidgetEnum.userInfoCard,
    ProfileWidgetEnum.operationDivider,
    ProfileWidgetEnum.remarkBar,
    ProfileWidgetEnum.operationDivider,
    ProfileWidgetEnum.addToBlockListBar,
    ProfileWidgetEnum.pinConversationBar,
    ProfileWidgetEnum.messageMute,
    ProfileWidgetEnum.operationDivider,
    ProfileWidgetEnum.addAndDeleteArea
  ];

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final theme = value.theme;
    final isDesktopScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
    return ChangeNotifierProvider.value(
      value: _model,
      child: Consumer<TUIProfileViewModel>(
        builder: (context, value, child) {
          final TUIProfileViewModel model =
              Provider.of<TUIProfileViewModel>(context);
          _controller.model = model;
          final V2TimFriendInfo? userInfo = model.userProfile?.friendInfo;

          if (userInfo == null) {
            return Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: theme.weakTextColor ?? Colors.grey,
                size: 48,
              ),
            );
          }

          final conversation = model.userProfile?.conversation ??
              V2TimConversation(
                  conversationID: "c2c_${widget.userID}",
                  type: 1,
                  userID: widget.userID,
                  faceUrl: model.userProfile?.friendInfo?.userProfile?.faceUrl,
                  showName: TencentUtils.checkString(
                          model.userProfile?.friendInfo?.friendRemark) ??
                      TencentUtils.checkString(model
                          .userProfile?.friendInfo?.userProfile?.nickName) ??
                      widget.userID);
          final TUISelfInfoViewModel _selfInfoViewModel =
              serviceLocator<TUISelfInfoViewModel>();

          final isFriend = model.friendType != 0;
          final isSelf = (model.userProfile?.friendInfo?.userID ==
              _selfInfoViewModel.loginInfo?.userID);
          final isMute = model.isDisturb ?? false;

          Widget profilePage({required Widget child}) {
            return Container(
              color: isDesktopScreen ? theme.wideBackgroundColor : null,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Container(
                  child: child,
                ),
              ),
            );
          }

          void handleAddToBlockList(bool value) async {
            model.addToBlackList(value, userInfo.userID);
          }

          void handlePinConversation(bool value) async {
            model.pinedConversation(value, conversation.conversationID);
          }

          void handleMuteMessage(bool value) async {
            model.setMessageDisturb(userInfo.userID, value);
          }

          void handleTapRemarkBar({Offset? offset, String? initText}) {
            _controller.showTextInputBottomSheet(
                initOffset: offset,
                initText: initText,
                context: context,
                title: TIM_t("修改备注名"),
                tips: TIM_t("仅限汉字、英文、数字和下划线"),
                onSubmitted: (String remark) async {
                  final res =
                      await _controller.updateRemarks(widget.userID, remark);
                  if (res.code == 0) {
                    widget.lifeCycle?.didRemarkUpdated(remark);
                  }
                },
                theme: theme);
          }

          void handleAddFriend() async {
            model.addFriend(userInfo.userID).then((res) {
              if (res == null) {
                throw Error();
              }
              if (res.resultCode == 0) {
                onTIMCallback(TIMCallback(
                    type: TIMCallbackType.INFO,
                    infoRecommendText: TIM_t("好友添加成功"),
                    infoCode: 6661202));
              } else if (res.resultCode == 30539) {
                onTIMCallback(TIMCallback(
                    type: TIMCallbackType.INFO,
                    infoRecommendText: TIM_t("好友申请已发出"),
                    infoCode: 6661203));
              } else if (res.resultCode == 30515) {
                onTIMCallback(TIMCallback(
                    type: TIMCallbackType.INFO,
                    infoRecommendText: TIM_t("当前用户在黑名单"),
                    infoCode: 6661204));
              }
            }).catchError((error) {
              onTIMCallback(TIMCallback(
                  type: TIMCallbackType.INFO,
                  infoRecommendText: TIM_t("好友添加失败"),
                  infoCode: 6661205));
            });
          }

          void handleDeleteFriend() {
            model.deleteFriend(userInfo.userID).then((res) {
              if (res == null) {
                throw Error();
              }
              if (res.resultCode != 0 && res.resultCode != null) {
                onTIMCallback(TIMCallback(
                    type: TIMCallbackType.INFO,
                    infoRecommendText: TIM_t("好友删除失败"),
                    infoCode: 6661207));
              } else {
                onTIMCallback(TIMCallback(
                    type: TIMCallbackType.INFO,
                    infoRecommendText: TIM_t("好友删除成功"),
                    infoCode: 6661206));
              }
            });
          }

          List<Widget> _renderWidgetsWithOrder(List<ProfileWidgetEnum> order) {
            final ProfileWidgetBuilder? customBuilder =
                widget.profileWidgetBuilder;
            return order.map((element) {
              switch (element) {
                case ProfileWidgetEnum.userInfoCard:
                  return (customBuilder?.userInfoCard != null
                      ? customBuilder?.userInfoCard!(userInfo.userProfile)
                      : TIMUIKitProfileUserInfoCard(
                          userInfo: userInfo.userProfile))!;
                case ProfileWidgetEnum.addToBlockListBar:
                  if (isSelf) {
                    return Container();
                  }
                  return (customBuilder?.addToBlockListBar != null
                      ? customBuilder?.addToBlockListBar!(
                          model.isAddToBlackList ?? false, handleAddToBlockList)
                      : TIMUIKitProfileWidget.addToBlackListBar(
                          model.isAddToBlackList ?? false,
                          context,
                          handleAddToBlockList,
                          widget.smallCardMode))!;
                case ProfileWidgetEnum.pinConversationBar:
                  // if (!isFriend) {
                  //   return Container();
                  // }
                  return (customBuilder?.pinConversationBar != null
                      ? customBuilder?.pinConversationBar!(
                          conversation.isPinned ?? false, handlePinConversation)
                      : TIMUIKitProfileWidget.pinConversationBar(
                          conversation.isPinned ?? false,
                          context,
                          handlePinConversation,
                          widget.smallCardMode))!;
                case ProfileWidgetEnum.messageMute:
                  // if (!isFriend) {
                  //   return Container();
                  // }
                  return (customBuilder?.messageMute != null
                      ? customBuilder?.messageMute!(isMute, handleMuteMessage)
                      : TIMUIKitProfileWidget.messageDisturb(context, isMute,
                          handleMuteMessage, widget.smallCardMode))!;
                case ProfileWidgetEnum.searchBar:
                  return (customBuilder?.searchBar != null
                      ? customBuilder?.searchBar!(conversation)
                      // Please define the search bar with navigating in `profileWidgetBuilder` before using it here.
                      : Text(TIM_t("你必须自定义search bar，并处理点击跳转")))!;
                case ProfileWidgetEnum.portraitBar:
                  return (customBuilder?.portraitBar != null
                      ? customBuilder?.portraitBar!(userInfo.userProfile)
                      : TIMUIKitProfileWidget.portraitBar(
                          TIMUIKitProfileWidget.defaultPortraitWidget(
                              userInfo.userProfile, widget.smallCardMode),
                          widget.smallCardMode))!;
                case ProfileWidgetEnum.nicknameBar:
                  return (customBuilder?.nicknameBar != null
                      ? customBuilder
                          ?.nicknameBar!(userInfo.userProfile?.nickName ?? "")
                      : TIMUIKitProfileWidget.nicknameBar(
                          userInfo.userProfile?.nickName ?? "",
                          widget.smallCardMode))!;
                case ProfileWidgetEnum.userAccountBar:
                  return (customBuilder?.userAccountBar != null
                      ? customBuilder
                          ?.userAccountBar!(userInfo.userProfile?.userID ?? "")
                      : TIMUIKitProfileWidget.userAccountBar(
                          userInfo.userProfile?.userID ?? "",
                          widget.smallCardMode))!;
                case ProfileWidgetEnum.signatureBar:
                  return (customBuilder?.signatureBar != null
                      ? customBuilder?.signatureBar!(
                          userInfo.userProfile?.selfSignature ?? "")
                      : TIMUIKitProfileWidget.signatureBar(
                          userInfo.userProfile?.selfSignature ?? "",
                          widget.smallCardMode))!;
                case ProfileWidgetEnum.genderBar:
                  return (customBuilder?.genderBar != null
                      ? customBuilder
                          ?.genderBar!(userInfo.userProfile?.gender ?? 0)
                      : TIMUIKitProfileWidget.genderBar(
                          userInfo.userProfile?.gender ?? 0,
                          widget.smallCardMode))!;
                case ProfileWidgetEnum.birthdayBar:
                  return (customBuilder?.birthdayBar != null
                      ? customBuilder
                          ?.birthdayBar!(userInfo.userProfile?.birthday)
                      : TIMUIKitProfileWidget.birthdayBar(
                          userInfo.userProfile?.birthday,
                          widget.smallCardMode))!;
                case ProfileWidgetEnum.addAndDeleteArea:
                  if (isSelf) {
                    return Container();
                  }
                  return (customBuilder?.addAndDeleteArea != null
                      ? customBuilder?.addAndDeleteArea!(
                          userInfo,
                          conversation,
                          value.friendType,
                          isMute,
                        )
                      : isDesktopScreen
                          ? TIMUIKitProfileWidget.addAndDeleteAreaWide(
                              userInfo,
                              conversation,
                              value.friendType,
                              isMute,
                              model.isAddToBlackList ?? false,
                              theme,
                              handleAddFriend,
                              handleDeleteFriend,
                              widget.smallCardMode)
                          : TIMUIKitProfileWidget.addAndDeleteArea(
                              userInfo,
                              conversation,
                              value.friendType,
                              isMute,
                              model.isAddToBlackList ?? false,
                              theme,
                              handleAddFriend,
                              handleDeleteFriend,
                              widget.smallCardMode))!;
                case ProfileWidgetEnum.operationDivider:
                  return (customBuilder?.operationDivider != null
                      ? customBuilder?.operationDivider!()
                      : TIMUIKitProfileWidget.operationDivider(
                          color: theme.weakDividerColor,
                          height: isDesktopScreen ? 1 : 10,
                          margin: isDesktopScreen
                              ? EdgeInsets.symmetric(
                                  vertical: widget.smallCardMode ? 4 : 20)
                              : null))!;
                case ProfileWidgetEnum.remarkBar:
                  if (!isFriend) {
                    return Container();
                  }
                  return (customBuilder?.remarkBar != null
                      ? customBuilder?.remarkBar!(
                          userInfo.friendRemark ?? "", handleTapRemarkBar)
                      : TIMUIKitProfileWidget.remarkBar(
                          context,
                          userInfo.friendRemark ?? "",
                          handleTapRemarkBar,
                          widget.smallCardMode))!;
                case ProfileWidgetEnum.customBuilderOne:
                  return (customBuilder?.customBuilderOne != null
                      ? customBuilder?.customBuilderOne!(
                          isFriend, userInfo, conversation)
                      // Please define the corresponding custom widget in `profileWidgetBuilder` before using it here.
                      : Text(TIM_t("如使用自定义区域，请在profileWidgetBuilder传入对应组件")))!;
                case ProfileWidgetEnum.customBuilderTwo:
                  return (customBuilder?.customBuilderTwo != null
                      ? customBuilder?.customBuilderTwo!(
                          isFriend, userInfo, conversation)
                      // Please define the corresponding custom widget in `profileWidgetBuilder` before using it here.
                      : Text(TIM_t("如使用自定义区域，请在profileWidgetBuilder传入对应组件")))!;
                case ProfileWidgetEnum.customBuilderThree:
                  return (customBuilder?.customBuilderThree != null
                      ? customBuilder?.customBuilderThree!(
                          isFriend, userInfo, conversation)
                      // Please define the corresponding custom widget in `profileWidgetBuilder` before using it here.
                      : Text(TIM_t("如使用自定义区域，请在profileWidgetBuilder传入对应组件")))!;
                case ProfileWidgetEnum.customBuilderFour:
                  return (customBuilder?.customBuilderFour != null
                      ? customBuilder?.customBuilderFour!(
                          isFriend, userInfo, conversation)
                      // Please define the corresponding custom widget in `profileWidgetBuilder` before using it here.
                      : Text(TIM_t("如使用自定义区域，请在profileWidgetBuilder传入对应组件")))!;
                case ProfileWidgetEnum.customBuilderFive:
                  return (customBuilder?.customBuilderFive != null
                      ? customBuilder?.customBuilderFive!(
                          isFriend, userInfo, conversation)
                      // Please define the corresponding custom widget in `profileWidgetBuilder` before using it here.
                      : Text(TIM_t("如使用自定义区域，请在profileWidgetBuilder传入对应组件")))!;

                default:
                  return Container();
              }
            }).toList();
          }

          if (widget.builder != null) {
            return widget.builder!(
                context, userInfo, conversation, value.friendType, isMute);
          } else if (widget.profileWidgetsOrder != null) {
            return profilePage(
              child: Column(
                children: [
                  ..._renderWidgetsWithOrder(widget.profileWidgetsOrder!)
                ],
              ),
            );
          } else {
            return profilePage(
                child: Column(
              children: [..._renderWidgetsWithOrder(_defaultWidgetOrder)],
            ));
          }
        },
      ),
    );
  }
}
