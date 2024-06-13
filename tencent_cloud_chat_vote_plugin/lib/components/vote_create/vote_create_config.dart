import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_vote_plugin/common/color_manager.dart';
import 'package:tencent_cloud_chat_vote_plugin/model/vote_create_model.dart';

class TencentCloudChatVoteCreateConfig extends StatefulWidget {
  const TencentCloudChatVoteCreateConfig({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatVoteCreateConfigState();
}

class TencentCloudChatVoteCreateConfigState extends State<TencentCloudChatVoteCreateConfig> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: const Column(
        children: [
          TencentCloudChatVoteCreateConfigItem(
            type: VoteConfigType.mutiChoose,
          ),
          TencentCloudChatVoteCreateConfigItem(
            type: VoteConfigType.anonymous,
          ),
          TencentCloudChatVoteCreateConfigItem(
            type: VoteConfigType.resultPublic,
          ),
        ],
      ),
    );
  }
}

enum VoteConfigType {
  none,
  mutiChoose,
  anonymous,
  resultPublic,
}

class TencentCloudChatVoteCreateConfigItem extends StatefulWidget {
  final VoteConfigType type;

  const TencentCloudChatVoteCreateConfigItem({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatVoteCreateConfigItemState();
}

class TencentCloudChatVoteCreateConfigItemState extends State<TencentCloudChatVoteCreateConfigItem> {
  String getItemText() {
    if (widget.type == VoteConfigType.mutiChoose) {
      return ("允许多选");
    } else if (widget.type == VoteConfigType.anonymous) {
      return ("匿名投票");
    } else if (widget.type == VoteConfigType.resultPublic) {
      return ("公开结果");
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: VoteColorsManager.voteConfigBorderBottomColor,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(getItemText()),
          SwitchScreen(
            type: widget.type,
          ),
        ],
      ),
    );
  }
}

class PlatformWidget extends StatelessWidget {
  final Widget androidWidget;
  final Widget iosWidget;

  const PlatformWidget({
    Key? key,
    required this.androidWidget,
    required this.iosWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return androidWidget;
    } else if (Platform.isIOS) {
      return iosWidget;
    } else if (Platform.isMacOS) {
      return iosWidget;
    } else if (Platform.isWindows) {
      return androidWidget;
    } else {
      return const SizedBox.shrink();
    }
  }
}

class SwitchScreen extends StatefulWidget {
  final VoteConfigType type;

  const SwitchScreen({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => SwitchScreenState();
}

class SwitchScreenState extends State<SwitchScreen> {
  onSwithChange(bool value) {
    TencentCloudChatVoteCreateModel pv = Provider.of<TencentCloudChatVoteCreateModel>(
      context,
      listen: false,
    );
    switch (widget.type) {
      case VoteConfigType.anonymous:
        pv.setAnonymous(value);
        break;
      case VoteConfigType.mutiChoose:
        pv.setAllowMultiVote(value);
        break;
      case VoteConfigType.resultPublic:
        pv.setPublic(value);
        break;
      case VoteConfigType.none:
        break;
    }
  }

  bool getSwitchValueByType() {
    bool res = false;
    TencentCloudChatVoteCreateModel pv = Provider.of<TencentCloudChatVoteCreateModel>(
      context,
      listen: true,
    );
    switch (widget.type) {
      case VoteConfigType.none:
        break;
      case VoteConfigType.mutiChoose:
        res = pv.allow_multi_vote;
        break;
      case VoteConfigType.anonymous:
        res = pv.anonymous;
        break;
      case VoteConfigType.resultPublic:
        res = pv.public;
        break;
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    bool switchValue = getSwitchValueByType();

    return Transform.scale(
      scale: 0.8,
      child: PlatformWidget(
        androidWidget: Switch(
          value: switchValue,
          onChanged: onSwithChange,
          activeColor: VoteColorsManager.voteConfigSwitchColor,
        ),
        iosWidget: CupertinoSwitch(
          activeColor: VoteColorsManager.voteConfigSwitchColor,
          value: switchValue,
          onChanged: onSwithChange,
        ),
      ),
    );
  }
}
