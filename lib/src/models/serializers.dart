library serializers;

import 'package:aplicatie/src/models/movie.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_collection/built_collection.dart';

part 'serializers.g.dart';

@SerializersFor(<Type>[
  Movie,
])
Serializers serializers = (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();

void main() {
  final movie = Movie();
  movie
    ..title
    ..runtime
    ..year;
}
