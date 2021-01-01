/*import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

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
  final AudioPlayer audioPlayer = AudioPlayer();

  // ignore: always_specify_types
  Future play() async {
    final int result = await audioPlayer.play('https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=test&tl=ro&total=1&idx=0&textlen=4');
    if (result == 1) {
      await audioPlayer.seek(const Duration(seconds: 1));
    }
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
                itemCount: 8,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () {
                          play();
                        },
                      child: AnimatedContainer(
                          color: Colors.blue, duration: const Duration(milliseconds: 500)));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/