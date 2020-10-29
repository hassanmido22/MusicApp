import 'package:MusicApp/Model/musicItem.dart';
import 'package:MusicApp/Provider/PlaylistProvider.dart';
import 'package:MusicApp/Widgets/listItem.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MusicPlaylist extends StatefulWidget {
  @override
  _MusicPlaylistState createState() => _MusicPlaylistState();
}

class _MusicPlaylistState extends State<MusicPlaylist> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PlaylistProvider>(context, listen: false).initPlayer();
    });
  }

  @override
  Widget build(BuildContext context) {
    PlaylistProvider playlistProvider = Provider.of<PlaylistProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Music Playlist"),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: ListView.builder(
                itemCount: playlistProvider.getPlaylist().length,
                itemBuilder: (context, i) {
                  return PlaylistItem(
                    item: playlistProvider.getPlaylist().elementAt(i),
                    index: i,
                  );
                }),
          ),
          playlistProvider.getRunningSong().length > 0
              ? new Positioned(
                  bottom: 10,
                  child: new Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    height: 60,
                    width: (MediaQuery.of(context).size.width) - 20,
                    decoration: new BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10,
                              spreadRadius: 5,
                              offset: Offset(3, 6),
                              color: Color(0xffEEEEEE))
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(playlistProvider
                            .getRunningSong()
                            .elementAt(0)
                            .songName)
                      ],
                    ),
                  ))
              : SizedBox(
                  height: 0,
                )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 75,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.all(10),
                    
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.list,
                          size: 35.0,
                        ),
                        Text(
                          "My Playlist",
                          style: TextStyle(fontSize: 10),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.list,
                          size: 35.0,
                        ),
                        Text(
                          "My Playlist",
                          style: TextStyle(fontSize: 10),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.list,
                          size: 35.0,
                        ),
                        Text(
                          "My Playlist",
                          style: TextStyle(fontSize: 10),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.list,
                          size: 35.0,
                        ),
                        Text(
                          "My Playlist",
                          style: TextStyle(fontSize: 10),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
