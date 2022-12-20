import 'package:flutter/material.dart';
import 'package:music_app/controller/songController.dart';
import 'package:music_app/db/functions/favorite_db.dart';
import 'package:music_app/screens/home_screens/nowplaying/now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: FavoriteDb.favoriteSongs,
      builder: (BuildContext ctx, List<SongModel> favoriteData, Widget? child) {
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
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
              title: const Text(
                'Favorite',
                style: TextStyle(
                    fontFamily: 'UbuntuCondensed',
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              // elevation: 0,
            ),
            body: ValueListenableBuilder(
              valueListenable: FavoriteDb.favoriteSongs,
              builder: (BuildContext ctx, List<SongModel> favoriteData,
                  Widget? child) {
                if (favoriteData.isEmpty) {
                  return const Center(
                    child: Text('No Favorite Songs',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'UbuntuCondensed',
                            fontSize: 16)
                        //  GoogleFonts.ubuntuCondensed(
                        //     textStyle: const TextStyle(
                        //         // color: Colors.red,
                        //         fontWeight: FontWeight.bold,
                        //         fontSize: 16))
                        ),
                  );
                } else {
                  return ListView.separated(
                      padding: const EdgeInsets.all(15),
                      itemBuilder: ((ctx, index) {
                        return ListTile(
                          tileColor: const Color.fromARGB(255, 45, 7, 72),
                          leading: QueryArtworkWidget(
                              id: favoriteData[index].id,
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.14,
                                child: Image.asset('assets/images/no song.png'),
                              )),
                          title: Text(favoriteData[index].title,
                              maxLines: 1,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.clip)),
                          subtitle: Text(
                            style: const TextStyle(
                                color: Colors.grey,
                                fontFamily: 'UbuntuCondensed',
                                overflow: TextOverflow.clip)
                         
                            ,
                            maxLines: 1,
                            favoriteData[index].artist.toString() == '<unknown>'
                                ? 'UNKNOWN ARTIST'
                                : favoriteData[index]
                                    .artist
                                    .toString()
                                    .toUpperCase(),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          onTap: () {
                            List<SongModel> favoriteList = [...favoriteData];
                            GetSongs.player.setAudioSource(
                                GetSongs.createSongList(favoriteList),
                                initialIndex: index);
                            GetSongs.player.play();
                            Navigator.push(context,
                                MaterialPageRoute(builder: ((context) {
                              return NowPlayingScreen(
                                songModelList: favoriteList,
                              );
                            })));
                          },
                          trailing: IconButton(
                              onPressed: (() {
                                FavoriteDb.favoriteSongs.notifyListeners();
                                FavoriteDb.delete(favoriteData[index].id);
                                const snackbar = SnackBar(
                                  backgroundColor: Colors.black,
                                  content: Text(
                                    'Song deleted from your favorites',
                                  ),
                                  duration: Duration(
                                    seconds: 1,
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackbar);
                              }),
                              icon: const Icon(
                                Icons.delete_rounded,
                              )),
                        );
                      }),
                      separatorBuilder: (context, index) => SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                      itemCount: favoriteData.length);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
