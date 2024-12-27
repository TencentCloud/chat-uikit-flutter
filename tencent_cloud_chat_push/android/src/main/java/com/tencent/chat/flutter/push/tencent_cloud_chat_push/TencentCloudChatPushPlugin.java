package com.tencent.chat.flutter.push.tencent_cloud_chat_push;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;

import com.tencent.chat.flutter.push.tencent_cloud_chat_push.common.Extras;
import com.tencent.qcloud.tim.push.TIMPushCallback;
import com.tencent.qcloud.tim.push.TIMPushConstants;
import com.tencent.qcloud.tim.push.TIMPushManager;
import com.tencent.qcloud.tim.push.config.TIMPushConfig;
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
import android.text.TextUtils;
import org.json.JSONObject;
import com.tencent.chat.flutter.push.tencent_cloud_chat_push.common.Utils;
import com.tencent.qcloud.tim.push.TIMPushMessage;
import com.tencent.qcloud.tim.push.TIMPushListener;

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

    private TIMPushListener timPushListener = new TIMPushListener() {
        @Override
        public void onRecvPushMessage(TIMPushMessage msg) {
            Log.d(TAG, "onRecvPushMessage =" + msg.toString());
            toFlutterMethodByJson("onRecvPushMessage", Utils.convertTIMPushMessageToMap(msg));
        }

        @Override
        public void onRevokePushMessage(String msgID) {
            Log.d(TAG, "onRevokePushMessage =" + msgID);
            toFlutterMethod("onRevokePushMessage", msgID);
        }
    };

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        Log.d(TAG, "onAttachedToEngine");
        instance = this;
        mContext = flutterPluginBinding.getApplicationContext();
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "tencent_cloud_chat_push");
        channel.setMethodCallHandler(this);
        attachedToEngine = true;
        addPushListener();
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
            case "setCustomFCMRing":
                setCustomFCMRing(call, result);
                break;
            case "setAndroidCustomConfigFile":
                setAndroidCustomConfigFile(call, result);
                break;
            case "setPushBrandId":
                // Deprecated
                setPushBrandId(call, result);
                break;
            case "getPushBrandId":
                // Deprecated
                getPushBrandId(call, result);
                break;
            case "checkPushStatus":
                // Deprecated
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
            case "setXiaoMiPushStorageRegion":
                // Deprecated
                setXiaoMiPushStorageRegion(call, result);
                break;
            case "enableBackupChannels":
                enableBackupChannels(call, result);
                break;
            case "getRegistrationID":
                getRegistrationID(call, result);
                break;
            case "setRegistrationID":
                setRegistrationID(call, result);
                break;
            case "disablePostNotificationInForeground":
                disablePostNotificationInForeground(call, result);
                break;
            case "canPostNotificationInForeground":
                canPostNotificationInForeground(call, result);
                break;
            case "addPushListener":
                addPushListener(call, result);
                break;
            case "forceUseFCMPushChannel":
                forceUseFCMPushChannel(call, result);
                break;
            case "createNotificationChannel":
                createNotificationChannel(call, result);
                break;
            case "callExperimentalAPI":
                callExperimentalAPI(call, result);
                break;
            default:
                result.notImplemented();
        }
    }

    public void disablePostNotificationInForeground(@NonNull MethodCall call, @NonNull Result result) {
        Map<String, String> arguments = (Map<String, String>) call.arguments;
        String disableStr = arguments.get(Extras.DISABLE_POST_NOTIFICATION_IN_FOREGROUND);
        boolean disable = Boolean.parseBoolean(disableStr);
        TIMPushManager.getInstance().disablePostNotificationInForeground(disable);
        result.success("");
    }

    public void canPostNotificationInForeground(@NonNull MethodCall call, @NonNull Result result) {
        int enable = TIMPushConfig.getInstance().canPostNotificationInForeground();
        String enableStr = "";
        if (enable == 1) {
            enableStr = "true";
        } else if (enable == 0) {
            enableStr = "false";
        }

        Log.i(TAG, "canPostNotificationInForeground, enable: " + enableStr);
        result.success(enableStr);
    }

    public void addPushListener(@NonNull MethodCall call, @NonNull Result result) {
        addPushListener();
        result.success("");
    }

    public void forceUseFCMPushChannel(@NonNull MethodCall call, @NonNull Result result) {
        Map<String, String> arguments = (Map<String, String>) call.arguments;
        String enableStr = arguments.get(Extras.FORCE_USE_FCM_PUSH_CHANNEL);
        boolean enable = Boolean.parseBoolean(enableStr);
        TIMPushManager.getInstance().forceUseFCMPushChannel(enable);
        result.success("");
    }

    public void createNotificationChannel(@NonNull MethodCall call, @NonNull Result result) {
        Map<String, String> arguments = (Map<String, String>) call.arguments;
        String channelID = arguments.get(Extras.CHANNEL_ID);
        String channelName = arguments.get(Extras.CHANNEL_NAME);
        String channelDes = arguments.get(Extras.CHANNEL_DESC);
        String channelSound = arguments.get(Extras.CHANNEL_SOUND);
        createNotificationChannel(channelName, channelID, channelDes, channelSound, result);
    }

    public void callExperimentalAPI(@NonNull MethodCall call, @NonNull Result result) {
        String api = call.argument("api");
        Object param = call.argument("param");
        TIMPushManager.getInstance().callExperimentalAPI(api, param, new TIMPushCallback<Object>() {
            @Override
            public void onSuccess(Object data) {
                result.success(String.valueOf(data));
            }

            @Override
            public void onError(int errCode, String errMsg, Object data) {
                result.error(String.valueOf(errCode), errMsg, data);
            }
        });
    }

    public void getRegistrationID(@NonNull MethodCall call, @NonNull Result result) {
        TIMPushManager.getInstance().getRegistrationID(new TIMPushCallback<Object>() {
            @Override
            public void onSuccess(Object data) {
                Log.i(TAG, "getRegistrationID, RegistrationID: " + data);
                result.success(String.valueOf(data));
            }

            @Override
            public void onError(int errCode, String errMsg, Object data) {
                result.error(String.valueOf(errCode), errMsg, data);
            }
        });
    }

    public void setRegistrationID(@NonNull MethodCall call, @NonNull Result result) {
        Map<String, String> arguments = (Map<String, String>) call.arguments;
        String registrationID = arguments.get(Extras.REGISTRATION_ID);
        TIMPushManager.getInstance().setRegistrationID(registrationID, new TIMPushCallback<Object>() {
            @Override
            public void onSuccess(Object data) {
                Log.d(TAG, "setRegistrationID onSuccess, registrationID = " + registrationID);
                result.success(data);
            }
        });
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        attachedToEngine = false;
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

    public void toFlutterMethodByJson(final String methodName,  HashMap<String,Object> data) {
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
        registeredOnNotificationClickEvent = true;
        TIMPushConfig.getInstance().setRunningPlatform(TIMPushConstants.PUSH_SDK_RUN_ON_FLUTTER);

        Map<String, String> arguments = (Map<String, String>) call.arguments;
        int sdkAppId = Integer.parseInt(arguments.get(Extras.SDK_APP_ID));
        String appKey = arguments.get(Extras.APP_KEY);

        if(sdkAppId != 0 && appKey != null && !TextUtils.isEmpty(appKey)){
            TIMPushManager.getInstance().registerPush(mContext, sdkAppId, appKey, new TIMPushCallback<String>() {
                @Override
                public void onSuccess(String data) {
                    result.success(data);
                }

                @Override
                public void onError(int errCode, String errMsg, String data) {
                    result.error(String.valueOf(errCode), errMsg, data);
                }
            });
        }else{
            TIMPushManager.getInstance().registerPush(mContext, 0, null, new TIMPushCallback<String>() {
                @Override
                public void onSuccess(String data) {
                    result.success(data);
                }

                @Override
                public void onError(int errCode, String errMsg, String data) {
                    result.error(String.valueOf(errCode), errMsg, data);
                }
            });
        }
    }

    public void unRegisterPush(@NonNull MethodCall call, @NonNull Result result) {
        TIMPushManager.getInstance().unRegisterPush(new TIMPushCallback<String>() {
            @Override
            public void onSuccess(String data) {
                result.success(data);
            }

            @Override
            public void onError(int errCode, String errMsg, String data) {
                result.error(String.valueOf(errCode), errMsg, data);
            }
        });
    }

    public void disableAutoRegisterPush(@NonNull MethodCall call, @NonNull Result result) {
        TIMPushManager.getInstance().callExperimentalAPI("disableAutoRegisterPush", null, new TIMPushCallback() {
            @Override
            public void onSuccess(Object data) {
                result.success(data);
            }

            @Override
            public void onError(int errCode, String errMsg, Object data) {
                result.error(String.valueOf(errCode), errMsg, data);
            }
        });
    }

    public void setCustomFCMRing(@NonNull MethodCall call, @NonNull Result result) {
        Map<String, String> arguments = (Map<String, String>) call.arguments;
        String fcmPushChannelId = arguments.get(Extras.FCM_PUSH_CHANNEL_ID);
        String privateRingName = arguments.get(Extras.PRIVATE_RING_NAME);
        String enableFCMPrivateRing = arguments.get(Extras.ENABLE_FCM_PRIVATE_RING);
        if (Boolean.parseBoolean(enableFCMPrivateRing)) {
            createNotificationChannel("FCM Channel", fcmPushChannelId, "", privateRingName, result);
        }
    }

    public void createNotificationChannel(String channelName, String channelID, String channelDesc,
                                           String channelSound, Result result) {
        try {
            JSONObject param = new JSONObject();
            param.put("channelName", channelName);
            param.put("channelID", channelID);
            param.put("channelDesc", channelDesc);
            param.put("channelSound", channelSound);
            TIMPushManager.getInstance().callExperimentalAPI("createNotificationChannel", param.toString(), new TIMPushCallback() {
                @Override
                public void onSuccess(Object data) {
                    result.success(data);
                }

                @Override
                public void onError(int errCode, String errMsg, Object data) {
                    result.error(String.valueOf(errCode), errMsg, data);
                }
            });
        } catch (Exception e) {
            result.error(String.valueOf(-1), "createNotificationChannel e = " + e, "");
        }
    }

    private void setAndroidCustomConfigFile(MethodCall call, Result result) {
        Map<String, String> arguments = (Map<String, String>) call.arguments;
        String configs = arguments.get(Extras.ANDROID_CONFIGS);
        Map<String, Object> param = new HashMap<>();
        param.put(TUIConstants.TIMPush.SET_CUSTOM_CONFIG_FILE_KEY, configs);
        TUICore.callService(TUIConstants.TIMPush.SERVICE_NAME, TUIConstants.TIMPush.METHOD_SET_CUSTOM_CONFIG_FILE, param);
        result.success("");
    }

    private void setXiaoMiPushStorageRegion(MethodCall call, Result result) {
        result.success("not support");
    }

    public void setPushBrandId(@NonNull MethodCall call, @NonNull Result result) {
        Map<String, String> arguments = (Map<String, String>) call.arguments;
        String brandId = arguments.get(Extras.BRAND_ID);
        TIMPushConfig.getInstance().setPushChannelId(Integer.parseInt(brandId != null ? brandId : "0"));
        result.success("");
    }

    public void getPushBrandId(@NonNull MethodCall call, @NonNull Result result) {
        int brandId = TIMPushConfig.getInstance().getPushChannelId();
        result.success(brandId);
    }

    public void enableBackupChannels(@NonNull MethodCall call, @NonNull Result result){
        try {
            JSONObject param = new JSONObject();
            param.put("enableBackupChannels", true);
            TIMPushManager.getInstance().callExperimentalAPI("setPushConfig", param.toString(), new TIMPushCallback() {
                @Override
                public void onSuccess(Object data) {
                    result.success("");
                }

                @Override
                public void onError(int errCode, String errMsg, Object data) {
                    result.error(String.valueOf(errCode), errMsg, data);
                }
            });
        } catch (Exception e) {
            result.error(String.valueOf(-1), "setPushConfig e = " + e, "");
            Log.e(TAG, "setPushConfig e = " + e);
        }
    }

    private void getAndroidPushToken(MethodCall call, Result result) {
        TIMPushManager.getInstance().callExperimentalAPI("getPushToken", null, new TIMPushCallback() {
            @Override
            public void onSuccess(Object data) {
                String token = (String) data;
                Log.d(TAG, "getAndroidPushToken data =" + token);
                result.success(token);
            }

            @Override
            public void onError(int errCode, String errMsg, Object data) {
                result.error(String.valueOf(errCode), errMsg, "");
            }
        });
    }

    private void setAndroidPushToken(MethodCall call, Result result) {
        Map<String, String> arguments = (Map<String, String>) call.arguments;
        String businessID = arguments.get(Extras.BUSINESS_ID);
        String pushToken = arguments.get(Extras.PUSH_TOKEN);

        try {
            JSONObject param = new JSONObject();
            param.put("businessID", businessID);
            param.put("token", pushToken);
            TIMPushManager.getInstance().callExperimentalAPI("setPushToken", param.toString(), new TIMPushCallback() {
                @Override
                public void onSuccess(Object data) {
                    result.success("");
                }

                @Override
                public void onError(int errCode, String errMsg, Object data) {
                    result.error(String.valueOf(errCode), errMsg, data);
                }
            });
        } catch (Exception e) {
            result.error(String.valueOf(-1), "setPushToken e = " + e, "");
            Log.e(TAG, "setPushConfig e = " + e);
        }
    }

    public void checkPushStatus(@NonNull MethodCall call, @NonNull Result result) {
        result.success("not support");
    }

    public void addPushListener() {
        TIMPushManager.getInstance().addPushListener(timPushListener);
    }

}
