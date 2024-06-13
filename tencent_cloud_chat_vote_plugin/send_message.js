import axios from 'axios';

const tempMap = [];

let i = 0;

const data = () => {
    const rand1 = Math.ceil(Math.random()*100000000);
    const rand2 = Math.ceil(Math.random()*100000000);
    const rand = rand1 + rand2;
    if(tempMap.includes(rand)){
        console.log("youchongfu");
    }
    tempMap.push(rand);
    i++;
    return {
        "From_Account": "1111",
        "GroupId": "@TGS#2YUHULJMP",
        "MsgRandom": rand,
        "MsgLifeTime": 120,
        "OfflinePushInfo": {
            "PushFlag": 0,
            "Desc": "离线推送内容",
            "Ext": "{}",
            "AndroidInfo": {
                "Sound": "android.mp3"
            },
            "ApnsInfo": {
                "Sound": "apns.mp3",
                "BadgeMode": 1, // 这个字段缺省或者为 0 表示需要计数，为 1 表示本条消息不需要计数，即右上角图标数字不增加
                "Title":"apns title", // apns title
                "SubTitle":"apns subtitle", // apns subtitle
                "Image":"www.image.com" // image url
            }
        },
        "MsgBody": [
            {
                "MsgType": "TIMTextElem",
                "MsgContent": {
                    "Text": i.toString()
                }
            }
        ]
    };
}

const timer = setInterval(() =>{
    axios.post(`https://console.tim.qq.com/v4/group_open_http_svc/send_group_msg?usersig=-38-QS7s820m7uLTYVqkWGMaM_&identifier=admin&sdkappid=1400182&random=99999999&contenttype=json`,data())
    .then(res=>{
        console.log(res);
    });
}, 200);

// axios.post(`https://console.tim.qq.com/v4/openim/sendmsg?usersig=eJyrVgrxCdYrSy1SslIy0jNQ0gHzM1NS80oy0zLBwokpuZl5UInilOzEgoLMFCUrQxMDA0MLc2NTI4hMakVBZlEqUNzU1NTIwMAAIlqSmQsSMzM3MTA2MrY0g5qSmQ40N888NSjCv9Anx88tqcQ7KDmjzMDCL9s1P8LTycgsN0Y-38-QS7s820m7uLTYVqkWAFnGMaM_&identifier=admin&sdkappid=1400187352&random=99999999&contenttype=json`,data())
//     .then(res=>{
//         console.log(res);
//     });
