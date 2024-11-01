import 'dart:developer';
import 'dart:math' as m;

import 'package:socket_io_client/socket_io_client.dart';

import 'notification_service.dart';

class SocketService {
  static late Socket socket;

  static init() {
    // Initialize the socket with the correct server address and options
    socket = io(
        'http:{SERVER_IP}:3000', // Make sure this IP and port are correct
        OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build(),
    );

    // Listen for connection and error events
    socket.onConnect((_) {
      log('Connected to the server');
    });

    socket.onConnectError((data) => log('Connection Error: $data'));
    socket.onError((data) => log('Socket Error: $data'));

    // Listen for notifications from the server
    socket.on('receiveNotification', (data) async {
      log('Received notification: $data');
      await LocalNotificationService.showTextNotification(
        id: data['id'] ?? 0,
        title: data['title'] ?? "TITLE IS NULL",
        body: data['body'] ?? "BODY IS NULL",
      );
    });

    socket.onDisconnect((_) => log('Disconnected from server'));

    // Connect the socket after setting up listeners
    socket.connect();
  }

  // Emit an event with a message
  static emit(String event, {Object? title, Object? body, Object? payload}) {
    log('Emitting event: $event');
    var id = DateTime.now().millisecondsSinceEpoch % m.pow(2, 31);
    var message = {'title': title, 'body': body, 'payload': payload, 'id': id};
    socket.emit(event, message);
  }

  // Listen for specific events
  static listen(String event, dynamic Function(dynamic) callback) {
    if (socket.hasListeners(event)) {
      socket.off(event);  // Remove any existing listeners for this event
    }
    socket.on(event, callback);
  }
}
