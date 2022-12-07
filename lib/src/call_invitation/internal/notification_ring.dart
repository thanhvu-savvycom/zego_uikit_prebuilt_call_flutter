// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class ZegoRingtone {
  bool isRingTimerRunning = false;
  var audioPlayer = AudioPlayer();

  bool isVibrate = true;
  String sourcePath = "";

  ZegoRingtone();

  void init({
    required String prefix,
    required String sourcePath,
    required bool isVibrate,
  }) {
    debugPrint('init: prefix:$prefix, source path:$sourcePath');

    AudioCache.instance.prefix = prefix;

    this.sourcePath = sourcePath;
    this.isVibrate = isVibrate;

    final AudioContext audioContext = AudioContext(
      iOS: AudioContextIOS(
        defaultToSpeaker: true,
        category: AVAudioSessionCategory.ambient,
        options: [
          AVAudioSessionOptions.defaultToSpeaker,
          AVAudioSessionOptions.mixWithOthers,
        ],
      ),
      android: AudioContextAndroid(
        isSpeakerphoneOn: true,
        stayAwake: true,
        contentType: AndroidContentType.music,
        usageType: AndroidUsageType.media,
        audioFocus: AndroidAudioFocus.gain,
      ),
    );
    AudioPlayer.global.setGlobalAudioContext(audioContext);
  }

  void startRing() async {
    if (isRingTimerRunning) {
      debugPrint('ring is running');
      return;
    }

    debugPrint('start ring, source path:$sourcePath');

    isRingTimerRunning = true;

    audioPlayer.setReleaseMode(ReleaseMode.loop);
    await audioPlayer.play(AssetSource(sourcePath));
    if (isVibrate && await Vibration.hasVibrator() != true) {
      Vibration.vibrate();
    }

    Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
      // debugPrint('ring timer periodic');
      if (!isRingTimerRunning) {
        debugPrint('ring timer ended');

        audioPlayer.stop();

        timer.cancel();
        Vibration.cancel();
      } else {
        if (isVibrate && await Vibration.hasVibrator() != true) {
          Vibration.vibrate();
        }
      }
    });
  }

  void stopRing() async {
    debugPrint('stop ring');

    isRingTimerRunning = false;

    audioPlayer.stop();

    Vibration.cancel();
  }
}
