// ignore_for_file:  avoid_print, unused_import

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tencent_im_base/tencent_im_base.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/message.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/permission.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/sound_record.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/logger.dart';

class SendSoundMessage extends StatefulWidget {
  /// conversation ID
  final String conversationID;

  /// control the list to bottom
  final VoidCallback onDownBottom;

  /// the conversation type
  final ConvType conversationType;

  const SendSoundMessage(
      {required this.conversationID,
      required this.conversationType,
      Key? key,
      required this.onDownBottom})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SendSoundMessageState();
}

class _SendSoundMessageState extends TIMUIKitState<SendSoundMessage> {
  final TUIChatGlobalModel model = serviceLocator<TUIChatGlobalModel>();
  String soundTipsText = "";
  bool isRecording = false;
  bool isInit = false;
  bool isCancelSend = false;
  DateTime startTime = DateTime.now();
  List<StreamSubscription<Object>> subscriptions = [];

  OverlayEntry? overlayEntry;
  String voiceIcon = "images/voice_volume_1.png";
  double volume = 0.1;

  buildOverLayView(BuildContext context) {
    if (overlayEntry == null) {
      overlayEntry = OverlayEntry(builder: (content) {
        return Positioned(
          top: 0,
          left: 0,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Material(
            color: Colors.transparent,
            type: MaterialType.canvas,
            child: Center(
              child: Opacity(
                opacity: 0.8,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: const BoxDecoration(
                    color: Color(0xff77797A),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Image.asset(
                              "images/microphone.png",
                              width: 50,
                              height: 60,
                              package: 'flutter_plugin_record_plus',
                            ),
                          ),
                          ClipRect(
                            clipBehavior: Clip.hardEdge,
                            child: Align(
                              heightFactor: max(min(volume, 1), 0.1),
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                width: 50,
                                height: 60,
                                child: Image.asset(
                                  "images/voice_volume_total.png",
                                  width: 50,
                                  height: 60,
                                  package: 'flutter_plugin_record_plus',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        soundTipsText,
                        style: const TextStyle(
                          fontStyle: FontStyle.normal,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
      Overlay.of(context).insert(overlayEntry!);
    }
  }

  onLongPressStart(_) {
    if (isInit) {
      setState(() {
        soundTipsText = TIM_t("手指上滑，取消发送");
      });
      startTime = DateTime.now();
      SoundPlayer.startRecord();
      buildOverLayView(context);
    }
  }

  onLongPressUpdate(e) {
    double height = MediaQuery.of(context).size.height * 0.5 - 240;
    double dy = e.localPosition.dy;

    if (dy.abs() > height) {
      if (mounted && soundTipsText != TIM_t("松开取消")) {
        setState(() {
          soundTipsText = TIM_t("松开取消");
        });
      }
    } else {
      if (mounted && soundTipsText == TIM_t("松开取消")) {
        setState(() {
          soundTipsText = TIM_t("手指上滑，取消发送");
        });
      }
    }
  }

  onLongPressEnd(e) {
    double dy = e.localPosition.dy;
    // 此高度为 160为录音取消组件距离顶部的预留距离
    double height = MediaQuery.of(context).size.height * 0.5 - 240;
    if (dy.abs() > height) {
      isCancelSend = true;
    } else {
      isCancelSend = false;
    }
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
    }
    // Did not receive onStop from FlutterPluginRecord if the duration is too short.
    if (DateTime.now().difference(startTime).inSeconds < 1) {
      isCancelSend = true;
      onTIMCallback(TIMCallback(
          type: TIMCallbackType.INFO,
          infoRecommendText: TIM_t("说话时间太短"),
          infoCode: 6660404));
    }
    stop();
  }

  onLonePressCancel() {
    if (isRecording) {
      isCancelSend = true;
      if (overlayEntry != null) {
        overlayEntry!.remove();
        overlayEntry = null;
      }
      stop();
    }
  }

  void stop() {
    setState(() {
      isRecording = false;
    });
    SoundPlayer.stopRecord();
    setState(() {
      soundTipsText = TIM_t("手指上滑，取消发送");
    });
  }

  sendSound(
      {required String path,
      required int duration,
      required TUIChatSeparateViewModel model}) {
    final convID = widget.conversationID;
    final convType = widget.conversationType;

    if (duration > 0) {
      if (!isCancelSend) {
        MessageUtils.handleMessageError(
            model.sendSoundMessage(
                soundPath: path,
                duration: duration,
                convID: convID,
                convType: convType),
            context);
        widget.onDownBottom();
      } else {
        isCancelSend = false;
      }
    } else {
      onTIMCallback(TIMCallback(
          type: TIMCallbackType.INFO,
          infoRecommendText: TIM_t("说话时间太短"),
          infoCode: 6660404));
    }
  }

  @override
  dispose() {
    for (var subscription in subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  initRecordSound(TUIChatSeparateViewModel model) {
    final responseSubscription = SoundPlayer.responseListener((recordResponse) {
      final status = recordResponse.msg;
      if (status == "onStop") {
        if (!isCancelSend) {
          final soundPath = recordResponse.path;
          final recordDuration = recordResponse.audioTimeLength;
          sendSound(
              path: soundPath!, duration: recordDuration!.ceil(), model: model);
        }
      } else if (status == "onStart") {
        outputLogger.i("start record");
        setState(() {
          isRecording = true;
        });
      } else {
        outputLogger.i(status);
      }
    });
    final amplitudesResponseSubscription =
        SoundPlayer.responseFromAmplitudeListener((recordResponse) {
      setState(() {
        volume = double.parse(recordResponse.msg!) * 1.1;
        if (overlayEntry != null) {
          overlayEntry!.markNeedsBuild();
        }
      });
    });
    subscriptions = [responseSubscription, amplitudesResponseSubscription];
    SoundPlayer.initSoundPlayer();
    isInit = true;
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;
    final TUIChatSeparateViewModel model =
        Provider.of<TUIChatSeparateViewModel>(context);
    return GestureDetector(
      onTapDown: (detail) async {
        if (!isInit) {
          bool hasMicrophonePermission = await Permissions.checkPermission(
            context,
            Permission.microphone.value,
            theme,
          );
          if (!hasMicrophonePermission) {
            return;
          }
          initRecordSound(model);
        }
      },
      onLongPressStart: onLongPressStart,
      onLongPressMoveUpdate: onLongPressUpdate,
      onLongPressEnd: onLongPressEnd,
      onLongPressCancel: onLonePressCancel,
      child: Container(
        height: 35,
        color: isRecording ? theme.weakBackgroundColor : Colors.white,
        alignment: Alignment.center,
        child: Text(
          TIM_t("按住说话"),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: theme.darkTextColor,
          ),
        ),
      ),
    );
  }
}
