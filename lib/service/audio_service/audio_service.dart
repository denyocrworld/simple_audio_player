import 'package:audioplayers/audioplayers.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class AudioService {
  static AudioPlayer player = AudioPlayer();
  static late RxSharedPreferences rxPrefs;
  static Future<void> play([
    String url = 'https://example.com/my-audio.wav',
  ]) async {
    rxPrefs = RxSharedPreferences(await SharedPreferences.getInstance());
    rxPrefs.setString("url", url);
    rxPrefs.setString("action", "play");
  }

  static Future<void> stop() async {
    rxPrefs = RxSharedPreferences(await SharedPreferences.getInstance());
    rxPrefs.setString("action", "stop");
  }

  static Future<void> pause() async {
    rxPrefs = RxSharedPreferences(await SharedPreferences.getInstance());
    rxPrefs.setString("action", "stop");
  }

  static Future<void> resume() async {
    rxPrefs = RxSharedPreferences(await SharedPreferences.getInstance());
    rxPrefs.setString("action", "resume");
  }

  static Future<int> getCurrentPosition() async {
    rxPrefs = RxSharedPreferences(await SharedPreferences.getInstance());
    return await rxPrefs.getInt("duration") ?? 0;
  }

  static cleanAction() {
    rxPrefs.remove("action");
  }

  static startBackgroundListener() async {
    rxPrefs = RxSharedPreferences(await SharedPreferences.getInstance());
    rxPrefs.getStringStream("action").listen((action) async {
      String? url = await rxPrefs.getString("url");
      if (url == null) return;
      if (action == "play") {
        cleanAction();
        await player.play(UrlSource(url));
        player.onDurationChanged.listen((event) {
          rxPrefs.setInt("duration", event.inSeconds);
        });
      } else if (action == "stop") {
        cleanAction();
        await player.stop();
      } else if (action == "pause") {
        cleanAction();
        await player.pause();
      } else if (action == "resume  ") {
        cleanAction();
        await player.resume();
      }
    });
  }
}
