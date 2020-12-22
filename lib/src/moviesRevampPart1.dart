import 'dart:convert';

import 'package:aplicatie/src/models/movie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Movie> _movies = <Movie>[];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getMovies();
  }

  Future<void> _getMovies() async {
    setState(() {
      _isLoading = true;
    });
    const String url = 'https://yts.mx/api/v2/list_movies.json';
    final Response response = await get(url);

    final String body = response.body;
    final List<dynamic> list = jsonDecode(body)['data']['movies'] as List<dynamic>;
    final List<Movie> movieList = list.map((dynamic json) => Movie.fromJson(json)).toList();
    setState(() {
      _movies.addAll(movieList);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Builder(builder: (BuildContext conext) {
        if(_isLoading){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
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
                  itemCount: _movies.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final Movie movie = _movies[index];
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
      }),
    );
  }
}
