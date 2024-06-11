import 'dart:async';

// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_plugin_record_plus/const/play_state.dart';
import 'package:flutter_plugin_record_plus/const/response.dart';
import 'package:flutter_plugin_record_plus/index.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tencent_cloud_chat_uikit/import_proxy/import_proxy.dart';

typedef PlayStateListener = void Function(PlayState playState);
typedef SoundInterruptListener = void Function();
typedef ResponseListener = void Function(RecordResponse recordResponse);

class SoundPlayer {
  final ImportProxy importProxy = ImportProxy();
  static final FlutterPluginRecord _recorder = FlutterPluginRecord();
  static SoundInterruptListener? _soundInterruptListener;
  static bool isInit = false;
  static final AudioPlayer _audioPlayer = AudioPlayer();

  static initSoundPlayer() {
    if (!isInit) {
      _recorder.init();
      // AudioPlayer.global.setGlobalAudioContext(const AudioContext());
      isInit = true;
    }
  }

  static Future<void> play({required String url}) async {
    _audioPlayer.stop();
    if (_soundInterruptListener != null) {
      _soundInterruptListener!();
    }
    await _audioPlayer.setUrl(url);

    await _audioPlayer.play();
  }

  static stop() {
    _audioPlayer.stop();

  }

  static dispose() {
    _audioPlayer.dispose();
    _recorder.dispose();
  }

  static StreamSubscription<PlayerState> playStateListener({required void Function(PlayerState)? listener}) => _audioPlayer.playerStateStream.listen(listener);

  static setSoundInterruptListener(SoundInterruptListener listener) {
    _soundInterruptListener = listener;
  }

  static removeSoundInterruptListener() {
    _soundInterruptListener = null;
  }

  static StreamSubscription<RecordResponse> responseListener(ResponseListener listener) => _recorder.response.listen(listener);

  static StreamSubscription<RecordResponse> responseFromAmplitudeListener(ResponseListener listener) => _recorder.responseFromAmplitude.listen(listener);

  static startRecord() {
    _recorder.start();
  }

  static stopRecord() {
    _recorder.stop();
  }
}
