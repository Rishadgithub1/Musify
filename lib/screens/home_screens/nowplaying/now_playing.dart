import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
// ignore: depend_on_referenced_packages
import 'package:google_fonts/google_fonts.dart';
import 'package:music_app/controller/songController.dart';
import 'package:music_app/db/functions/favorite_db.dart';
import 'package:music_app/screens/home_screens/modules/all_songs/playlistFromAllSong.dart';
import 'package:music_app/screens/home_screens/modules/favorite/favbut_nowplaying.dart';
import 'package:on_audio_query/on_audio_query.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({
    super.key,
    required this.songModelList,
  });

  final List<SongModel> songModelList;
  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  Duration _duration = const Duration();
  Duration _position = const Duration();

  int currentIndex = 0;

  @override
  void initState() {
    GetSongs.player.currentIndexStream.listen((index) {
      if (index != null && mounted) {
        setState(() {
          currentIndex = index;
        });
        GetSongs.currentIndes = index;
      }
    });
    super.initState();
    playSong();
  }

  void playSong() {
    GetSongs.player.durationStream.listen((d) {
      setState(() {
        _duration = d!;
      });
    });
    GetSongs.player.positionStream.listen((p) {
      setState(() {
        _position = p;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FavoriteDb.favoriteSongs.notifyListeners();
        return true;
      },
      child: Container(
        // width: double.infinity,
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
                                Navigator.of(context).pop();
                                FavoriteDb.favoriteSongs.notifyListeners();
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
                        QueryArtworkWidget(
                          artworkHeight: MediaQuery.of(context).size.height * 0.28,
                          artworkWidth:MediaQuery.of(context).size.width * 0.65,
                          artworkFit: BoxFit.cover,
                          artworkQuality: FilterQuality.high,
                          id: widget.songModelList[currentIndex].id,
                          type: ArtworkType.AUDIO,
                          keepOldArtwork: true,
                          artworkBorder: BorderRadius.circular(200),
                          nullArtworkWidget: const Icon(
                            Icons.music_note,
                            size: 80,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.013,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 12),
                          child: Text(
                            maxLines: 1,
                            widget.songModelList[currentIndex].title,
                            overflow: TextOverflow.clip,
                            style: GoogleFonts.ubuntuCondensed(
                                textStyle: const TextStyle(color: Colors.white),
                                fontWeight: FontWeight.w600,
                                fontSize: 21),
                          ),
                        ),
                        Text(
                          widget.songModelList[currentIndex].artist
                                      .toString() ==
                                  "<unknown>"
                              ? "Unknown artist"
                              : widget.songModelList[currentIndex].artist
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
                                    widget.songModelList[currentIndex]),
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
                              _position.toString().substring(2, 7),
                              style: const TextStyle(color: Colors.white),
                            ),
                            Expanded(
                                child: Slider(
                                    activeColor: Colors.cyan,
                                    inactiveColor: Colors.white,
                                    thumbColor:
                                        const Color.fromARGB(255, 10, 139, 245),
                                    min: const Duration(microseconds: 0)
                                        .inSeconds
                                        .toDouble(),
                                    value: _position.inSeconds.toDouble(),
                                    max: _duration.inSeconds.toDouble(),
                                    onChanged: (value) {
                                      setState(() {
                                        sliderFunction(value.toInt());
                                        value = value;
                                      });
                                    })),
                            Text(
                              _duration.toString().substring(2, 7),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.013,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor:
                                  const Color.fromARGB(255, 91, 174, 241),
                              child: IconButton(
                                  onPressed: () {
                                    if (GetSongs.player.hasPrevious) {
                                      GetSongs.player.seekToPrevious();
                                    }
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
                                  onPressed: () async {
                                    if (GetSongs.player.playing) {
                                      await GetSongs.player.pause();
                                      setState(() {});
                                    } else {
                                      await GetSongs.player.play();
                                      setState(() {});
                                    }
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
                                  onPressed: () {
                                    if (GetSongs.player.hasNext) {
                                      GetSongs.player.seekToNext();
                                    }
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

  void sliderFunction(int seconds) {
    Duration duration = Duration(seconds: seconds);
    GetSongs.player.seek(duration);
  }
}
