import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../global/environment.dart';
import 'auth_service.dart';

enum ServerStatus { Online, Offline, Connecting }

class SocketService extends StateNotifier<ServerStatus> {
  SocketService() : super(ServerStatus.Connecting);

  ServerStatus _serverStatus = ServerStatus.Connecting;

  late io.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;

  io.Socket get socket => _socket;

  Function get emit => _socket.emit;

  Future<void> connect() async {
    final String? token = await AuthService.getToken();

    // Dart client
    _socket = io.io(Environment.socketUrl, <String, dynamic>{
      'transports': <String>['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': <String, dynamic>{'x-token': token}
    });

    _socket.on('connect', (_) {
      _serverStatus = ServerStatus.Online;
      state = _serverStatus;
    });

    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.Offline;
      state = _serverStatus;
    });
  }

  void disconnect() {
    _socket.disconnect();
  }
}

final StateNotifierProvider<SocketService, ServerStatus> socketServiceProvider =
    StateNotifierProvider<SocketService, ServerStatus>(
  (StateNotifierProviderRef<SocketService, ServerStatus> ref) =>
      SocketService(),
);
