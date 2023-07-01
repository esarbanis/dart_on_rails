library models;

import 'package:dart_blog/config/environment.dart';
import 'package:orm/logger.dart';

import 'client.dart';

export 'client.dart';

final orm = PrismaClient(
  stdout: Event.values, // print all events to the console
  datasources: Datasources(
    db: environment['DATABASE_CONNECTION_URL']!,
  ),
);
