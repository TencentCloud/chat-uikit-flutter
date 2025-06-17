import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_builder.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_builder_definitions.dart';
import 'package:tencent_cloud_chat_common/data/message/tencent_cloud_chat_message_data.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_header/tencent_cloud_chat_message_header.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_input/forward/tencent_cloud_chat_message_forward.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_input/message_reply/tencent_cloud_chat_message_input_reply.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_input/mobile/tencent_cloud_chat_message_attachment_options.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_input/select_mode/tencent_cloud_chat_message_input_select_mode.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_input/tencent_cloud_chat_message_input.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_layout/special_case/tencent_cloud_chat_message_no_chat.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_layout/tencent_cloud_chat_message_layout.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_list_view/dynamic_button/tencent_cloud_chat_dynamic_button.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_list_view/message_row/tencent_cloud_chat_message_row.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_list_view/message_row/tencent_cloud_chat_message_row_message_sender_avatar.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_list_view/message_row/tencent_cloud_chat_message_row_message_sender_name.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_list_view/tencent_cloud_chat_message_list_view.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/menu/tencent_cloud_chat_message_item_with_menu.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/tencent_cloud_chat_message_item_builders.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/tencent_cloud_chat_message_reply_view.dart';

typedef MessageDynamicButtonBuilder = Widget? Function({
  Key? key,
  required MessageDynamicButtonBuilderWidgets widgets,
  required MessageDynamicButtonBuilderData data,
  required MessageDynamicButtonBuilderMethods methods,
});

typedef MessageLayoutBuilder = Widget? Function({
  Key? key,
  required MessageLayoutBuilderWidgets widgets,
  required MessageLayoutBuilderData data,
  required MessageLayoutBuilderMethods methods,
});

typedef MessageListViewBuilder = Widget? Function({
  Key? key,
  required MessageListViewBuilderWidgets widgets,
  required MessageListViewBuilderData data,
  required MessageListViewBuilderMethods methods,
});

typedef MessageReplyViewBuilder = Widget? Function({
  Key? key,
  required MessageReplyViewBuilderWidgets widgets,
  required MessageReplyViewBuilderData data,
  required MessageReplyViewBuilderMethods methods,
});

typedef MessageNoChatBuilder = Widget? Function();

typedef MessageInputBuilder = Widget? Function({
  Key? key,
  required MessageInputBuilderWidgets widgets,
  required MessageInputBuilderData data,
  required MessageInputBuilderMethods methods,
});

typedef MessageRowBuilder = Widget? Function({
  Key? key,
  required MessageRowBuilderWidgets widgets,
  required MessageRowBuilderData data,
  required MessageRowBuilderMethods methods,
});

typedef MessageRowMessageSenderAvatarBuilder = Widget? Function({
  Key? key,
  required MessageRowMessageSenderAvatarBuilderWidgets widgets,
  required MessageRowMessageSenderAvatarBuilderData data,
  required MessageRowMessageSenderAvatarBuilderMethods methods,
});

typedef MessageRowMessageSenderNameBuilder = Widget? Function({
  Key? key,
  required MessageRowMessageSenderNameBuilderWidgets widgets,
  required MessageRowMessageSenderNameBuilderData data,
  required MessageRowMessageSenderNameBuilderMethods methods,
});

typedef MAOInternalBuilder = Widget? Function({
  Key? key,
  required MessageAttachmentOptionsBuilderData data,
  required MessageAttachmentOptionsBuilderMethods methods,
});

typedef MessageAttachmentOptionsBuilder = Widget? Function({
  Key? key,
  required MessageAttachmentOptionsBuilderWidgets widgets,
  required MessageAttachmentOptionsBuilderData data,
  required MessageAttachmentOptionsBuilderMethods methods,
});

typedef MessageHeaderBuilder = Widget? Function({
  Key? key,
  required MessageHeaderBuilderWidgets widgets,
  required MessageHeaderBuilderData data,
  required MessageHeaderBuilderMethods methods,
});

