import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';

class TencentCloudChatUserProfileOptions {
  final String userID;
  final V2TimUserFullInfo? userFullInfo;
  final VoidCallback? startVoiceCall;
  final VoidCallback? startVideoCall;
  bool? isNavigatedFromChat = true;

  // Constructor for TencentCloudChatUserProfileOptions.
  TencentCloudChatUserProfileOptions({
    required this.userID,
    this.userFullInfo,
    this.startVoiceCall,
    this.startVideoCall,
    this.isNavigatedFromChat,
  });

  // Converts the TencentCloudChatMessageOptions object to a map.
  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
    };
  }

  // Creates a TencentCloudChatMessageOptions object from the given map.
  static TencentCloudChatUserProfileOptions fromMap(Map<String, dynamic> map) {
    return TencentCloudChatUserProfileOptions(
        userID: map['userID'] as String,
        startVideoCall: map['startVideoCall'] as VoidCallback,
        startVoiceCall: map['startVoiceCall'] as VoidCallback,
        isNavigatedFromChat: map['isNavigatedFromChat'] ?? true);
  }
}
