class CustomSticker {
  const CustomSticker(
      {required this.name, required this.index, this.url, this.unicode});

  final int? unicode;
  final String name;
  final int index;
  final String? url;
}
