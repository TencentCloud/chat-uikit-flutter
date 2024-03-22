package com.tencent.chat.flutter.push.tencent_cloud_chat_push;

import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;

import com.tencent.chat.flutter.push.tencent_cloud_chat_push.common.Extras;
import com.tencent.qcloud.tuicore.TUIConstants;
import com.tencent.qcloud.tuicore.TUICore;
import com.tencent.qcloud.tuicore.interfaces.TUIServiceCallback;

import java.util.HashMap;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * TencentCloudChatPushPlugin
 */
public class TencentCloudChatPushPlugin implements FlutterPlugin, MethodCallHandler {
    public static TencentCloudChatPushPlugin instance;

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;

    private String TAG = "TencentCloudChatPushPlugin";

    public Boolean attachedToEngine = false;

    private Boolean registeredOnNotificationClickEvent = false;

    private Boolean registeredOnAppWakeUpEvent = false;

    private Context mContext;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        instance = this;
        mContext = flutterPluginBinding.getApplicationContext();
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "tencent_cloud_chat_push");
        channel.setMethodCallHandler(this);
        attachedToEngine = true;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "getPlatformVersion":
                result.success("Android " + android.os.Build.VERSION.RELEASE);
                break;
            case "registerPush":
                registerPush(call, result);
                break;
            case "unRegisterPush":
                unRegisterPush(call, result);
                break;
            case "disableAutoRegisterPush":
                disableAutoRegisterPush(call, result);
                break;
            case "configFCMPrivateRing":
                configFCMPrivateRing(call, result);
                break;
            case "setPushBrandId":
                setPushBrandId(call, result);
                break;
            case "getPushBrandId":
                getPushBrandId(call, result);
                break;
            case "checkPushStatus":
                checkPushStatus(call, result);
                break;
            case "registerOnNotificationClickedEvent":
                registerOnNotificationClickedEvent(call, result);
                break;
            case "registerOnAppWakeUpEvent":
                registerOnAppWakeUpEvent(call, result);
                break;
            case "getAndroidPushToken":
                getAndroidPushToken(call, result);
                break;
            case "setAndroidPushToken":
                setAndroidPushToken(call, result);
                break;
            case "setAndroidCustomTIMPushConfigs":
                setAndroidCustomTIMPushConfigs(call, result);
                break;
            default:
                result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    public void toFlutterMethod(final String methodName, final String data) {
        final Handler handler = new Handler(Looper.getMainLooper());
        handler.post(() -> {
            if (attachedToEngine) {
                channel.invokeMethod(methodName, data);
            } else {
                // Create a timer that checks if attachedToEngine is true every 500 milliseconds
                final Timer timer = new Timer();
                timer.schedule(new TimerTask() {
                    @Override
                    public void run() {
                        if (attachedToEngine) {
                            // If attachedToEngine is true, call invokeMethod and cancel the timer
                            channel.invokeMethod(methodName, data);
                            timer.cancel();
                        }
                    }
                }, 0, 500);
            }
        });
    }

    private boolean getMethodToBeCalledPrepared(final String action){
        boolean methodToBeCalledPrepared = false;
        switch (action){
            case Extras.ON_NOTIFICATION_CLICKED:
                methodToBeCalledPrepared = registeredOnNotificationClickEvent;
                break;
            case Extras.ON_APP_WAKE_UP:
                methodToBeCalledPrepared = registeredOnAppWakeUpEvent;
                break;
            default:
                break;
        }
        return methodToBeCalledPrepared;
    }

    public void tryNotifyDartEvent(final String action, final String data) {
        final Handler handler = new Handler(Looper.getMainLooper());
        handler.post(() -> {
            boolean methodToBeCalledPrepared = getMethodToBeCalledPrepared(action);

            if (methodToBeCalledPrepared) {
                toFlutterMethod(action, data);
            } else {
                // Create a timer that checks if method waiting to be called is prepared every 500 milliseconds
                final Timer timer = new Timer();
                timer.schedule(new TimerTask() {
                    @Override
                    public void run() {
                        boolean methodToBeCalledPrepared = getMethodToBeCalledPrepared(action);
                        if (methodToBeCalledPrepared) {
                            // If methodToBeCalledPrepared is true, call toFlutterMethod and cancel the timer
                            toFlutterMethod(action, data);
                            timer.cancel();
                        }
                    }
                }, 0, 500);
            }
        });
    }

    public void registerOnNotificationClickedEvent(@NonNull MethodCall call, @NonNull Result result) {
        registeredOnNotificationClickEvent = true;
        result.success("");
    }

    public void registerOnAppWakeUpEvent(@NonNull MethodCall call, @NonNull Result result) {
        registeredOnAppWakeUpEvent = true;
        result.success("");
    }

    public void registerPush(@NonNull MethodCall call, @NonNull Result result) {
        Log.d(TAG, "registerPush");
        registeredOnNotificationClickEvent = true;
        Map<String, String> arguments = (Map<String, String>) call.arguments;
        String pushConfigJson = arguments.get(Extras.PUSH_CONFIG_JSON);

        String useMethod = (pushConfigJson != null && !pushConfigJson.isEmpty()) ? TUIConstants.TIMPush.METHOD_REGISTER_PUSH_WITH_JSON : TUIConstants.TIMPush.METHOD_REGISTER_PUSH;

        Map<String, Object> param = new HashMap<>();
        param.put("context", mContext);
        if (pushConfigJson != null && !pushConfigJson.isEmpty()) {
            param.put(TUIConstants.TIMPush.REGISTER_PUSH_WITH_JSON_KEY, pushConfigJson);
        }

        TUICore.callService(TUIConstants.TIMPush.SERVICE_NAME, useMethod, param, new TUIServiceCallback() {
            @Override
            public void onServiceCallback(int errorCode, String errorMessage, Bundle bundle) {
                try {
                    if (errorCode == 0) {
                        result.success("");
                    } else {
                        result.error(String.valueOf(errorCode), errorMessage, errorMessage);
                    }
                }catch (Exception e){
                    Log.d(TAG, errorMessage);
                }
            }
        });
    }

    public void unRegisterPush(@NonNull MethodCall call, @NonNull Result result) {
        TUICore.callService(TUIConstants.TIMPush.SERVICE_NAME, TUIConstants.TIMPush.METHOD_UNREGISTER_PUSH, null, new TUIServiceCallback() {
            @Override
            public void onServiceCallback(int errorCode, String errorMessage, Bundle bundle) {
                if (errorCode == 0) {
                    result.success("");
                } else {
                    result.error(String.valueOf(errorCode), errorMessage, errorMessage);
                }
            }
        });
    }

    public void disableAutoRegisterPush(@NonNull MethodCall call, @NonNull Result result) {
        TUICore.callService(TUIConstants.TIMPush.SERVICE_NAME, TUIConstants.TIMPush.METHOD_DISABLE_AUTO_REGISTER_PUSH, null);
        result.success("");
    }

    public void configFCMPrivateRing(@NonNull MethodCall call, @NonNull Result result) {
        Map<String, String> arguments = (Map<String, String>) call.arguments;
        String fcmPushChannelId = arguments.get(Extras.FCM_PUSH_CHANNEL_ID);
        String privateRingName = arguments.get(Extras.PRIVATE_RING_NAME);
        String enableFCMPrivateRing = arguments.get(Extras.ENABLE_FCM_PRIVATE_RING);

        Map<String, Object> param = new HashMap<>();
        param.put(TUIConstants.TIMPush.CONFIG_FCM_CHANNEL_ID_KEY, fcmPushChannelId);
        param.put(TUIConstants.TIMPush.CONFIG_FCM_PRIVATE_RING_NAME_KEY, privateRingName);
        param.put(TUIConstants.TIMPush.CONFIG_ENABLE_FCM_PRIVATE_RING_KEY, Boolean.valueOf(enableFCMPrivateRing));
        TUICore.callService(TUIConstants.TIMPush.SERVICE_NAME, TUIConstants.TIMPush.METHOD_CONFIG_FCM_PRIVATE_RING, param);
        result.success("");
    }

    public void setPushBrandId(@NonNull MethodCall call, @NonNull Result result) {
        Map<String, String> arguments = (Map<String, String>) call.arguments;
        String brandId = arguments.get(Extras.BRAND_ID);

        Map<String, Object> param = new HashMap<>();
        param.put(TUIConstants.TIMPush.PUSH_BRAND_ID_KEY, Integer.parseInt(brandId != null ? brandId : "0"));
        TUICore.callService(TUIConstants.TIMPush.SERVICE_NAME, TUIConstants.TIMPush.METHOD_SET_PUSH_BRAND_ID, param);
        result.success("");
    }

    public void getPushBrandId(@NonNull MethodCall call, @NonNull Result result) {
        int brandId = (Integer) TUICore.callService(TUIConstants.TIMPush.SERVICE_NAME, TUIConstants.TIMPush.METHOD_GET_PUSH_BRAND_ID, null);
        result.success(brandId);
    }

    private void getAndroidPushToken(MethodCall call, Result result) {
        TUICore.callService(TUIConstants.TIMPush.SERVICE_NAME, TUIConstants.TIMPush.METHOD_GET_PUSH_TOKEN, null, new TUIServiceCallback() {
            @Override
            public void onServiceCallback(int errorCode, String errorMessage, Bundle bundle) {
                if (errorCode == 0 && bundle != null) {
                    String token = (String) bundle.get("token");
                    Log.d(TAG, "getAndroidPushToken onServiceCallback data =" + token);
                    result.success(token);
                } else {
                    result.error(String.valueOf(errorCode), errorMessage, errorMessage);
                }
            }
        });
    }

    private void setAndroidPushToken(MethodCall call, Result result) {
        Map<String, String> arguments = (Map<String, String>) call.arguments;
        String businessID = arguments.get(Extras.BUSINESS_ID);
        String pushToken = arguments.get(Extras.PUSH_TOKEN);

        Map<String, Object> param = new HashMap<>();
        param.put(TUIConstants.TIMPush.METHOD_PUSH_BUSSINESS_ID_KEY, Integer.parseInt(businessID != null ? businessID : "0"));
        param.put(TUIConstants.TIMPush.METHOD_PUSH_TOKEN_KEY, pushToken);
        TUICore.callService(TUIConstants.TIMPush.SERVICE_NAME, TUIConstants.TIMPush.METHOD_SET_PUSH_TOKEN, param, new TUIServiceCallback() {
            @Override
            public void onServiceCallback(int errorCode, String errorMessage, Bundle bundle) {
                if (errorCode == 0) {
                    result.success("");
                } else {
                    result.error(String.valueOf(errorCode), errorMessage, errorMessage);
                }
            }
        });
    }

    private void setAndroidCustomTIMPushConfigs(MethodCall call, Result result) {
        Map<String, String> arguments = (Map<String, String>) call.arguments;
        String configs = arguments.get(Extras.ANDROID_CONFIGS);

        Map<String, Object> param = new HashMap<>();
        param.put(TUIConstants.TIMPush.CUSTOM_TIMPUSH_CONFINGS_KEY, configs);
        TUICore.callService(TUIConstants.TIMPush.SERVICE_NAME, TUIConstants.TIMPush.METHOD_CUSTOM_TIMPUSH_CONFINGS, param, new TUIServiceCallback() {
            @Override
            public void onServiceCallback(int errorCode, String errorMessage, Bundle bundle) {
                if (errorCode == 0) {
                    result.success("");
                } else {
                    result.error(String.valueOf(errorCode), errorMessage, errorMessage);
                }
            }
        });
    }

    public void checkPushStatus(@NonNull MethodCall call, @NonNull Result result) {
        Map<String, String> arguments = (Map<String, String>) call.arguments;
        String brandId = arguments.get(Extras.BRAND_ID);

        Map<String, Object> param = new HashMap<>();
        param.put(TUIConstants.TIMPush.PUSH_BRAND_ID_KEY, brandId);
        TUICore.callService(TUIConstants.TIMPush.SERVICE_NAME, TUIConstants.TIMPush.METHOD_CHECK_PUSH_STATUS, param, new TUIServiceCallback() {
            @Override
            public void onServiceCallback(int errorCode, String errorMessage, Bundle bundle) {
                if (errorCode == 0) {
                    if (bundle == null) {
                        String errorMsg = "bundle == null";
                        result.error(String.valueOf(errorCode), errorMsg, errorMsg);
                        return;
                    }
                    String res = bundle.getString(TUIConstants.TIMPush.CHECK_PUSH_STATUS_RESULT_LEY);
                    result.success(res);
                } else {
                    String errorMsg = "errorCode = " + errorCode + ", errorMessage = " + errorMessage;
                    result.error(String.valueOf(errorCode), errorMsg, errorMsg);
                }
            }
        });
    }

}
