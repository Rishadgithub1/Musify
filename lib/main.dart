import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_app/controller/provider/allsongs/allsongs_provider.dart';
import 'package:music_app/controller/provider/bottomnav_provider.dart';
import 'package:music_app/controller/provider/miniplayer_provider.dart';
import 'package:music_app/controller/provider/nowplayings_provider.dart';
import 'package:music_app/controller/provider/playlist/playlist_list_provider.dart';
import 'package:music_app/controller/provider/playlist/playlistallsongs_provider.dart';
import 'package:music_app/controller/provider/recentsong_provider.dart';
import 'package:music_app/controller/provider/searchscreen_provider.dart';
import 'package:music_app/db/model/music_model.dart';
import 'package:music_app/screens/spash_screen/splash_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(MusicModelAdapter().typeId)) {
    Hive.registerAdapter(MusicModelAdapter());
  }
  await Hive.openBox<int>('FavoriteDB');
  await Hive.openBox<MusicModel>('playlistDB');

  await JustAudioBackground.init(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
      preloadArtwork: true);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BottomNavigationProvider()),
        ChangeNotifierProvider(create: (context) => MiniPlayerProvider()),
        ChangeNotifierProvider(create: (context) => SearchScreenProvider()),
        ChangeNotifierProvider(create: (context) => NowPlayingScreenProvider()),
        ChangeNotifierProvider(create: (context) => RecentSongProvider()),
        ChangeNotifierProvider(create: (context) => PlaylistListProvider()),
        ChangeNotifierProvider(create: (context) => PlaylistAllsongsProvider()),
        ChangeNotifierProvider(create: (context) => AllsongsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: const SplashScreen(),
      ),
    );
  }
}
