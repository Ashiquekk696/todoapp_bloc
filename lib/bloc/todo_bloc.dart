import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/events/todo_event.dart';
import 'package:todoapp/models/todo_model.dart';
import 'package:todoapp/repositories/todo_rep.dart';
import 'package:todoapp/state/todo_state.dart';

class TodoBloc extends Bloc<ToDoEvent, ToDoState> {
  TodoRepo? todoRepo = TodoRepo();
  List<TodoModel> todoModel = [];
  TodoBloc({this.todoRepo}) : super(ToDoDataLoadingState()) {
    on<ToDoDataEvent>((event, emit) async {
      try {
        emit(ToDoDataLoadingState());
        List a = await todoRepo?.getTodoDataRepository();
        
        a.forEach((element) {
        
          todoModel.add(TodoModel.fromJson(element));
        });
      } catch (e) {} 
      emit(ToDoDataLoadedState(todoModel));
    });
  }
}
