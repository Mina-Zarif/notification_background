import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:notification/socket_service.dart';

import 'notification_service.dart';

class BackgroundService {
  static final service = FlutterBackgroundService();

  static Future<void> initializeService() async {
    try {
      await service.configure(
        androidConfiguration: AndroidConfiguration(
          onStart: onStart,

          autoStart: true,
          isForegroundMode: true,
        ),
        iosConfiguration: IosConfiguration(
          autoStart: true,
          onForeground: onStart,
        ),
      );
      await service.startService();
    } catch (e) {
      log(e.toString(), error: true);
    }
  }

  static onStart(ServiceInstance service) async {
    // WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    SocketService.init();

    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });
      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }

    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        if (service is AndroidServiceInstance) {
          if (await service.isForegroundService()) {
            SocketService.listen('receiveNotification', (data) async {
              log('Received notification: $data');
              await LocalNotificationService.showTextNotification(
                id: data['id'] ?? 0,
                title: data['title'] ?? "TITLE IS NULL",
                body: data['body'] ?? "BODY IS NULL",
              );
            });
          }
        }
        log('Background service is working');
        service.invoke('update');
      },
    );
  }
}
