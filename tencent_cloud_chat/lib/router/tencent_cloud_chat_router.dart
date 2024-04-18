import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/log/tencent_cloud_chat_log.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';

/// A utility class for managing the global routing table for TencentCloudChat
///
/// This class provides a singleton instance for managing the global routing table
/// for the entire application. It enables the registration of routes and navigation
/// between components across different package of widgets.
///
/// All widgets in the Chat UIKit should register their routes with this class
/// to ensure consistent navigation behavior.
class TencentCloudChatRouter {
  // Private constructor to implement the singleton pattern.
  TencentCloudChatRouter._internal();

  // Factory constructor that returns the singleton instance of TencentCloudChatRouter.
  factory TencentCloudChatRouter() => _instance;
  static final TencentCloudChatRouter _instance =
      TencentCloudChatRouter._internal();

  /// A map containing the registered routes.
  final Map<String, WidgetBuilder> routes = {};

  /// A global route observer for listening to route changes.
  final RouteObserver<Route<dynamic>> routeObserver = RouteObserver();

  /// Registers a route with the given [routeName] and [builder].
  ///
  /// This method should be called separately during the `initUIKit` process of
  /// `TencentCloudChatController` for each component
  /// (e.g. Message or Conversation) in the main function of the application.
  /// It automatically adds the component to the global routing table, allowing
  /// other components to navigate to it.
  void registerRouter({
    required String routeName,
    required WidgetBuilder builder,
  }) {
    routes[routeName] = builder;
  }

  /// Retrieves an argument of type [T] from the route's argument map using the given [key].
  ///
  /// This method is useful for retrieving arguments passed during navigation.
  /// Returns the argument value if found, or `null` if the argument is not found or is of the wrong type.
  T? getArgumentFromMap<T>(BuildContext context, String key) {
    var argument = ModalRoute.of(context)!.settings.arguments;
    if (argument == null || argument is! Map) {
      return null;
    }
    Map<String, Object?> argMap = argument as Map<String, Object?>;
    return argMap[key] as T?;
  }

  /// Navigates to the specified [routeName] with the given [options] as arguments.
  ///
  /// This method pushes a new route to the navigation stack and returns a
  /// [Future] that completes when the pushed route is popped.
  ///
  /// The [BuildContext] [context] and the target [routeName] are required.
  /// The [options] parameter is optional and can be used to pass additional
  /// arguments to the target route.
  Future<T?>? navigateTo<T extends Object?>({
    required BuildContext context,
    required String routeName,
    dynamic options,
  }) {
    if (routes[routeName] != null) {
      try {
        return Navigator.push(
          context,
          MaterialPageRoute(
            builder: routes[routeName]!,
            settings: RouteSettings(arguments: {
              'options': options,
            }),
          ),
        );
      } catch (e) {
        TencentCloudChat.instance.logInstance.console(
          componentName: 'Navigator',
          logs: '`$routeName` failed: ${e.toString()}',
          logLevel: TencentCloudChatLogLevel.error,
        );
      }
    } else {
      TencentCloudChat.instance.logInstance.console(
        componentName: 'Navigator',
        logs: '`$routeName` not registered',
        logLevel: TencentCloudChatLogLevel.error,
      );
    }
    return null;
  }
}
