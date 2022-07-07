import 'package:flutter_riverpod/flutter_riverpod.dart';

class Todo {
  final String content;
  final String id;

  Todo({
    required this.content,
    required this.id,
  });
}

class TodoProvider extends StateNotifier<List<Todo>> {
  TodoProvider()
      : super(
          [],
        );

  void addTodo(String task) {
    state = [...state, Todo(content: task, id: state.length.toString())];
  }

  void removeTodo(Todo todo) => state = [
        for (final temp in state)
          if (temp != todo) temp,
      ];
}
