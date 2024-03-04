import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:path_provider/path_provider.dart';

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    final value = Random().nextInt(1000).toString();
    print('Background service timer is working... $value');
    final path = await getTemporaryDirectory();
    final file = File('${path.path}/data.txt');
    file.writeAsStringSync(value);
  });
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  return false;
}

class BackgroundService {
  factory BackgroundService() {
    return instance;
  }
  BackgroundService._internal();
  static final BackgroundService instance = BackgroundService._internal();
  Future<void> init() async {
    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );
    await service.startService();
  }
}
