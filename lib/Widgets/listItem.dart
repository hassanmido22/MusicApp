import 'package:MusicApp/Model/musicItem.dart';
import 'package:MusicApp/Provider/PlaylistProvider.dart';
import 'package:MusicApp/Screens/PlaySingleMusic.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaylistItem extends StatefulWidget {
  final MusicItem item;
  final int index;

  const PlaylistItem({Key key, this.item, this.index}) : super(key: key);

  @override
  _PlaylistItemState createState() => _PlaylistItemState();
}

class _PlaylistItemState extends State<PlaylistItem> {
  @override
  Widget build(BuildContext context) {
    PlaylistProvider playlistProvider =
        Provider.of<PlaylistProvider>(context, listen: false);
    return Consumer<PlaylistProvider>(
        builder: (context, itemProvider, widgett) {
      return ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: CachedNetworkImage(
            imageUrl: widget.item.image,
            imageBuilder: (context, imageProvider) => Container(
              width: 60,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
        onTap: () async {

          itemProvider.getPlaylist().asMap().forEach((i, element) {
            if (widget.index != i) {
              itemProvider.setPlaying(i, false);
            }
          });

          bool value =
              itemProvider.getPlaylist().elementAt(widget.index).playing;

          if (value) {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => SingleMusic(
                      index: widget.index,
                    )));
          } else {
            itemProvider.setPlaying(widget.index, !value);
            await itemProvider.audioCache.play(widget.item.musicPath);
          }
        },
        title: Text(widget.item.songName),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(widget.item.singerName),
            playlistProvider.getPlaylist().elementAt(widget.index).playing
                ? Text(
                    "Now Playing",
                    style: TextStyle(color: Colors.red),
                  )
                : SizedBox(
                    width: 0,
                  ),
          ],
        ),
        trailing: Consumer<PlaylistProvider>(
          builder: (context, musicProvider, widgett) {
            return IconButton(
                onPressed: () async {
                  itemProvider.setRunning(widget.index);
                  musicProvider.getPlaylist().asMap().forEach((i, element) {
                    if (widget.index != i) {
                      musicProvider.setPlaying(i, false);
                    }
                  });
                  bool value = musicProvider
                      .getPlaylist()
                      .elementAt(widget.index)
                      .playing;

                  musicProvider.setPlaying(widget.index, !value);
                  if (value) {
                    await musicProvider.advancedPlayer.stop();
                  } else {
                    await musicProvider.audioCache.play(widget.item.musicPath);
                  }
                },
                icon: Icon(
                  musicProvider.getPlaylist().elementAt(widget.index).playing
                      ? Icons.pause
                      : Icons.play_arrow,
                ));
          },
        ),
      );
    });
  }
}
