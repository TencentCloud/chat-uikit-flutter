import 'package:flutter/material.dart';

class VoteLocalImageManager {
  static AssetImage packageImagefn(String name) {
    return AssetImage(
      name,
      package: "tencent_cloud_chat_vote_plugin",
    );
  }

  static Image voteOptionsItemDefaultIcon({
    double? width,
    double? height,
  }) {
    return Image(
      filterQuality: FilterQuality.high,
      width: width,
      height: height,
      image: packageImagefn("assets/poll_delete_option_disable.png"),
      fit: BoxFit.cover,
    );
  }

  static Image voteOptionsItemAddDisable({
    double? width,
    double? height,
  }) {
    return Image(
      image: packageImagefn("assets/poll_add_option_disable.png"),
      filterQuality: FilterQuality.high,
      width: width,
      height: height,
    );
  }

  static Image voteOptionsItemAddenable({
    double? width,
    double? height,
  }) {
    return Image(
      image: packageImagefn("assets/poll_add_option_enable_light.png"),
      filterQuality: FilterQuality.high,
      width: width,
      height: height,
    );
  }

  static Image voteOptionsItemDelete({
    double? width,
    double? height,
  }) {
    return Image(
      image: packageImagefn("assets/poll_delete_option_enable.png"),
      filterQuality: FilterQuality.high,
      width: width,
      height: height,
    );
  }

  static Image voteMessageTitleIcon({
    double? width,
    double? height,
  }) {
    return Image(
      image: packageImagefn("assets/poll_message_title_icon_light.png"),
      filterQuality: FilterQuality.high,
      width: width,
      height: height,
    );
  }
}
