import 'package:MusicApp/Model/musicItem.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class PlaylistProvider with ChangeNotifier {
  int runningIndex;

  List<MusicItem> musicList = [
    MusicItem(
        singerName: "AmrDaib",
        songName: "Tensa Wa7da",
        albumName: "lely nhary",
        type: "Pop",
        image:
            "https://images.pexels.com/photos/1910236/pexels-photo-1910236.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260",
        musicPath: 'audios/TensaWa7da.mp3',
        playing: false),
    MusicItem(
        singerName: "AmrDaib",
        songName: "We Malo",
        albumName: "kamel kalamak",
        type: "Pop",
        image:
            "https://images.pexels.com/photos/1910236/pexels-photo-1910236.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260",
        musicPath: 'audios/WeMalo.mp3',
        playing: false),
    MusicItem(
        singerName: "AmrDaib",
        songName: "Wa7ashteeny",
        albumName: "lely nhary",
        type: "Pop",
        image:
            "https://images.pexels.com/photos/1910236/pexels-photo-1910236.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260",
        musicPath: 'audios/Wa7ashteeny.mp3',
        playing: false),
    MusicItem(
        singerName: "AmrDaib",
        songName: "Osad 3eeny",
        albumName: "lely nhary",
        type: "Pop",
        image:
            "https://images.pexels.com/photos/1910236/pexels-photo-1910236.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260",
        musicPath: 'audios/Osad3eeny.mp3',
        playing: false),
  ];

  AudioPlayer advancedPlayer;
  AudioCache audioCache;

  void initPlayer() {
    advancedPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: advancedPlayer);
    notifyListeners();
    print('object');

    /*advancedPlayer.durationHandler = (d) => setState(() {
          _duration = d;
        });

    advancedPlayer.positionHandler = (p) => setState(() {
          _position = p;
        });*/
  }

  setPlaying(index, value) {
    musicList[index].playing = value;
    notifyListeners();
  }

  setRunning(index) {
    runningIndex = index;
    musicList.asMap().forEach((i, element) {
      if (i != index) {
        musicList[i].running = false;
      }
    });
    musicList[runningIndex].running = true;
    print(runningIndex);
    notifyListeners();
  }

  Iterable<MusicItem> getCurrent() {
    return musicList.where((element) => element.playing == true);
  }

  List<MusicItem> getPlaylist() {
    return musicList;
  }

  Iterable<MusicItem> getRunningSong() {
    return musicList.where((element) => element.running == true);
  }
}
