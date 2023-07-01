library controllers;

import 'dart:io';

import 'package:dart_blog/app/helpers/helpers.dart';
import 'package:dart_blog/app/models/models.dart';
import 'package:dart_blog/app/views/views.dart';
import 'package:shelf/shelf.dart';

class Users {
  static Future<Response> login(Request req) async {
    final view = views.getTemplate('users/login.j2');

    return Response.ok(
      view.render({}),
      headers: {'Content-Type': 'text/html'},
    );
  }

  static Future<Response> newOne(Request req) async {
    final view = views.getTemplate('users/new.j2');

    return Response.ok(
      view.render({}),
      headers: {'Content-Type': 'text/html'},
    );
  }

  static Future<Response> create(Request req) async {
    final fields = await req.getFields();
    final password = createPasswordHash(fields['password']!);

    final user = await orm.user.create(
      data: UserCreateInput(
        name: fields['name']!,
        email: fields['email']!,
        password: password,
      ),
    );

    final sessionId = await createSession(user);

    return Response.seeOther('/posts', headers: {
      HttpHeaders.setCookieHeader: 'DSESSIONID=$sessionId; path=/',
    });
  }

  static Future<Response> authenticate(Request req) async {
    final fields = await req.getFields();

    final user = await orm.user.findUnique(
      where: UserWhereUniqueInput(email: fields['email']!),
    );

    if (user == null) {
      return Response.seeOther('/users/login');
    }

    if (!verifyPassword(fields['password']!, user.password)) {
      return Response.seeOther('/users/login');
    }

    final sessionId = await createSession(user);

    return Response.seeOther('/posts', headers: {
      HttpHeaders.setCookieHeader: 'DSESSIONID=$sessionId; Path=/',
    });
  }

  static Future<Response> logout(Request req) async {
    final sessionId = req.context['sessionId'] as String;

    await destroySession(sessionId);

    return Response.seeOther('/posts', headers: {
      HttpHeaders.setCookieHeader: 'DSESSIONID=0; Path=/',
    });
  }
}
