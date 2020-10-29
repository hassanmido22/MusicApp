import 'package:MusicApp/Model/musicItem.dart';
import 'package:MusicApp/Provider/PlaylistProvider.dart';
import 'package:MusicApp/Widgets/listItem.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SingleMusic extends StatefulWidget {
  final int index;
  const SingleMusic({Key key, this.index}) : super(key: key);

  @override
  _SingleMusicState createState() => _SingleMusicState();
}

class _SingleMusicState extends State<SingleMusic> {
  Slider musicSlider;
  double x = 0;
  double max;
  int index;
  Duration _duration = new Duration();
  Duration _position = new Duration();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlayer();
    setState(() {
      index = widget.index;
    });
  }

  void initPlayer() {
    PlaylistProvider playlistProvider =
        Provider.of<PlaylistProvider>(context, listen: false);

    playlistProvider.advancedPlayer.durationHandler = (d) => setState(() {
          _duration = d;
          print(_duration.toString());
        });

    playlistProvider.advancedPlayer.positionHandler = (p) => setState(() {
          _position = p;
        });

    playlistProvider.advancedPlayer.audioPlayerStateChangeHandler =
        (s) => setState(() {
              if (s == AudioPlayerState.COMPLETED) {
                index++;
              }
            });
  }

  seekToSecond(int second) async {
    PlaylistProvider playlistProvider =
        Provider.of<PlaylistProvider>(context, listen: false);
    Duration newDuration = Duration(seconds: second);

    playlistProvider.advancedPlayer.seek(newDuration);
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
    PlaylistProvider playlistProvider =
        Provider.of<PlaylistProvider>(context, listen: false);

    MediaQueryData m = MediaQuery.of(context);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
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
                onPressed: () {
                  Navigator.of(context).pop();
                },
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
                      playlistProvider.getPlaylist().elementAt(index).image,
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
              "${playlistProvider.getPlaylist().elementAt(index).songName} , ${playlistProvider.getPlaylist().elementAt(index).singerName}",
              style: TextStyle(
                  color: Color(0xff333333),
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              " ${playlistProvider.getPlaylist().elementAt(index).albumName} , ${playlistProvider.getPlaylist().elementAt(index).type}",
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
                  Consumer<PlaylistProvider>(
                    builder: (context, musicProvider, widgett) {
                      return IconButton(
                          icon: Icon(
                            Icons.chevron_left,
                            color: Color(index == 0 ? 0xffc1c1c1 : 0xff363636),
                          ),
                          iconSize: 40,
                          onPressed: index == 0
                              ? null
                              : () async {
                                  setState(() {
                                    index = index - 1;
                                  });
                                  musicProvider
                                      .getPlaylist()
                                      .asMap()
                                      .forEach((i, element) {
                                    if (index != i) {
                                      musicProvider.setPlaying(i, false);
                                    }
                                  });
                                  bool value = musicProvider
                                      .getPlaylist()
                                      .elementAt(index)
                                      .playing;

                                  musicProvider.setPlaying(index, !value);

                                  await musicProvider.audioCache.play(
                                      playlistProvider
                                          .getPlaylist()
                                          .elementAt(index)
                                          .musicPath);
                                });
                    },
                  ),
                  Consumer<PlaylistProvider>(
                    builder: (context, musicProvider, widgett) {
                      return Container(
                        child: IconButton(
                            icon: Icon(
                              musicProvider
                                      .getPlaylist()
                                      .elementAt(index)
                                      .playing
                                  ? Icons.pause
                                  : Icons.play_arrow,
                            ),
                            iconSize: 40,
                            onPressed: () async {
                              bool value = musicProvider
                                  .getPlaylist()
                                  .elementAt(index)
                                  .playing;
                              musicProvider.setPlaying(index, !value);

                              if (!musicProvider
                                  .getPlaylist()
                                  .elementAt(index)
                                  .playing) {
                                musicProvider.advancedPlayer.pause();
                              } else {
                                musicProvider.advancedPlayer.resume();
                                /*audioCache. play(
                                  'audios/Osad3eeny.mp3',
                                );*/
                                //print(audioCache.loadedFiles);
                                //int x = await advancedPlayer.play('https://y2mate.guru/api/storage/5ff735f5cbe5dde946df5f615a37fbff2c4eb820.mp3',isLocal: false);
                                //print("sdsfdghfgjghfgdfsdsasfdgf\n\n\n\n\n");
                                //print(x);
                                //print("\n\n\n\n\n");
                              }
                            }),
                      );
                    },
                  ),
                  Consumer<PlaylistProvider>(
                    builder: (context, musicProvider, widgett) {
                      return IconButton(
                          icon: Icon(Icons.chevron_right),
                          iconSize: 40,
                          onPressed: () async {
                            setState(() {
                              index = (index + 1) %
                                  musicProvider.getPlaylist().length;
                            });
                            musicProvider
                                .getPlaylist()
                                .asMap()
                                .forEach((i, element) {
                              if (index != i) {
                                musicProvider.setPlaying(i, false);
                              }
                            });
                            bool value = musicProvider
                                .getPlaylist()
                                .elementAt(index)
                                .playing;

                            musicProvider.setPlaying(index, !value);

                            await musicProvider.audioCache.play(playlistProvider
                                .getPlaylist()
                                .elementAt(index)
                                .musicPath);
                          });
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
