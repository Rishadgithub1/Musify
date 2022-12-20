import 'package:flutter/material.dart';
import 'package:music_app/controller/songController.dart';
import 'package:music_app/db/functions/playlist_db.dart';
import 'package:music_app/screens/home_screens/homeDrawer/about_us.dart';
import 'package:music_app/screens/home_screens/homeDrawer/privacy_drawer.dart';
import 'package:music_app/screens/home_screens/homeDrawer/share_app.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 42, 5, 90),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              child: Column(
                children: [
                  DrawerHeader(
                    child: Image.asset('assets/images/image.png'),
                  ),
                  DrawerTile(
                    ontap1: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AboutUsDrawer()));
                    },
                    icon1: Icons.report_outlined,
                    text1: "About Us",
                  ),
                  DrawerTile(
                    ontap1: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const PrivacyDrawer()));
                    },
                    icon1: Icons.lock_person_rounded,
                    text1: "Privacy & Policy",
                  ),
                  DrawerTile(
                    ontap1: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor:
                                  const Color.fromARGB(223, 43, 9, 53),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              title: const Text(
                                'Reset App',
                                style: TextStyle(
                                    fontFamily: 'UbuntuCondensed',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              content: const Text(
                                'Are You Sure Want To Reset The App',
                                style: TextStyle(
                                    fontFamily: 'UbuntuCondensed', fontSize: 18),
                              ),
                              actions: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          PlayListDB.resetAPP(context);
                                          GetSongs.player.stop();
                                        },
                                        child: const Text('Reset')),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel'))
                                  ],
                                )
                              ],
                            );
                          });
                    },
                    icon1: Icons.refresh_outlined,
                    text1: "Reset App",
                  ),
                  DrawerTile(
                    ontap1: () {
                      ShareAppFile(context);
                    },
                    icon1: Icons.share,
                    text1: "Share This App",
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.32),
            const Text(
              "V.1.0.0",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  String text1;
  IconData icon1;
  final void Function() ontap1;
  DrawerTile(
      {super.key,
      required this.ontap1,
      required this.icon1,
      required this.text1});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white24,
        ),
        height: MediaQuery.of(context).size.height * 0.07,
        width: double.infinity,
        child: ListTile(
          iconColor: Colors.white,
          textColor: Colors.white,
          leading: Icon(icon1),
          title: Text(
            text1,
            style: const TextStyle(fontFamily: 'UbuntuCondensed', fontSize: 19),
            // style: GoogleFonts.ubuntuCondensed(
            //     textStyle: const TextStyle(
            //   fontSize: 19,
            // )),
          ),
          onTap: ontap1,
        ),
      ),
    );
  }
}
