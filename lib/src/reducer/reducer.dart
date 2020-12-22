import 'package:aplicatie/src/actions/get_movies.dart';
import 'package:aplicatie/src/models/app_state.dart';

AppState reducer(AppState state, dynamic action) {
  if(action is GetMovies){
    final AppStateBuilder builder = state.toBuilder();
    builder.isLoading = true;
    return builder.build();
  } else if(action is GetMoviesSuccessful || action is GetMoviesError){
    return state.isLoading = false;
  }
  return state;
}