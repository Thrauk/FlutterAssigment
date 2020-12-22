library app_state;

import 'package:aplicatie/src/models/movie.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

part 'app_state.g.dart';

abstract class AppState implements Built<AppState, AppStateBuilder> {
  factory AppState() {
      final AppStateBuilder builder = AppStateBuilder();
      builder.isLoading = true;
      return builder.build() as AppState;
    }
  AppState._();

  BuiltList<Movie> get movies;
  bool get isLoading;
}