typedef MessageItemBuilder = Widget? Function({
  Key? key,
  required MessageItemBuilderWidgets widgets,
  required MessageItemBuilderData data,
  required MessageItemBuilderMethods methods,
});

typedef MessageItemMenuBuilder = Widget? Function({
  Key? key,
  required MessageItemMenuBuilderWidgets widgets,
  required MessageItemMenuBuilderData data,
  required MessageItemMenuBuilderMethods methods,
});

typedef MessageForwardBuilder = Widget? Function({
  Key? key,
  required MessageForwardBuilderWidgets widgets,
  required MessageForwardBuilderData data,
  required MessageForwardBuilderMethods methods,
});

typedef MFInternalBuilder = Widget? Function({
  Key? key,
  MessageForwardBuilderWidgets? widgets,
  required MessageForwardBuilderData data,
  required MessageForwardBuilderMethods methods,
});

typedef MessageInputReplyBuilder = Widget? Function({
  Key? key,
  required MessageInputReplyBuilderWidgets widgets,
  required MessageInputReplyBuilderData data,
  required MessageInputReplyBuilderMethods methods,
});

typedef MessageInputSelectBuilder = Widget? Function({
  Key? key,
  required MessageInputSelectBuilderWidgets widgets,
  required MessageInputSelectBuilderData data,
  required MessageInputSelectBuilderMethods methods,
});

class TencentCloudChatMessageBuilders extends TencentCloudChatComponentBuilder {
  MessageLayoutBuilder? _messageLayoutBuilder;
  MessageHeaderBuilder? _messageHeaderBuilder;
  MessageListViewBuilder? _messageListViewBuilder;
  MessageRowBuilder? _messageRowBuilder;
  MessageInputBuilder? _messageInputBuilder;
  MessageAttachmentOptionsBuilder? _messageAttachmentOptionsBuilder;
  MessageItemMenuBuilder? _messageItemMenuBuilder;
  MessageForwardBuilder? _messageForwardBuilder;
  MessageInputReplyBuilder? _messageInputReplyBuilder;
  MessageInputSelectBuilder? _messageInputSelectBuilder;
  MessageNoChatBuilder? _messageNoChatBuilder;
  MessageReplyViewBuilder? _messageReplyViewBuilder;
  MessageItemBuilder? _messageItemBuilder;
  MessageDynamicButtonBuilder? _messageDynamicButtonBuilder;
  MessageRowMessageSenderNameBuilder? _messageRowMessageSenderNameBuilder;
  MessageRowMessageSenderAvatarBuilder? _messageRowMessageSenderAvatarBuilder;

  TencentCloudChatMessageBuilders({
    MessageLayoutBuilder? messageLayoutBuilder,
    MessageHeaderBuilder? messageHeaderBuilder,
    MessageListViewBuilder? messageListViewBuilder,
    MessageRowBuilder? messageRowBuilder,
    MessageInputBuilder? messageInputBuilder,
    MessageAttachmentOptionsBuilder? messageAttachmentOptionsBuilder,
    MessageItemMenuBuilder? messageItemMenuBuilder,
    MessageForwardBuilder? messageForwardBuilder,
    MessageInputReplyBuilder? messageInputReplyBuilder,
    MessageNoChatBuilder? messageNoChatBuilder,
    MessageInputSelectBuilder? messageInputSelectBuilder,
    MessageReplyViewBuilder? messageReplyViewBuilder,
    MessageItemBuilder? messageItemBuilder,
    MessageDynamicButtonBuilder? messageDynamicButtonBuilder,
    MessageRowMessageSenderNameBuilder? messageRowMessageSenderNameBuilder,
    MessageRowMessageSenderAvatarBuilder? messageRowMessageSenderAvatarBuilder,
  }) {
    _messageLayoutBuilder = messageLayoutBuilder;
    _messageListViewBuilder = messageListViewBuilder;
    _messageRowBuilder = messageRowBuilder;
    _messageInputBuilder = messageInputBuilder;
    _messageAttachmentOptionsBuilder = messageAttachmentOptionsBuilder;
    _messageHeaderBuilder = messageHeaderBuilder;
    _messageItemMenuBuilder = messageItemMenuBuilder;
    _messageForwardBuilder = messageForwardBuilder;
    _messageNoChatBuilder = messageNoChatBuilder;
    _messageInputReplyBuilder = messageInputReplyBuilder;
    _messageReplyViewBuilder = messageReplyViewBuilder;
    _messageInputSelectBuilder = messageInputSelectBuilder;
    _messageItemBuilder = messageItemBuilder;
    _messageDynamicButtonBuilder = messageDynamicButtonBuilder;
    _messageRowMessageSenderNameBuilder = messageRowMessageSenderNameBuilder;
    _messageRowMessageSenderAvatarBuilder = messageRowMessageSenderAvatarBuilder;
  }

