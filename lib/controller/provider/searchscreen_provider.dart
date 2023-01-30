import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/controller/songController.dart';
import 'package:music_app/screens/home_screens/nowplaying/now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SearchScreenProvider with ChangeNotifier {
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
    notifyListeners();
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
    foundSongs = results;
    notifyListeners();
  }

  Widget? showListView() {
    if (foundSongs.isNotEmpty) {
      return ListView.separated(
          padding: const EdgeInsets.all(15),
          itemBuilder: ((context, index) {
            return ListTile(
              tileColor: const Color.fromARGB(255, 34, 2, 75),
              leading: QueryArtworkWidget(
                id: foundSongs[index].id,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Image.asset('assets/images/no song.png')),
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: ((context) {
                      return NowPlayingScreen(
                        songModelList: foundSongs,
                      );
                    }),
                  ),
                );
              },
            );
          }),
          separatorBuilder: (context, index) => SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
          itemCount: foundSongs.length);
    }else{
      return null;
    }
  }
}
