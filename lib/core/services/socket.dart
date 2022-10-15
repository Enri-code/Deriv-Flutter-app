import 'package:web_socket_channel/web_socket_channel.dart';

abstract class SocketConnection {
  static final _webSocket = WebSocketChannel.connect(
    Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'),
  );

  static Stream? _breadcastStream;

  static Sink get sink => _webSocket.sink;
  static Stream get stream {
    return _breadcastStream ??= _webSocket.stream.asBroadcastStream();
  }
}
