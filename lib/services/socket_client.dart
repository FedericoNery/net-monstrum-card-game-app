import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketManager {
  static final SocketManager _instance = SocketManager._internal();
  IO.Socket? _socket;

  factory SocketManager() {
    return _instance;
  }

  SocketManager._internal();

  void initSocket(String serverUrl) {
    _socket = IO.io(
        'ws://192.168.0.23:8000',
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .setExtraHeaders({'foo': 'bar'}) // optional
            .build());

    _socket!.onConnect((_) {
      print('connect');
    });

    _socket!.onDisconnect((_) => print('disconnect'));
    _socket!.connect();
  }

  IO.Socket? get socket {
    if (_socket == null) {
      initSocket('');
    }
    return _socket!;
  }
}
