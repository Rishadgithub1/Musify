// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';


Widget ShareAppFile(BuildContext context) {
  return Scaffold(
    body: FutureBuilder(
      future: Future.delayed(const Duration(milliseconds: 30), () {
        return Share.share('https://play.google.com/store/games');
      }),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.data;
      },
    ),
  );
}