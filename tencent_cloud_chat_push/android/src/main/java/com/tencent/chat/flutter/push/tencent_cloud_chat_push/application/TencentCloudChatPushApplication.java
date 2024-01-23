package com.tencent.chat.flutter.push.tencent_cloud_chat_push.application;

import android.app.Application;
import android.content.Intent;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import com.tencent.chat.flutter.push.tencent_cloud_chat_push.TencentCloudChatPushPlugin;
import com.tencent.qcloud.tuicore.TUIConstants;
import com.tencent.qcloud.tuicore.TUICore;
import com.tencent.qcloud.tuicore.interfaces.ITUINotification;

import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

import io.flutter.app.FlutterApplication;

public class TencentCloudChatPushApplication extends FlutterApplication {
    private String TAG = "TencentCloudChatPushApplication";

    @Override
    public void onCreate() {
        super.onCreate();

        TUICore.callService(TUIConstants.TIMPush.SERVICE_NAME, TUIConstants.TIMPush.METHOD_DISABLE_AUTO_REGISTER_PUSH, null);
        registerOnNotificationClickedEventToTUICore();
    }

    private void launchMainActivity() {
        Intent intentLaunchMain = this.getPackageManager().getLaunchIntentForPackage(this.getPackageName());
        if (intentLaunchMain != null) {
            this.startActivity(intentLaunchMain);
        } else {
            Log.e(TAG, "Failed to get launch intent for package: " + this.getPackageName());
        }
    }

    private void scheduleCheckPluginInstanceAndNotify(final String extString) {
        final Handler handler = new Handler(Looper.getMainLooper());
        Timer timer = new Timer();
        timer.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        try {
                            Log.i(TAG, "Checking instance: " + String.valueOf(TencentCloudChatPushPlugin.instance != null));
                            Log.i(TAG, "Checking attachedToEngine: " + String.valueOf(TencentCloudChatPushPlugin.instance.attachedToEngine));

                            if (TencentCloudChatPushPlugin.instance != null && TencentCloudChatPushPlugin.instance.attachedToEngine) {
                                Log.i(TAG, "invoke tryNotifyDartOnNotificationClickEvent");
                                TencentCloudChatPushPlugin.instance.tryNotifyDartOnNotificationClickEvent(extString);
                                timer.cancel();
                            }
                        } catch (Exception e) {
                            Log.e(TAG, e.toString());
                        }
                    }
                });
            }
        }, 100, 500);
    }

    private void registerOnNotificationClickedEventToTUICore() {
        Log.d(TAG, "registerOnNotificationClickedEventToTUICore");
        TUICore.registerEvent(TUIConstants.TIMPush.EVENT_NOTIFY,
                TUIConstants.TIMPush.EVENT_NOTIFY_NOTIFICATION, new ITUINotification() {
                    @Override
                    public void onNotifyEvent(String key, String subKey, Map<String, Object> param) {
                        Log.d(TAG, "onNotifyEvent onclick key = " + key + "subKey = " + subKey);
                        launchMainActivity();
                        if (TUIConstants.TIMPush.EVENT_NOTIFY.equals(key)) {
                            if (TUIConstants.TIMPush.EVENT_NOTIFY_NOTIFICATION.equals(subKey)) {
                                if (param != null) {
                                    String extString = (String) param.get(TUIConstants.TUIOfflinePush.NOTIFICATION_EXT_KEY);
                                    scheduleCheckPluginInstanceAndNotify(extString);
                                }
                            }
                        }
                    }
                }
        );
    }
}
