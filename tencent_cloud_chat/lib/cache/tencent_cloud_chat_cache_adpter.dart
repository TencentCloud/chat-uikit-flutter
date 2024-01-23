import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class TencentCloudChatAdpter {
  TencentCloudChatAdpter(
      {required this.name, required this.age, required this.friends});

  @HiveField(0)
  String name;

  @HiveField(1)
  int age;

  @HiveField(2)
  List<String> friends;

  @override
  String toString() {
    return '$name: $age';
  }
}
