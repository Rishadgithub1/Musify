// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:music_app/db/functions/favorite_db.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavTextButton extends StatelessWidget {
  const FavTextButton({super.key, required this.songFavorite});
  final SongModel songFavorite;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: FavoriteDb.favoriteSongs,
      builder: (BuildContext ctx, List<SongModel> favoriteData, Widget? child) {
        return TextButton(
          onPressed: () {
            if (FavoriteDb.isFavor(songFavorite)) {
              FavoriteDb.delete(songFavorite.id);
              const snackBar = SnackBar(
                content: Text(
                  'Song Removed From Favorite',
                  style: TextStyle(color: Colors.white),
                ),
                duration: Duration(milliseconds: 1500),
                backgroundColor: Colors.black,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              FavoriteDb.add(songFavorite);
              const snackbar = SnackBar(
                backgroundColor: Colors.black,
                content: Text(
                  'Song Added to Favorite',
                  style: TextStyle(color: Colors.white),
                ),
                duration: Duration(milliseconds: 350),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            }

            FavoriteDb.favoriteSongs.notifyListeners();
            Navigator.of(context).pop();
          },
          child: FavoriteDb.isFavor(songFavorite)
              ? const Text(
                  'Remove from Favorites',
                  style: TextStyle(
                      fontFamily: 'UbuntuCondensed',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color.fromARGB(255, 255, 255, 255)),
                )
              : const Text(
                  'Add to Favorites',
                  style: TextStyle(
                      fontFamily: 'UbuntuCondensed',
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
        );
      },
    );
  }
}
