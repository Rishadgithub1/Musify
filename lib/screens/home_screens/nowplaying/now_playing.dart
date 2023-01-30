// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/controller/provider/nowplayings_provider.dart';
import 'package:music_app/controller/songController.dart';
import 'package:music_app/screens/home_screens/modules/all_songs/playlistFromAllSong.dart';
import 'package:music_app/screens/home_screens/modules/favorite/favbut_nowplaying.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class NowPlayingScreen extends StatelessWidget {
   NowPlayingScreen({
    super.key,
    required this.songModelList,
  });

  final List<SongModel> songModelList;
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    
    Provider.of<NowPlayingScreenProvider>(context, listen: false).initStateFunction();
    Provider.of<NowPlayingScreenProvider>(context, listen: false).playSongFun();
    final providerWL = Provider.of<NowPlayingScreenProvider>(context);
    final providerWOL = Provider.of<NowPlayingScreenProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: Provider.of<NowPlayingScreenProvider>(context).willPoPFun,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
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
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding:
                        const EdgeInsets.only(left: 15, bottom: 50, right: 15),
                    //  color: Colors.amber,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              const Color.fromARGB(255, 91, 174, 241),
                          child: IconButton(
                              padding: const EdgeInsets.only(left: 5),
                              onPressed: () {
                                providerWOL.backBtnTop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.black,
                                size: 20,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: SizedBox(
                    // color: Colors.amberAccent,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Consumer<NowPlayingScreenProvider>(
                            builder: (context, value, child) {
                          return QueryArtworkWidget(
                            artworkHeight:
                                MediaQuery.of(context).size.height * 0.28,
                            artworkWidth:
                                MediaQuery.of(context).size.width * 0.65,
                            artworkFit: BoxFit.cover,
                            artworkQuality: FilterQuality.high,
                            id: songModelList[value.currentIndex].id,
                            type: ArtworkType.AUDIO,
                            keepOldArtwork: true,
                            artworkBorder: BorderRadius.circular(200),
                            nullArtworkWidget: const Icon(
                              Icons.music_note,
                              size: 80,
                            ),
                          );
                        }),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.013,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 12),
                          child: Text(
                            maxLines: 1,
                            songModelList[providerWL.currentIndex].title,
                            overflow: TextOverflow.clip,
                            style: const TextStyle(
                                fontFamily: 'UbuntuCondensed',
                                fontWeight: FontWeight.w600,
                                fontSize: 21),
                          ),
                        ),
                        Text(
                          songModelList[providerWL.currentIndex].artist
                                      .toString() ==
                                  "<unknown>"
                              ? "Unknown artist"
                              : songModelList[providerWL.currentIndex].artist
                                  .toString(),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    padding:
                        const EdgeInsets.only(top: 35, left: 10, right: 10),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              onPressed: () {
                                GetSongs.player.shuffleModeEnabled == true
                                    ? GetSongs.player
                                        .setShuffleModeEnabled(false)
                                    : GetSongs.player
                                        .setShuffleModeEnabled(true);
                              },
                              icon: GetSongs.player.shuffleModeEnabled == true
                                  ? const Icon(Icons.shuffle_on_outlined)
                                  : const Icon(
                                      Icons.shuffle,
                                      color: Colors.grey,
                                    ),
                            ),
                            IconButton(
                              onPressed: () {
                                GetSongs.player.loopMode == LoopMode.off
                                    ? GetSongs.player.setLoopMode(LoopMode.one)
                                    : GetSongs.player.setLoopMode(LoopMode.off);
                              },
                              icon: GetSongs.player.loopMode == LoopMode.off
                                  ? const Icon(
                                      Icons.repeat,
                                      color: Colors.grey,
                                    )
                                  : const Icon(Icons.repeat_one),
                            ),
                            FavButMusicPlaying(
                                songFavoriteMusicPlaying:
                                    songModelList[providerWOL.currentIndex]),
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          PlayListScreenAllSongs(
                                              findex: currentIndex)));
                                },
                                icon: const Icon(Icons.queue_music,
                                    color: Colors.white))
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.013,
                        ),
                        Row(
                          children: [
                            Text(
                              providerWL.position.toString().substring(2, 7),
                              style: const TextStyle(color: Colors.white),
                            ),
                            Expanded(
                                child: Consumer<NowPlayingScreenProvider>(
                              builder: (context, value, child) => Slider(
                                  activeColor: Colors.cyan,
                                  inactiveColor: Colors.white,
                                  thumbColor:
                                      const Color.fromARGB(255, 10, 139, 245),
                                  min: const Duration(microseconds: 0)
                                      .inSeconds
                                      .toDouble(),
                                  value: value.position.inSeconds.toDouble(),
                                  max: value.duration.inSeconds.toDouble(),
                                  onChanged: (seconds) {
                                    value.sliderFunction(seconds);
                                  }),
                            )),
                            Text(
                              providerWL.duration.toString().substring(2, 7),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.013),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor:
                                  const Color.fromARGB(255, 91, 174, 241),
                              child: IconButton(
                                  onPressed: () async{
                                   providerWOL.previousBtn();
                                  },
                                  icon: const Icon(
                                    Icons.skip_previous,
                                    color: Colors.black,
                                  ),
                                  iconSize: 30),
                            ),
                            CircleAvatar(
                              radius: 35,
                              backgroundColor:
                                  const Color.fromARGB(255, 91, 174, 241),
                              child: IconButton(
                                 onPressed: () async{
                                  providerWL.playBtnPressed();
                                 },
                                  icon: Icon(
                                    GetSongs.player.playing
                                        ? Icons.pause_outlined
                                        : Icons.play_arrow,
                                    color: Colors.black,
                                  ),
                                  iconSize: 40),
                            ),
                            CircleAvatar(
                              radius: 25,
                              backgroundColor:
                                  const Color.fromARGB(255, 91, 174, 241),
                              child: IconButton(
                                  onPressed: () async{
                                  providerWOL.nextBtn();
                                  },
                                  icon: const Icon(
                                    Icons.skip_next,
                                    color: Colors.black,
                                  ),
                                  iconSize: 30),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
