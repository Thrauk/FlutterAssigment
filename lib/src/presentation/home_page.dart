import 'package:aplicatie/src/containers/is_loading_container.dart';
import 'package:aplicatie/src/containers/movies_container.dart';
import 'package:aplicatie/src/models/movie.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IsLoadingContainer(builder: (BuildContext context, bool isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: Builder(builder: (BuildContext context) {
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
                  ],
                ),
              ),
            );
          });
        }),
      );
    });
  }
}
