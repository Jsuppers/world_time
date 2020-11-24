import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:timezones/services/database.dart';
import 'package:timezones/services/timeInformation.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:timezones/services/admob_service.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};
  ProfileProvider database;
  final ams = AdMobService();

  @override
  void initState() {
    super.initState();

    Admob.initialize(ams.getAdModAppID());
  }

  @override
  Widget build(BuildContext context) {
    data = data != null && data.isNotEmpty
        ? data : ModalRoute.of(context).settings.arguments;

    List<TimeProfile> profiles = data['profiles'];
    List<String> locations = data['locations'];
    database = data['database'];

    return MaterialApp(
        home: Scaffold(
            backgroundColor: Colors.grey[300],
            appBar: AppBar(
              backgroundColor: Colors.grey[300],
              title: Text('What\'s the time in?',
                  style: TextStyle(
                      fontSize: 18.0,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold)),
              centerTitle: false,
              elevation: 0,
            ),
            floatingActionButton: FloatingActionButton(
                elevation: 0.0,
                child: new Icon(Icons.add),
                backgroundColor: Colors.blue[900],
                onPressed: () async {
                  setState(() {
                    updateLocation(
                        context, locations, profiles, profiles.length);
                  });
                }),
            body: Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: AdmobBanner(
                      adUnitId: ams.getBannerAdId(),
                      adSize:  AdmobBannerSize.BANNER,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: profiles.length,
                        itemBuilder: (cnt, index) {
                          return GestureDetector(
                            onTap: () async {
                              updateLocation(
                                  context, locations, profiles, index);
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                              width: double.maxFinite,
                              child: Card(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Row(
                                      children: [
                                        profileColumn(profiles[index]),
                                        usernameColumn(profiles[index]),
                                        Spacer(),
                                        timeColumn(profiles[index])
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            )));
  }

  Future updateLocation(BuildContext context, List<String> locations,
      List<TimeProfile> profiles, int index) async {
    {
      TimeProfile profile = index >= profiles.length ? null : profiles[index];
      if (profile == null) {
        profile = new TimeProfile();
        profile.name = '';
        profile.avatarImage = 'assets/lego/001-lego.png';
      }

      dynamic result =
          await Navigator.pushNamed(context, '/update', arguments: {
        'locations': locations,
        'index': index,
        'profile': profile,
      });

      print(result);
      if (result != null && result['delete']) {
        setState(() {
          database.delete(profile.id);
          print('Removing profile ${profiles.remove(profile)}');
        });
      } else if (profile.location != null && profile.location.isNotEmpty) {
        print(profile.toString());
        try {
          setState(() {
            if (!profiles.contains(profile)) {
              profiles.add(profile);
              database.insert(profile);
            } else {
              database.update(profile);
            }

          });
        } catch (exception) {
          print('exception - $exception');
        }
      } else {
        print('no location picked');
      }
    }
  }

  Column usernameColumn(TimeProfile profile) {
    String displayLocation = profile.location;
    if (displayLocation.length > 16) {
      displayLocation = '${displayLocation.substring(0, 14)}..';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(profile.name,
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14.0,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        Row(
          children: <Widget>[
            Text(displayLocation,
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16.0,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }

  Column timeColumn(TimeProfile profile) {
    return Column(
      children: [
        TimerBuilder.periodic(Duration(minutes: 1), builder: (context) {
          print("${TimeInformation.getTime(profile.location)}");
          return Text(
            "${TimeInformation.getTime(profile.location)}",
            style: TextStyle(
                color: Colors.black87,
                fontSize: 22.0,
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold),
          );
        }),
      ],
    );
  }

  Column profileColumn(TimeProfile profile) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: CircleAvatar(
              backgroundColor: Colors.grey[300],
              backgroundImage: AssetImage('${profile.avatarImage}')),
        ),
      ],
    );
  }
}
