import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(MyApp());
}

class Country {
  const Country({
    @required this.name,
    @required this.flagUrl,
  });
  final String name;
  final String flagUrl;
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
  List<String> flagUrls = <String>[];
  List<String> countryName = <String>[];
  List<Country> countries = <Country>[];

  @override
  void initState(){
    super.initState();
    getFlags();
  }

  Future<void> getFlags() async {
    final Response response = await get('https://www.worldometers.info/geography/flags-of-the-world/');
    final String data = response.body;
    final List<String> items = data.split('<a href="/img/flags');
    for (final String item in items.skip(1)) {
      final String url = 'https://www.worldometers.info/img/flags/${item.split('"')[0]}';
      final String name = item.split('padding-top:10px">')[1].split('<')[0];
      countries.add(Country(name: name,flagUrl:url));
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
            children: <Widget>[
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: countries.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Image(
                            image: NetworkImage(countries[index].flagUrl),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(countries[index].name,textAlign: TextAlign.center),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
