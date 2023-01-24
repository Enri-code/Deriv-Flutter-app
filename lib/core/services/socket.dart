import 'package:web_socket_channel/web_socket_channel.dart';

///A class that exposes the websocket's stream and sink
class SocketConnection {
  SocketConnection({required String baseUrl})
      : _webSocket = WebSocketChannel.connect(Uri.parse(baseUrl));

  final WebSocketChannel _webSocket;

  Sink get sink => _webSocket.sink;

  Stream? _breadcastStream;

  ///Convert's the websocket stream to a broadcast stream and returns it
  Stream get stream {
    return _breadcastStream ??= _webSocket.stream.asBroadcastStream();
  }
}