  void setBuilders({
    MessageDynamicButtonBuilder? messageDynamicButtonBuilder,
    MessageLayoutBuilder? messageLayoutBuilder,
    MessageHeaderBuilder? messageHeaderBuilder,
    MessageListViewBuilder? messageListViewBuilder,
    MessageRowBuilder? messageRowBuilder,
    MessageInputBuilder? messageInputBuilder,
    MessageAttachmentOptionsBuilder? messageAttachmentOptionsBuilder,
    MessageItemMenuBuilder? messageItemMenuBuilder,
    MessageForwardBuilder? messageForwardBuilder,
    MessageInputReplyBuilder? messageInputReplyBuilder,
    MessageReplyViewBuilder? messageReplyViewBuilder,
    MessageNoChatBuilder? messageNoChatBuilder,
    MessageInputSelectBuilder? messageInputSelectBuilder,
    MessageItemBuilder? messageItemBuilder,
    MessageRowMessageSenderNameBuilder? messageRowMessageSenderNameBuilder,
    MessageRowMessageSenderAvatarBuilder? messageRowMessageSenderAvatarBuilder,
  }) {
    _messageLayoutBuilder = messageLayoutBuilder ?? _messageLayoutBuilder;
    _messageListViewBuilder = messageListViewBuilder ?? _messageListViewBuilder;
    _messageDynamicButtonBuilder = messageDynamicButtonBuilder ?? _messageDynamicButtonBuilder;
    _messageItemBuilder = messageItemBuilder ?? _messageItemBuilder;
    _messageRowBuilder = messageRowBuilder ?? _messageRowBuilder;
    _messageInputBuilder = messageInputBuilder ?? _messageInputBuilder;
    _messageAttachmentOptionsBuilder = messageAttachmentOptionsBuilder ?? _messageAttachmentOptionsBuilder;
    _messageHeaderBuilder = messageHeaderBuilder ?? _messageHeaderBuilder;
    _messageItemMenuBuilder = messageItemMenuBuilder ?? _messageItemMenuBuilder;
    _messageForwardBuilder = messageForwardBuilder ?? _messageForwardBuilder;
    _messageNoChatBuilder = messageNoChatBuilder ?? _messageNoChatBuilder;
    _messageReplyViewBuilder = messageReplyViewBuilder ?? _messageReplyViewBuilder;
    _messageInputReplyBuilder = messageInputReplyBuilder ?? _messageInputReplyBuilder;
    _messageInputSelectBuilder = messageInputSelectBuilder ?? _messageInputSelectBuilder;
    _messageRowMessageSenderNameBuilder = messageRowMessageSenderNameBuilder ?? _messageRowMessageSenderNameBuilder;
    _messageRowMessageSenderAvatarBuilder =
        messageRowMessageSenderAvatarBuilder ?? _messageRowMessageSenderAvatarBuilder;
    TencentCloudChat.instance.dataInstance.messageData.notifyListener(TencentCloudChatMessageDataKeys.builder);
  }

