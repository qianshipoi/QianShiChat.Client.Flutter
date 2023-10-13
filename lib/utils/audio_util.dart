import 'package:audioplayers/audioplayers.dart';

class AudioUtil {
  static final Map<String, AudioPlayer> _players = {};

  var audioPlayer = AudioPlayer();
  String path;
  AudioUtil(
    this.path,
  );

  Future<void> play() async {
    if (_players.containsKey(path)) {
      await _players[path]!.resume();
      return;
    }

    for (var element in _players.entries) {
      element.value.stop();
    }

    await audioPlayer.setSourceUrl(path);
    await audioPlayer.play(audioPlayer.source!);
    _players[path] = audioPlayer;
  }

  Future<void> stop() async {
    await audioPlayer.stop();
    await audioPlayer.dispose();
    if (_players.containsKey(path)) {
      _players.remove(path);
    }
  }

  Future<void> pause() async {
    await audioPlayer.pause();
  }

  Future<void> resume() async {
    await audioPlayer.resume();
  }

  Future<void> seek(Duration duration) async {
    audioPlayer.seek(duration);
  }

  static Future<Duration?> getDuration(String path) async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.setSourceUrl(path);
    Duration? duration = await audioPlayer.getDuration();
    audioPlayer.dispose();
    return duration;
  }
}
