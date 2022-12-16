import 'package:flutter/material.dart';
import 'package:music_app/db/functions/playlist_db.dart';
import 'package:music_app/db/model/music_model.dart';
// ignore: depend_on_referenced_packages
import 'package:google_fonts/google_fonts.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongListPage extends StatefulWidget {
  const SongListPage({Key? key, required this.playlist}) : super(key: key);
  final MusicModel playlist;

  @override
  State<SongListPage> createState() => _SongListPageState();
}

class _SongListPageState extends State<SongListPage> {
  final OnAudioQuery audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
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
            title: Text('Add Songs', style: GoogleFonts.ubuntuCondensed()),
            centerTitle: true,
          ),
          body: SafeArea(
            child: FutureBuilder<List<SongModel>>(
                future: audioQuery.querySongs(
                    sortType: null,
                    orderType: OrderType.ASC_OR_SMALLER,
                    uriType: UriType.EXTERNAL,
                    ignoreCase: true),
                builder: (context, item) {
                  if (item.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  } 
                  if (item.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No Songs Found',
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (ctx, index) {
                        return ListTile(
                          tileColor: const Color.fromARGB(255, 34, 2, 75),
                          onTap: () {},
                          iconColor: Colors.white,
                          textColor: Colors.white,
                          leading: QueryArtworkWidget(
                            artworkHeight:
                                MediaQuery.of(context).size.height * 0.14,
                            artworkWidth:
                                MediaQuery.of(context).size.width * 0.14,
                            id: item.data![index].id,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.14,
                              child: Image.asset('assets/images/no song.png'),
                            ),
                            artworkFit: BoxFit.fill,
                            artworkBorder: BorderRadius.circular(10),
                          ),
                          title: Text(
                            style: GoogleFonts.alegreya(
                                fontWeight: FontWeight.w600, fontSize: 17),
                            item.data![index].title,
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                          ),
                          subtitle: Text(
                            style: GoogleFonts.alegreya(
                                fontWeight: FontWeight.w600, fontSize: 12),
                            "${item.data![index].artist}",
                            overflow: TextOverflow.visible,
                            maxLines: 1,
                          ),
                          trailing:
                              !widget.playlist.inValueIn(item.data![index].id)
                                  ? IconButton(
                                      onPressed: (() {
                                        setState(() {
                                          playlistCheck(item.data![index]);
                                          PlayListDB()
                                              .playlistnotifier
                                              .notifyListeners();
                                        });
                                      }),
                                      icon: const Icon(Icons.add),
                                    )
                                  : IconButton(
                                      onPressed: (() {
                                        setState(() {
                                          widget.playlist
                                              .deleteData(item.data![index].id);
                                        });
                                      }),
                                      icon: const Icon(Icons.remove),
                                    ),
                        );
                      },
                      itemCount: item.data!.length);
                }),
          )),
    );
  }

  void playlistCheck(SongModel data) {
    if (!widget.playlist.inValueIn(data.id)) {
      widget.playlist.add(data.id);
      const snackbar = SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          content: Text(
            'song Added to Playlist',
            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }
}