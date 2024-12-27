import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_message_common_defines.dart';
import 'package:tencent_cloud_chat/components/component_event_handlers/tencent_cloud_chat_message_event_handlers.dart';
import 'package:tencent_cloud_chat/data/message/tencent_cloud_chat_message_data.dart';
import 'package:tencent_cloud_chat/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';

class MessageHeaderBuilderWidgets {
  final Widget messageHeaderProfileImage;
  final Widget messageHeaderInfo;
  final Widget messageHeaderActions;
  final Widget messageHeaderMessagesSelectMode;

  MessageHeaderBuilderWidgets({
    required this.messageHeaderProfileImage,
    required this.messageHeaderInfo,
    required this.messageHeaderActions,
    required this.messageHeaderMessagesSelectMode,
  });
}

class MessageHeaderBuilderData {
  final String? userID;
  final String? topicID;
  final String? groupID;
  final V2TimConversation? conversation;
  final bool inSelectMode;
  final int selectAmount;
  final bool showUserOnlineStatus;

  MessageHeaderBuilderData({
    this.userID,
    this.groupID,
    this.topicID,
    this.conversation,
    required this.inSelectMode,
    required this.selectAmount,
    required this.showUserOnlineStatus,
  });
}

class MessageHeaderBuilderMethods {
  final VoidCallback? startVoiceCall;
  final VoidCallback? startVideoCall;
  final VoidCallback onClearSelect;
  final VoidCallback onCancelSelect;
  final bool Function({required String userID}) getUserOnlineStatus;
  final List<V2TimGroupMemberFullInfo> Function() getGroupMembersInfo;

  /// TencentCloudChatMessageController
  final Object controller;

  MessageHeaderBuilderMethods({
    this.startVoiceCall,
    this.startVideoCall,
    required this.onClearSelect,
    required this.getGroupMembersInfo,
    required this.onCancelSelect,
    required this.getUserOnlineStatus,
    required this.controller,
  });
}

class MessageItemBuilderWidgets {
  final Widget messageItemView;

  MessageItemBuilderWidgets({
    required this.messageItemView,
  });
}

class MessageItemBuilderData {
  final V2TimMessage message;
  final String? userID;
  final String? topicID;
  final String? groupID;
  final bool showMessageStatusIndicator;
  final bool showMessageTimeIndicator;
  final bool shouldBeHighlighted;
  final bool showMessageSenderName;
  final V2TimMessageReceipt? messageReceipt;
  final SendingMessageData? sendingMessageData;
  final CurrentPlayAudioInfo? currentPlayAudioInfo;
  final double messageRowWidth;
  final bool renderOnMenuPreview;
  final bool inSelectMode;
  final String altText;
  final bool inMergerMessagePreviewMode;
  final bool enableParseMarkdown;
  final bool hasStickerPlugin;
  final TencentCloudChatPlugin? stickerPluginInstance;
  final Widget? repliedMessageItem;
  final TencentCloudChatPlugin? messageReactionPluginInstance;

  MessageItemBuilderData({
    this.repliedMessageItem,
    required this.message,
    this.userID,
    this.groupID,
    this.topicID,
    required this.altText,
    required this.enableParseMarkdown,
    required this.showMessageStatusIndicator,
    required this.showMessageTimeIndicator,
    required this.shouldBeHighlighted,
    required this.showMessageSenderName,
    this.messageReceipt,
    this.sendingMessageData,
    this.currentPlayAudioInfo,
    required this.messageRowWidth,
    required this.renderOnMenuPreview,
    required this.inSelectMode,
    required this.inMergerMessagePreviewMode,
    required this.hasStickerPlugin,
    this.stickerPluginInstance,
    this.messageReactionPluginInstance,
  });
}

class MessageItemBuilderMethods {
  final VoidCallback clearHighlightFunc;
  final ValueChanged<String> triggerLinkTappedEvent;
  final VoidCallback? startVoiceCall;
  final VoidCallback? startVideoCall;
  final VoidCallback? onResendMessage;
  final Function({
    required String messageText,
    required List<String> groupMembersNeedToMention,
  }) setMessageTextWithMentions;

  MessageItemBuilderMethods({
    required this.clearHighlightFunc,
    required this.triggerLinkTappedEvent,
    required this.setMessageTextWithMentions,
    this.startVoiceCall,
    this.startVideoCall,
    this.onResendMessage,
  });
}

