//
//  TencentCloudPushListener.swift
//


import Foundation
import TIMPush
import Flutter

class TencentCloudPushListener: NSObject, TIMPushListener {
    func onRecvPushMessage(_ message: TIMPushMessage) {
        TencentCloudChatPushPlugin.shared.invokeListener(method: "onRecvPushMessage", data: TencentCloudPushMessageEntity.init(message: message).getDict())
    }
    
    func onRevokePushMessage(_ messageID: String) {
        TencentCloudChatPushPlugin.shared.invokeListener(method: "onRevokePushMessage", data: messageID)
    }
    
    func onNotificationClicked(_ ext: String) {
        TencentCloudChatPushPlugin.shared.invokeListener(method: "onNotificationClicked", data: ext)
    }
    
}
