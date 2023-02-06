import 'package:sqflite/sqflite.dart';
import 'package:todoapp/models/todo_model.dart';

class DbHelper {
  List<TodoModel>? hh = [];

  //var hh;
  Future<Database> openMyDataBase() async {
    Database db = await openDatabase('tod.db', version: 1,
        onCreate: (Database _db, int version) {
      _db.execute('CREATE TABLE mytodos(id INTEGER PRIMARY KEY,todo TEXT,minutes INTEGER)');
    });
    return db;
  }

  Future getAllData() async {
    final db = await openMyDataBase();
    final values = await db.rawQuery('SELECT * FROM mytodos');
   // print(values);
    return values;

    // values.forEach((e) {
    //   hh?.add(TodoModel.fromJson(e));
    // });
    // print(hh?[24].toDo);
  }

  Future addToDo(TodoModel todoModel) async {
    final db = await openMyDataBase();
    await db.rawInsert('INSERT INTO mytodos(todo,minutes) VALUES(?,?)', [todoModel.toDo,todoModel.mintes,]);
    getAllData();
  }
}