class MessageItemMenuBuilderWidgets {
  final Widget messageItemMenuView;

  MessageItemMenuBuilderWidgets({
    required this.messageItemMenuView,
  });
}

class MessageItemMenuBuilderData {
  final bool useMessageReaction;
  final V2TimMessage message;
  final bool inSelectMode;
  final bool isMergeMessage;
  final TencentCloudChatPlugin? messageReactionPluginInstance;

  MessageItemMenuBuilderData( {
    required this.useMessageReaction,
    required this.message,
    required this.inSelectMode,
    required this.isMergeMessage,
    this.messageReactionPluginInstance,
  });
}

class MessageItemMenuBuilderMethods {
  final Widget Function({required bool renderOnMenuPreview, Key? key,}) getMessageItemWidget;
  final VoidCallback onSelectMessage;
  final List<TencentCloudChatMessageGeneralOptionItem> Function({String? selectedText}) getMenuOptions;

  MessageItemMenuBuilderMethods({
    required this.getMessageItemWidget,
    required this.onSelectMessage,
    required this.getMenuOptions,
  });
}

class MessageAttachmentOptionsBuilderWidgets {
  final Widget messageAttachmentOptionsView;

  MessageAttachmentOptionsBuilderWidgets({
    required this.messageAttachmentOptionsView,
  });
}

class MessageInputReplyBuilderData {
  final V2TimMessage? repliedMessage;

  MessageInputReplyBuilderData({
    this.repliedMessage,
  });
}

class MessageInputReplyBuilderMethods {
  final VoidCallback onCancel;
  final VoidCallback onClickReply;

  MessageInputReplyBuilderMethods({
    required this.onCancel,
    required this.onClickReply,
  });
}

class MessageInputSelectBuilderWidgets {
  final Widget messageInputSelectView;

  MessageInputSelectBuilderWidgets({
    required this.messageInputSelectView,
  });
}

class MessageInputSelectBuilderData {
  final List<V2TimMessage> messages;
  final bool enableMessageForwardIndividually;
  final bool enableMessageForwardCombined;
  final bool enableMessageDeleteForSelf;

  MessageInputSelectBuilderData({
    required this.messages,
    required this.enableMessageForwardIndividually,
    required this.enableMessageForwardCombined,
    required this.enableMessageDeleteForSelf,
  });
}

class MessageInputSelectBuilderMethods {
  final ValueChanged<List<V2TimMessage>> onDeleteForMe;
  final ValueChanged<TencentCloudChatForwardType> onMessagesForward;

  MessageInputSelectBuilderMethods({
    required this.onDeleteForMe,
    required this.onMessagesForward,
  });
}

class MessageInputReplyBuilderWidgets {
  final Widget messageInputReplyView;

  MessageInputReplyBuilderWidgets({
    required this.messageInputReplyView,
  });
}

enum MessageDynamicButtonEventType {
  navigateToTheLatestReadMessage,
  navigateToTheLatestMessageMentionedMe,
  navigateToTheLatestReceivedMessage,
  navigateToTheBottomOfMessageList,
}

class MessageDynamicButtonBuilderData {
  final String? text;
  final IconData? iconData;
  final bool isLoading;
  final MessageDynamicButtonEventType eventType;

  MessageDynamicButtonBuilderData({
    required this.eventType,
    required this.isLoading,
    this.text,
    this.iconData,
  });
}

class MessageDynamicButtonBuilderMethods {
  final VoidCallback triggerDefaultButtonTappedEvent;

  MessageDynamicButtonBuilderMethods({
    required this.triggerDefaultButtonTappedEvent,
  });
}

class MessageDynamicButtonBuilderWidgets {
  final Widget messageDynamicButtonView;

  MessageDynamicButtonBuilderWidgets({
    required this.messageDynamicButtonView,
  });
}

class MessageAttachmentOptionsBuilderData {
  final List<TencentCloudChatMessageGeneralOptionItem> attachmentOptions;

  MessageAttachmentOptionsBuilderData({
    required this.attachmentOptions,
  });
}

class MessageAttachmentOptionsBuilderMethods {
  final VoidCallback onActionFinish;

  MessageAttachmentOptionsBuilderMethods({
    required this.onActionFinish,
  });
}

class MessageForwardBuilderWidgets {
  final Widget messageForwardView;

