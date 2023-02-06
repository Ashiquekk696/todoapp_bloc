import 'package:equatable/equatable.dart';

abstract class ToDoEvent extends Equatable {}

class ToDoDataEvent extends ToDoEvent {
  List<Object?> get props => [];
}
