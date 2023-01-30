import 'package:flutter/material.dart';
import 'package:music_app/screens/home_screens/search_screen/search_screen.dart';

Widget searchBar(BuildContext context) {
  return Container(
    height: 50,
    padding: const EdgeInsets.only(right: 18, left: 15),
    child: TextField(
      readOnly: true,
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: ((context) => const SearchScreen())));
      },
      decoration: InputDecoration(
          fillColor: Colors.white.withOpacity(0.8),
          filled: true,
          hintText: 'search songs',
          hintStyle:const TextStyle(fontFamily: 'UbuntuCondensed',color: Colors.black),
          suffixIcon: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
            color: Colors.black,
            iconSize: 30,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(25),
          ),
          contentPadding: const EdgeInsets.only(left: 15)),
    ),
  );
}