  @override
  Widget getMessageRowMessageSenderNameBuilder({
    Key? key,
    MessageRowMessageSenderNameBuilderWidgets? widgets,
    required MessageRowMessageSenderNameBuilderData data,
    required MessageRowMessageSenderNameBuilderMethods methods,
  }) {
    Widget? widget;

    if (_messageRowMessageSenderNameBuilder != null) {
      widget = _messageRowMessageSenderNameBuilder!(
        key: key,
        widgets: widgets ??
            MessageRowMessageSenderNameBuilderWidgets(
              messageRowMessageSenderNameView: TencentCloudChatMessageRowMessageSenderName(
                data: data,
                methods: methods,
              ),
            ),
        data: data,
        methods: methods,
      );
    }

    return widget ??
        TencentCloudChatMessageRowMessageSenderName(
          key: key,
          data: data,
          methods: methods,
        );
  }

  @override
  Widget getMessageRowMessageSenderAvatarBuilder({
    Key? key,
    MessageRowMessageSenderAvatarBuilderWidgets? widgets,
    required MessageRowMessageSenderAvatarBuilderData data,
    required MessageRowMessageSenderAvatarBuilderMethods methods,
    bool showOthersAvatar = false,
    bool showSelfAvatar = false,
  }) {
    Widget? widget;

    if (_messageRowMessageSenderAvatarBuilder != null) {
      widget = _messageRowMessageSenderAvatarBuilder!(
        key: key,
        widgets: widgets ??
            MessageRowMessageSenderAvatarBuilderWidgets(
              messageRowMessageSenderAvatarView: TencentCloudChatMessageRowMessageSenderAvatar(
                data: data,
                methods: methods,
                showOthersAvatar: showOthersAvatar,
                showSelfAvatar: showSelfAvatar,
              ),
            ),
        data: data,
        methods: methods,
      );
    }

    return widget ??
        TencentCloudChatMessageRowMessageSenderAvatar(
          key: key,
          data: data,
          methods: methods,
          showOthersAvatar: showOthersAvatar,
          showSelfAvatar: showSelfAvatar,
        );
  }

  @override
  Widget getMessageDynamicButtonBuilder({
    Key? key,
    MessageDynamicButtonBuilderWidgets? widgets,
    required MessageDynamicButtonBuilderData data,
    required MessageDynamicButtonBuilderMethods methods,
  }) {
    Widget? widget;

    if (_messageDynamicButtonBuilder != null) {
      widget = _messageDynamicButtonBuilder!(
        key: key,
        widgets: widgets ??
            MessageDynamicButtonBuilderWidgets(
              messageDynamicButtonView: TencentCloudChatMessageListViewDynamicButton(
                data: data,
                methods: methods,
              ),
            ),
        data: data,
        methods: methods,
      );
    }

    return widget ??
        TencentCloudChatMessageListViewDynamicButton(
          key: key,
          data: data,
          methods: methods,
        );
  }

  @override
  Widget getMessageInputSelectBuilder({
    Key? key,
    MessageInputSelectBuilderWidgets? widgets,
    required MessageInputSelectBuilderData data,
    required MessageInputSelectBuilderMethods methods,
  }) {
    Widget? widget;

    if (_messageInputSelectBuilder != null) {
      widget = _messageInputSelectBuilder!(
        key: key,
        widgets: widgets ??
            MessageInputSelectBuilderWidgets(
              messageInputSelectView: TencentCloudChatMessageInputSelectMode(
                data: data,
                methods: methods,
              ),
            ),
        data: data,
        methods: methods,
      );
    }

    return widget ??
        TencentCloudChatMessageInputSelectMode(
          key: key,
          data: data,
          methods: methods,
        );
  }

