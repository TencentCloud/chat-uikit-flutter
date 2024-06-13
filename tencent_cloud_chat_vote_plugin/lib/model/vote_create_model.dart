// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_vote_plugin/components/vote_create/vote_create.dart';
import 'package:tencent_cloud_chat_vote_plugin/struct/vote_custom_struct.dart';

class TencentCloudChatVoteCreateModel extends ChangeNotifier {
  TencentCloudChatVoteCreateModel({
    required this.groupID,
    required this.onCreateVoteSuccess,
    this.onCreateVoteError,
  });
  final OnCreateVoteSuccess onCreateVoteSuccess;
  final OnCreateVoteError? onCreateVoteError;
  final String groupID;
  String _title = "";
  String get title => _title;
  void setTitle(String t) {
    _title = t;
    notifyListeners();
  }

  bool _public = true;
  bool get public => _public;
  void setPublic(bool p) {
    _public = p;
    notifyListeners();
  }

  bool _allow_multi_vote = false;
  bool get allow_multi_vote => _allow_multi_vote;
  void setAllowMultiVote(bool m) {
    _allow_multi_vote = m;
    notifyListeners();
  }

  bool _anonymous = false;
  bool get anonymous => _anonymous;
  void setAnonymous(bool a) {
    _anonymous = a;
    notifyListeners();
  }

  List<TencentCloudChatVoteDataOptoin> _options = [
    TencentCloudChatVoteDataOptoin(index: 1, option: ""),
    TencentCloudChatVoteDataOptoin(index: 2, option: "")
  ];
  List<TencentCloudChatVoteDataOptoin> get options => _options;
  void setOptions(List<TencentCloudChatVoteDataOptoin> o) {
    _options = o;
    notifyListeners();
  }

  int _nowIndex = 2;
  int get nowIndex => _nowIndex;
  setNowIndex(int index) {
    _nowIndex = index;
    notifyListeners();
  }
}
