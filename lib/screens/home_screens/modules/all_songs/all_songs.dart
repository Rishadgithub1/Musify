// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/controller/songController.dart';
import 'package:music_app/db/functions/favorite_db.dart';
import 'package:music_app/db/functions/recent_db.dart';
import 'package:music_app/screens/home_screens/Drawer/drawer_home.dart';
import 'package:music_app/screens/home_screens/miniplayer/miniplayer.dart';
import 'package:music_app/screens/home_screens/modules/all_songs/playlistFromAllSong.dart';
import 'package:music_app/screens/home_screens/modules/favorite/favBut_allsongs.dart';
import 'package:music_app/screens/home_screens/modules/all_songs/row_allsongs.dart';
import 'package:music_app/screens/home_screens/nowplaying/now_playing.dart';
import 'package:music_app/screens/home_screens/search_screen/search_bar.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';

List<SongModel> startSong = [];

class AllSogs extends StatefulWidget {
  const AllSogs({super.key});

  @override
  State<AllSogs> createState() => _AllSogsState();
}

class _AllSogsState extends State<AllSogs> {
//  static List<SongModel> startSong = [];
  @override
  void initState() {
    requestpermission();
    super.initState();
  }

  void requestpermission() async {
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }
      setState(() {});
    }
    Permission.storage.request;
  }

  playSong(String? uri) {
    try {
      _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      _audioPlayer.play();
    } on Exception {
      log("error parsing song");
    }
  }

  final _audioQuery = OnAudioQuery();
  final _audioPlayer = AudioPlayer();

  List<SongModel> allsongs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const HomeDrawer(),
      resizeToAvoidBottomInset: false,
      body: Container(
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
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 10),
                color: Colors.transparent,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(Icons.menu_rounded),
                          color: Colors.white.withOpacity(0.9),
                          onPressed: () => Scaffold.of(context).openEndDrawer(),
                        ),
                      ),
                    ),
                    searchBar(context),
                  ],
                ),
              ),
              rowItemAllsongs(context),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: FutureBuilder<List<SongModel>>(
                    future: _audioQuery.querySongs(
                        sortType: null,
                        orderType: OrderType.ASC_OR_SMALLER,
                        uriType: UriType.EXTERNAL,
                        ignoreCase: true),
                    builder: (context, item) {
                      if (item.data == null) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (item.data!.isEmpty) {
                        const Center(
                          child: Text('no songs found'),
                        );
                      }
                      startSong = item.data!;
                      GetSongs.songscopy = item.data!;
                      if (!FavoriteDb.isInitialized) {
                        FavoriteDb.intialize(item.data!);
                      }
                      return ListView.builder(
                        itemCount: item.data!.length,
                        itemBuilder: (context, index) {
                          allsongs.addAll(item.data!);
                          return Card(
                            color: const Color.fromARGB(255, 34, 2, 75),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: ListTile(
                              contentPadding: const EdgeInsets.only(
                                left: 15,
                              ),
                              onTap: () {
                                GetRecentSong.addRecentlyPlayed(
                                    item.data![index].id);
                                GetSongs.player.setAudioSource(
                                    GetSongs.createSongList(
                                      item.data!,
                                    ),
                                    initialIndex: index);
                                GetSongs.player.play();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NowPlayingScreen(
                                      songModelList: item.data!,
                                      // audioPlayer: _audioPlayer,
                                    ),
                                  ),
                                );
                              },
                              title: Text(
                                style: GoogleFonts.alegreya(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                                item.data![index].title,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              subtitle: Text(
                                style: GoogleFonts.alegreya(
                                    fontWeight: FontWeight.w600, fontSize: 12),
                                "${item.data![index].artist}",
                                overflow: TextOverflow.visible,
                                maxLines: 1,
                              ),
                              leading: QueryArtworkWidget(
                                  artworkBorder: BorderRadius.circular(10),
                                  artworkHeight:
                                      MediaQuery.of(context).size.height * 0.14,
                                  artworkWidth:
                                      MediaQuery.of(context).size.width * 0.14,
                                  id: item.data![index].id,
                                  type: ArtworkType.AUDIO,
                                  // ignore: sized_box_for_whitespace
                                  nullArtworkWidget: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.14,
                                    child: Image.asset(
                                        'assets/images/no song.png'),
                                  )),
                              trailing: IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx1) =>
                                          showDialogOption(index, context),
                                    );
                                  },
                                  icon: const Icon(Icons.more_vert)),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: ValueListenableBuilder(
          valueListenable: FavoriteDb.favoriteSongs,
          builder:
              (BuildContext context, List<SongModel> music, Widget? child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GetSongs.player.currentIndex != null
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: const MiniPlayerScreen(),
                      )
                    : const SizedBox()
              ],
            );
          }),
    );
  }

  SimpleDialog showDialogOption(int findex, BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: const Color.fromARGB(223, 43, 9, 53),
      children: [
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PlayListScreenAllSongs(findex: findex)));
          },
          child: Center(
            child: Text(
              'Add To Playlist',
              style: GoogleFonts.ubuntuCondensed(
                textStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                fontSize: 16,
              ),
            ),
          ),
        ),
        const Divider(),
        SimpleDialogOption(
          child: FavTextButton(songFavorite: startSong[findex]),
        ),
        const Divider(),
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Center(
            child: Text(
              'Cancel',
              style: GoogleFonts.ubuntuCondensed(
                textStyle: const TextStyle(
                    color: Color.fromARGB(255, 228, 46, 46), fontWeight: FontWeight.bold),
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
