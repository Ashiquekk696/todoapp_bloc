class TodoModel {
  String? toDo;
  int? mintes;
 
  TodoModel({this.toDo,this.mintes,});

  TodoModel.fromJson(Map json) {
    toDo = json["todo"];
    mintes = json["minutes"];
 
  }
}
