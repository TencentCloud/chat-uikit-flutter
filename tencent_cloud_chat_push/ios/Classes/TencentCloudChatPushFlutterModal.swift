import UIKit
import TIMPush
import Flutter

public class TencentCloudChatPushFlutterModal: NSObject {
    public static let shared = TencentCloudChatPushFlutterModal()

    public var busId: Int32 = 0
    
    private override init() {
            super.init()
        }
    
    public var kAPNSApplicationGroupID: String = ""

    public func offlinePushCertificateID() -> Int32 {
        return busId
    }

    public func applicationGroupID() -> String! {
        return kAPNSApplicationGroupID
    }
}
