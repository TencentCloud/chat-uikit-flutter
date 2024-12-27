class TranslationData {
  static const int msgTranslateStatusUnknown = 0;
  static const int msgTranslateStatusHidden = 1;
  static const int msgTranslateStatusLoading = 2;
  static const int msgTranslateStatusShown = 3;

  final String translation;
  final int translationViewStatus;

  TranslationData({
    required this.translation,
    required this.translationViewStatus,
  });

  static TranslationData fromJson(Map<String, dynamic> json) {
    return TranslationData(
      translation: json['translation'],
      translationViewStatus: json['translationViewStatus'],
    );
  }

  // 添加一个方法来返回一个Map对象
  Map<String, dynamic> toJson() {
    return {
      'translation': translation,
      'translation_view_status': translationViewStatus,
    };
  }
}