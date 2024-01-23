import 'package:flutter/cupertino.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_message_common_defines.dart';
import 'package:tencent_cloud_chat/data/message/tencent_cloud_chat_message_data.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_controller.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_header/tencent_cloud_chat_message_header.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_input/forward/tencent_cloud_chat_message_forward.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_input/forward/tencent_cloud_chat_message_forward_container.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_input/message_reply/tencent_cloud_chat_message_input_reply.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_input/mobile/tencent_cloud_chat_message_attachment_options.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_input/select_mode/tencent_cloud_chat_message_input_select_mode.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_input/tencent_cloud_chat_message_input.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_layout/special_case/tencent_cloud_chat_message_no_chat.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_layout/tencent_cloud_chat_message_layout.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_list_view/message_row/tencent_cloud_chat_message_row.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_list_view/tencent_cloud_chat_message_list_view.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/menu/tencent_cloud_chat_message_item_with_menu.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/tencent_cloud_chat_message_item_builders.dart';

typedef MessageLayoutBuilder = Widget? Function(
    {String? userID,
    String? groupID,
    required PreferredSizeWidget header,
    required Widget messageListView,
    required Widget messageInput,
    required Function({
      required String text,
      List<String>? mentionedUsers,
    }) sendTextMessage,
    required Function({required String imagePath}) sendImageMessage,
    required Function({required String videoPath}) sendVideoMessage,
    required Function({required String filePath}) sendFileMessage,
    required String currentConversationShowName,
    required Function({required String voicePath, required int duration})
        sendVoiceMessage,
    required double desktopMentionBoxPositionX,
    required double desktopMentionBoxPositionY,
    required int activeMentionIndex,
    required List<V2TimGroupMemberFullInfo?>
        currentFilteredMembersListForMention,
    required AutoScrollController desktopInputMemberSelectionPanelScroll,
    required ValueChanged<
            ({V2TimGroupMemberFullInfo memberFullInfo, int index})>
        onSelectMember});

typedef MessageListViewBuilder = Widget? Function({
  String? userID,
  String? groupID,
  required List<V2TimMessage> messageList,
  required Future Function() loadToLatestMessage,
  required Function({
    required TencentCloudChatMessageLoadDirection direction,
  }) loadMoreMessage,
  required bool haveMoreLatestData,
  required List<V2TimMessage> Function() getMessageList,
  required bool haveMorePreviousData,
  required ValueChanged<List<V2TimMessage>> onSelectMessages,
  required ValueChanged<V2TimMessage> highlightMessage,
  required TencentCloudChatMessageController controller,
  required List<V2TimMessage> messagesMentionedMe,
  int? unreadCount,
  int? c2cReadTimestamp,
  int? groupReadSequence,
  required Function({
    V2TimMessage? message,
    int? timeStamp,
    int? seq,
  }) loadToSpecificMessage,
});

typedef MessageNoChatBuilder = Widget? Function();

typedef MessageInputBuilder = Widget? Function({
  String? userID,
  String? groupID,
  required List<TencentCloudChatMessageGeneralOptionItem> attachmentOptions,
  required Function({
    required String text,
    List<String>? mentionedUsers,
  }) sendTextMessage,
  required Function({required String imagePath}) sendImageMessage,
  required Function({required String videoPath}) sendVideoMessage,
  required Function({required String filePath}) sendFileMessage,
  required Function({required String voicePath, required int duration})
      sendVoiceMessage,
  required bool inSelectMode,
  required TencentCloudChatMessageInputStatus status,
  required List<V2TimMessage> selectedMessages,
  V2TimMessage? repliedMessage,
  required Future<List<V2TimGroupMemberFullInfo>> Function({
    int? maxSelectionAmount,
    String? title,
    String? onSelectLabel,
  }) onChooseGroupMembers,
  required TencentCloudChatMessageController controller,
  required VoidCallback clearRepliedMessage,
  required double desktopMentionBoxPositionX,
  required double desktopMentionBoxPositionY,
  required bool isGroupAdmin,
  required int activeMentionIndex,
  required List<V2TimGroupMemberFullInfo?> currentFilteredMembersListForMention,
  required ValueChanged<double> setDesktopMentionBoxPositionX,
  required ValueChanged<double> setDesktopMentionBoxPositionY,
  required ValueChanged<int> setActiveMentionIndex,
  required ValueChanged<List<V2TimGroupMemberFullInfo?>>
      setCurrentFilteredMembersListForMention,
  required AutoScrollController desktopInputMemberSelectionPanelScroll,
  required List<V2TimGroupMemberFullInfo> groupMemberList,
  required V2TimGroupMemberFullInfo? memberNeedToMention,
  required String currentConversationShowName,
});

