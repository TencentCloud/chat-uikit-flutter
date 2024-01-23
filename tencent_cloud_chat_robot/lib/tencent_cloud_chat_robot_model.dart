class TencentCloudChatRobotModelContentItem {
  String content = "";
  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from({
      "content": content,
    });
  }

  TencentCloudChatRobotModelContentItem(
    this.content,
  );
  static TencentCloudChatRobotModelContentItem fromJson(
      Map<String, dynamic> jsonData) {
    String content = jsonData["content"] ?? "";
    return TencentCloudChatRobotModelContentItem(content);
  }
}

class TencentCloudChatRobotModelContent {
  String title = "";
  String content = "";
  List<TencentCloudChatRobotModelContentItem> items = [];
  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from({
      "title": title,
      "content": content,
      "items": items.map((e) => e.toJson()).toList(),
    });
  }

  TencentCloudChatRobotModelContent(
    this.content,
    this.items,
    this.title,
  );
  static TencentCloudChatRobotModelContent fromJson(
      Map<String, dynamic> jsonData) {
    String content = jsonData["content"] ?? "";
    String title = jsonData["title"] ?? "";
    List<dynamic> itemsData = jsonData["items"] ?? [];

    List<TencentCloudChatRobotModelContentItem> items = itemsData
        .map((e) => TencentCloudChatRobotModelContentItem.fromJson(
            Map<String, dynamic>.from(e)))
        .toList();

    return TencentCloudChatRobotModelContent(content, items, title);
  }
}

enum TencentCloudChatRobotSrcEnum {
  unkonwn_0,
  unkonwn_1,
  robotChunkMessage,
  unkonwn_3,
  unkonwn_4,
  unkonwn_5,
  unkonwn_6,
  welcomeCardMsgSendToRobot,
  welcomeTextMsgSendToRobot,
  unkonwn_9,
  unkonwn_10,
  unkonwn_11,
  unkonwn_12,
  unkonwn_13,
  unkonwn_14,
  robotCardMessage,
}

class TencentCloudChatRobotData {
  int chatbotPlugin = 1;
  TencentCloudChatRobotSrcEnum src = TencentCloudChatRobotSrcEnum.unkonwn_0;
  List<String> chunks = [];
  String subtype = '';
  String robotID = "";
  int isFinished = 0;
  String msgID = "";
  TencentCloudChatRobotModelContent content =
      TencentCloudChatRobotModelContent('', [], '');
  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from({
      "chatbotPlugin": chatbotPlugin,
      "src": src.index,
      "chunks": chunks,
      "subtype": subtype,
      "content": content.toJson(),
      "robotID": robotID,
      "isFinished": isFinished,
      "msgID": msgID,
    });
  }

  TencentCloudChatRobotData(
    this.chatbotPlugin,
    this.chunks,
    this.src,
    this.content,
    this.subtype,
    this.robotID,
    this.isFinished,
    this.msgID,
  );
  static TencentCloudChatRobotSrcEnum converIntToEnum(int src) {
    if (src == TencentCloudChatRobotSrcEnum.robotCardMessage.index) {
      return TencentCloudChatRobotSrcEnum.robotCardMessage;
    } else if (src == TencentCloudChatRobotSrcEnum.robotChunkMessage.index) {
      return TencentCloudChatRobotSrcEnum.robotChunkMessage;
    } else if (src ==
        TencentCloudChatRobotSrcEnum.welcomeCardMsgSendToRobot.index) {
      return TencentCloudChatRobotSrcEnum.welcomeCardMsgSendToRobot;
    } else if (src ==
        TencentCloudChatRobotSrcEnum.welcomeTextMsgSendToRobot.index) {
      return TencentCloudChatRobotSrcEnum.welcomeTextMsgSendToRobot;
    }
    return TencentCloudChatRobotSrcEnum.unkonwn_0;
  }

  static TencentCloudChatRobotData fromJson(Map<String, dynamic> jsonData) {
    int chatbotPlugin = jsonData["chatbotPlugin"] ?? 0;
    List<String> chunks = List<String>.from(jsonData["chunks"] ?? []);
    TencentCloudChatRobotSrcEnum src = converIntToEnum(jsonData["src"] ?? 0);
    String subtype = jsonData["subtype"] ?? "";
    String robotID = jsonData["robotID"] ?? "";
    int isFinished = jsonData["isFinished"] ?? 2; // 0 未结束 1 已结束 2 旧消息没有这个字段
    String msgID = jsonData["msgID"] ?? "";
    TencentCloudChatRobotModelContent content =
        TencentCloudChatRobotModelContent.fromJson(jsonData["content"] ?? {});
    return TencentCloudChatRobotData(chatbotPlugin, chunks, src, content,
        subtype, robotID, isFinished, msgID);
  }
}
