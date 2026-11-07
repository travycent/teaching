import 'package:flutter/material.dart';
import 'package:toddo_app/models/tasks.dart';

// The to-do screen. The list of tasks changes while the app runs, so this is a
// StatefulWidget: the widget itself is fixed, and the changing data lives in
// its State class below.
class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  // All the tasks on screen. `final` means we can't replace the list with a new
  // one, but we can still add to it and remove from it.
  final List<Task> _tasks = [];

  // A controller lets us read (and clear) whatever the user typed in the TextField.
  final TextEditingController _taskController = TextEditingController();

  void _addTask() {
    // trim() removes spaces at the start and end, so "   " counts as empty.
    final text = _taskController.text.trim();
    // Guard clause: if there is nothing to add, stop here.
    if (text.isEmpty) return;

    // Changing the list inside setState tells Flutter to run build() again,
    // so the new task appears on screen.
    setState(() {
      _tasks.add(Task(text));
    });

    // Empty the text box so the user can type the next task.
    _taskController.clear();
  }

  // Flip a task between done and not done. `!` turns true into false and back.
  void _toggleTask(int index) {
    setState(() {
      _tasks[index].isDone = !_tasks[index].isDone;
    });
  }

void _toggleImportant(int index) {
  setState(() {
    _tasks[index].isImportant = !_tasks[index].isImportant;
  });
}

  Future<void> _deleteTask(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!mounted) return;

    final removedTask = _tasks[index];
    setState(() {
      _tasks.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Task deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _tasks.insert(index, removedTask);
            });
          },
        ),
      ),
    );
  }
  
  void _clearCompleted() {
  setState(() {
    _tasks.removeWhere((t) => t.isDone); 
  });
 
}

  // dispose() runs when this screen is removed. Controllers hold on to
  // resources, so we must dispose them ourselves to avoid memory leaks.
  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Tasks (${_tasks.where((t) => !t.isDone).length} left)'),
      actions: [
        IconButton(
          icon: const Icon(Icons.delete_sweep),
          tooltip: 'Clear completed',
          onPressed: _tasks.any((t) => t.isDone) ? _clearCompleted : null,
          ),
      ],
      ),
   
      // Column stacks its children top to bottom: the input row, then the list.
     
      body: Column(
        children: [
          // --- Input row: text box + Add button ---
          Padding(
            padding: const EdgeInsets.all(16),
            // Row places its children side by side.
            child: Row(
              children: [
                // Expanded makes the TextField take all the width the button
                // doesn't need. Without it, a TextField inside a Row crashes
                // because it doesn't know how wide to be.
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a task',
                      border: OutlineInputBorder(),
                    ),
                    // Pressing Enter on the keyboard also adds the task.
                    // `_` means "we get a value here but don't need it".
                    onSubmitted: (_) => _addTask(),
                  ),
                ),

                const SizedBox(width: 8), // a small gap between box and button
                FilledButton(onPressed: _addTask, child: const Text('Add')),
              ],
            ),
          ),

          // --- Task list ---
          // Expanded gives the list all the remaining height under the input row.
          Expanded(
            // Ternary: show a friendly message when empty, otherwise the list.
            child: _tasks.isEmpty
                ? const Center(child: Text('No tasks yet! Add one above.'))
                // ListView.builder only builds the rows that are visible, so it
                // stays fast even with a very long list.
                : ListView.builder(
                    itemCount: _tasks.length,
                    // Called once per row. `index` is the row number (0, 1, 2, ...).
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      // ListTile is a ready-made row with leading / title / trailing slots.
                      return ListTile(
                        onLongPress: () => _toggleImportant(index),
                        // Left side: checkbox shows and toggles isDone.
                        leading: Checkbox(
                          value: task.isDone,
                          onChanged: (_) => _toggleTask(index),
                        ),

                        // Middle: the task text. Finished tasks are crossed out
                        // and grey. `null` means "use the normal style".
                        title: Text(
                          task.title,
                          style: TextStyle(
                            decoration: task.isDone
                                ? TextDecoration.lineThrough
                                : null,
                            color: task.isDone ? Colors.grey : (task.isImportant ? Colors.red : null),
                          ),
                        ),

                        // Right side: delete button.
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _deleteTask(index),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
