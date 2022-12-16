

// class MusicPlayingScreen extends StatefulWidget {
//   const MusicPlayingScreen({
//     super.key,
//     required this.songModelList,
//   });
//   final List<MusicModel> songModelList;
//   @override
//   State<MusicPlayingScreen> createState() => _MusicPlayingScreenState();
// }

// // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
// // TextEditingController playlistController = TextEditingController(); 

// class _MusicPlayingScreenState extends State<MusicPlayingScreen> {
//   Duration _duration = const Duration();
//   Duration _position = const Duration();

//   bool _isShuffle = false; 
//   int currentIndex = 0;
//   int counter = 0;

//   @override
//   void initState() {
//     GetSongs.player.currentIndexStream.listen((index) {
//       if (index != null) {
//         setState(() {
//           currentIndex = index;
//         });
//         // GetAllSongController.currentIndexes = index; 
//       }
//     });
//     super.initState();
//     playSong();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: double.infinity,
//       width: double.infinity,
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             Color.fromARGB(255, 15, 159, 167),
//             Color.fromARGB(255, 16, 16, 16)
//           ],
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Align(
//                     alignment: Alignment.topLeft,
//                     child: IconButton( 
//                       onPressed: () { 
//                         setState(() {});
//                         Navigator.of(context).pop();  
//                       },
//                       icon: const Icon(Icons.keyboard_arrow_down),
//                       color: Colors.white,
//                     ),
//                   ),
//                     SizedBox(height: MediaQuery.of(context).size.height/8,),  
//                      ClipRRect(
//                     child: SizedBox(  
//                         width: MediaQuery.of(context).size.height * 0.3, 
//                         height: MediaQuery.of(context).size.width* 0.5, 
//                         child: QueryArtworkWidget(id: widget.songModelList[currentIndex].id,
//                         type: ArtworkType.AUDIO,
//                         keepOldArtwork: true,
//                         nullArtworkWidget: Image.asset('assets/images/music logo2-modified (1).png'),) 
//                         ), 
//                     ),
//                    SizedBox(
//                     height: MediaQuery.of(context).size.height * 0.06,
//                    ),
//                    Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                     Padding(
//                     padding: const EdgeInsets.only(left:20 ,right: 12), 
//                     child: Text(
//                       widget.songModelList[currentIndex].displayNameWOExt,
//                       overflow: TextOverflow.ellipsis,
//                       style: GoogleFonts.ubuntuCondensed(
//                           textStyle:const TextStyle(color: Colors.white),
//                            fontSize: 23), 
//                     ),
//                   ),
//                  const SizedBox( height: 13),
//                    Text(
//                     widget.songModelList[currentIndex].artist.toString() == "<unknown>"
//                     ? "Unknown artist" : widget.songModelList[currentIndex].artist.toString(),
//                     overflow: TextOverflow.ellipsis,
//                     style:const TextStyle(fontSize: 12, color: Colors.white),
//                   ),
//                   const SizedBox(height: 34,),
//                    Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         IconButton(
//                             onPressed: () {
//                               GetSongs.player.loopMode ==
//                                LoopMode.one
//                                ? GetSongs.player
//                                .setLoopMode(LoopMode.all)
//                                : GetSongs.player
//                                 .setLoopMode(LoopMode.one);  
//                             },
//                             icon: StreamBuilder<LoopMode>(
//                               stream: GetSongs
//                                   .player.loopModeStream,
//                               builder: (context, snapshot) {
//                                 final loopMode = snapshot.data;
//                                 if (LoopMode.one == loopMode) { 
//                                   return Icon(
//                                     Icons.repeat, 
//                                     color: Colors.red[600],
//                                   );
//                                 } else {
//                                   return const Icon(
//                                     Icons.repeat,
//                                     color: Colors.white,
//                                   );
//                                 }
//                               },
//                             ),
//                           ),
//                         IconButton(
//                             onPressed: () {
//                               _isShuffle == false
//                                   ? GetSongs.player
//                                       .setShuffleModeEnabled(true)
//                                   : GetSongs.player
//                                       .setShuffleModeEnabled(false);
//                             },
//                             icon: StreamBuilder<bool>(
//                               stream: GetSongs.player.shuffleModeEnabledStream,
//                               builder: (BuildContext context,
//                                   AsyncSnapshot snapshot) {
//                                 _isShuffle = snapshot.data;
//                                 if (_isShuffle) {
//                                   return Icon(
//                                     Icons.shuffle,
//                                     color: Colors.red[600],
//                                   );
//                                 } else {
//                                   return const Icon(
//                                     Icons.shuffle,   
//                                     color: Colors.white,
//                                   );
//                                 }
//                               },
//                             ),
//                         ),
//                         IconButton(
//                           onPressed: () { 
//                            Navigator.of(context).push(MaterialPageRoute(
//                             builder: (context)=> PlaylistScreenFromallsong(findex: currentIndex,)));
//                           },
//                           icon:const Icon(Icons.playlist_add), 
//                           color: Colors.white,
//                         ),
//                          FavButMusicPlaying( 
//                         songFavoriteMusicPlaying:
//                        widget.songModelList[currentIndex]),
//                       ],
//                     ), 
//                     SizedBox(height: MediaQuery.of(context).size.height*0.02,),  
//                       Row(
//                         children: [
//                           Text(
//                             _position.toString().substring(2, 7),
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                           Expanded(
//                             child: SliderTheme(
//                               data: SliderTheme.of(context).copyWith(
//                                 activeTrackColor: Colors.white,
//                                 thumbShape:const RoundSliderThumbShape( enabledThumbRadius: 7.0),
//                                 overlayShape:const RoundSliderOverlayShape(overlayRadius: 1.0),
//                               ),
//                               child: Slider(
//                                 value: _position.inSeconds.toDouble(),
//                                 onChanged: ((double value) {
//                                   setState(() {
//                                     changeToSeconds(value.toInt());
//                                     value = value;
//                                   });
//                                 }),
//                                 min: 0.0,
//                                 max: _duration.inSeconds.toDouble(),
//                                 inactiveColor: Colors.white.withOpacity(0.3),
//                                 activeColor: Colors.white,
//                               ),
//                             ),
//                           ),
//                           Text(
//                             _duration.toString().substring(2, 7),
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 30,),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [ 
//                           IconButton(
//                               onPressed: () async {
//                                 if (GetSongs.player.hasPrevious) {
//                                   await GetSongs.player
//                                       .seekToPrevious();
//                                   await GetSongs.player.play();
//                                 } else {
//                                   awaitGetSongs.player.play();
//                                 }
//                               },
//                               icon: const Icon(
//                                 Icons.skip_previous,
//                                 size: 35,
//                                 color: Colors.white,
//                               )),
//                                IconButton(onPressed: (){
//                             if(GetSongs.player.position.inSeconds>10){ 
//                         GetSongs.player.seek(Duration(seconds:GetSongs.player.position.inSeconds -10));   
//                             } else{
//                              GetSongs.player .seek(const Duration(seconds: 0)); 
//                             }   
//                           }, 
//                           icon:const Icon(Icons.replay_10,color: Colors.white,)),
//                          IconButton(
//                       onPressed: (() async {
//                         if (GetSongs.player.playing) {
//                           await GetSongs.player.pause();
//                           setState(() {});
//                         } else {
//                           await GetSongs.player.play();
//                           setState(() {});
//                         }
//                       }),
//                       icon: Icon(GetSongs.player.playing
//                           ? Icons.pause
//                           : Icons.play_arrow),
//                       color: Colors.white,
//                       iconSize: MediaQuery.of(context).size.width * 0.2,
//                     ),
//                            IconButton(onPressed: (){
//                            if (GetAllSongController.audioPlayer.position.inSeconds+10 > GetAllSongController.audioPlayer.duration!.inSeconds){
//                            GetAllSongController.audioPlayer.seek(Duration(seconds:GetAllSongController.audioPlayer.duration!.inSeconds ));
//                             }else{ 
//                               GetAllSongController.audioPlayer.seek(Duration(seconds:GetAllSongController.audioPlayer.position.inSeconds +10)); 
//                             }   
//                           }, icon:const Icon(Icons.forward_10,color: Colors.white,)),
//                           IconButton(
//                               onPressed: () async {
//                                 if (GetAllSongController.audioPlayer.hasNext) {
//                                   await GetAllSongController.audioPlayer
//                                       .seekToNext();
//                                   await GetAllSongController.audioPlayer.play();
//                                 } else {
//                                   await GetAllSongController.audioPlayer.play();
//                                 }
//                               },
//                               icon: const Icon( Icons.skip_next,
//                                 size: 35,color: Colors.white,)),
//                         ],
//                       ),
//                     ],
//                   ),
//                ],),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//   void changeToSeconds(int seconds) {
//     Duration duration = Duration(seconds: seconds);
//     GetAllSongController.audioPlayer.seek(duration);
//   }

//   void playSong() {
//     GetAllSongController.audioPlayer.durationStream.listen((eventd) {
//       setState(() {
//         _duration = eventd!;
//       });
//     });
//     GetAllSongController.audioPlayer.positionStream.listen((eventp) {
//       setState(() {
//         _position = eventp;
//       });
//     });
//   }
// }