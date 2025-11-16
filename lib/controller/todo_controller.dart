

import 'package:get/get.dart';
import 'package:todo_getx/database/db_helper.dart';
import 'package:todo_getx/model/todo_model.dart';

class TodoController extends GetxController{
  final DBHelper dbHelper = DBHelper.db;
  var todoList = <TodoModel>[].obs;

  ///fetch All Todos
  void fetchAllTodos() async {
   todoList.value =  await dbHelper.getAllTodos();
  }

  ///delete todos
  void deleteTodo(int id) async {
    await dbHelper.deleteTodo(id);
  }

  /// add todos
  void addTodo(TodoModel todoModel) async {
    await dbHelper.addTodo(todoModel);
  }

  /// edit todos
  void updateTodo(TodoModel todoModel) async {
    await dbHelper.updateTodo(todoModel);
  }
  /// toggle status

  void toggleTodoStatus({required TodoModel todoModel}) async {
    final updatedTodo = TodoModel(
      id: todoModel.id,
      todoTitle: todoModel.todoTitle,
      todoMsg: todoModel.todoMsg,
      isDone: todoModel.isDone == 0 ? 1 : 0, // inverse le status
    );
    await dbHelper.updateTodo(updatedTodo);
    fetchAllTodos();
  }

  /// get total todos
  int get totalTodos => todoList.length;

  int get completedTodo =>
      todoList.where((element) => element.isDone== 1).length;
  double get percentCompleted => (completedTodo/totalTodos)*100;
}