
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:music_app/screens/home_screens/modules/all_songs/all_songs.dart';
import 'package:on_audio_query/on_audio_query.dart';

class GetRecentSong {
  static ValueNotifier <List<SongModel>> recentSongNotifier = ValueNotifier([]);
  static List<dynamic> recentlyPlayed =[];

  static Future<void> addRecentlyPlayed(item) async{
    final recentDB = await  Hive.openBox('recentSongNotifier');
    await recentDB.add(item);
    getRecentSongs();
    recentSongNotifier.notifyListeners();

  }

  static Future<void> getRecentSongs() async {
    final recentDB =await Hive.openBox('recentSongNotifier');
    recentlyPlayed = recentDB.values.toList();
    displayRecentSongs();
    recentSongNotifier.notifyListeners();
  }
  


  static Future<void> displayRecentSongs() async{
    final recentDB = await Hive.openBox('recentSongNotifier');
    final recentSongItems = recentDB.values.toList();
    recentSongNotifier.value.clear();
    recentlyPlayed.clear();
    for(int i = 0; i < recentSongItems.length; i++){
      for(int j = 0 ; j < startSong.length; j++ ){
        if(recentSongItems[i] == startSong[j].id){
          recentSongNotifier.value.add(startSong[j]);
          recentlyPlayed.add(startSong[j]);
        }
      }
    }
  }
}
