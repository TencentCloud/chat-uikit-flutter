import 'package:tencent_cloud_chat_uikit/business_logic/life_cycle/base_life_cycle.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

class ChatLifeCycle {
  /// Before a new message will be added to historical message list from long connection.
  /// You may not render this message by return null.
  MessageFunctionOptional newMessageWillMount;

  /// Before a modified message updated to historical message list UI.
  MessageFunction modifiedMessageWillMount;

  /// Before a new message will be sent.
  /// Returns null can block the message from sending.
  MessageFunction messageWillSend;

  /// After a new message been sent.
  MessageFunctionNullCallback messageDidSend;

  /// After getting the latest message list from API,
  /// and before historical message list will be rendered.
  /// You may add or delete some messages here.
  MessageListFunction didGetHistoricalMessageList;

  /// Before deleting a message from historical message list,
  /// `true` means can delete continually, while `false` will not delete.
  /// You can make a second confirmation here by a modal, etc.
  FutureBool Function(String msgID) shouldDeleteMessage;

  /// Before clearing the historical message list,
  /// `true` means can clear continually, while `false` will not clear.
  /// You can make a second confirmation here by a modal, etc.
  FutureBool Function(String conversationID) shouldClearHistoricalMessageList;


  /// Before rendering a message to message list.
  bool Function(V2TimMessage msgID) messageShouldMount;

  ChatLifeCycle({
    this.shouldClearHistoricalMessageList =
        DefaultLifeCycle.defaultAsyncBooleanSolution,
    this.shouldDeleteMessage = DefaultLifeCycle.defaultAsyncBooleanSolution,
    this.messageDidSend = DefaultLifeCycle.defaultNullCallbackSolution,
    this.didGetHistoricalMessageList =
        DefaultLifeCycle.defaultMessageListSolution,
    this.messageWillSend = DefaultLifeCycle.defaultMessageSolution,
    this.modifiedMessageWillMount = DefaultLifeCycle.defaultMessageSolution,
    this.newMessageWillMount = DefaultLifeCycle.defaultMessageSolution,
    this.messageShouldMount = DefaultLifeCycle.defaultBooleanSolution,
  });
}
