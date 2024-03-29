import 'dart:io';

import 'package:dart_blog/config/config.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Initialize session store.
  await initSessionStore();

  // Configure a pipeline that logs requests.
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(sessionMiddleware())
      .addHandler(routes);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8888');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
