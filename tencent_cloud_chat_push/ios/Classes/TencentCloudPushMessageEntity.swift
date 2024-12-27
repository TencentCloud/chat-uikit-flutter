import TIMPush

public class TencentCloudPushMessageEntity {
	var messageID: String?;
	var title: String?;
	var desc: String?;
	var ext: String?;

	var timPushMessage: TIMPushMessage;
	
	func getDict() -> [String: Any] {
		var result: [String: Any] = [:]
		result["messageID"] = self.messageID
		result["title"] = self.title as Any
		result["desc"] = self.desc as Any
		result["ext"] = self.ext as Any

		return result
	}

	init(message : TIMPushMessage) {
        _ = NSTemporaryDirectory()
		self.messageID = message.messageID
        self.title = message.title
        self.desc = message.desc
        self.ext = message.ext
        
		self.timPushMessage = message
	}
}