typedef MessageRowBuilder = Widget? Function({
  Key? key,
  required V2TimMessage message,

  /// The width of the message row, which represents the available width
  /// for displaying the message on the screen. This is useful for
  /// automatically wrapping text messages in a message bubble.
  required double messageRowWidth,
  required bool inSelectMode,
  required bool isSelected,
  required ValueChanged<V2TimMessage> onSelectCurrent,
});

typedef MessageAttachmentOptionsBuilder = Widget? Function({
  required List<TencentCloudChatMessageGeneralOptionItem> attachmentOptions,
  required VoidCallback onActionFinish,
});

typedef MessageHeaderBuilder = Widget? Function({
  V2TimConversation? conversation,
  required Future<V2TimConversation> Function({bool shouldUpdateState})
      loadConversation,
  String? userID,
  String? groupID,
  VoidCallback? startVoiceCall,
  VoidCallback? startVideoCall,
  required bool inSelectMode,
  required int selectAmount,
  required VoidCallback onClearSelect,
  required VoidCallback onCancelSelect,
  required bool showUserOnlineStatus,
  required bool Function({required String userID}) getUserOnlineStatus,
  required TencentCloudChatMessageController controller,
});

typedef MessageLongPressBuilder = Widget? Function({
  required Widget Function({required bool renderOnMenuPreview}) messageItem,
  required bool useMessageReaction,
  required V2TimMessage message,
  required List<TencentCloudChatMessageGeneralOptionItem> menuOptions,
  required int menuCloser,
  required bool inSelectMode,
  required VoidCallback onSelectMessage,
});

typedef MessageForwardBuilder = Widget? Function({
  required TencentCloudChatForwardType type,
  required List<V2TimConversation> conversationList,
  required ValueChanged<List<({String? userID, String? groupID})>>
      onSelectConversations,
  required VoidCallback onCancel,
  required List<V2TimFriendInfo> contactList,
  required List<V2TimGroupInfo> groupList,
});

typedef MessageInputReplyBuilder = Widget? Function({
  required V2TimMessage? repliedMessage,
  required VoidCallback onCancel,
  required VoidCallback onClickReply,
});

typedef MessageInputSelectBuilder = Widget? Function({
  required List<V2TimMessage> messages,
  required bool useDeleteForEveryone,
  required ValueChanged<List<V2TimMessage>> onDeleteForMe,
  required ValueChanged<List<V2TimMessage>> onDeleteForEveryone,
});

class TencentCloudChatMessageBuilders {
  static TencentCloudChatMessageItemBuilders?
      _tencentCloudChatMessageItemBuilders;
  static MessageLayoutBuilder? _messageLayoutBuilder;
  static MessageHeaderBuilder? _messageHeaderBuilder;
  static MessageListViewBuilder? _messageListViewBuilder;
  static MessageRowBuilder? _messageRowBuilder;
  static MessageInputBuilder? _messageInputBuilder;
  static MessageAttachmentOptionsBuilder? _messageAttachmentOptionsBuilder;
  static MessageLongPressBuilder? _messageLongPressBuilder;
  static MessageForwardBuilder? _messageForwardBuilder;
  static MessageInputReplyBuilder? _messageInputReplyBuilder;
  static MessageInputSelectBuilder? _messageInputSelectBuilder;
  static MessageNoChatBuilder? _messageNoChatBuilder;

