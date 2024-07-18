import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/widgets/avatar/tencent_cloud_chat_avatar.dart';

class TencentCloudChatSearchResultBoxItemData {
  final String title;
  final String? subTitle;
  final String? avatarUrl;
  final VoidCallback onTap;
  final String keyword;

  TencentCloudChatSearchResultBoxItemData( {
    required this.title,
    this.subTitle,
    this.avatarUrl,
    required this.keyword,
    required this.onTap,
  });
}

class TencentCloudChatSearchResultItem extends StatelessWidget {
  final TencentCloudChatSearchResultBoxItemData data;
  const TencentCloudChatSearchResultItem({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<TextSpan> buildHighlightedTitle(String title, String keyword, Color primaryColor ) {
      List<TextSpan> spans = [];
      int startIndex = 0;

      while (startIndex < title.length) {
        int keywordIndex = title.indexOf(keyword, startIndex);
        if (keywordIndex == -1) {
          spans.add(TextSpan(text: title.substring(startIndex)));
          break;
        }

        if (keywordIndex > startIndex) {
          spans.add(TextSpan(text: title.substring(startIndex, keywordIndex)));
        }

        spans.add(TextSpan(
            text: title.substring(keywordIndex, keywordIndex + keyword.length),
            style: TextStyle(color: primaryColor)));

        startIndex = keywordIndex + keyword.length;
      }

      return spans;
    }

    return TencentCloudChatThemeWidget(build: (context, colorTheme, textStyle) => ListTile(
      dense: true,
      contentPadding:
      EdgeInsets.symmetric(vertical: data.subTitle != null ? 0 : 4, horizontal: 16),
      leading: data.avatarUrl != null ? TencentCloudChatAvatar(
        imageList: [data.avatarUrl],
        scene: TencentCloudChatAvatarScene.searchResult,
      ) : null,
      title: Text.rich(
        TextSpan(children: buildHighlightedTitle(data.title, data.keyword, colorTheme.primaryColor)),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: data.subTitle != null ? Text(data.subTitle!) : null,
      onTap: data.onTap,
    ));
  }
}