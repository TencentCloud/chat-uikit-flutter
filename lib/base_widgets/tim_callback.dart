enum TIMCallbackType { API_ERROR, FLUTTER_ERROR, INFO }

class TIMCallback {
  TIMCallbackType? type;
  String? errorMsg;
  int? errorCode;
  StackTrace? stackTrace;
  Object? catchError;
  int? infoCode;
  String? infoRecommendText;

  TIMCallback(
      {this.catchError,
      this.infoRecommendText,
      this.errorMsg,
      this.errorCode,
      this.stackTrace,
      this.infoCode,
      this.type});
}
