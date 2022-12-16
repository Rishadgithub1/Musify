// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUsDrawer extends StatelessWidget {
  const AboutUsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 50, 6, 107),
              Color.fromARGB(255, 15, 2, 44),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(80.0),
          child: Column(
            children: [
              Image.asset(
                'assets/images/image.png',
                // 'assets/images/music-removed.png',
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.09),
              Text(
                """
Welcome to Musify Endless Music, 

your number one source for all things Music. We're dedicated to providing you the best of Music, with a focus on dependability. customer service,.

We're working to turn our passion for music into a booming Music Player. We hope you enjoy our Music as much as we enjoy offering them to you.

Sincerely,

Rishad E""",
                style: GoogleFonts.ubuntuCondensed(
                    textStyle:const TextStyle(fontSize: 18)),
              )
            ],
          ),
        ),
      )),
    );
  }
}
