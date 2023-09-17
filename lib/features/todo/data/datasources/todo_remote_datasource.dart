import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/todo_model.dart';

abstract class TodoRemoteDataSource {
  Future<List<TodoModel>> getRandomTodoFromApi();
}

class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  final client = http.Client();

  @override
  Future<List<TodoModel>> getRandomTodoFromApi() async {
    final response = await client.get(
      Uri.parse('https://jsonplaceholder.typicode.com/todos'),
      headers: {
        'content-type': 'application/json',
      },
    );

    final List responseBody = json.decode(response.body);

    final List<TodoModel> todos =
        responseBody.map((todo) => TodoModel.fromMap(todo)).toList();

    return todos;
  }
}
