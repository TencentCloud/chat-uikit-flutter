import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

class MessageRepliedData {
  late String messageAbstract;
  late String messageSender;
  late String messageID;

  MessageRepliedData.fromJson(Map messageReply) {
    messageAbstract = messageReply["messageAbstract"];
    messageSender = messageReply["messageSender"] ?? "";
    messageID = messageReply["messageID"];
  }
}

class RepliedMessageAbstract {
  final int? elemType;
  final String? msgID;
  final int? timestamp;
  final String? seq;
  final String? summary;

  RepliedMessageAbstract(
      {this.elemType, this.msgID, this.timestamp, this.seq, this.summary});

  // fromJson constructor
  RepliedMessageAbstract.fromJson(Map<String, dynamic> json)
      : elemType = json['elemType'],
        msgID = json['msgID'],
        timestamp = json['timestamp'],
        seq = json['seq'],
        summary = json['summary'];

  // toJson function
  Map<String, dynamic> toJson() {
    return {
      'summary': summary,
      'elemType': elemType,
      'msgID': msgID,
      'timestamp': timestamp,
      'seq': seq,
    };
  }

  // isNotEmpty method
  bool get isNotEmpty =>
      TencentUtils.checkString(msgID) != null &&
      TencentUtils.checkString(timestamp.toString()) != null &&
      TencentUtils.checkString(seq) != null;
}

class CloudCustomData {
  Map<String, dynamic>? messageReply;
  Map<String, dynamic>? messageReaction = {};

  CloudCustomData.fromJson(Map jsonMap) {
    messageReply = jsonMap["messageReply"];
    messageReaction = jsonMap["messageReaction"] ?? {};
  }

  Map<String, Map?> toMap() {
    final Map<String, Map?> data = {};
    if (messageReply != null) {
      data['messageReply'] = messageReply;
    }
    data['messageReaction'] = messageReaction ?? {};
    return data;
  }

  CloudCustomData();
}
