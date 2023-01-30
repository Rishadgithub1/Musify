
import 'package:flutter/material.dart';
import 'package:music_app/screens/widgets/bottom_nav.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    goallsongs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 30),
                child: Image.asset(
                  'assets/images/music-removed.png',
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const Text('Listen the Soul... ♪',
                  style: TextStyle(
                      fontFamily: 'UbuntuCondensed',
                      fontSize: 20,
                      color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> goallsongs() async {
    await Future.delayed(
      const Duration(seconds: 3),
    );
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => BottomNav()));
  }
}
