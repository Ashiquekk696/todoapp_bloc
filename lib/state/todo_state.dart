import 'package:equatable/equatable.dart';
import 'package:todoapp/models/todo_model.dart';

abstract class ToDoState extends Equatable {}

class ToDoDataLoadingState extends ToDoState {
  List<Object?> get props => [];
}

class ToDoDataLoadedState extends ToDoState {
  List<TodoModel> todoData ;
  ToDoDataLoadedState(this.todoData);
  List<Object?> get props => [todoData];
}

class ToDoDataErrorState extends ToDoState {
  List<Object?> get props => [];
}
