class TencentCloudChatPushResult<T> {
  int code;
  String? errorMessage;
  T? data;

  TencentCloudChatPushResult({
    required this.code,
    this.errorMessage,
    this.data,
  });
}
