import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:music_app/db/functions/favorite_db.dart';
import 'package:music_app/db/model/music_model.dart';
import 'package:music_app/screens/spash_screen/splash_screen.dart';

class PlayListDB {
  ValueNotifier<List<MusicModel>> playlistnotifier = ValueNotifier([]);
static  final playListDb = Hive.box<MusicModel>('playlistDB'); 
  Future<void> playlistAdd(MusicModel value) async {
    final playListDb = Hive.box<MusicModel>('playlistDB');
    await playListDb.add(value);

    playlistnotifier.value.add(value);
  } 

  Future<void> getAllPlaylist() async {
    final playListDb = Hive.box<MusicModel>('playlistDB');
    playlistnotifier.value.clear();
    playlistnotifier.value.addAll(playListDb.values);

    playlistnotifier.notifyListeners();
  }

  Future<void> playlistDelete(int index) async {
    final playListDb = Hive.box<MusicModel>('playlistDB');

    await playListDb.deleteAt(index);
    getAllPlaylist();
  }

   static Future<void>  resetAPP(context) async {
    final playListDb = Hive.box<MusicModel>('playlistDB');
    final musicDb = Hive.box<int>('FavoriteDB');
    final recentDb = Hive.box('recentSongNotifier');
    await musicDb.clear();
    await playListDb.clear();
    await recentDb.clear();
    
    

    FavoriteDb.favoriteSongs.value.clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        ),
         (route) => false
        );
  }
}
