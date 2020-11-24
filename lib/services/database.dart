import 'package:sqflite/sqflite.dart';

final String tableProfiles = 'profiles';
final String columnId = '_id';
final String columnName = 'name';
final String columnAvatarImage = 'avatarImage';
final String columnLocation = 'location';

class TimeProfile {
  int id;
  String name;
  String avatarImage;
  String location;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnId: id,
      columnName: name,
      columnAvatarImage: avatarImage,
      columnLocation: location,
    };
    return map;
  }

  TimeProfile();

  TimeProfile.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    name = map[columnName];
    avatarImage = map[columnAvatarImage];
    location = map[columnLocation];
  }
}

class ProfileProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableProfiles ( 
  $columnId integer primary key, 
  $columnName text not null,
  $columnAvatarImage text not null,
  $columnLocation text not null)
''');
    });
  }

  Future<TimeProfile> insert(TimeProfile todo) async {
    todo.id = await db.insert(tableProfiles, todo.toMap());
    return todo;
  }

  Future<List<TimeProfile>> getTodos() async {
    List<Map> maps = await db.query(tableProfiles,
        columns: [columnId, columnName, columnAvatarImage, columnLocation]);
    List<TimeProfile> output = [];
    if (maps.length > 0) {
      maps.forEach((element) {
        output.add(TimeProfile.fromMap(element));
      });
      output.sort((a, b) => a.id.compareTo(b.id));
      return output;
    }
    return output;
  }

  Future<TimeProfile> getTodo(int id) async {
    List<Map> maps = await db.query(tableProfiles,
        columns: [columnId, columnName, columnAvatarImage, columnLocation],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return TimeProfile.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db
        .delete(tableProfiles, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(TimeProfile todo) async {
    return await db.update(tableProfiles, todo.toMap(),
        where: '$columnId = ?', whereArgs: [todo.id]);
  }

  Future close() async => db.close();
}