  MessageForwardBuilderWidgets({
    required this.messageForwardView,
  });
}

class MessageForwardBuilderData {
  final TencentCloudChatForwardType type;
  final List<V2TimConversation> conversationList;
  final List<V2TimFriendInfo> contactList;
  final List<V2TimGroupInfo> groupList;

  MessageForwardBuilderData({
    required this.type,
    required this.conversationList,
    required this.contactList,
    required this.groupList,
  });
}

class MessageForwardBuilderMethods {
  final ValueChanged<List<({String? userID, String? groupID})>> onSelectConversations;
  final VoidCallback onCancel;

  MessageForwardBuilderMethods({
    required this.onSelectConversations,
    required this.onCancel,
  });
}

class MessageLayoutBuilderWidgets {
  final PreferredSizeWidget header;
  final Widget messageListView;
  final Widget messageInput;

  MessageLayoutBuilderWidgets({
    required this.header,
    required this.messageListView,
    required this.messageInput,
  });
}

class MessageLayoutBuilderData {
  final String? userID;
  final String? topicID;
  final String? groupID;
  final String currentConversationShowName;
  final double desktopMentionBoxPositionX;
  final double desktopMentionBoxPositionY;
  final double desktopStickerBoxPositionX;
  final double desktopStickerBoxPositionY;
  final int activeMentionIndex;
  final List<V2TimGroupMemberFullInfo?> currentFilteredMembersListForMention;
  final bool hasStickerPlugin;
  final TencentCloudChatPlugin? stickerPluginInstance;

  MessageLayoutBuilderData({
    this.userID,
    this.groupID,
    this.topicID,
    required this.currentConversationShowName,
    required this.desktopMentionBoxPositionX,
    required this.desktopMentionBoxPositionY,
    required this.activeMentionIndex,
    required this.currentFilteredMembersListForMention,
    required this.desktopStickerBoxPositionX,
    required this.desktopStickerBoxPositionY,
    required this.hasStickerPlugin,
    this.stickerPluginInstance,
  });
}

class MessageLayoutBuilderMethods {
  final Function({
    required String text,
    List<String>? mentionedUsers,
  }) sendTextMessage;
  final Function({String? imagePath, String? imageName, dynamic inputElement}) sendImageMessage;
  final Function({String? videoPath, dynamic inputElement}) sendVideoMessage;
  final Function({String? filePath, String? fileName, dynamic inputElement}) sendFileMessage;
  final Function({required String voicePath, required int duration}) sendVoiceMessage;
  final AutoScrollController desktopInputMemberSelectionPanelScroll;
  final ValueChanged<({V2TimGroupMemberFullInfo memberFullInfo, int index})> onSelectMember;
  final void Function() closeSticker;

  MessageLayoutBuilderMethods({
    required this.sendTextMessage,
    required this.sendImageMessage,
    required this.sendVideoMessage,
    required this.sendFileMessage,
    required this.sendVoiceMessage,
    required this.desktopInputMemberSelectionPanelScroll,
    required this.onSelectMember,
    required this.closeSticker,
  });
}

class MessageReplyViewBuilderWidgets {
  final Widget messageReplyView;

  MessageReplyViewBuilderWidgets({
    required this.messageReplyView,
  });
}

class MessageReplyViewBuilderData {
  final String? messageSender;
  final String? messageAbstract;
  final String messageID;
  final int? messageSeq;
  final int? messageTimestamp;

  MessageReplyViewBuilderData({
    this.messageSender,
    this.messageAbstract,
    required this.messageID,
    this.messageSeq,
    this.messageTimestamp,
  });
}

class MessageReplyViewBuilderMethods {
  final VoidCallback onTriggerNavigation;

  MessageReplyViewBuilderMethods({
    required this.onTriggerNavigation,
  });
}

class MessageListViewBuilderWidgets {
  final Widget messageListView;

  MessageListViewBuilderWidgets({required this.messageListView});
}

class MessageListViewBuilderData {
  final String? userID;
  final String? topicID;
  final String? groupID;

  final List<V2TimMessage> messageList;
  final bool haveMoreLatestData;
  final bool haveMorePreviousData;

  final List<V2TimMessage> messagesMentionedMe;

  final int? unreadCount;
  final int? c2cReadTimestamp;
  final int? groupReadSequence;

