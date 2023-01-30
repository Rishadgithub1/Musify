import 'package:flutter/material.dart';
import 'package:music_app/controller/songController.dart';
import 'package:music_app/db/functions/favorite_db.dart';

class NowPlayingScreenProvider with ChangeNotifier {
  Duration duration = const Duration();
  Duration position = const Duration();
  int currentIndex = 0;

  void initStateFunction() {
    GetSongs.player.currentIndexStream.listen((index) {
      if (index != null) {
        currentIndex = index;
        GetSongs.currentIndes = index;
        notifyListeners();
      }
    });
  }

  void playSongFun() {
    GetSongs.player.durationStream.listen((d) {
      duration = d!;
      notifyListeners();
    });
    GetSongs.player.positionStream.listen((p) {
      position = p;
      notifyListeners();
    });
  }

  Future<bool> willPoPFun() async {
    FavoriteDb.favoriteSongs.notifyListeners();
    return true;
  }

  void backBtnTop(BuildContext context) {
    Navigator.of(context).pop();
    FavoriteDb.favoriteSongs.notifyListeners();
  }

  void sliderFunction(double seconds) {
    Duration duration = Duration(seconds: seconds.toInt());
    GetSongs.player.seek(duration);
    notifyListeners();
  }

  Future<void> playBtnPressed() async {
    if (GetSongs.player.playing) {
      await GetSongs.player.pause();
      notifyListeners();
    } else {
      await GetSongs.player.play();
      notifyListeners();
    }
  }

  Future<void> nextBtn() async {
    if (GetSongs.player.hasNext) {
      await GetSongs.player.seekToNext();
      await GetSongs.player.play();
    } else {
      await GetSongs.player.play();
    }
  }

  Future<void> previousBtn() async {
    if (GetSongs.player.hasPrevious) {
      await GetSongs.player.seekToPrevious();
      await GetSongs.player.play();
    } else {
      await GetSongs.player.play();
    }
  }
}
