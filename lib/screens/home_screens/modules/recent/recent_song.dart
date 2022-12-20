import 'package:flutter/material.dart';
import 'package:music_app/db/functions/recent_db.dart';
import 'package:music_app/controller/songController.dart';
import 'package:music_app/db/functions/favorite_db.dart';
import 'package:music_app/screens/home_screens/nowplaying/now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';

class RecentlyPlayedScreen extends StatefulWidget {
  const RecentlyPlayedScreen({super.key});

  @override
  State<RecentlyPlayedScreen> createState() => _RecentlyPlayedScreenState();
}

class _RecentlyPlayedScreenState extends State<RecentlyPlayedScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  static List<SongModel> recentSong = [];
  @override
  void initState() {
    super.initState();
    getAllRecent();
    setState(() {});
  }

  Future getAllRecent() async {
    await GetRecentSong.getRecentSongs();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    FavoriteDb.favoriteSongs;
    return Container(
      height: double.infinity,
      width: double.infinity,
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
          centerTitle: true,
          title: const Text('Recent Songs',
              style: TextStyle(
                  fontFamily: 'UbuntuCondensed',
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 248, 245, 245))),
          backgroundColor: Colors.transparent,
          // elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder(
                  future: GetRecentSong.getRecentSongs(),
                  builder: (BuildContext context, items) {
                    return ValueListenableBuilder(
                      valueListenable: GetRecentSong.recentSongNotifier,
                      builder: (BuildContext context, List<SongModel> value,
                          Widget? child) {
                        if (value.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 100),
                            child: Center(
                              child: Text(
                                'No Song In Recents',
                                style: TextStyle(
                                    fontFamily: 'UbuntuCondensed',
                                    fontSize: 25,
                                    color: Colors.white),
                              ),
                            ),
                          );
                        } else {
                          final temp = value.reversed.toList();
                          recentSong = temp.toSet().toList();
                          return FutureBuilder<List<SongModel>>(
                            future: _audioQuery.querySongs(
                              sortType: null,
                              orderType: OrderType.ASC_OR_SMALLER,
                              uriType: UriType.EXTERNAL,
                              ignoreCase: true,
                            ),
                            builder: (context, item) {
                              if (item.data == null) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (item.data!.isEmpty) {
                                return const Center(
                                    child: Text(
                                  'No Songs Available',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ));
                              }
                              return ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    minVerticalPadding: 10.0,
                                    contentPadding: const EdgeInsets.all(0),
                                    leading: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: QueryArtworkWidget(
                                        id: recentSong[index].id,
                                        type: ArtworkType.AUDIO,
                                        nullArtworkWidget: const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(5, 5, 5, 5),
                                          child: Icon(
                                            Icons.music_note,
                                            color: Colors.white,
                                            size: 33,
                                          ),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                        recentSong[index].displayNameWOExt,
                                        maxLines: 1,
                                        style: const TextStyle(
                                            fontFamily: 'UbuntuCondensed',
                                            color: Colors.white,
                                            fontSize: 18)),
                                    subtitle: Text(
                                      '${recentSong[index].artist == "<unknown>" ? "Unknown Artist" : recentSong[index].artist}',
                                      maxLines: 1,
                                      style: const TextStyle(
                                          fontFamily: 'UbuntuCondensed',
                                          color: Colors.white,
                                          fontSize: 11),
                                    ),
                                    onTap: () {
                                      GetSongs.player.setAudioSource(
                                          GetSongs.createSongList(recentSong),
                                          initialIndex: index);
                                      GetSongs.player.play();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NowPlayingScreen(
                                                      songModelList: GetSongs
                                                          .playingSongs)));
                                    },
                                  );
                                },
                                itemCount: recentSong.length,
                                separatorBuilder: (context, index) {
                                  return const Divider(
                                    height: 10.0,
                                  );
                                },
                              );
                            },
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