  TencentCloudChatMessageBuilders({
    TencentCloudChatMessageItemBuilders? tencentCloudChatMessageItemBuilders,
    MessageLayoutBuilder? messageLayoutBuilder,
    MessageHeaderBuilder? messageHeaderBuilder,
    MessageListViewBuilder? messageListViewBuilder,
    MessageRowBuilder? messageRowBuilder,
    MessageInputBuilder? messageInputBuilder,
    MessageAttachmentOptionsBuilder? messageAttachmentOptionsBuilder,
    MessageLongPressBuilder? messageLongPressBuilder,
    MessageForwardBuilder? messageForwardBuilder,
    MessageInputReplyBuilder? messageInputReplyBuilder,
    MessageNoChatBuilder? messageNoChatBuilder,
    MessageInputSelectBuilder? messageInputSelectBuilder,
  }) {
    _tencentCloudChatMessageItemBuilders = tencentCloudChatMessageItemBuilders;
    _messageLayoutBuilder = messageLayoutBuilder;
    _messageListViewBuilder = messageListViewBuilder;
    _messageRowBuilder = messageRowBuilder;
    _messageInputBuilder = messageInputBuilder;
    _messageAttachmentOptionsBuilder = messageAttachmentOptionsBuilder;
    _messageHeaderBuilder = messageHeaderBuilder;
    _messageLongPressBuilder = messageLongPressBuilder;
    _messageForwardBuilder = messageForwardBuilder;
    _messageNoChatBuilder = messageNoChatBuilder;
    _messageInputReplyBuilder = messageInputReplyBuilder;
    _messageInputSelectBuilder = messageInputSelectBuilder;
  }

  static TencentCloudChatMessageItemBuilders
      get tencentCloudChatMessageItemBuilders =>
          _tencentCloudChatMessageItemBuilders ??
          TencentCloudChatMessageItemBuilders();

  static Widget getMessageInputSelectBuilder({
    required List<V2TimMessage> messages,
    required ValueChanged<List<V2TimMessage>> onDeleteForMe,
    required ValueChanged<List<V2TimMessage>> onDeleteForEveryone,
    required bool useDeleteForEveryone,
  }) {
    Widget? widget;

    if (_messageInputSelectBuilder != null) {
      widget = _messageInputSelectBuilder!(
        messages: messages,
        onDeleteForMe: onDeleteForMe,
        onDeleteForEveryone: onDeleteForEveryone,
        useDeleteForEveryone: useDeleteForEveryone,
      );
    }

    return widget ??
        TencentCloudChatMessageInputSelectMode(
          messages: messages,
          onDeleteForMe: onDeleteForMe,
          onDeleteForEveryone: onDeleteForEveryone,
          useDeleteForEveryone: useDeleteForEveryone,
        );
  }

  static Widget getMessageNoChatBuilder() {
    Widget? widget;

    if (_messageNoChatBuilder != null) {
      widget = _messageNoChatBuilder!();
    }

    return widget ?? const TencentCloudChatMessageNoChat();
  }

  static Widget getMessageInputReplyBuilder({
    required V2TimMessage? repliedMessage,
    required VoidCallback onCancel,
    required VoidCallback onClickReply,
  }) {
    Widget? widget;

    if (_messageInputReplyBuilder != null) {
      widget = _messageInputReplyBuilder!(
        onCancel: onCancel,
        onClickReply: onClickReply,
        repliedMessage: repliedMessage,
      );
    }

    return widget ??
        TencentCloudChatMessageInputReply(
          onCancel: onCancel,
          onClickReply: onClickReply,
          repliedMessage: repliedMessage,
        );
  }

