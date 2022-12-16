// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_app/controller/songController.dart';
import 'package:music_app/db/functions/playlist_db.dart';
import 'package:music_app/db/model/music_model.dart';
// ignore: depend_on_referenced_packages
import 'package:google_fonts/google_fonts.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayListScreenAllSongs extends StatefulWidget {
  const PlayListScreenAllSongs({Key? key, this.findex}) : super(key: key);

// ignore: prefer_typing_uninitialized_variables
final findex;
  @override
  State<PlayListScreenAllSongs> createState() => _PlayListScreenAllSongsState();
}

final nameController = TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _PlayListScreenAllSongsState extends State<PlayListScreenAllSongs> {
  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    return Container(
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
      child: ValueListenableBuilder(
        valueListenable: Hive.box<MusicModel>('playlistDB').listenable(),
        builder:
            (BuildContext context, Box<MusicModel> musicList, Widget? child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Text( 'PlayList',
                style: GoogleFonts.ubuntuCondensed(
                    textStyle: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              centerTitle: true,
            ),
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Hive.box<MusicModel>('playlistDB').isEmpty
                    ? Center(
                        child: Text('No PlayList',
                            style: GoogleFonts.ubuntuCondensed(
                              textStyle: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )),
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 5,
                        ),
                        itemCount: musicList.length,
                        itemBuilder: (context, index) {
                          final datas = musicList.values.toList()[index];
                          return ValueListenableBuilder(
                              valueListenable:
                                  Hive.box<MusicModel>('playlistDB')
                                      .listenable(),
                              builder: (BuildContext context,
                                  Box<MusicModel> musicList, Widget? child) {
                                return GestureDetector(
                                  onTap: () {
                                    playlistCheck(GetSongs.songscopy[widget.findex],datas); 
                                    PlayListDB().playlistnotifier.notifyListeners();
                                    Navigator.of(context).pop();
                                  },
                                  child: Padding(
                                      padding: const EdgeInsets.all(5), 
                                      child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10)),
                                          color: Colors.transparent,
                                          elevation: 3,
                                          child: Column(
                                            crossAxisAlignment:CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context).size.width*0.35,
                                                  padding:const EdgeInsets.only(top: 8),
                                                  child: Image.asset('assets/images/no song.png')),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(left: 5, right: 8),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 4,
                                                        child:
                                                            SingleChildScrollView(
                                                          scrollDirection:Axis.horizontal,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                            children: [
                                                              Text(datas.name,
                                                                  style:GoogleFonts.ubuntuCondensed(textStyle:const TextStyle(
                                                                      color: Colors.white,fontWeight:FontWeight.bold)),
                                                                  overflow:TextOverflow.ellipsis)
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                     
                                                    ],
                                                  ))
                                            ],
                                          ))),
                                );
                              });
                        },
                      ),
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              label:Text('New playlist',
              style:GoogleFonts.ubuntuCondensed(textStyle:const TextStyle(fontSize: 18)),),
              splashColor: Colors.transparent,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          30.0,
                        ),
                      ),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height*0.3,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               Text(
                                 'Create New Playlist',
                                 style: GoogleFonts.ubuntuCondensed(textStyle:const TextStyle(
                                     fontSize: 25, fontWeight: FontWeight.bold))
                               ),
                              const SizedBox(
                                height: 30,
                              ),
                              Form(
                                key: _formKey,
                                child: TextFormField(
                                    controller: nameController,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'New Playlist',
                                        hintStyle: GoogleFonts.ubuntuCondensed()),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter playlist name";
                                      } else {
                                        return null;
                                      }
                                    }),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: 100.0,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Cancel',
                                        style: GoogleFonts.ubuntuCondensed(textStyle:const TextStyle(
                                          color: Colors.white,
                                        ),)
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:Colors.white
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          whenButtonClicked();
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Text(
                                        'Save',
                                        style:GoogleFonts.ubuntuCondensed(textStyle:const TextStyle(color: Colors.black)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              backgroundColor: Colors.white,
              icon: const Icon(
                Icons.playlist_add,
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> whenButtonClicked() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      return;
    } else {
      final music = MusicModel(
        songId: [],
        name: name,
      );
      PlayListDB().playlistAdd(music);
      nameController.clear();
    }
  }


   void playlistCheck(SongModel data,datas) {
    if (!datas.inValueIn(data.id)) {
      datas.add(data.id);
      const snackbar = SnackBar(
        behavior: SnackBarBehavior.floating,
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          content: Text(
            'song Added to Playlist',
            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }else{
       const snackbarscnd = SnackBar(
        behavior: SnackBarBehavior.floating,
          backgroundColor: Color.fromARGB(255, 99, 96, 96),
          content: Text(
            'Song Already Added to Playlist',
            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackbarscnd);
    }
  }
}
