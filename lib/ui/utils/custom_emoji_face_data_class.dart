class CustomEmojiFaceData {
  CustomEmojiFaceData(
      {required this.name,
      required this.icon,
      required this.list,
      this.isEmoji = false});

  late String name;
  late String icon;
  late List<String> list;
  late bool isEmoji;

  CustomEmojiFaceData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    icon = json['icon'];
    list = json['list'];
    isEmoji = json['isEmoji'] ?? false;
  }
}
