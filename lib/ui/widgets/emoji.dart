
class Emoji {
  String name;
  int unicode;

  Emoji({required this.name, required this.unicode});

  factory Emoji.fromJson(Map<String, dynamic> json) {
    return Emoji(
      name: json['name'],
      unicode: json['unicode'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['unicode'] = unicode;
    return data;
  }
}