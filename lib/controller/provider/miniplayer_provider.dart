// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:music_app/controller/songController.dart';



class MiniPlayerProvider with ChangeNotifier {
  void mounterfun() {
    GetSongs.player.currentIndexStream.listen((index) {
      if (index != null) {
        notifyListeners();
      }
    });
  }

  Future<void>playBtnPressed(BuildContext context)async{
      if (GetSongs.player.playing) {
      await GetSongs.player.pause();
      notifyListeners();
    } else {
      await GetSongs.player.play();
      notifyListeners();
    }
  }

  Future<void> previousBtnPressed() async {
    if (GetSongs.player.hasPrevious) {
      await GetSongs.player.seekToPrevious();
      await GetSongs.player.play();
    } else {
      await GetSongs.player.play();
    }
  }

  Future<void> nextBtnPressed() async {
    if (GetSongs.player.hasNext) {
      await GetSongs.player.seekToNext();
      await GetSongs.player.play();
    } else {
      await GetSongs.player.play();
    }
  }
}
