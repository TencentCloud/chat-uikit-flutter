package com.tencent.chat.flutter.push.tencent_cloud_chat_push.activity;


import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.NonNull;

import com.tencent.chat.flutter.push.tencent_cloud_chat_push.application.TencentCloudChatPushApplication;
import com.tencent.chat.flutter.push.tencent_cloud_chat_push.common.Extras;

import io.flutter.embedding.android.FlutterActivity;

public class TencentCloudChatPushActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        handleIntent(getIntent());
        TencentCloudChatPushApplication.hadLaunchedMainActivity = true;
    }

    @Override
    protected void onNewIntent(@NonNull Intent intent) {
        super.onNewIntent(intent);
        handleIntent(intent);
    }

    private void handleIntent(Intent intent) {
        boolean showInForeground = intent.getBooleanExtra(Extras.SHOW_IN_FOREGROUND, true);
        if (!showInForeground) {
            moveTaskToBack(true);
        }
    }

    @Override
    public String getCachedEngineId() {
        if(TencentCloudChatPushApplication.useCustomFlutterEngine){
            return Extras.FLUTTER_ENGINE;
        }else{
            try{
                return getIntent().getStringExtra("cached_engine_id");
            }catch (Exception e){
                return null;
            }
        }
    }
}
