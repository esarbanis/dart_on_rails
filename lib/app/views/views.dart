library views;

import 'package:jinja/jinja.dart';
import 'package:jinja/loaders.dart';

final views = Environment(
  loader: FileSystemLoader(
    paths: ['lib/app/views'],
    extensions: {'j2'},
  ),
);