  static Widget getMessageForwardBuilder({
    required TencentCloudChatForwardType type,
    required List<V2TimConversation> conversationList,
    required ValueChanged<List<({String? userID, String? groupID})>>
        onSelectConversations,
    required VoidCallback onCancel,
    required List<V2TimFriendInfo> contactList,
    required List<V2TimGroupInfo> groupList,
  }) {
    Widget? widget;

    if (_messageForwardBuilder != null) {
      widget = _messageForwardBuilder!(
        type: type,
        conversationList: conversationList,
        onSelectConversations: onSelectConversations,
        onCancel: onCancel,
        groupList: groupList,
        contactList: contactList,
      );
    }

    return widget ??
        TencentCloudChatMessageForward(
          type: type,
          conversationList: conversationList,
          onSelectConversations: onSelectConversations,
          onCancel: onCancel,
          groupList: groupList,
          contactList: contactList,
        );
  }

  static Widget getMessageLongPressBuilder({
    required Widget Function({required bool renderOnMenuPreview}) messageItem,
    required bool useMessageReaction,
    required V2TimMessage message,
    required List<TencentCloudChatMessageGeneralOptionItem> menuOptions,
    required int menuCloser,
    required bool inSelectMode,
    required VoidCallback onSelectMessage,
    required bool isMergeMessage,
  }) {
    Widget? widget;

    if (_messageLongPressBuilder != null) {
      widget = _messageLongPressBuilder!(
        message: message,
        menuOptions: menuOptions,
        messageItem: messageItem,
        inSelectMode: inSelectMode,
        onSelectMessage: onSelectMessage,
        useMessageReaction: useMessageReaction,
        menuCloser: menuCloser,
      );
    }

    return widget ??
        TencentCloudChatMessageItemWithMenu(
          message: message,
          menuOptions: menuOptions,
          inSelectMode: inSelectMode,
          onSelectMessage: onSelectMessage,
          messageItem: messageItem,
          useMessageReaction: useMessageReaction,
          menuCloser: menuCloser,
          isMergeMessage: isMergeMessage,
        );
  }

  static Widget getMessageHeader({
    V2TimConversation? conversation,
    required Future<V2TimConversation> Function({bool shouldUpdateState})
        loadConversation,
    String? userID,
    String? groupID,
    VoidCallback? startVoiceCall,
    VoidCallback? startVideoCall,
    required bool inSelectMode,
    required int selectAmount,
    required VoidCallback onCancelSelect,
    required bool showUserOnlineStatus,
    required bool Function({required String userID}) getUserOnlineStatus,
    required List<V2TimGroupMemberFullInfo> Function() getGroupMembersInfo,
    required TencentCloudChatMessageController controller,
    required VoidCallback onClearSelect,
  }) {
    Widget? widget;

    if (_messageHeaderBuilder != null) {
      widget = _messageHeaderBuilder!(
        conversation: conversation,
        loadConversation: loadConversation,
        userID: userID,
        groupID: groupID,
        onClearSelect: onClearSelect,
        startVideoCall: startVideoCall,
        startVoiceCall: startVoiceCall,
        inSelectMode: inSelectMode,
        selectAmount: selectAmount,
        onCancelSelect: onCancelSelect,
        showUserOnlineStatus: showUserOnlineStatus,
        getUserOnlineStatus: getUserOnlineStatus,
        controller: controller,
      );
    }

    return widget ??
        TencentCloudChatMessageHeader(
          onCancelSelect: onCancelSelect,
          onClearSelect: onClearSelect,
          conversation: conversation,
          inSelectMode: inSelectMode,
          loadConversation: loadConversation,
          userID: userID,
          groupID: groupID,
          startVideoCall: startVideoCall,
          startVoiceCall: startVoiceCall,
          selectAmount: selectAmount,
          showUserOnlineStatus: showUserOnlineStatus,
          getUserOnlineStatus: getUserOnlineStatus,
          getGroupMembersInfo: getGroupMembersInfo,
          controller: controller,
        );
  }

