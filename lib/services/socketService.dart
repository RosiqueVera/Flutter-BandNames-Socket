import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus {
  online,
  offline,
  connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  Socket? _socket;

  ServerStatus get serverStatus => _serverStatus;
  Socket get socket => _socket!;

  SocketService() {
    _initConfig();
  }
  void _initConfig() {
    _socket = io(
      'http://10.0.2.2:3000',
      OptionBuilder().setTransports(['websocket']).enableAutoConnect().build(),
    );
    _socket!.onConnect((_) {
      log('connect');
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });
    _socket!.onDisconnect((_) {
      log('disconnect');
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });
    _socket!.on('emitir-mensaje', (data) {
      print('Cliente origen ${data['name']}');
      log('Nuevo mensaje ${data['message']}');
    });
  }
}
