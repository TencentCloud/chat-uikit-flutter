import Flutter
import UIKit
import TIMPush


public class TencentCloudChatPushPlugin: NSObject, FlutterPlugin {
    public static let shared = TencentCloudChatPushPlugin()
    public var attachedToEngine = false
    public var registeredOnNotificationClickEvent = false
    
    public var channel: FlutterMethodChannel?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = shared
        instance.channel = FlutterMethodChannel(name: "tencent_cloud_chat_push", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: instance.channel!)
        instance.attachedToEngine = true
        TIMPush.disableAutoRegister()
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "setBusId":
            self.setBusId(call, result: result)
            break
        case "registerOnNotificationClickedEvent":
            self.registerOnNotificationClickedEvent(call, result: result)
            break
        case "registerOnAppWakeUpEvent":
            self.registerOnAppWakeUpEvent(call, result: result)
            break
        case "setApplicationGroupID":
            self.setApplicationGroupID(call, result: result)
            break
        case "registerPush":
            self.registerPush(call, result: result)
            break
        case "unRegisterPush":
            self.unRegisterPush(call, result: result)
            break
        case "disableAutoRegisterPush":
            self.disableAutoRegisterPush(call, result: result)
            break
        case "getAndroidPushToken":
            self.getAndroidPushToken(call, result: result)
            break
        case "setAndroidPushToken":
            self.setAndroidPushToken(call, result: result)
            break
        case "setAndroidCustomTIMPushConfigs":
            self.setAndroidCustomTIMPushConfigs(call, result: result)
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    public func toFlutterMethod(_ methodName: String, data: String) {
        if attachedToEngine {
            channel?.invokeMethod(methodName, arguments: data)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.toFlutterMethod(methodName, data: data)
            }
        }
    }
    
    public func tryNotifyDartOnNotificationClickEvent(_ extString: String?) {
        if registeredOnNotificationClickEvent {
            toFlutterMethod("on_notification_clicked", data: extString ?? "")
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.tryNotifyDartOnNotificationClickEvent(extString)
            }
        }
    }
    
    public func setBusId(_ call: FlutterMethodCall, result: @escaping FlutterResult){
        if let args = call.arguments as? [String: Any],
           let busId = args["busId"] as? Int {
            TencentCloudChatPushFlutterModal.shared.busId = Int32(busId)
            result(nil)
        } else {
            result(FlutterError(code: "-1", message: "Invalid arguments", details: nil))
        }
    }
    
    public func registerOnNotificationClickedEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult){
        registeredOnNotificationClickEvent = true
        result(nil)
    }
    
    public func setApplicationGroupID(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? [String: Any],
           let applicationGroupID = args["applicationGroupID"] as? String {
            TencentCloudChatPushFlutterModal.shared.kAPNSApplicationGroupID = applicationGroupID
            result(nil)
        } else {
            result(FlutterError(code: "-1", message: "Invalid arguments", details: nil))
        }
    }
    
    public func registerPush(_ call: FlutterMethodCall, result: @escaping FlutterResult){
        TIMPush.register()
        result(nil)
    }
    
    public func unRegisterPush(_ call: FlutterMethodCall, result: @escaping FlutterResult){
        TIMPush.unRegister()
        result(nil)
    }
    
    public func getAndroidPushToken(_ call: FlutterMethodCall, result: @escaping FlutterResult){
        result(nil)
    }
    
    public func setAndroidPushToken(_ call: FlutterMethodCall, result: @escaping FlutterResult){
        result(nil)
    }
    
    public func setAndroidCustomTIMPushConfigs(_ call: FlutterMethodCall, result: @escaping FlutterResult){
        result(nil)
    }
    
    public func registerOnAppWakeUpEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult){
        result(nil)
    }
    
    public func disableAutoRegisterPush(_ call: FlutterMethodCall, result: @escaping FlutterResult){
        TIMPush.disableAutoRegister()
        result(nil)
    }
}
