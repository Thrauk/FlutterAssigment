import 'package:aplicatie/src/actions/get_movies.dart';
import 'package:aplicatie/src/actions/update_genre.dart';
import 'package:aplicatie/src/actions/update_quality.dart';
import 'package:aplicatie/src/models/app_state.dart';

AppState reducer(AppState state, dynamic action) {
  final AppStateBuilder builder = state.toBuilder();
  if (action is GetMoviesStart) {
    builder.isLoading = true;
  } else if (action is GetMoviesSuccessful) {
    builder.movies.addAll(action.movies);
    builder
      ..isLoading = false
      ..nextPage = builder.nextPage + 1;
  } else if (action is GetMoviesError) {
    builder.isLoading = false;
  } else if (action is UpdateQuality) {
    builder
      ..movies.clear()
      ..nextPage = 1
      ..quality = action.quality;
  } else if (action is UpdateGenre) {
    builder
      ..movies.clear()
      ..nextPage = 1
      ..genre = action.genre;
  }
  return builder.build();
}
