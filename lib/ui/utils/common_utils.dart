class TencentUtils{
  static bool isTextNotEmpty(String? text){
    return text != null && text.isNotEmpty;
  }

  static String? checkString(String? text){
    return (text != null && text.isEmpty) ? null : text;
  }
}