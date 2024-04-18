package com.tencent.chat.flutter.push.tencent_cloud_chat_push.application;

import android.content.Intent;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import com.tencent.chat.flutter.push.tencent_cloud_chat_push.TencentCloudChatPushPlugin;
import com.tencent.chat.flutter.push.tencent_cloud_chat_push.common.Extras;
import com.tencent.qcloud.tuicore.TUIConstants;
import com.tencent.qcloud.tuicore.TUICore;

import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

import io.flutter.app.FlutterApplication;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.embedding.engine.dart.DartExecutor;

public class TencentCloudChatPushApplication extends FlutterApplication {
    private String TAG = "TencentCloudChatPushApplication";

    public static boolean useCustomFlutterEngine = false;

    @Override
    public void onCreate() {
        super.onCreate();

        TUICore.callService(TUIConstants.TIMPush.SERVICE_NAME, TUIConstants.TIMPush.METHOD_DISABLE_AUTO_REGISTER_PUSH, null);
        registerOnNotificationClickedEventToTUICore();
        registerOnAppWakeUp();
    }

    private void generateFlutterEngine(){
        useCustomFlutterEngine = true;
        FlutterEngine engine = new FlutterEngine(this);
        engine.getDartExecutor().executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault());
        FlutterEngineCache.getInstance().put(Extras.FLUTTER_ENGINE, engine);
    }

    private void launchMainActivity(boolean showInForeground) {
        Intent intentLaunchMain = this.getPackageManager().getLaunchIntentForPackage(this.getPackageName());
        if (intentLaunchMain != null) {
            intentLaunchMain.putExtra(Extras.SHOW_IN_FOREGROUND, showInForeground);
            this.startActivity(intentLaunchMain);
        } else {
            Log.e(TAG, "Failed to get launch intent for package: " + this.getPackageName());
        }
    }

    private void scheduleCheckPluginInstanceAndNotifyForOnClick(final String action, final String data) {
        final Handler handler = new Handler(Looper.getMainLooper());
        Timer timer = new Timer();
        timer.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                handler.post(() -> {
                    try {
                        Log.i(TAG, "Checking instance: " + (TencentCloudChatPushPlugin.instance != null));
                        Log.i(TAG, "Checking attachedToEngine: " + TencentCloudChatPushPlugin.instance.attachedToEngine);

                        if (TencentCloudChatPushPlugin.instance != null && TencentCloudChatPushPlugin.instance.attachedToEngine) {
                            Log.i(TAG, "invoke: " + action);
                            TencentCloudChatPushPlugin.instance.tryNotifyDartEvent(action, data);
                            timer.cancel();
                        }
                    } catch (Exception e) {
                        Log.e(TAG, e.toString());
                    }
                });
            }
        }, 100, 500);
    }

    private void registerOnNotificationClickedEventToTUICore() {
        Log.d(TAG, "registerOnNotificationClickedEventToTUICore");
        TUICore.registerEvent(TUIConstants.TIMPush.EVENT_NOTIFY,
                TUIConstants.TIMPush.EVENT_NOTIFY_NOTIFICATION, (key, subKey, param) -> {
                    Log.d(TAG, "onNotifyEvent onclick key = " + key + "subKey = " + subKey);
                    launchMainActivity(true);
                    if (TUIConstants.TIMPush.EVENT_NOTIFY.equals(key)) {
                        if (TUIConstants.TIMPush.EVENT_NOTIFY_NOTIFICATION.equals(subKey)) {
                            if (param != null) {
                                String extString = (String) param.get(TUIConstants.TUIOfflinePush.NOTIFICATION_EXT_KEY);
                                scheduleCheckPluginInstanceAndNotifyForOnClick(Extras.ON_NOTIFICATION_CLICKED, extString);
                            }
                        }
                    }
                }
        );
    }

    private void registerOnAppWakeUp() {
        Log.d(TAG, "registerOnAppWakeUp");
        TUICore.registerEvent(TUIConstants.TIMPush.EVENT_IM_LOGIN_AFTER_APP_WAKEUP_KEY, TUIConstants.TIMPush.EVENT_IM_LOGIN_AFTER_APP_WAKEUP_SUB_KEY, (key, subKey, param) -> {
            Log.d(TAG, "onNotifyEvent key = " + key + "subKey = " + subKey);
            if (TUIConstants.TIMPush.EVENT_IM_LOGIN_AFTER_APP_WAKEUP_KEY.equals(key)) {
                if (TUIConstants.TIMPush.EVENT_IM_LOGIN_AFTER_APP_WAKEUP_SUB_KEY.equals(subKey)) {
                    generateFlutterEngine();
                    scheduleCheckPluginInstanceAndNotifyForOnClick(Extras.ON_APP_WAKE_UP, "");
                }
            }
        });
    }
}
