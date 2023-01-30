import 'package:flutter/material.dart';
import 'package:music_app/controller/provider/miniplayer_provider.dart';
import 'package:music_app/controller/songController.dart';
import 'package:music_app/screens/home_screens/nowplaying/now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';
// ignore: depend_on_referenced_packages
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MiniPlayerScreen extends StatelessWidget {
  const MiniPlayerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint("mini player builder");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<MiniPlayerProvider>(context, listen: false).mounterfun();
    });
    return Consumer<MiniPlayerProvider>(
      builder: (context, value, child) {
        return Container(
          color: Colors.transparent,
          child: ListTile(
            tileColor: const Color.fromARGB(255, 34, 2, 75),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      NowPlayingScreen(songModelList: GetSongs.playingSongs)));
            },
            textColor: const Color.fromARGB(255, 255, 255, 255),
            leading: CircleAvatar(
              radius: 30,
              child: QueryArtworkWidget(
                id: GetSongs.playingSongs[GetSongs.player.currentIndex!].id,
                type: ArtworkType.AUDIO,
                artworkQuality: FilterQuality.high,
                artworkFit: BoxFit.fill,
                nullArtworkWidget: Image.asset('assets/images/no song.png'),
              ),
            ),
            title: SingleChildScrollView(
              child: Text(
                  GetSongs.playingSongs[GetSongs.player.currentIndex!]
                      .displayNameWOExt,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  style: GoogleFonts.ubuntuCondensed(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  )),
            ),
            subtitle: Text(
                "${GetSongs.playingSongs[GetSongs.player.currentIndex!].artist}",
                maxLines: 1,
                style: GoogleFonts.ubuntuCondensed(
                    textStyle: const TextStyle(
                        fontSize: 11, overflow: TextOverflow.ellipsis))),
            trailing: FittedBox(
              fit: BoxFit.fill,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () async {
                        Provider.of<MiniPlayerProvider>(context,).previousBtnPressed;
                      },
                      icon: const Icon(
                        Icons.skip_previous_sharp,
                        color: Colors.white,
                        size: 30,
                      )),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 91, 174, 241),
                      shape: const CircleBorder(),
                    ),
                    onPressed: () async {
                    Provider.of<MiniPlayerProvider>(context,listen: false).playBtnPressed(context);
                    },
                    child: StreamBuilder<bool>(
                      stream: GetSongs.player.playingStream,
                      builder: (context, snapshot) {
                        bool? playingStage = snapshot.data;
                        if (playingStage != null && playingStage) {
                          return const Icon(
                            Icons.pause,
                            color: Colors.white,
                            size: 35,
                          );
                        } else {
                          return const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 35,
                          );
                        }
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: (() async {
                      Provider.of<MiniPlayerProvider>(context).nextBtnPressed();
                    }),
                    icon: const Icon(
                      Icons.skip_next_sharp,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
