package com.tencent.chat.flutter.push.tencent_cloud_chat_push.common;

import com.tencent.qcloud.tim.push.TIMPushMessage;
import java.util.HashMap;

public class Utils {

    public static HashMap<String, Object> convertTIMPushMessageToMap(TIMPushMessage msg,Object ...progress){
        final HashMap<String, Object> message = new HashMap<String, Object>();
        if(msg == null) {
            return  null;
        }
        message.put("title", msg.getTitle());
        message.put("desc", msg.getDesc());
        message.put("ext", msg.getExt());
        message.put("messageID", msg.getMessageID());

        return message;
    }
}