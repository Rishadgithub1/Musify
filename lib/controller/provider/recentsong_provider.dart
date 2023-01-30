import 'package:flutter/material.dart';
import 'package:music_app/db/functions/recent_db.dart';

class RecentSongProvider with ChangeNotifier {
 
  Future<void>getAllRecent() async{
    await GetRecentSong.getRecentSongs();
    notifyListeners();
  }
}