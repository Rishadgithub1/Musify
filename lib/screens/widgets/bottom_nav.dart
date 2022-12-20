import 'package:flutter/material.dart';
import 'package:music_app/controller/songController.dart';
import 'package:music_app/db/functions/favorite_db.dart';
import 'package:music_app/screens/home_screens/modules/all_songs/all_songs.dart';
import 'package:music_app/screens/home_screens/modules/favorite/favorite_screen.dart';
import 'package:music_app/screens/home_screens/modules/playlist/playlist_list.dart';
import 'package:music_app/screens/home_screens/modules/recent/recent_song.dart';
import 'package:music_app/screens/widgets/miniplayer.dart';
import 'package:on_audio_query/on_audio_query.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentIndex = 0;

  List pages = [
    const AllSogs(),
    const RecentlyPlayedScreen(),
    const FavoriteScreen(),
    const PlayListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
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
        body: pages[currentIndex],
        bottomNavigationBar: ValueListenableBuilder(
          valueListenable: FavoriteDb.favoriteSongs,
          builder:
              (BuildContext context, List<SongModel> music, Widget? child) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  if (GetSongs.player.currentIndex != null)
                    Column(
                      children: const [
                        MiniPlayerScreen(),
                        SizedBox(height: 10),
                      ],
                    )
                  else
                    const SizedBox(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 10),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        child: BottomNavigationBar(
                          items: const [
                            BottomNavigationBarItem(
                              icon: Icon(Icons.headset_mic, size: 25),
                              label: 'All Songs',
                            ),
                            BottomNavigationBarItem(
                                icon: Icon(Icons.history, size: 25),
                                label: 'Recent'),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.favorite_rounded, size: 25),
                              label: 'Favorite',
                            ),
                            BottomNavigationBarItem(
                                icon: Icon(Icons.queue_music, size: 25),
                                label: 'Playlist'),
                          ],
                          backgroundColor:
                              const Color.fromARGB(255, 50, 6, 107),
                          selectedItemColor: Colors.white,
                          unselectedItemColor: Colors.white54,
                          showUnselectedLabels: false,
                          type: BottomNavigationBarType.fixed,
                          currentIndex: currentIndex,
                          onTap: (index) {
                            setState(() {
                              currentIndex = index;
                              FavoriteDb.favoriteSongs.notifyListeners();
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
