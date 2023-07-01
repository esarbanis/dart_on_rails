import 'dart:io';

import 'package:dart_blog/app/helpers/helpers.dart';
import 'package:hive/hive.dart';
import 'package:shelf/shelf.dart';

initSessionStore() async {
  Hive.init('./db/hive');

  await Hive.openBox('sessions');
}

Middleware sessionMiddleware() => (Handler innerHandler) => (Request req) {
      final sessionId = req.headers[HttpHeaders.cookieHeader]
          ?.split(';')
          .map((cookie) => cookie.trim())
          .firstWhere(
            (cookie) => cookie.startsWith('DSESSIONID='),
            orElse: () => '',
          )
          .split('=')
          .last;

      if (sessionId?.isEmpty == true) {
        return innerHandler(req);
      }

      final user = getUserFromSession(sessionId!);

      return innerHandler(req.change(context: {
        'user': user,
        'sessionId': sessionId,
      }));
    };
