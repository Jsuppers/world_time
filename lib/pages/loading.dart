import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:timezone/data/latest_all.dart' as timezoneDatabase;
import 'package:timezone/timezone.dart' as timezoneMethods;
import 'package:timezones/services/database.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  final String tableTodo = 'todo';
  final String columnId = '_id';
  final String columnTitle = 'title';
  final String columnDone = 'done';

  void setupWorldTime() async {
    List<TimeProfile> profiles = [];
    // Load timezone database
    timezoneDatabase.initializeTimeZones();

    // Get a location using getDatabasesPath
    String databasesPath = await getDatabasesPath();
    String path = p.join(databasesPath, 'demo2.db');

    ProfileProvider provider = new ProfileProvider();
    await provider.open(path);

    if (provider == null) {
      print('1 ----------');
      print(provider.getTodos());

      Navigator.pushReplacementNamed(context, '/error');

    } else {
      print('2 ----------');
      profiles = await provider.getTodos();
      if (profiles.length == 0) {

        TimeProfile profile = new TimeProfile();
        profile.id = 0;
        profile.name = 'example';
        profile.location = 'Europe/Berlin';
        profile.avatarImage = 'assets/lego/009-lego.png';

        await provider.insert(profile);
        profiles.add(profile);
        print('Created new profile');
      }
    }

    try {
      Navigator.pushReplacementNamed(context, '/home', arguments: {
        'profiles': profiles,
        'locations': timezoneMethods.timeZoneDatabase.locations.keys.toList(),
        'database': provider,
      });
    } catch (exception) {
      print('caught error - $exception');
      Navigator.pushReplacementNamed(context, '/error');
    }
  }

  @override
  void initState() {
    super.initState();
    setupWorldTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitFoldingCube(
          color: Colors.blue,
          size: 50.0,
        ),
      ),
    );
  }
}
