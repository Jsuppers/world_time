import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:timezones/services/database.dart';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  Map data = {};
  TimeProfile profile;
  List<String> locations = [];
  final List<DropdownMenuItem> items = [];
  final picker = ImagePicker();

  _imgFromLibrary() async {
    dynamic result = await Navigator.pushNamed(context, '/avatars');

    if (result != null) {
      setState(() {
        profile.avatarImage = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    data = data != null && data.isNotEmpty
        ? data
        : ModalRoute.of(context).settings.arguments;
    locations = data['locations'];
    profile = data['profile'];

    locations.forEach((key) {
      items.add(DropdownMenuItem(
        child: Text(key),
        value: key,
      ));
    });

    return Scaffold(

      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.delete),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context, {'delete': true});
              })
        ],
        backgroundColor: Colors.grey[300],
        title: Text('Profile'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              _imgFromLibrary();
            },
            child: Center(
              child: CircleAvatar(
                radius: 58.0,
                child: ClipOval(
                  child: Image.asset('${profile.avatarImage}'),
                ),
                backgroundColor: Colors.grey[300],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
            child: Text('Profile Name',
                style: GoogleFonts.lato(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: Colors.black87,
                  fontSize: 14.0,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w700,
                )),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
            child: TextField(
              maxLength: 16,
              maxLengthEnforced: true,
              style: GoogleFonts.lato(
                textStyle: Theme.of(context).textTheme.headline4,
                fontSize: 28.0,
                color: Colors.black87,
                letterSpacing: 2.0,
                fontWeight: FontWeight.w700,
              ),
              controller: TextEditingController()..text = profile.name,
              onChanged: (text) => {profile.name = text},
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Enter a name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
            child: Text('Location',
                style: GoogleFonts.lato(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: Colors.black87,
                  fontSize: 14.0,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w700,
                )),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5.0, 0.0, 15.0, 0.0),
            child: SearchableDropdown.single(
              style: GoogleFonts.lato(
                textStyle: Theme.of(context).textTheme.headline4,
                fontSize: 28.0,
                color: Colors.black87,
                letterSpacing: 2.0,
                fontWeight: FontWeight.w700,
              ),
              value: profile.location,
              items: items,
              hint: "Select location",
              searchHint: "Select location",
              onChanged: (value) {
                profile.location = value;
              },
              displayClearIcon: false,
              isExpanded: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: ButtonBar(
                children: [
                  RaisedButton(child: Text("Back"), onPressed: () {
                    Navigator.pop(context);
                  },),
                ],
                alignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max),
          )
        ],
      ),
    );
  }
}
