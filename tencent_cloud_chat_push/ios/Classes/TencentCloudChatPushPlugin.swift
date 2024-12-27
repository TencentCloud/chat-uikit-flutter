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
        instance.addPushListener()
        instance.disableAutoRegisterPush { result in
            print("disableAutoRegisterPush")
        }
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
        //not support
            self.getAndroidPushToken(call, result: result)
            break
        case "setAndroidPushToken":
        //not support
            self.setAndroidPushToken(call, result: result)
            break
        case "setAndroidCustomTIMPushConfigs":
        //not support
            self.setAndroidCustomTIMPushConfigs(call, result: result)
            break
        case "enableBackupChannels":
        //not support
            self.enableBackupChannels(call, result: result)
            break;
        case "getRegistrationID":
            self.getRegistrationID(call, result: result)
            break;
        case "setRegistrationID":
            self.setRegistrationID(call, result: result)
            break;
        case "disablePostNotificationInForeground":
            self.disablePostNotificationInForeground(call, result: result)
            break;
        //not support
        case "canPostNotificationInForeground":
            self.canPostNotificationInForeground(call, result: result)
            break;
        case "addPushListener":
            self.addPushListener(call, result: result)
            break;
        case "forceUseFCMPushChannel":
            self.forceUseFCMPushChannel(call, result: result)
            break;
        case "createNotificationChannel":
            self.createNotificationChannel(call, result: result)
            break;
        case "callExperimentalAPI":
            self.callExperimentalAPI(call, result: result)
            break;
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
    
    public func registerPush(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any] else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Arguments are not valid", details: nil))
            return
        }

        let intNumber = Int(arguments["sdkAppId"] as! String) ?? 0
        let sdkAppId = Int32(intNumber)
        let appKey = arguments["appKey"] as? String

        if let appKey = appKey, sdkAppId != 0 {
            TIMPushManager.registerPush(sdkAppId, appKey: appKey, succ: { data in
                result(data)
            }, fail: { errorCode, errorMessage in
                result(FlutterError(code: String(errorCode), message: errorMessage, details: nil))
            })
        } else {
            TIMPushManager.registerPush(0, appKey: "", succ: { data in
                result(data)
            }, fail: { errorCode, errorMessage in
                result(FlutterError(code: String(errorCode), message: errorMessage, details: nil))
            })
        }
    }
    
    public func unRegisterPush(_ call: FlutterMethodCall, result: @escaping FlutterResult){
        TIMPushManager.unRegisterPush({
            result(nil);
        }, fail: { errorCode, errorMessage in
            result(FlutterError(code: String(errorCode), message: errorMessage, details: nil));
        });
    }
    
    public func getAndroidPushToken(_ call: FlutterMethodCall, result: @escaping FlutterResult){
        result(nil)
    }
    
    public func setAndroidPushToken(_ call: FlutterMethodCall, result: @escaping FlutterResult){
        result(nil)
    }
    
    public func getRegistrationID(_ call: FlutterMethodCall, result: @escaping FlutterResult){
        TIMPushManager.getRegistrationID { data in
            result(data)
        };
    }

    public func setRegistrationID(_ call: FlutterMethodCall, result: @escaping FlutterResult){
        if let args = call.arguments as? [String: Any],
           let registrationID = args["registrationID"] as? String {
            TIMPushManager.setRegistrationID(registrationID) {
                result(nil)
            };
        } else {
            result(FlutterError(code: "-1", message: "Invalid arguments", details: nil))
        }
    }
    
    public func setAndroidCustomTIMPushConfigs(_ call: FlutterMethodCall, result: @escaping FlutterResult){
        result(nil)
    }
    
    public func registerOnAppWakeUpEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult){
        result(nil)
    }
    
    public func enableBackupChannels(_ call: FlutterMethodCall, result: @escaping FlutterResult){
        result(nil)
    }
    
    public func disableAutoRegisterPush(_ call: FlutterMethodCall, result: @escaping FlutterResult){
        disableAutoRegisterPush(result: result)
    }

    public func disablePostNotificationInForeground(_ call: FlutterMethodCall, result: @escaping FlutterResult){
        if let args = call.arguments as? [String: Any],
           let disableStr = args["disablePostNotificationInForeground"] as? String {
            TIMPushManager.disablePostNotificationInForeground(disable: (disableStr.lowercased() == "true"))
            result(nil)
        } else {
            result(FlutterError(code: "-1", message: "Invalid arguments", details: nil))
        }
    }

    public func canPostNotificationInForeground(_ call: FlutterMethodCall, result: @escaping FlutterResult){
        result(nil)
    }
    
    static let messageListener = TencentCloudPushListener();
    public func addPushListener(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        addPushListener()
    }
    
    public func forceUseFCMPushChannel(_ call: FlutterMethodCall, result: @escaping FlutterResult){
        result(nil)
    }
    
    public func createNotificationChannel(_ call: FlutterMethodCall, result: @escaping FlutterResult){
        result(nil)
    }
    
    public func callExperimentalAPI(_ call: FlutterMethodCall, result: @escaping FlutterResult){
        guard let arguments = call.arguments as? [String: Any] else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Arguments are not valid", details: nil))
            return
        }

        guard let api = arguments["api"] as? String else {
            result(FlutterError(code: "INVALID_API", message: "API is not valid", details: nil))
            return
        }

        let param = arguments["param"] as? NSObject;

        TIMPushManager.callExperimentalAPI(api, param: param ?? NSObject(), succ: { data in
            result(data)
        }, fail: { errorCode, errorMessage in
            result(FlutterError(code: String(errorCode), message: errorMessage, details: nil))
        })
    }

    public func invokeListener(method: String, data: Any?) {
        if attachedToEngine {
            channel?.invokeMethod(method, arguments: data)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.invokeListener(method: method, data: data)
            }
        }
    }
    
    private func disableAutoRegisterPush(result: @escaping FlutterResult) {
        TIMPushManager.callExperimentalAPI("disableAutoRegisterPush", param: NSNull(), succ: { data in
            result(data)
        }, fail: { errorCode, errorMessage in
            result(FlutterError(code: String(errorCode), message: errorMessage, details: nil))
        })
        result(nil)
    }
    
    private func addPushListener() {
        TIMPushManager.addPushListener(listener: TencentCloudChatPushPlugin.messageListener)
    }
}
