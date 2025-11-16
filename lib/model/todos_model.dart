class TodosModel {
  String? id;
  String? todoTitle;
  String? todoMsg;
  bool? isDone;
  String? category;
  String? date; // yyyy-MM-dd
  String? startTime; // ex: "13:00"
  String? endTime;   // ex: "15:00"
  String? userId;

  TodosModel({
    this.id,
    this.todoTitle,
    this.todoMsg,
    this.isDone = false,
    this.category = "General",
    this.date,
    this.startTime,
    this.endTime,
    this.userId,
  });

  factory TodosModel.fromJson(Map<String, dynamic> json) => TodosModel(
    id: json['_id'],
    todoTitle: json['todoTitle'],
    todoMsg: json['todoMsg'],
    isDone: json['isDone'],
    category: json['category'],
    date: json['date'],
    startTime: json['startTime'],
    endTime: json['endTime'],
    userId: json['userId'],
  );

  Map<String, dynamic> toJson() => {
    'todoTitle': todoTitle,
    'todoMsg': todoMsg,
    'isDone': isDone,
    'category': category,
    'date': date,
    'startTime': startTime,
    'endTime': endTime,
    'userId': userId,
  };
}
