// A model is a plain Dart class that describes our data. It has no UI code.
// Each item in the to-do list is one Task.
class Task {
  String title;
  bool isDone;
  bool isImportant;

  // `this.title` is required and positional: Task('Buy milk').
  // `{this.isDone = false}` is a named parameter with a default value, so a new
  // task starts unfinished unless we say otherwise: Task('Buy milk', isDone: true).
  Task(this.title, {this.isDone = false, this.isImportant = false});
}
