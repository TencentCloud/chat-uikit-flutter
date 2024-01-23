import 'package:flutter/material.dart';

/// This abstract class represents a base component for Tencent Cloud Chat.
///
/// This abstract class serves as the foundation for all primary components in Tencent Cloud Chat,
/// such as Message, Conversation, etc. By extending this class, external developers can benefit
/// from consistent parameter naming and a clear understanding of how to use these components effectively.
abstract class TencentCloudChatComponent<T, U, K, H, L> extends StatefulWidget {
  /// The options for the component, such as conversation ID, message type, etc.
  final T? options;

  /// The configuration for the component, including module and function switches,
  /// and other settings like `upperRecallTime`, appearance, etc.
  final U? config;

  /// The custom builders for the component, such as message widget builder,
  /// avatar builder, etc., which allow developers to customize the appearance
  /// and behavior of the component.
  final K? builders;

  /// The event handlers for the component, including lifecycle hooks like
  /// events related to chat business (e.g., before or after sending a message),
  /// interactive events (e.g., onTapAvatar), and more.
  final H? eventHandlers;

  /// The controller for the component, which provides various functions
  /// depending on the component type. For example, the MessageController
  /// includes functions like sending a message and scrolling to a specific message.
  final L? controller;

  /// Constructor for TencentCloudChatComponent.
  const TencentCloudChatComponent({
    Key? key,
    this.options,
    this.config,
    this.builders,
    this.eventHandlers,
    this.controller,
  }) : super(key: key);
}
