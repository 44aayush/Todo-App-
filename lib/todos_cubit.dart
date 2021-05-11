import 'package:todo_aws/todos_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'models/Todo.dart';

abstract class TodoState {}

class LoadingTodos extends TodoState {}

class ListTodosSuccess extends TodoState {
  final List<Todo> todos;

  ListTodosSuccess({this.todos});
}

class ListTodosFailure extends TodoState {
  final Exception exception;

  ListTodosFailure({this.exception});
}

class TodoCubit extends Cubit<TodoState> {
  final _todoRepo = TodoRepo();

  TodoCubit() : super(LoadingTodos());

  void getTodos() async {
    if (state is ListTodosSuccess == false) {
      emit(LoadingTodos());
    }

    try {
      final todos = await _todoRepo.getTodos();
      emit(ListTodosSuccess(todos: todos));
    } catch (e) {
      emit(ListTodosFailure(exception: e));
    }
  }

  void observeTodos() {
    final todosStream = _todoRepo.observeTodos();
    todosStream.listen((_) => getTodos());
}

  void createTodo(String title) async {
    await _todoRepo.createTodo(title);
  }

  void updateTodoIsComplete(Todo todo, bool isComplete) async {
    await _todoRepo.updateTodoIsComplete(todo, isComplete);
  }
}