// ignore: depend_on_referenced_packages
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:music_app/screens/home_screens/modules/favorite/favorite_screen.dart';
import 'package:music_app/screens/home_screens/modules/playlist/playlist_list.dart';
import 'package:music_app/screens/home_screens/modules/recent/recent_song.dart';

Widget rowItemAllsongs(context) {
  return Padding(
    padding: const EdgeInsets.only(top: 20,right:10,left: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.04,
          width: 88,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                backgroundColor:Colors.white ,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            child: Text(
              'All songs',
              style: GoogleFonts.alegreya(
                  textStyle: const TextStyle(color: Colors.black),
                  fontWeight: FontWeight.w800,
                  fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.04,
          width: MediaQuery.of(context).size.width * 0.18,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const RecentlyPlayedScreen()));
            },
            style: ElevatedButton.styleFrom(
               backgroundColor: const Color.fromARGB(225, 66, 61, 61),
                shape: RoundedRectangleBorder( 
                    borderRadius: BorderRadius.circular(20))),
            child: Text(
              'Recent',
              style: GoogleFonts.alegreya(
                  textStyle: const TextStyle(color: Colors.white),
                  fontWeight: FontWeight.w800,
                  fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.04,
          width: MediaQuery.of(context).size.width * 0.19,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const FavoriteScreen(),
              ));
            },
            style: ElevatedButton.styleFrom(
               backgroundColor: const Color.fromARGB(225, 66, 61, 61),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            child: Text(
              'Favorite',
              style: GoogleFonts.alegreya(
                  textStyle: const TextStyle(color: Colors.white),
                  fontWeight: FontWeight.w800,
                  fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.04,
          width: MediaQuery.of(context).size.width * 0.19,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const PlayListScreen(),
              ));
            },
            style: ElevatedButton.styleFrom(
               backgroundColor: const Color.fromARGB(225, 66, 61, 61),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            child: Text(
              'Playlist',
              style: GoogleFonts.alegreya(
                  textStyle: const TextStyle(color: Colors.white),
                  fontWeight: FontWeight.w800,
                  fontSize: 12),
            ),
          ),
        ),
      ],
    ),
  );
}
