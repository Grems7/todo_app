import 'package:get/get.dart';
import 'package:todo_getx/network/api_service.dart';
import '../model/todos_model.dart';
import '../utils/pref_helper.dart';
import 'package:intl/intl.dart';
class TodosController extends GetxController {
  final ApiService _apiService = ApiService();
  final RxList<TodosModel> todoList = <TodosModel>[].obs;

  /// ================================
  /// 🔹 Charger tous les todos d’un utilisateur
  /// ================================
  Future<void> fetchTodosForUser() async {
    try {
      final userId = await PrefHelper.getId();
      if (userId == null) {
        print("⚠️ Aucun utilisateur connecté");
        return;
      }

      final response = await _apiService.get("/todos/$userId");
      if (response is List) {
        todoList.assignAll(response.map((e) => TodosModel.fromJson(e)).toList());
      } else {
        print("⚠️ Format inattendu pour les todos : $response");
      }
    } catch (e) {
      print("❌ Erreur lors du fetchTodosForUser: $e");
    }
  }

  /// ================================
  /// 🔹 Ajouter un nouveau todo
  /// ================================
  Future<void> addTodo(TodosModel todo) async {
    try {
      final userId = await PrefHelper.getId();
      if (userId == null) {
        print("⚠️ Aucun utilisateur connecté");
        return;
      }

      final body = todo.toJson();
      body['userId'] = userId;

      await _apiService.post("/todos", body);
      print(todo.toJson());
      await fetchTodosForUser();
    } catch (e) {
      print("❌ Erreur lors du addTodo: $e");
    }
  }

  /// ================================
  /// 🔹 Mettre à jour un todo existant
  /// ================================
  Future<void> updateTodo(TodosModel todo) async {
    try {
      if (todo.id == null) return;

      final body = {
        "todoTitle": todo.todoTitle,
        "todoMsg": todo.todoMsg,
        "category": todo.category,
        "date": todo.date,
        "isDone": todo.isDone,
        'startTime': todo.startTime,
        'endTime': todo.endTime,
      };

      await _apiService.put("/todos/${todo.id}", body);
      await fetchTodosForUser();
    } catch (e) {
      print("❌ Erreur lors du updateTodo: $e");
    }
  }

  /// ================================
  /// 🔹 Basculer le statut (fait / non fait)
  /// ================================
  Future<void> toggleTodoStatus(TodosModel todo) async {
    try {
      if (todo.id == null) return;

      final newStatus = !(todo.isDone == true);
      await _apiService.put("/todos/${todo.id}", {'isDone': newStatus});
      await fetchTodosForUser();
    } catch (e) {
      print("❌ Erreur toggleTodoStatus: $e");
    }
  }

  /// ================================
  /// 🔹 Supprimer un todo
  /// ================================
  Future<void> deleteTodo(String? id) async {
    try {
      await _apiService.delete("/todos/$id", {});
      await fetchTodosForUser();
    } catch (e) {
      print("❌ Erreur deleteTodo: $e");
    }
  }


  double getDailyProgress(DateTime date) {
    final dayStr = DateFormat('yyyy-MM-dd').format(date);
    final dayTodos = todoList.where((t) => t.date == dayStr).toList();
    if (dayTodos.isEmpty) return 0.0;
    final doneCount = dayTodos.where((t) => t.isDone == true).length;
    return doneCount / dayTodos.length;
  }

  List<TodosModel> getTodosForHour(DateTime selectedDay, String hour) {
    return todoList.where((t) =>
    t.date == DateFormat('yyyy-MM-dd').format(selectedDay) &&
        t.startTime?.startsWith(hour) == true
    ).toList();
  }


  /// ================================
  /// 🔹 Auto fetch au démarrage
  /// ================================
  @override
  void onInit() {
    super.onInit();
    fetchTodosForUser();
  }
}
