import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' ;
import 'package:test_app/models/User.dart';

class DatabaseHelper {
  //Create a private constructor
  DatabaseHelper._();

  static const databaseName = 'todos_database.db';
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database _database;

  Future<Database> get database async {
    if (_database == null) {
      return await initializeDatabase();
    }
    return _database;
  }

  initializeDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), databaseName),
        version: 1, onCreate: (Database db, int version) async {
          await db.execute(
              "CREATE TABLE users(uuid TEXT, fullname TEXT, raiting TEXT, city TEXT, email TEXT, lat TEXT, lng TEXT, picture TEXT, street TEXT, state TEXT, postal_code TEXT, phone_number TEXT)");
        });

  }


  insertUser(UserModel user) async {
    final db = await database;
    var res = await db.insert(UserModel.TABLENAME, user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  Future<List<UserModel>> fetchLocalUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(UserModel.TABLENAME);
    return List.generate(maps.length, (i) {
      return UserModel(
        uuid: maps[i]['uuid'],
        fullname: maps[i]['fullname'],
        raiting: maps[i]['raiting'],
        city:maps[i]['city'],
        email:maps[i]['email'],
        lat:maps[i]['lat'],
        lng:maps[i]['lng'],
        picture:maps[i]['picture'],
        street:maps[i]['street'],
        state:maps[i]['state'],
        postal_code:maps[i]['postal_code'],
        phone_number:maps[i]['phone_number']
      );
    });
  }

}