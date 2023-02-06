import 'package:todoapp/helpers/db_helper.dart';
import 'package:todoapp/models/todo_model.dart';

class TodoRepo {
  Future getTodoDataRepository() async {
    print("obect");
    DbHelper helper = DbHelper();
    var toDoData = await helper.getAllData();
    // toDoData.forEach((e) {
    //   todoModel?.add(TodoModel.fromJson(e));
    // }); 
    return toDoData;
  }
}
