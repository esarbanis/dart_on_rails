import 'package:dart_blog/app/models/application.dart';
import 'package:shelf/shelf.dart';

extension RequestExtension on Request {
  Future<Map<String, String>> getFields() async {
    final body = await readAsString();

    return _parseFormFields(body);
  }

  User? get user => context['user'] as User?;

  bool get isAuthenticated => user != null;
}

Map<String, String> _parseFormFields(String data) {
  return data.split('&').fold(
    <String, String>{},
    (map, element) {
      final split = element.split('=');
      map[split[0]] = Uri.decodeQueryComponent(split[1]);
      return map;
    },
  );
}

Handler authenticated(Handler innerHandler) => (Request req) {
      if (req.user == null) {
        return Response(302, headers: {'location': '/users/login'});
      }

      return innerHandler(req);
    };
