import 'package:aplicatie/src/actions/get_movies.dart';
import 'package:aplicatie/src/actions/update_genre.dart';
import 'package:aplicatie/src/actions/update_quality.dart';
import 'package:aplicatie/src/containers/genre_container.dart';
import 'package:aplicatie/src/containers/is_loading_container.dart';
import 'package:aplicatie/src/containers/movies_container.dart';
import 'package:aplicatie/src/containers/quality_container.dart';
import 'package:aplicatie/src/models/app_state.dart';
import 'package:aplicatie/src/models/movie.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IsLoadingContainer(builder: (BuildContext context, bool isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: <Widget>[
            QualityContainer(
              builder: (BuildContext context, String quality) {
                return DropdownButton<String>(
                  onChanged: (String value) {
                    StoreProvider.of<AppState>(context)..dispatch(UpdateQuality(value))..dispatch(const GetMovies());
                  },
                  value: quality,
                  items: <String>['720p', '1080p', '2160p', '3D'].map((String quality) {
                    return DropdownMenuItem<String>(
                      value: quality,
                      child: Text(quality),
                    );
                  }).toList(),
                );
              },
            ),
            GenreContainer(
              builder: (BuildContext context, String genre) {
                return Wrap(
                  spacing: 4,
                  children: <String>[
                    'Action',
                    'Adventure',
                    'Animation',
                    'Biography',
                    'Comedy',
                    'Crime',
                    'Documentary',
                    'Drama',
                    'Family',
                    'Fantasy',
                    'Film Noir',
                    'History',
                    'Horror',
                    'Music',
                    'Musical',
                    'Mystery',
                    'Romance',
                    'Sci-Fi',
                    'Short Film',
                    'Sport',
                    'Superhero',
                    'Thriller',
                    'War',
                    'Western',
                  ].map((String value) {
                    return ChoiceChip(
                      label: Text(
                        value,
                        style: const TextStyle(
                          fontSize: 10,
                        ),
                      ),
                      selected: value == genre,
                      onSelected: (bool selected) {
                        if (selected) {
                          StoreProvider.of<AppState>(context)
                            ..dispatch(UpdateGenre(value))
                            ..dispatch(const GetMovies());
                        }
                      },
                    );
                  }).toList(),
                );
              },
            ),
            Expanded(
              child: Builder(builder: (BuildContext context) {
                if (isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return MoviesContainer(builder: (BuildContext context, BuiltList<Movie> movies) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(height: 15),
                          Column(
                            children: <Widget>[
                              GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: movies.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  final Movie movie = movies[index];
                                  return Container(
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 2,
                                          child: Image(
                                            image: NetworkImage(movie.mediumCoverImage),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            movie.title,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              FlatButton(
                                child: const Text('Load more'),
                                onPressed: () {
                                  StoreProvider.of<AppState>(context).dispatch(const GetMovies());
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
              }),
            ),
          ],
        ),
      );
    });
  }
}
