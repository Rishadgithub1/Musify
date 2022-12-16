import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_app/controller/songController.dart';
import 'package:music_app/db/functions/playlist_db.dart';
import 'package:music_app/db/model/music_model.dart';
import 'package:music_app/screens/home_screens/modules/playlist/allsongslist_playlist.dart';
import 'package:music_app/screens/home_screens/nowplaying/now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';
// ignore: depend_on_referenced_packages
import 'package:google_fonts/google_fonts.dart';

class PlaylistData extends StatefulWidget {
  const PlaylistData(
      {Key? key, required this.playlist, required this.folderindex})
      : super(key: key);
  final MusicModel playlist;
  final int folderindex;
  @override
  State<PlaylistData> createState() => _PlaylistDataState();
}

class _PlaylistDataState extends State<PlaylistData> {
  late List<SongModel> playlistsong;
  @override
  Widget build(BuildContext context) {
    PlayListDB().getAllPlaylist();
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 50, 6, 107),
            Color.fromARGB(255, 15, 2, 44),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
          automaticallyImplyLeading: false,
          title: Text(
            widget.playlist.name,
            style: GoogleFonts.ubuntuCondensed(
                textStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            )),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ValueListenableBuilder(
                valueListenable:
                    Hive.box<MusicModel>('playlistDB').listenable(),
                builder: (BuildContext context, Box<MusicModel> value,
                    Widget? child) {
                  playlistsong = listPlaylist(
                      value.values.toList()[widget.folderindex].songId);
                  return playlistsong.isEmpty
                      ? const Center(
                          child: Text(
                            ' ',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 20),
                          ),
                        )
                      : ListView.separated(
                          reverse: true,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (ctx, index) {
                            return ListTile(
                              onTap: () {
                                List<SongModel> newlist = [...playlistsong];
                                GetSongs.player.stop();
                                GetSongs.player.setAudioSource(
                                    GetSongs.createSongList(
                                      newlist,
                                    ),
                                    initialIndex: index);
                                GetSongs.player.play();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => NowPlayingScreen(
                                      songModelList: playlistsong,
                                    ),
                                  ),
                                );
                              },
                              leading: QueryArtworkWidget(
                                artworkHeight:MediaQuery.of(context).size.height * 0.14,
                                artworkWidth: MediaQuery.of(context).size.width * 0.14,
                                id: playlistsong[index].id,
                                type: ArtworkType.AUDIO,
                                artworkBorder: BorderRadius.circular(10),
                                    nullArtworkWidget: SizedBox(
                                    width: MediaQuery.of(context).size.width*0.14,
                                    child: Image.asset(
                                        'assets/images/no song.png'),
                                  ),
                                errorBuilder: (
                                  context,
                                  excepion,
                                  gdb,
                                ) {
                                  setState(() {});
                                  return Image.asset('');
                                },
                              ),
                              title: Text(
                                playlistsong[index].title,
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                style: GoogleFonts.ubuntuCondensed(textStyle:const TextStyle(
                                  fontSize: 18
                                ),)
                              ),
                              subtitle: Text(
                                playlistsong[index].artist!,
                                style: GoogleFonts.ubuntuCondensed(),
                                maxLines: 1,
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  widget.playlist.deleteData(
                                    playlistsong[index].id,
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (ctx, index) {
                            return const Divider();
                          },
                          itemCount: playlistsong.length,
                        );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => SongListPage(
                  playlist: widget.playlist,
                ),
              ),
            );
          },
          label: const Text(
            'Add song',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          icon: const Icon(
            Icons.add,
          ),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  List<SongModel> listPlaylist(List<int> data) {
    List<SongModel> plsongs = [];
    for (int i = 0; i < GetSongs.songscopy.length; i++) {
      for (int j = 0; j < data.length; j++) {
        if (GetSongs.songscopy[i].id == data[j]) {
          plsongs.add(GetSongs.songscopy[i]);
        }
      }
    }
    return plsongs;
  }
}


