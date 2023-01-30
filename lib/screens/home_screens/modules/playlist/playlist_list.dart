import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_app/controller/provider/playlist/playlist_list_provider.dart';
import 'package:music_app/db/model/music_model.dart';
import 'package:music_app/screens/home_screens/modules/playlist/playlist_screen.dart';
import 'package:provider/provider.dart';

class PlayListScreen extends StatelessWidget {
  PlayListScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    final providerWOL = Provider.of<PlaylistListProvider>(context,listen: false);
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
              title: const Text('PlayList',
                  style: TextStyle(
                      fontFamily: 'UbuntuCondensed',
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              centerTitle: true,
            ),
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Hive.box<MusicModel>('playlistDB').isEmpty
                    ? const Center(
                        child: Text('No PlayList',
                            style: TextStyle(
                                fontFamily: 'UbuntuCondensed',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70)),
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
                          final data = musicList.values.toList()[index];
                          return ValueListenableBuilder(
                              valueListenable:
                                  Hive.box<MusicModel>('playlistDB')
                                      .listenable(),
                              builder: (BuildContext context,
                                  Box<MusicModel> musicList, Widget? child) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return PlaylistData(
                                        playlist: data,
                                        folderindex: index,
                                      );
                                    }));
                                  },
                                  child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          color: Colors.transparent,
                                          elevation: 3,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8),
                                                    child: Image.asset(
                                                        'assets/images/no song.png')),
                                              ),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5, right: 8),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 4,
                                                        child:
                                                            SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(data.name,
                                                                  style: const TextStyle(
                                                                      fontFamily:
                                                                          'UbuntuCondensed',
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis)
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                          flex: 1,
                                                          child: IconButton(
                                                              icon: const Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .white),
                                                              onPressed: () {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return AlertDialog(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(20.0)),
                                                                      elevation:
                                                                          30,
                                                                      backgroundColor:
                                                                          const Color.fromARGB(
                                                                              223,
                                                                              43,
                                                                              9,
                                                                              53),
                                                                      title: const Text(
                                                                          'Delete Playlist',
                                                                          style: TextStyle(
                                                                              fontFamily: 'UbuntuCondensed',
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 22),
                                                                          textAlign: TextAlign.center),
                                                                      content: const Text(
                                                                          'Are Yout Sure You Want To Delete This Playlist',
                                                                          style:
                                                                              TextStyle(fontFamily: 'UbuntuCondensed')),
                                                                      actions: [
                                                                        TextButton(
                                                                            child:
                                                                                const Text(
                                                                              'No',
                                                                              style: TextStyle(fontFamily: 'UbuntuCondensed', fontSize: 18),
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            }),
                                                                        TextButton(
                                                                          child:
                                                                              const Text(
                                                                            'Yes',
                                                                            style:
                                                                                TextStyle(fontFamily: 'UbuntuCondensed', fontSize: 18),
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            musicList.deleteAt(index);
                                                                            Navigator.pop(context);
                                                                          },
                                                                        )
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                              }))
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
              label: const Text(
                'New playlist',
                style: TextStyle(fontFamily: 'UbuntuCondensed'),
              ),
              splashColor: Colors.transparent,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Create New Playlist',
                                  style: TextStyle(
                                      fontFamily: 'UbuntuCondensed',
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 30),
                              Form(
                                key: _formKey,
                                child: TextFormField(
                                    controller: providerWOL.nameController,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'New Playlist',
                                        hintStyle: TextStyle(
                                            fontFamily: 'UbuntuCondensed')),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter playlist name";
                                      } else {
                                        return null;
                                      }
                                    }),
                              ),
                              const SizedBox(height: 20),
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
                                        child: const Text('Cancel',
                                            style: TextStyle(
                                                fontFamily: 'UbuntuCondensed')),
                                      )),
                                  SizedBox(
                                    width: 100,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                         providerWOL.whenSaveButtonClicked(context);
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: const Text(
                                        'Save',
                                        style: TextStyle(
                                            fontFamily: 'UbuntuCondensed',
                                            color: Colors.black),
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
}