  static Widget getAttachmentOptionsBuilder({
    required List<TencentCloudChatMessageGeneralOptionItem> attachmentOptions,
    required VoidCallback onActionFinish,
  }) {
    Widget? widget;

    if (_messageAttachmentOptionsBuilder != null) {
      widget = _messageAttachmentOptionsBuilder!(
        attachmentOptions: attachmentOptions,
        onActionFinish: onActionFinish,
      );
    }

    return widget ??
        TencentCloudChatMessageAttachmentOptionsWidget(
          attachmentOptions: attachmentOptions,
          onActionFinish: onActionFinish,
        );
  }

  static Widget getMessageInputBuilder({
    String? userID,
    String? groupID,
    required List<TencentCloudChatMessageGeneralOptionItem>
        attachmentOrInputControlBarOptions,
    required Function({
      required String text,
      List<String>? mentionedUsers,
    }) sendTextMessage,
    required Function({required String imagePath}) sendImageMessage,
    required Function({required String videoPath}) sendVideoMessage,
    required Function({required String filePath}) sendFileMessage,
    required Function({required String voicePath, required int duration})
        sendVoiceMessage,
    required bool inSelectMode,
    required List<V2TimMessage> selectedMessages,
    V2TimMessage? repliedMessage,
    required TencentCloudChatMessageInputStatus status,
    required TencentCloudChatMessageController controller,
    required Future<List<V2TimGroupMemberFullInfo>> Function({
      int? maxSelectionAmount,
      String? title,
      String? onSelectLabel,
    }) onChooseGroupMembers,
    required VoidCallback clearRepliedMessage,
    required double desktopMentionBoxPositionX,
    required double desktopMentionBoxPositionY,
    required int activeMentionIndex,
    required List<V2TimGroupMemberFullInfo?>
        currentFilteredMembersListForMention,
    required ValueChanged<double> setDesktopMentionBoxPositionX,
    required ValueChanged<double> setDesktopMentionBoxPositionY,
    required ValueChanged<int> setActiveMentionIndex,
    required ValueChanged<List<V2TimGroupMemberFullInfo?>>
        setCurrentFilteredMembersListForMention,
    required AutoScrollController desktopInputMemberSelectionPanelScroll,
    required List<V2TimGroupMemberFullInfo> groupMemberList,
    required bool isGroupAdmin,
    required V2TimGroupMemberFullInfo? memberNeedToMention,
    required String currentConversationShowName,
  }) {
    Widget? widget;

    if (_messageInputBuilder != null) {
      widget = _messageInputBuilder!(
        userID: userID,
        groupID: groupID,
        attachmentOptions: attachmentOrInputControlBarOptions,
        sendTextMessage: sendTextMessage,
        sendImageMessage: sendImageMessage,
        sendVideoMessage: sendVideoMessage,
        sendFileMessage: sendFileMessage,
        sendVoiceMessage: sendVoiceMessage,
        onChooseGroupMembers: onChooseGroupMembers,
        inSelectMode: inSelectMode,
        status: status,
        selectedMessages: selectedMessages,
        repliedMessage: repliedMessage,
        controller: controller,
        clearRepliedMessage: clearRepliedMessage,
        desktopMentionBoxPositionX: desktopMentionBoxPositionX,
        desktopMentionBoxPositionY: desktopMentionBoxPositionY,
        activeMentionIndex: activeMentionIndex,
        currentFilteredMembersListForMention:
            currentFilteredMembersListForMention,
        isGroupAdmin: isGroupAdmin,
        setActiveMentionIndex: setActiveMentionIndex,
        setCurrentFilteredMembersListForMention:
            setCurrentFilteredMembersListForMention,
        setDesktopMentionBoxPositionX: setDesktopMentionBoxPositionX,
        setDesktopMentionBoxPositionY: setDesktopMentionBoxPositionY,
        groupMemberList: groupMemberList,
        desktopInputMemberSelectionPanelScroll:
            desktopInputMemberSelectionPanelScroll,
        memberNeedToMention: memberNeedToMention,
        currentConversationShowName: currentConversationShowName,
      );
    }

    return widget ??
        TencentCloudChatMessageInput(
          userID: userID,
          groupID: groupID,
          memberNeedToMention: memberNeedToMention,
          attachmentOptions: attachmentOrInputControlBarOptions,
          sendTextMessage: sendTextMessage,
          sendImageMessage: sendImageMessage,
          currentConversationShowName: currentConversationShowName,
          status: status,
          clearRepliedMessage: clearRepliedMessage,
          isGroupAdmin: isGroupAdmin,
          groupMemberList: groupMemberList,
          sendVideoMessage: sendVideoMessage,
          desktopMentionBoxPositionX: desktopMentionBoxPositionX,
          desktopMentionBoxPositionY: desktopMentionBoxPositionY,
          activeMentionIndex: activeMentionIndex,
          currentFilteredMembersListForMention:
              currentFilteredMembersListForMention,
          setActiveMentionIndex: setActiveMentionIndex,
          setCurrentFilteredMembersListForMention:
              setCurrentFilteredMembersListForMention,
          setDesktopMentionBoxPositionX: setDesktopMentionBoxPositionX,
          setDesktopMentionBoxPositionY: setDesktopMentionBoxPositionY,
          sendFileMessage: sendFileMessage,
          sendVoiceMessage: sendVoiceMessage,
          onChooseGroupMembers: onChooseGroupMembers,
          desktopInputMemberSelectionPanelScroll:
              desktopInputMemberSelectionPanelScroll,
          inSelectMode: inSelectMode,
          selectedMessages: selectedMessages,
          repliedMessage: repliedMessage,
          controller: controller,
        );
  }