  MessageListViewBuilderData({
    this.userID,
    this.groupID,
    this.topicID,
    required this.messageList,
    this.c2cReadTimestamp,
    required this.haveMoreLatestData,
    required this.haveMorePreviousData,
    required this.messagesMentionedMe,
    this.unreadCount,
    this.groupReadSequence,
  });
}

class MessageListViewBuilderMethods {
  final Future Function() loadToLatestMessage;
  final Function({
    required TencentCloudChatMessageLoadDirection direction,
  }) loadMoreMessages;

  final Future<bool> Function({
    required bool highLightTargetMessage,
    V2TimMessage? message,
    int? timeStamp,
    int? seq,
  }) loadToSpecificMessage;

  final ValueChanged<V2TimMessage> highlightMessage;

  /// TencentCloudChatMessageController
  final Object controller;

  final List<V2TimMessage> Function() getMessageList;
  final Function() closeSticker;

  MessageListViewBuilderMethods({
    required this.loadToLatestMessage,
    required this.loadMoreMessages,
    required this.loadToSpecificMessage,
    required this.highlightMessage,
    required this.controller,
    required this.getMessageList,
    required this.closeSticker,
  });
}

class MessageInputBuilderWidgets {
  final Widget messageInput;

  MessageInputBuilderWidgets({
    required this.messageInput,
  });
}

class MessageInputBuilderData {
  final String? userID;
  final String? topicID;
  final String? groupID;
  final List<TencentCloudChatMessageGeneralOptionItem> attachmentOptions;
  final bool inSelectMode;
  final TencentCloudChatMessageInputStatus status;
  final List<V2TimMessage> selectedMessages;
  final V2TimMessage? repliedMessage;

  final double desktopMentionBoxPositionX;
  final double desktopMentionBoxPositionY;
  final bool isGroupAdmin;
  final int activeMentionIndex;
  final List<V2TimGroupMemberFullInfo?> currentFilteredMembersListForMention;
  final List<V2TimGroupMemberFullInfo> groupMemberList;
  final List<V2TimGroupMemberFullInfo>? membersNeedToMention;
  final String? specifiedMessageText;
  final String currentConversationShowName;
  final bool enableReplyWithMention;
  final bool hasStickerPlugin;
  final TencentCloudChatPlugin? stickerPluginInstance;

  MessageInputBuilderData({
    this.userID,
    this.groupID,
    this.topicID,
    required this.attachmentOptions,
    required this.inSelectMode,
    required this.enableReplyWithMention,
    required this.status,
    required this.selectedMessages,
    this.repliedMessage,
    required this.desktopMentionBoxPositionX,
    this.specifiedMessageText,
    required this.desktopMentionBoxPositionY,
    required this.isGroupAdmin,
    required this.activeMentionIndex,
    required this.currentFilteredMembersListForMention,
    required this.groupMemberList,
    this.membersNeedToMention,
    required this.currentConversationShowName,
    required this.hasStickerPlugin,
    required this.stickerPluginInstance,
  });
}

class MessageInputBuilderMethods {
  final Function({
    required String text,
    List<String>? mentionedUsers,
  }) sendTextMessage;
  final Function({String? imagePath, String? imageName, dynamic inputElement}) sendImageMessage;
  final Function({String? videoPath, dynamic inputElement}) sendVideoMessage;
  final Function({String? filePath, String? fileName, dynamic inputElement}) sendFileMessage;
  final Function({required String voicePath, required int duration}) sendVoiceMessage;
  final Future<List<V2TimGroupMemberFullInfo>> Function() onChooseGroupMembers;

  /// TencentCloudChatMessageController
  final Object controller;
  final VoidCallback clearRepliedMessage;

  final ValueChanged<double> setDesktopMentionBoxPositionX;
  final ValueChanged<double> setDesktopMentionBoxPositionY;
  final ValueChanged<int> setActiveMentionIndex;
  final ValueChanged<List<V2TimGroupMemberFullInfo?>> setCurrentFilteredMembersListForMention;
  final AutoScrollController desktopInputMemberSelectionPanelScroll;

  /// MessageAttachmentOptionsBuilder
  final Object messageAttachmentOptionsBuilder;
  final void Function() closeSticker;