  Widget getMessageReplyViewBuilder({
    Key? key,
    MessageReplyViewBuilderWidgets? widgets,
    required MessageReplyViewBuilderData data,
    required MessageReplyViewBuilderMethods methods,
  }) {
    Widget? widget;

    if (_messageReplyViewBuilder != null) {
      widget = _messageReplyViewBuilder!(
        key: key,
        widgets: widgets ??
            MessageReplyViewBuilderWidgets(
              messageReplyView: TencentCloudChatMessageReplyView(
                data: data,
                methods: methods,
              ),
            ),
        data: data,
        methods: methods,
      );
    }

    return widget ??
        TencentCloudChatMessageReplyView(
          key: key,
          data: data,
          methods: methods,
        );
  }

  @override
  Widget getMessageNoChatBuilder() {
    Widget? widget;

    if (_messageNoChatBuilder != null) {
      widget = _messageNoChatBuilder!();
    }

    return widget ?? const TencentCloudChatMessageNoChat();
  }

  @override
  Widget getMessageInputReplyBuilder({
    Key? key,
    MessageInputReplyBuilderWidgets? widgets,
    required MessageInputReplyBuilderData data,
    required MessageInputReplyBuilderMethods methods,
  }) {
    Widget? widget;

    if (_messageInputReplyBuilder != null) {
      widget = _messageInputReplyBuilder!(
        key: key,
        widgets: widgets ??
            MessageInputReplyBuilderWidgets(
                messageInputReplyView: TencentCloudChatMessageInputReply(
              key: key,
              widgets: widgets,
              data: data,
              methods: methods,
            )),
        data: data,
        methods: methods,
      );
    }

    return widget ??
        TencentCloudChatMessageInputReply(
          key: key,
          widgets: widgets,
          data: data,
          methods: methods,
        );
  }

  @override
  Widget getMessageForwardBuilder({
    Key? key,
    MessageForwardBuilderWidgets? widgets,
    required MessageForwardBuilderData data,
    required MessageForwardBuilderMethods methods,
  }) {
    Widget? widget;

    if (_messageForwardBuilder != null) {
      widget = _messageForwardBuilder!(
        key: key,
        widgets: widgets ??
            MessageForwardBuilderWidgets(
              messageForwardView: TencentCloudChatMessageForward(
                key: key,
                widgets: widgets,
                data: data,
                methods: methods,
              ),
            ),
        data: data,
        methods: methods,
      );
    }

    return widget ??
        TencentCloudChatMessageForward(
          key: key,
          widgets: widgets,
          data: data,
          methods: methods,
        );
  }

  Widget getMessageItemMenuBuilder({
    Key? key,
    MessageItemMenuBuilderWidgets? widgets,
    required MessageItemMenuBuilderData data,
    required MessageItemMenuBuilderMethods methods,
  }) {
    Widget? widget;

    if (_messageItemMenuBuilder != null) {
      widget = _messageItemMenuBuilder!(
        key: key,
        widgets: widgets ??
            MessageItemMenuBuilderWidgets(
              messageItemMenuView: TencentCloudChatMessageItemWithMenu(
                data: data,
                methods: methods,
              ),
            ),
        data: data,
        methods: methods,
      );
    }

    return widget ??
        TencentCloudChatMessageItemWithMenu(
          key: key,
          data: data,
          methods: methods,
        );
  }

  @override
  Widget getMessageItemBuilder({
    Key? key,
    MessageItemBuilderWidgets? widgets,
    required MessageItemBuilderData data,
    required MessageItemBuilderMethods methods,
  }) {
    Widget? widget;

    if (_messageItemBuilder != null) {
      widget = _messageItemBuilder!(
        key: key,
        widgets: widgets ??
            MessageItemBuilderWidgets(
              messageItemView: TencentCloudChatMessageItemBuilders.getMessageItemBuilder(
                data: data,
                methods: methods,
              ),
            ),
        data: data,
        methods: methods,
      );
    }

    return widget ??
        TencentCloudChatMessageItemBuilders.getMessageItemBuilder(
          data: data,
          methods: methods,
        );
  }

