class TencentCloudChatUserConfig {
  /// Whether to use the user's online status. Note that using this function requires the IM Ultimate version.
  bool? useUserOnlineStatus;
  bool? autoDownloadMultimediaMessage;
  TencentCloudChatUserConfig({
    this.useUserOnlineStatus,
    this.autoDownloadMultimediaMessage,
  });
}