  MessageInputBuilderMethods({
    required this.sendTextMessage,
    required this.sendImageMessage,
    required this.sendVideoMessage,
    required this.sendFileMessage,
    required this.messageAttachmentOptionsBuilder,
    required this.sendVoiceMessage,
    required this.onChooseGroupMembers,
    required this.controller,
    required this.clearRepliedMessage,
    required this.setDesktopMentionBoxPositionX,
    required this.setDesktopMentionBoxPositionY,
    required this.setActiveMentionIndex,
    required this.setCurrentFilteredMembersListForMention,
    required this.desktopInputMemberSelectionPanelScroll,
    required this.closeSticker,
  });
}

class MessageRowMessageSenderAvatarBuilderWidgets {
  final Widget messageRowMessageSenderAvatarView;

  MessageRowMessageSenderAvatarBuilderWidgets({
    required this.messageRowMessageSenderAvatarView,
  });
}

class MessageRowMessageSenderAvatarBuilderData {
  final String? userID;
  final String? topicID;
  final String? groupID;
  final V2TimMessage message;
  final String messageSenderAvatarURL;

  MessageRowMessageSenderAvatarBuilderData({
    this.userID,
    this.topicID,
    this.groupID,
    required this.message,
    required this.messageSenderAvatarURL,
  });
}

class MessageRowMessageSenderAvatarBuilderMethods {
  final OnTapMessageRelated? onCustomUIEventTapAvatar;
  final OnTapMessageRelated? onCustomUIEventLongPressAvatar;

  MessageRowMessageSenderAvatarBuilderMethods({
    this.onCustomUIEventTapAvatar,
    this.onCustomUIEventLongPressAvatar,
  });
}

class MessageRowMessageSenderNameBuilderWidgets {
  final Widget messageRowMessageSenderNameView;

  MessageRowMessageSenderNameBuilderWidgets({
    required this.messageRowMessageSenderNameView,
  });
}

class MessageRowMessageSenderNameBuilderData {
  final String? userID;
  final String? topicID;
  final String? groupID;
  final V2TimMessage message;
  final String messageSenderName;

  MessageRowMessageSenderNameBuilderData({
    this.userID,
    this.topicID,
    this.groupID,
    required this.message,
    required this.messageSenderName,
  });
}

class MessageRowMessageSenderNameBuilderMethods {}

class MessageRowBuilderWidgets {
  final Widget messageRowAvatar;
  final Widget messageRowMessageSenderName;

  /// One of them will be provided11
  final Widget? messageRowTips;
  final Widget? messageRowMessageItem;

  final Widget? messageReplyItem;

  final Widget? messageTextTranslateItem;

  final Widget? messageSoundToTextItem;

  MessageRowBuilderWidgets({
    required this.messageRowAvatar,
    this.messageRowMessageItem,
    this.messageTextTranslateItem,
    required this.messageRowMessageSenderName,
    this.messageRowTips,
    this.messageReplyItem,
    this.messageSoundToTextItem
  });
}

class MessageRowBuilderData {
  final V2TimMessage message;
  final String? userID;
  final String? topicID;
  final String? groupID;

  /// The width of the message row, which represents the available width
  /// for displaying the message on the screen. This is useful for
  /// automatically wrapping text messages in a message bubble.
  final double messageRowWidth;
  final bool inSelectMode;
  final bool isSelected;
  final bool showMessageStatusIndicator;
  final bool showSelfAvatar;
  final bool showOthersAvatar;
  final bool showMessageSenderName;
  final bool showMessageTimeIndicator;
  final bool isMergeMessage;
  final bool hasStickerPlugin;
  final TencentCloudChatPlugin? stickerPluginInstance;

  MessageRowBuilderData({
    required this.message,
    this.userID,
    this.groupID,
    this.topicID,
    required this.messageRowWidth,
    required this.showMessageSenderName,
    required this.inSelectMode,
    required this.isSelected,
    required this.isMergeMessage,
    required this.showMessageStatusIndicator,
    required this.showSelfAvatar,
    required this.showOthersAvatar,
    required this.showMessageTimeIndicator,
    required this.hasStickerPlugin,
    this.stickerPluginInstance,
  });
}

class MessageRowBuilderMethods {
  final ValueChanged<V2TimMessage> onSelectCurrent;

  final Future<bool> Function({
    required bool highLightTargetMessage,
    V2TimMessage? message,
    int? timeStamp,
    int? seq,
  }) loadToSpecificMessage;

  MessageRowBuilderMethods({
    required this.onSelectCurrent,
    required this.loadToSpecificMessage,
  });
}
