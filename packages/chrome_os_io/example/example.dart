import 'package:chrome_os_io/chrome_os_io.dart';
import 'package:universal_io/io.dart';

Future<void> main() async {
  // Enable Chrome IO Driver
  chromeIODriver.enable();

  // Open TCP server
  final server = await ServerSocket.bind('localhost', 0);
  server.listen((socket) {
    // ...
  });

  // Open TCP client
  final client = await Socket.connect('localhost', server.port);

  // ...

  await client.close();
}
