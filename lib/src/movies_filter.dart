import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(MyApp());
}

class Movie {
  const Movie(
      {@required this.title,
      @required this.imageUrl,
      @required this.genre,
      @required this.year,
      @required this.rating});

  final String title;
  final String imageUrl;
  final List<String> genre;
  final int year;
  final String rating;

  String getInfo() {
    String ret = title + ' ' + year.toString() + '\nRating: ' + rating + '\n';
    for (final String elem in genre) {
      ret += elem + ', ';
    }
    return ret.substring(0, ret.length - 2);
  }
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
  List<Movie> movies;
  List<String> selectableGenres = <String>[
    '-',
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
    'Western'
  ];

  List<String> selectableYears = List<int>.generate(71, (int i) => i + 1950).map((int el) => el.toString()).toList();

  List<String> selectableRatings = List<int>.generate(10, (int i) => i + 1).map((int el) => el.toString()).toList();

  String dropdownValueGenre = '-';
  String dropdownValueYear = '-';
  String dropdownValueRating = '-';

  int indexGenre = 0;
  int indexYear = 0;
  int indexRating = 0;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    getMovies(1);
    selectableYears.insert(0, '-');
    selectableRatings.insert(0, '-');
  }

  Future<void> getMovies(int page) async {
    List<String> genres;
    movies = <Movie>[];
    String genreFilter = '';
    String ratingFilter = '';
    if (dropdownValueGenre != '-') {
      genreFilter = '&genre=' + dropdownValueGenre;
    }
    if (dropdownValueRating != '-') {
      ratingFilter = '&minimum_rating=' + dropdownValueRating;
    }
    final Response response =
        await get('https://yts.mx/api/v2/list_movies.json?page=' + page.toString() + genreFilter + ratingFilter);
    final Map<String, dynamic> map = jsonDecode(response.body) as Map<String, dynamic>;
    final List<dynamic> movieList = map['data']['movies'] as List<dynamic>;
    for (int i = 0; i < movieList.length; ++i) {
      final String title = movieList[i]['title'] as String;
      final String imageUrl = movieList[i]['medium_cover_image'] as String;
      try {
        genres = List<String>.from(movieList[i]['genres'] as List<dynamic>);
      } catch (e) {
        genres = <String>[];
      }
      final int year = movieList[i]['year'] as int;
      final String rating = movieList[i]['rating'].toString();
      if (dropdownValueYear != '-') {
        if (year.toString() == dropdownValueYear) {
          movies.add(Movie(title: title, imageUrl: imageUrl, genre: genres, year: year, rating: rating));
        }
      } else {
        movies.add(Movie(title: title, imageUrl: imageUrl, genre: genres, year: year, rating: rating));
      }
    }
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Genre',
                        ),
                        const SizedBox(width: 10),
                        DropdownButton<String>(
                          value: dropdownValueGenre,
                          onChanged: (String value) {
                            setState(() {
                              indexGenre = selectableGenres.indexOf(value);
                              print(indexGenre.toString());
                              dropdownValueGenre = value;
                              if (dropdownValueGenre != '-') {
                                currentPage = 1;
                                getMovies(currentPage);
                              }
                            });
                          },
                          items: selectableGenres.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Year',
                        ),
                        const SizedBox(width: 10),
                        DropdownButton<String>(
                          value: dropdownValueYear,
                          onChanged: (String value) {
                            setState(() {
                              indexYear = selectableYears.indexOf(value);
                              print(indexYear.toString());
                              dropdownValueYear = value;
                              if (dropdownValueYear != '-') {
                                currentPage = 1;
                                getMovies(currentPage);
                              }
                            });
                          },
                          items: selectableYears.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Minimum rating',
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: dropdownValueRating,
                    onChanged: (String value) {
                      setState(() {
                        indexYear = selectableRatings.indexOf(value);
                        print(indexRating.toString());
                        dropdownValueRating = value;
                        if (dropdownValueRating != '-') {
                          currentPage = 1;
                          getMovies(currentPage);
                        }
                      });
                    },
                    items: selectableRatings.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
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
                  return Container(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Image(
                            image: NetworkImage(movies[index].imageUrl),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            movies[index].getInfo(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
              Text(
                'Page number ' + currentPage.toString(),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Visibility(
                    visible: currentPage != 1,
                    child: Row(
                      children: <Widget>[
                        RaisedButton(
                          color: Colors.blueGrey,
                          child: const Text('Previous',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                          onPressed: () {
                            setState(() {
                              currentPage -= 1;
                              getMovies(currentPage);
                            });
                          },
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                  RaisedButton(
                    color: Colors.blueGrey,
                    child: const Text('Next page',
                        style: TextStyle(
                          color: Colors.white,
                        )),
                    onPressed: () {
                      setState(() {
                        currentPage += 1;
                        getMovies(currentPage);
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
