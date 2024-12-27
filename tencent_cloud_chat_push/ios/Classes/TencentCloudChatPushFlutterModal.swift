import UIKit
import Flutter

@objc public class TencentCloudChatPushFlutterModal: NSObject {
    @objc public static let shared = TencentCloudChatPushFlutterModal()

    @objc public var busId: Int32 = 0
    
    private override init() {
            super.init()
        }
    
    @objc  public var kAPNSApplicationGroupID: String = ""

    @objc  public func businessID() -> Int32 {
        return busId
    }

    @objc  public func offlinePushCertificateID() -> Int32 {
        return busId
    }

    @objc  public func applicationGroupID() -> String! {
        return kAPNSApplicationGroupID
    }
}
