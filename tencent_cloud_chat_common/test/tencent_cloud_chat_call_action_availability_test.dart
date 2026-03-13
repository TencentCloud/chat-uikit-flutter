import 'package:flutter_test/flutter_test.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_call_action_availability.dart';

void main() {
  group('TencentCloudChatCallActionAvailability', () {
    test('disables direct c2c call actions when the remote user is offline',
        () {
      final enabled = shouldEnableDirectCallActions(
        userID: 'offline-user',
        groupID: null,
        getUserOnlineStatus: ({required String userID}) => false,
      );

      expect(enabled, isFalse);
    });

    test('keeps direct c2c call actions enabled when the remote user is online',
        () {
      final enabled = shouldEnableDirectCallActions(
        userID: 'online-user',
        groupID: null,
        getUserOnlineStatus: ({required String userID}) => true,
      );

      expect(enabled, isTrue);
    });

    test('does not disable group call actions based on a single user status',
        () {
      var onlineStatusQueried = false;

      final enabled = shouldEnableDirectCallActions(
        userID: null,
        groupID: 'group-1',
        getUserOnlineStatus: ({required String userID}) {
          onlineStatusQueried = true;
          return false;
        },
      );

      expect(enabled, isTrue);
      expect(onlineStatusQueried, isFalse);
    });
  });
}
