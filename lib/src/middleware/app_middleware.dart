import 'package:aplicatie/src/actions/get_movies.dart';
import 'package:aplicatie/src/data/yts_api.dart';
import 'package:aplicatie/src/models/app_state.dart';
import 'package:aplicatie/src/models/movie.dart';
import 'package:redux/redux.dart';
import 'package:meta/meta.dart';

class AppMiddleware {
  const AppMiddleware({@required YtsApi ytsApi})
      : assert(ytsApi != null),
        _ytsApi = ytsApi;

  final YtsApi _ytsApi;

  List<Middleware<AppState>> get middleware {
    return <Middleware<AppState>>[
      _getMovies,
    ];
  }

  Future<void> _getMovies(Store<AppState> store, dynamic action, NextDispatcher next) async {
    next(action);
    if (action is GetMoviesStart) {
      try {
        final List<Movie> movies = await _ytsApi.getMovies(store.state.nextPage, store.state.quality, store.state.genre);
        final GetMoviesSuccessful successful = GetMovies.successful(movies) as GetMoviesSuccessful;
        store.dispatch(successful);
      } catch (e) {
        final GetMoviesError error = GetMovies.error(e) as GetMoviesError;
        store.dispatch(error);
      }
    }
  }
}
