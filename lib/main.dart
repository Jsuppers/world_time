import 'package:flutter/material.dart';
import 'package:timezones/pages/avatars.dart';
import 'package:timezones/pages/update.dart';
import 'package:timezones/pages/error.dart';
import 'package:timezones/pages/home.dart';
import 'package:timezones/pages/loading.dart';

void main() => runApp(MaterialApp(

  initialRoute: '/',
  routes: {
    '/': (context) => Loading(),
    '/home': (context) => Home(),
    '/update': (context) => UpdateProfile(),
    '/avatars': (context) => AvatarList(),
    '/error': (context) => ErrorPage(),
  }
));
