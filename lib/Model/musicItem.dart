class MusicItem {
  String singerName;
  String songName;
  String image;
  String musicPath;
  String type;
  String albumName;
  bool playing;
  bool running;

  MusicItem({
    this.singerName,
    this.songName,
    this.image,
    this.musicPath,
    this.type,
    this.albumName,
    this.playing,
    this.running = false,
  });
}
