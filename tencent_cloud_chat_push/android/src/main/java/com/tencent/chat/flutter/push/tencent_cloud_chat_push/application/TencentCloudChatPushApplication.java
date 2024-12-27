package com.tencent.chat.flutter.push.tencent_cloud_chat_push.application;

import android.content.Intent;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.app.Activity;
import android.os.Bundle;

import com.tencent.chat.flutter.push.tencent_cloud_chat_push.TencentCloudChatPushPlugin;
import com.tencent.chat.flutter.push.tencent_cloud_chat_push.common.Extras;
import com.tencent.qcloud.tuicore.TUIConstants;
import com.tencent.qcloud.tuicore.TUICore;
import com.tencent.qcloud.tim.push.TIMPushListener;
import com.tencent.qcloud.tim.push.TIMPushManager;

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
    public static boolean hadLaunchedMainActivity = false;
    public boolean appInForeground = false;
    private int activityReferences = 0;
    private boolean isActivityChangingConfigurations;

    private TIMPushListener timPushListener = new TIMPushListener() {
        @Override
        public void onNotificationClicked(String ext) {
            Log.d(TAG, "onNotificationClicked =" + ext);
            toFlutterMethod("onNotificationClicked", ext);
        }
    };

    @Override
    public void onCreate() {
        super.onCreate();
        Log.d(TAG, "onCreate");
        TUICore.callService(TUIConstants.TIMPush.SERVICE_NAME, TUIConstants.TIMPush.METHOD_DISABLE_AUTO_REGISTER_PUSH, null);
        registerOnNotificationClickedEventToTUICore();
        registerOnAppWakeUp();
        registerActivityLifecycleCallbacks();
        addPushListener();
    }

    private void registerActivityLifecycleCallbacks() {
        registerActivityLifecycleCallbacks(new ActivityLifecycleCallbacks() {
            @Override
            public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
                // Activity 创建时调用
            }

            @Override
            public void onActivityStarted(Activity activity) {
                if (++activityReferences == 1 && !isActivityChangingConfigurations) {
                    // 应用进入前台
                    appInForeground = true;
                    Log.e(TAG, "appInForeground true");
                }
            }

            @Override
            public void onActivityResumed(Activity activity) {
                // Activity 恢复时调用
            }

            @Override
            public void onActivityPaused(Activity activity) {
                // Activity 暂停时调用
            }

            @Override
            public void onActivityStopped(Activity activity) {
                isActivityChangingConfigurations = activity.isChangingConfigurations();
                if (--activityReferences == 0 && !isActivityChangingConfigurations) {
                    // 应用进入后台
                    appInForeground = false;
                    Log.e(TAG, "appInForeground false");
                }
            }

            @Override
            public void onActivitySaveInstanceState(Activity activity, Bundle outState) {
                // Activity 保存实例状态时调用
            }

            @Override
            public void onActivityDestroyed(Activity activity) {
                // Activity 销毁时调用
            }
        });
    }

    private void generateFlutterEngine(){
        if (FlutterEngineCache.getInstance().contains(Extras.FLUTTER_ENGINE) || hadLaunchedMainActivity) {
            return;
        }

        new Handler(Looper.getMainLooper()).post(() -> {
            useCustomFlutterEngine = true;
            FlutterEngine engine = new FlutterEngine(this);
            engine.getDartExecutor().executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault());
            FlutterEngineCache.getInstance().put(Extras.FLUTTER_ENGINE, engine);
            FlutterEngineCache cache = FlutterEngineCache.getInstance();
        });
    }

    private boolean launchMainActivity(boolean showInForeground) {
        Log.e(TAG, "launchMainActivity start: " + (TencentCloudChatPushPlugin.instance != null) + " and: " + (TencentCloudChatPushPlugin.instance != null ? TencentCloudChatPushPlugin.instance.attachedToEngine : "TencentCloudChatPushPlugin.instance is null"));
        if (TencentCloudChatPushPlugin.instance != null && TencentCloudChatPushPlugin.instance.attachedToEngine) {
            return false;
        }

        Log.e(TAG, "launchMainActivity check needed, package name: " + this.getPackageName());
        launchMainActivityDirectly(true);
        return true;
    }

    private void launchMainActivityDirectly(boolean showInForeground) {
        Log.e(TAG, "launchMainActivity check needed, package name: " + this.getPackageName());

        Intent intentLaunchMain = this.getPackageManager().getLaunchIntentForPackage(this.getPackageName());
        if (intentLaunchMain != null) {
            intentLaunchMain.putExtra(Extras.SHOW_IN_FOREGROUND, showInForeground);
            intentLaunchMain.addFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
            Log.e(TAG, "launchMainActivity startActivity ");
            this.startActivity(intentLaunchMain);
        } else {
            Log.e(TAG, "Failed to get launch intent for package: " + this.getPackageName());
        }
    }

    private void scheduleCheckPluginInstanceAndNotifyForOnClick(final String action, final String data) {
        final Handler handler = new Handler(Looper.getMainLooper());
        Timer timer = new Timer();
        timer.schedule(new TimerTask() {
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
                    if (launchMainActivity(true)) {
                        notifyNotificationClickedEvent(key, subKey, param);
                    } else {
                        new Handler(Looper.getMainLooper()).postDelayed(new Runnable() {
                            @Override
                            public void run() {
                                if (!appInForeground) {
                                    launchMainActivityDirectly(true);
                                }

                                notifyNotificationClickedEvent(key, subKey, param);
                            }
                        }, 500);
                    }
                }
        );
    }

    private void notifyNotificationClickedEvent(String key, String subKey, Map<String, Object> param) {
        if (TUIConstants.TIMPush.EVENT_NOTIFY.equals(key)) {
            if (TUIConstants.TIMPush.EVENT_NOTIFY_NOTIFICATION.equals(subKey)) {
                if (param != null) {
                    String extString = (String) param.get(TUIConstants.TUIOfflinePush.NOTIFICATION_EXT_KEY);
                    Log.d(TAG, "onNotifyEvent onclick key = " + key + "subKey = " + subKey + " extString = " + extString);
                    scheduleCheckPluginInstanceAndNotifyForOnClick(Extras.ON_NOTIFICATION_CLICKED, extString);
                }
            }
        }
    }

    private void registerOnAppWakeUp() {
        Log.d(TAG, "registerOnAppWakeUp");
        TUICore.registerEvent(TUIConstants.TIMPush.EVENT_IM_LOGIN_AFTER_APP_WAKEUP_KEY, TUIConstants.TIMPush.EVENT_IM_LOGIN_AFTER_APP_WAKEUP_SUB_KEY, (key, subKey, param) -> {
            Log.d(TAG, "onNotifyEvent key = " + key + "subKey = " + subKey);
            if (TUIConstants.TIMPush.EVENT_IM_LOGIN_AFTER_APP_WAKEUP_KEY.equals(key)) {
                if (TUIConstants.TIMPush.EVENT_IM_LOGIN_AFTER_APP_WAKEUP_SUB_KEY.equals(subKey)) {
                    // generateFlutterEngine();
                    scheduleCheckPluginInstanceAndNotifyForOnClick(Extras.ON_APP_WAKE_UP, "");
                }
            }
        });
    }

    private void addPushListener() {
        TIMPushManager.getInstance().addPushListener(timPushListener);
    }

    private void toFlutterMethod(final String methodName, final String data) {
        final Handler handler = new Handler(Looper.getMainLooper());
        Timer timer = new Timer();
        timer.schedule(new TimerTask() {
            @Override
            public void run() {
                handler.post(() -> {
                    try {
                        Log.i(TAG, "Checking instance: " + (TencentCloudChatPushPlugin.instance != null));
                        Log.i(TAG, "Checking attachedToEngine: " + TencentCloudChatPushPlugin.instance.attachedToEngine);

                        if (TencentCloudChatPushPlugin.instance != null && TencentCloudChatPushPlugin.instance.attachedToEngine) {
                            Log.i(TAG, "methodName: " + methodName);
                            TencentCloudChatPushPlugin.instance.toFlutterMethod(methodName, data);
                            timer.cancel();
                        }
                    } catch (Exception e) {
                        Log.e(TAG, e.toString());
                    }
                });
            }
        }, 100, 500);
    }
}
