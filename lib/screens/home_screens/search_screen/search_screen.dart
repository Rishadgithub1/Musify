import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/controller/songController.dart';
import 'package:music_app/screens/home_screens/nowplaying/now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
  });

  @override
  State<SearchScreen> createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {
  late List<SongModel> allSongs;
  List<SongModel> foundSongs = [];
  final OnAudioQuery audioQueryObject = OnAudioQuery();
  final AudioPlayer searchPageAudioPlayer = AudioPlayer();

  void fetchingAllSongsAndAssigningToFoundSongs() async {
    allSongs = await audioQueryObject.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: null,
    );
    foundSongs = allSongs;
  }

  void runFilter(String enteredKeyword) {
    List<SongModel> results = [];
    if (enteredKeyword.isEmpty) {
      results = allSongs;
    }
    if (enteredKeyword.isNotEmpty) {
      results = allSongs.where((element) {
        return element.displayNameWOExt
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase().trimRight());
      }).toList();
    }

    setState(() {
      foundSongs = results;
    });
  }

  @override
  void initState() {
    fetchingAllSongsAndAssigningToFoundSongs();
    super.initState();
  }

  void updateList(String value) {
    setState(() {});
  }

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
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.white)),
              toolbarHeight: 80,
              backgroundColor: Colors.transparent,
              actions: [
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 15, 50, 0),
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                      filled: true,
                      fillColor: Colors.white.withOpacity(.5),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none),
                      hintText: 'Artists,songs,or albums',
                      hintStyle: const TextStyle(
                          fontFamily: 'UbuntuCondensed', color: Colors.white),
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onChanged: ((value) {
                      runFilter(value);
                    }),
                  ),
                )
              ],
            ),
            body: foundSongs.isNotEmpty
                ? ListView.separated(
                    padding: const EdgeInsets.all(15),
                    itemBuilder: ((context, index) {
                      return ListTile(
                          tileColor: const Color.fromARGB(255, 34, 2, 75),
                          leading: QueryArtworkWidget(
                            id: foundSongs[index].id,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child:
                                    Image.asset('assets/images/no song.png')),
                          ),
                          title: Text(
                            foundSongs[index].title,
                            maxLines: 1,
                            style: const TextStyle(
                                fontFamily: 'UbuntuCondensed',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                overflow: TextOverflow.clip),
                          ),
                          subtitle: Text(
                            maxLines: 1,
                            foundSongs[index].artist.toString() == '<unknown>'
                                ? 'UNKNOWN ARTIST'
                                : foundSongs[index].artist.toString(),
                            style: const TextStyle(
                                fontFamily: 'UbuntuCondensed', fontSize: 12),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          onTap: () {
                            GetSongs.player.setAudioSource(
                                GetSongs.createSongList(foundSongs),
                                initialIndex: index);
                            GetSongs.player.play();
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: ((context) {
                              return NowPlayingScreen(
                                songModelList: foundSongs,
                              );
                            })));
                          });
                    }),
                    separatorBuilder: (context, index) => SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                    itemCount: foundSongs.length)
                : const Center(child: Text(' '))));
  }
}