  static Widget getMessageRowBuilder({
    Key? key,
    required V2TimMessage message,

    /// The width of the message row, which represents the available width
    /// for displaying the message on the screen. This is useful for
    /// automatically wrapping text messages in a message bubble.
    required double messageRowWidth,
    required bool inSelectMode,
    required bool isSelected,
    required ValueChanged<V2TimMessage> onSelectCurrent,
    required bool isMergeMessage,
  }) {
    Widget? widget;

    if (_messageRowBuilder != null) {
      widget = _messageRowBuilder!(
        key: key,
        message: message,
        messageRowWidth: messageRowWidth,
        isSelected: isSelected,
        inSelectMode: inSelectMode,
        onSelectCurrent: onSelectCurrent,
      );
    }

    return widget ??
        TencentCloudChatMessageRow(
          key: key,
          message: message,
          messageRowWidth: messageRowWidth,
          isSelected: isSelected,
          inSelectMode: inSelectMode,
          onSelectCurrent: onSelectCurrent,
          isMergeMessage: isMergeMessage,
        );
  }

  static Widget getMessageLayoutBuilder(
      {String? userID,
      String? groupID,
      required PreferredSizeWidget header,
      required Widget messageListView,
      required Widget messageInput,
      required Function({
        required String text,
        List<String>? mentionedUsers,
      }) sendTextMessage,
      required Function({required String imagePath}) sendImageMessage,
      required Function({required String videoPath}) sendVideoMessage,
      required Function({required String filePath}) sendFileMessage,
      required Function({required String voicePath, required int duration})
          sendVoiceMessage,
      required String currentConversationShowName,
      required double desktopMentionBoxPositionX,
      required double desktopMentionBoxPositionY,
      required int activeMentionIndex,
      required List<V2TimGroupMemberFullInfo?>
          currentFilteredMembersListForMention,
      required AutoScrollController desktopInputMemberSelectionPanelScroll,
      required ValueChanged<
              ({V2TimGroupMemberFullInfo memberFullInfo, int index})>
          onSelectMember}) {
    assert((userID == null) != (groupID == null));
    Widget? widget;

    if (_messageLayoutBuilder != null) {
      widget = _messageLayoutBuilder!(
        userID: userID,
        groupID: groupID,
        header: header,
        sendTextMessage: sendTextMessage,
        sendImageMessage: sendImageMessage,
        sendVideoMessage: sendVideoMessage,
        sendFileMessage: sendFileMessage,
        sendVoiceMessage: sendVoiceMessage,
        messageListView: messageListView,
        currentConversationShowName: currentConversationShowName,
        messageInput: messageInput,
        desktopMentionBoxPositionX: desktopMentionBoxPositionX,
        desktopMentionBoxPositionY: desktopMentionBoxPositionY,
        activeMentionIndex: activeMentionIndex,
        currentFilteredMembersListForMention:
            currentFilteredMembersListForMention,
        desktopInputMemberSelectionPanelScroll:
            desktopInputMemberSelectionPanelScroll,
        onSelectMember: onSelectMember,
      );
    }

    return widget ??
        TencentCloudChatMessageLayout(
          userID: userID,
          groupID: groupID,
          header: header,
          messageListView: messageListView,
          messageInput: messageInput,
          currentConversationShowName: currentConversationShowName,
          sendTextMessage: sendTextMessage,
          sendImageMessage: sendImageMessage,
          sendVideoMessage: sendVideoMessage,
          sendFileMessage: sendFileMessage,
          sendVoiceMessage: sendVoiceMessage,
          desktopMentionBoxPositionX: desktopMentionBoxPositionX,
          desktopMentionBoxPositionY: desktopMentionBoxPositionY,
          activeMentionIndex: activeMentionIndex,
          currentFilteredMembersListForMention:
              currentFilteredMembersListForMention,
          desktopInputMemberSelectionPanelScroll:
              desktopInputMemberSelectionPanelScroll,
          onSelectMember: onSelectMember,
        );
  }

