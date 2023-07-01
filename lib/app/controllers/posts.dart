library controllers;

import 'package:dart_blog/app/helpers/helpers.dart';
import 'package:dart_blog/app/models/models.dart';
import 'package:dart_blog/app/views/views.dart';
import 'package:shelf/shelf.dart';

class Posts {
  static Future<Response> index(Request req) async {
    final posts = await orm.post.findMany();
    final view = views.getTemplate('posts/index.j2');

    return Response.ok(
      view.render({
        'posts': posts.map((post) => post.toJson()),
        'user': req.user,
      }),
      headers: {'Content-Type': 'text/html'},
    );
  }

  static Future<Response> show(Request req, String id) async {
    final postId = int.parse(id);
    final post = await orm.post.findUnique(
      where: PostWhereUniqueInput(id: postId),
    );
    if (post == null) return Response.notFound('Not found');

    final view = views.getTemplate('posts/show.j2');

    return Response.ok(
      view.render({
        'post': post.toJson(),
        'user': req.context['user'] as User?,
      }),
      headers: {'Content-Type': 'text/html'},
    );
  }

  static Future<Response> newOne(Request req) async {
    final view = views.getTemplate('posts/new.j2');

    return Response.ok(
      view.render({
        'user': req.user,
      }),
      headers: {'Content-Type': 'text/html'},
    );
  }

  static Future<Response> create(Request req) async {
    final fields = await req.getFields();

    if (!req.isAuthenticated) return Response.forbidden('Forbidden');

    final user = req.user!;

    final post = await orm.post.create(
      data: PostCreateInput(
        title: fields['title']!,
        content: fields['content']!,
        author: UserCreateNestedOneWithoutPostsInput(
          connect: UserWhereUniqueInput(id: user.id),
        ),
      ),
    );

    return Response.seeOther('/posts/${post.id}');
  }
}
