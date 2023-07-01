import 'dart:convert';
import 'dart:math';

import 'package:crypt/crypt.dart';
import 'package:dart_blog/app/models/models.dart';
import 'package:hive/hive.dart';

final _sessionStore = Hive.box('sessions');

createPasswordHash(String password) {
  final salt = Random.secure();
  return Crypt.sha256(
    password,
    rounds: 10000,
    salt: salt.toString(),
  ).toString();
}

verifyPassword(String password, String hash) {
  return Crypt(hash).match(password);
}

_createSessionToken() {
  final random = Random.secure();
  final values = List<int>.generate(32, (i) => random.nextInt(256));
  return values.map((v) => v.toRadixString(16)).join();
}

Future<String> createSession(User user) async {
  final token = _createSessionToken();
  await _sessionStore.put(token, jsonEncode(user.toJson()));

  return token;
}

Future<void> destroySession(String sessionId) async {
  await _sessionStore.delete(sessionId);
}

User? getUserFromSession(String token) {
  final user = _sessionStore.get(token);

  if (user == null) {
    return null;
  }

  return User.fromJson(jsonDecode(user) as Map<String, dynamic>);
}