  static Widget getMessageListViewBuilder({
    String? userID,
    String? groupID,
    required List<V2TimMessage> messageList,
    required Function({
      required TencentCloudChatMessageLoadDirection direction,
    }) loadMoreMessages,
    required Future Function() loadToLatestMessage,
    required bool haveMoreLatestData,
    required bool haveMorePreviousData,
    required ValueChanged<List<V2TimMessage>> onSelectMessages,
    required List<V2TimMessage> messagesMentionedMe,
    required TencentCloudChatMessageController controller,
    int? unreadCount,
    int? c2cReadTimestamp,
    int? groupReadSequence,
    required Function({
      V2TimMessage? message,
      int? timeStamp,
      int? seq,
    }) loadToSpecificMessage,
    required List<V2TimMessage> Function() getMessageList,
    required ValueChanged<V2TimMessage> highlightMessage,
  }) {
    assert((userID == null) != (groupID == null));

    Widget? widget;

    if (_messageListViewBuilder != null) {
      widget = _messageListViewBuilder!(
        loadToLatestMessage: loadToLatestMessage,
        userID: userID,
        groupID: groupID,
        messageList: messageList,
        haveMoreLatestData: haveMoreLatestData,
        messagesMentionedMe: messagesMentionedMe,
        haveMorePreviousData: haveMorePreviousData,
        loadMoreMessage: loadMoreMessages,
        onSelectMessages: onSelectMessages,
        controller: controller,
        unreadCount: unreadCount,
        getMessageList: getMessageList,
        highlightMessage: highlightMessage,
        c2cReadTimestamp: c2cReadTimestamp,
        loadToSpecificMessage: loadToSpecificMessage,
        groupReadSequence: groupReadSequence,
      );
    }

    return widget ??
        TencentCloudChatMessageListView(
          loadToLatestMessage: loadToLatestMessage,
          userID: userID,
          groupID: groupID,
          controller: controller,
          messagesMentionedMe: messagesMentionedMe,
          messageList: messageList,
          haveMoreLatestData: haveMoreLatestData,
          getMessageList: getMessageList,
          unreadCount: unreadCount,
          highlightMessage: highlightMessage,
          loadToSpecificMessage: loadToSpecificMessage,
          c2cReadTimestamp: c2cReadTimestamp,
          groupReadSequence: groupReadSequence,
          haveMorePreviousData: haveMorePreviousData,
          loadMoreMessages: loadMoreMessages,
          onSelectMessages: onSelectMessages,
        );
  }
}
