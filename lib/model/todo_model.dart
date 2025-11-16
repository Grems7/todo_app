import 'package:todo_getx/database/db_helper.dart';

class TodoModel {
  int? id;
  String todoTitle;
  String todoMsg;
  int isDone;

  TodoModel({this.id,required this.todoTitle, required this.todoMsg, this.isDone=0});

  /// ----from map ----///
  factory TodoModel.fromMap(Map<String, dynamic> map){
    return TodoModel(
        id: map[DBHelper.columnTodoId],
        todoTitle: map[DBHelper.columnTodoTitle],
        todoMsg: map[DBHelper.columnTodoMsg],
        isDone: map[DBHelper.columnTodoIsdone],
    );
  }


 /// ----to map ----///
  Map<String, dynamic> toMap(){
    return{
      DBHelper.columnTodoId : id,
      DBHelper.columnTodoTitle : todoTitle,
      DBHelper.columnTodoMsg : todoMsg,
      DBHelper.columnTodoIsdone : isDone,
    };
  }
}