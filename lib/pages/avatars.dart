import 'dart:convert';

import 'package:flutter/material.dart';

class AvatarList extends StatefulWidget {
  @override
  _AvatarListState createState() => _AvatarListState();
}

class _AvatarListState extends State<AvatarList> {
  List<String> legoAvatarsNames;
  List<Widget> legoAvatarsImages;

  List<String> flagAvatarsNames;
  List<Widget> flagAvatarsImages;

  Future _initImages() async {
    // >> To get paths you need these 2 lines
    final manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    // >> To get paths you need these 2 lines

    final legoImagePaths = manifestMap.keys
        .where((String key) => key.contains('assets/lego'))
        .toList();

    final flagImagePaths = manifestMap.keys
        .where((String key) => key.contains('assets/flags'))
        .toList();

    setState(() {
      legoAvatarsNames = legoImagePaths;
      legoAvatarsImages = [];
      legoAvatarsNames.forEach((path) {
        legoAvatarsImages.add(avatarSelectImage(path));
      });

      flagAvatarsNames = flagImagePaths;
      flagAvatarsImages = [];
      flagAvatarsNames.forEach((path) {
        flagAvatarsImages.add(avatarSelectImage(path));
      });
    });
  }

  Widget avatarSelectImage(String path) {
    String newpath = Uri.decodeFull(path);
    return GestureDetector(
      onTap: () {
        Navigator.pop(context, path);
      },
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage((newpath)))
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(legoAvatarsImages);
    print(flagAvatarsImages);
    if (legoAvatarsImages == null && flagAvatarsImages == null) {
      _initImages();
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: buildBar(context),
          body: TabBarView(
            children: [
              GridView.count(
                  crossAxisCount: 4,
                  children: flagAvatarsImages != null ? flagAvatarsImages : []),

          GridView.count(
              crossAxisCount: 4,
              children: legoAvatarsImages != null ? legoAvatarsImages : []),
            ],
          ),
        ),
      ),
    );
  }


  Widget appBarTitle = Text(
    "Choose Avatar",
    style: TextStyle(color: Colors.white),
  );

  Icon actionIcon = Icon(
    Icons.search,
    color: Colors.white,
  );


  final TextEditingController _searchQuery = TextEditingController();

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = Text(
        "Choose Avatar",
        style: TextStyle(color: Colors.white),
      );
      _searchQuery.clear();
    });
  }

  Widget buildBar(BuildContext context) {
    return AppBar(
        bottom: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.flag)),
            Tab(icon: Icon(Icons.insert_emoticon)),
          ],
        ),
        title: appBarTitle,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.grey[300],
        actions: [
          IconButton(
            icon: actionIcon,
            onPressed: () {
            setState(() {
              if (this.actionIcon.icon == Icons.search) {
                this.actionIcon = Icon(
                  Icons.close,
                  color: Colors.white,
                );
                this.appBarTitle = TextField(
                  onChanged: (text) {

                    setState(() {
                      flagAvatarsImages = [];
                      flagAvatarsNames.forEach((path) {
                        if (text == '' || path.contains(text)){
                          flagAvatarsImages.add(avatarSelectImage(path));
                        }
                      });

                      legoAvatarsImages = [];
                      legoAvatarsNames.forEach((path) {
                        if (text == '' || path.contains(text)){
                          legoAvatarsImages.add(avatarSelectImage(path));
                        }
                      });
                    });
                  },
                  controller: _searchQuery,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                      hintText: "Search here..",
                      hintStyle: TextStyle(color: Colors.white)),
                );
              } else {
                _handleSearchEnd();
              }
            });
            },
          ),
        ]);
  }

}


