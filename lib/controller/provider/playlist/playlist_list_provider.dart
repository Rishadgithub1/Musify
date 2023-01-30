import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:music_app/db/functions/playlist_db.dart';
import 'package:music_app/db/model/music_model.dart';

class PlaylistListProvider with ChangeNotifier {
  final nameController = TextEditingController();
  Future<void> whenSaveButtonClicked(BuildContext context) async {
    log("build of playprovider");
    final name = nameController.text.trim();
    final music = MusicModel(
      name: name,
      songId: [],
    );
    final data =
        PlayListDB.playListDb.values.map((e) => e.name.trim()).toList();

    if (name.isEmpty) {
      log("is empty");
      return;
    } else if (data.contains(music.name)) {
      const snackBar3 = SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Playlist Already Exist',
            style: TextStyle(fontFamily: 'UbuntuCondensed')),
        duration: Duration(milliseconds: 850),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar3);
      nameController.clear();
      log("inside");
    } else {
      PlayListDB().playlistAdd(music);
      nameController.clear();
      
    }
  }
}