  @override
  Widget getMessageHeader({
    Key? key,
    required MessageHeaderBuilderWidgets widgets,
    required MessageHeaderBuilderData data,
    required MessageHeaderBuilderMethods methods,
  }) {
    Widget? widget;

    if (_messageHeaderBuilder != null) {
      widget = _messageHeaderBuilder!(
        key: key,
        widgets: widgets,
        data: data,
        methods: methods,
      );
    }

    return widget ??
        TencentCloudChatMessageHeader(
          key: key,
          widgets: widgets,
          data: data,
          methods: methods,
        );
  }

  @override
  Widget getAttachmentOptionsBuilder({
    Key? key,
    MessageAttachmentOptionsBuilderWidgets? widgets,
    required MessageAttachmentOptionsBuilderData data,
    required MessageAttachmentOptionsBuilderMethods methods,
  }) {
    Widget? widget;

    if (_messageAttachmentOptionsBuilder != null) {
      widget = _messageAttachmentOptionsBuilder!(
        key: key,
        methods: methods,
        data: data,
        widgets: widgets ??
            MessageAttachmentOptionsBuilderWidgets(
              messageAttachmentOptionsView: TencentCloudChatMessageAttachmentOptionsWidget(
                methods: methods,
                data: data,
              ),
            ),
      );
    }

    return widget ??
        TencentCloudChatMessageAttachmentOptionsWidget(
          key: key,
          methods: methods,
          data: data,
        );
  }

  @override
  Widget getMessageInputBuilder({
    Key? key,
    MessageInputBuilderWidgets? widgets,
    required MessageInputBuilderData data,
    required MessageInputBuilderMethods methods,
  }) {
    Widget? widget;

    if (_messageInputBuilder != null) {
      widget = _messageInputBuilder!(
        key: key,
        data: data,
        methods: methods,
        widgets: widgets ??
            MessageInputBuilderWidgets(
              messageInput: TencentCloudChatMessageInput(
                data: data,
                methods: methods,
            )),
      );
    }

    return widget ??
        TencentCloudChatMessageInput(
          key: key,
          data: data,
          methods: methods,
        );
  }

  @override
  Widget getMessageRowBuilder({
    Key? key,
    required MessageRowBuilderWidgets widgets,
    required MessageRowBuilderData data,
    required MessageRowBuilderMethods methods,
  }) {
    Widget? widget;

    if (_messageRowBuilder != null) {
      widget = _messageRowBuilder!(
        key: key,
        widgets: widgets,
        data: data,
        methods: methods,
      );
    }

    return widget ??
        TencentCloudChatMessageRow(
          key: key,
          widgets: widgets,
          data: data,
          methods: methods,
        );
  }

  @override
  Widget getMessageLayoutBuilder({
    Key? key,
    required MessageLayoutBuilderWidgets widgets,
    required MessageLayoutBuilderData data,
    required MessageLayoutBuilderMethods methods,
  }) {
    Widget? widget;

    if (_messageLayoutBuilder != null) {
      widget = _messageLayoutBuilder!(
        key: key,
        data: data,
        widgets: widgets,
        methods: methods,
      );
    }

    return widget ??
        TencentCloudChatMessageLayout(
          key: key,
          data: data,
          widgets: widgets,
          methods: methods,
        );
  }

  Widget getMessageListViewBuilder({
    Key? key,
    MessageListViewBuilderWidgets? widgets,
    required MessageListViewBuilderData data,
    required MessageListViewBuilderMethods methods,
  }) {
    Widget? widget;

    if (_messageListViewBuilder != null) {
      widget = _messageListViewBuilder!(
        key: key,
        data: data,
        methods: methods,
        widgets: widgets ??
            MessageListViewBuilderWidgets(
                messageListView: TencentCloudChatMessageListView(
              data: data,
              methods: methods,
            )),
      );
    }

    return widget ??
        TencentCloudChatMessageListView(
          key: key,
          data: data,
          methods: methods,
        );
  }
}
