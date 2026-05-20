// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';

/// toxee 5.3 — Desktop voice recording dialog.
///
/// Unlike the mobile recorder (press-and-hold + slide-to-cancel), desktop
/// uses a click-to-start, click-to-stop interaction: an overlay dialog with
/// a Stop button and a Cancel button. This keeps the mouse-driven UX
/// predictable and avoids fighting `package:record`'s desktop backends.
///
/// `record: ^5.x` supports macOS, Windows and Linux (Linux requires
/// PulseAudio or PipeWire). To keep behaviour predictable we currently gate
/// the entry point to macOS + Windows from the calling site, but the widget
/// itself is platform-agnostic.
class RecordInfo {
  final String path;
  final int duration;

  const RecordInfo({
    required this.path,
    required this.duration,
  });
}

/// Shows a modal recording dialog. Resolves with a [RecordInfo] when the
/// user clicks "Send", or `null` when they cancel.
Future<RecordInfo?> showDesktopVoiceRecorder(BuildContext context) {
  return showDialog<RecordInfo?>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => const _DesktopVoiceRecorderDialog(),
  );
}

class _DesktopVoiceRecorderDialog extends StatefulWidget {
  const _DesktopVoiceRecorderDialog();

  @override
  State<_DesktopVoiceRecorderDialog> createState() =>
      _DesktopVoiceRecorderDialogState();
}

class _DesktopVoiceRecorderDialogState
    extends State<_DesktopVoiceRecorderDialog> {
  static const int _maxDurationMs = 60000; // 1 minute, matches mobile.

  AudioRecorder? _recorder;
  Timer? _timer;
  int _elapsedMs = 0;
  bool _isRecording = false;
  bool _isStarting = true;
  String? _activePath;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    // Defer the actual start until after first frame so the dialog has
    // already painted — saves a perceived "click did nothing" moment.
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  Future<void> _start() async {
    try {
      _recorder = AudioRecorder();
      if (!await _recorder!.hasPermission()) {
        if (!mounted) return;
        setState(() {
          _isStarting = false;
          _errorText = 'Microphone permission denied';
        });
        return;
      }

      final directory = await getTemporaryDirectory();
      final recordingDirectory = Pertypath()
          .join(directory.path, 'tencent_cloud_chat', 'recordings_desktop');
      await Directory(recordingDirectory).create(recursive: true);
      final uuid = DateTime.now().millisecondsSinceEpoch;
      final path = Pertypath().join(recordingDirectory, '$uuid.m4a');

      const encoder = AudioEncoder.aacLc;
      const config = RecordConfig(encoder: encoder);
      await _recorder!.start(config, path: path);
      _activePath = path;

      if (!mounted) return;
      setState(() {
        _isRecording = true;
        _isStarting = false;
      });
      _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        setState(() {
          _elapsedMs += 100;
        });
        if (_elapsedMs >= _maxDurationMs) {
          _stop(send: true);
        }
      });
    } catch (e) {
      debugPrint('Desktop voice record start failed: $e');
      if (!mounted) return;
      setState(() {
        _isStarting = false;
        _errorText = 'Failed to start recording';
      });
    }
  }

  Future<void> _stop({required bool send}) async {
    _timer?.cancel();
    _timer = null;
    String? path;
    try {
      path = await _recorder?.stop();
    } catch (e) {
      debugPrint('Desktop voice record stop failed: $e');
    }
    await _recorder?.dispose();
    _recorder = null;

    final filePath = path ?? _activePath;
    if (!send) {
      if (filePath != null) {
        try {
          final f = File(filePath);
          if (await f.exists()) {
            await f.delete();
          }
        } catch (_) {/* best-effort cleanup */}
      }
      if (mounted) Navigator.of(context).pop();
      return;
    }

    if (filePath != null && TencentCloudChatUtils.checkString(filePath) != null) {
      final durationSeconds = (_elapsedMs / 1000).ceil();
      if (mounted) {
        Navigator.of(context).pop(
          RecordInfo(path: filePath, duration: durationSeconds),
        );
      }
    } else if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recorder?.dispose();
    super.dispose();
  }

  String _formatElapsed() {
    final seconds = _elapsedMs ~/ 1000;
    final tenths = (_elapsedMs % 1000) ~/ 100;
    return '${seconds.toString().padLeft(2, '0')}.$tenths s';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: const Text('Voice message'),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              _isRecording ? Icons.mic : Icons.mic_off,
              size: 48,
              color: _isRecording ? theme.colorScheme.error : null,
            ),
            const SizedBox(height: 12),
            if (_isStarting)
              const Text('Starting microphone...')
            else if (_errorText != null)
              Text(
                _errorText!,
                style: TextStyle(color: theme.colorScheme.error),
              )
            else
              Text(
                _formatElapsed(),
                style: theme.textTheme.headlineSmall,
              ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: (_elapsedMs / _maxDurationMs).clamp(0.0, 1.0),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => _stop(send: false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isRecording && _elapsedMs > 200
              ? () => _stop(send: true)
              : null,
          child: const Text('Send'),
        ),
      ],
    );
  }
}
