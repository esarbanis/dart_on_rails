import 'package:dart_blog/app/controllers/controllers.dart';
import 'package:dart_blog/app/helpers/helpers.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';

final routes = Router()
  ..get('/', _redirect('/posts'))
  ..mount(
    '/posts',
    Router()
      ..get('/', Posts.index)
      ..get('/<id|[0-9]+>', Posts.show)
      ..get('/new', authenticated(Posts.newOne))
      ..post('/', authenticated(Posts.create)),
  )
  ..mount(
    '/users',
    Router()
      ..get('/login', Users.login)
      ..get('/new', Users.newOne)
      ..post('/', Users.create)
      ..post('/auth', Users.authenticate)
      ..get('/logout', Users.logout),
  )
  ..get('/<path|.*>', createStaticHandler('public'));

_redirect(String url) => (request) {
  Map<String,String> headers = {'location':url};
  return Response(302,headers:headers);
};
