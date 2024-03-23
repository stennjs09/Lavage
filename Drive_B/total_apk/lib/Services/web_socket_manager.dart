import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketManager {
  static late WebSocketChannel _channel;

  static void connect(String url) {
    _channel = WebSocketChannel.connect(Uri.parse(url));
  }

  static void listen(void Function(dynamic) onData, void Function() onDone) {
    _channel.stream.listen(
      onData,
      onDone: onDone,
    );
  }

  static void send(String message) {
    _channel.sink.add(message);
  }

  static void close() {
    _channel.sink.close();
  }
}
