import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playClickSound() async {
    await _player.play(AssetSource('sounds/click-menu-app.mp3'));
  }
}
