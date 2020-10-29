import 'package:MusicApp/Provider/PlaylistProvider.dart';
import 'package:MusicApp/Screens/musicPlaylist.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => PlaylistProvider()),
    ],
      child: MyApp(
    ),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MusicPlaylist(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Slider musicSlider;
  double x = 0;
  double max;
  bool play = false;

  Duration _duration = new Duration();
  Duration _position = new Duration();
  AudioPlayer advancedPlayer;
  AudioCache audioCache;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlayer();
  }

  void initPlayer() {
    advancedPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: advancedPlayer);
    
    advancedPlayer.durationHandler = (d) => setState(() {
          _duration = d;
        });

    advancedPlayer.positionHandler = (p) => setState(() {
          _position = p;
        });
  }

  String localFilePath;

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);

    advancedPlayer.seek(newDuration);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    setState(() {
      max = 450;
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData m = MediaQuery.of(context);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        body: Container(
      width: m.size.width,
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.keyboard_arrow_down,
              ),
              iconSize: 40,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Color(0xff999999),
                  blurRadius: 20,
                  offset: Offset(-5, 5)),
              BoxShadow(
                  color: Color(0xff11000000),
                  blurRadius: 20,
                  offset: Offset(-5, 5))
            ]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                imageUrl:
                    'https://images.pexels.com/photos/1910236/pexels-photo-1910236.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260',
                imageBuilder: (context, imageProvider) => Container(
                  width: 0.7 * m.size.width,
                  height: 0.7 * m.size.width,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          Text(
            "Ayam , Tamer Ashor",
            style: TextStyle(
                color: Color(0xff333333),
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            " Hekayat , Pop",
            style: TextStyle(
              color: Color(0xff333333),
              fontSize: 16,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 0.9 * m.size.width,
            child: Slider(
              onChanged: (value) {
                setState(() {
                  seekToSecond(value.toInt());
                  value = value;
                });
              },
              value: _position.inSeconds.toDouble(),
              min: 0.0,
              max: _duration.inSeconds.toDouble(),
              inactiveColor: Color(0xffEEEEEE),
              activeColor: Color(0xff9B5094),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 0.8 * m.size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                    '${_position.inMinutes}:${_position.inSeconds % 60 < 10 ? 0 + _position.inSeconds % 60 : _position.inSeconds % 60}'),
                Text('${_duration.inMinutes}:${_duration.inSeconds % 60}')
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            width: 0.9 * m.size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.chevron_left),
                    iconSize: 40,
                    onPressed: () {}),
                IconButton(
                    icon: Icon(play ? Icons.pause : Icons.play_arrow),
                    iconSize: 40,
                    onPressed: () async {
                      setState(() {
                        play = !play;
                      });
                      if (!play) {
                        advancedPlayer.pause();
                      } else {
                        audioCache.play(
                          'audios/Osad3eeny.mp3',
                        );
                        //int x = await advancedPlayer.play('https://y2mate.guru/api/storage/5ff735f5cbe5dde946df5f615a37fbff2c4eb820.mp3',isLocal: false);
                        //print("sdsfdghfgjghfgdfsdsasfdgf\n\n\n\n\n");
                        //print(x);
                        //print("\n\n\n\n\n");
                      }
                    }),
                IconButton(
                    icon: Icon(Icons.chevron_right),
                    iconSize: 40,
                    onPressed: () {
                      advancedPlayer.setReleaseMode(ReleaseMode.LOOP);
                    }),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
