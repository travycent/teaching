# Week 4: Finishing the To-Do App (Saving, Editing, and Swipe to Delete)

This week we finished the to-do app we started in week 3. Tasks are now **saved on the
device**, so they are still there after you close the app. You can also **edit** and
**swipe to delete** tasks.

There is no new project this week. The code is in the same app as week 3:
**[week3/toddo_app](../week3/toddo_app/)**

## How to run this week's code

```bash
cd flutter_2026/week3/toddo_app
flutter pub get
flutter run
```

Or in **VS Code**: open [lib/main.dart](../week3/toddo_app/lib/main.dart) and press **F5**.

Run the tests with:
```bash
flutter test
```

We added a package this week, so run `flutter pub get` again even if you ran the app
in week 3.

## What changed in the project

Two new folders were added to `lib/`:

```
lib/
├── main.dart
├── models/
│   └── tasks.dart            # + toJson() and Task.fromJson
├── screens/
│   └── todo_page.dart        # + loading, saving, and editing
├── services/                 # NEW
│   └── task_storage.dart     # saves and loads tasks on the device
└── widgets/                  # NEW
    ├── task_tile.dart        # one row in the list
    └── edit_task_dialog.dart # pop-up for renaming a task
```

- **services/** do jobs for the app that have no UI, like saving data.
- **widgets/** hold smaller reusable pieces of UI that screens are built from.

We also added the `shared_preferences` package to `pubspec.yaml`.

## What we built in class

| Feature | Where to look |
|---------|---------------|
| Tasks are saved and loaded with `shared_preferences` | [lib/services/task_storage.dart](../week3/toddo_app/lib/services/task_storage.dart) |
| `Task` can turn into JSON and back | `toJson()` and `Task.fromJson` in [tasks.dart](../week3/toddo_app/lib/models/tasks.dart) |
| Spinner while saved tasks load | `initState`, `_loadTasks()`, `_isLoading` in [todo_page.dart](../week3/toddo_app/lib/screens/todo_page.dart) |
| Every change is saved automatically | `_update()` in [todo_page.dart](../week3/toddo_app/lib/screens/todo_page.dart) |
| Each row is its own widget | [lib/widgets/task_tile.dart](../week3/toddo_app/lib/widgets/task_tile.dart) |
| Swipe left to delete (replaces the week 3 delete button) | `Dismissible` in `TaskTile` |
| Tap a task to edit it | [lib/widgets/edit_task_dialog.dart](../week3/toddo_app/lib/widgets/edit_task_dialog.dart), `_editTask()` |

## Key ideas

### `async` / `await` and `Future`
Reading from storage takes a moment. A `Future` is a value that arrives later, and
`await` waits for it without freezing the app:
```dart
Future<void> _loadTasks() async {
  final loaded = await _storage.load();
  if (!mounted) return; // the user may have left the screen while we waited
  setState(() => _tasks = loaded);
}
```

### `initState`
`initState()` runs once, when the screen is first created. It's where we start loading
the saved tasks.

### JSON
Storage only understands simple values, so we turn each `Task` into a `Map` (`toJson`)
and the whole list into one string (`jsonEncode`). Loading does the reverse with
`jsonDecode` and `Task.fromJson`.

### Passing functions into widgets
`TaskTile` doesn't change any data itself. The screen gives it `onToggle`, `onDelete`,
and `onEdit` (`VoidCallback`s), and the tile calls them when the user taps or swipes.

### Getting a value back from a dialog
`showDialog` returns a `Future`. `Navigator.pop(value)` closes the dialog and sends
`value` back, and a plain `pop()` sends back `null`.

### Testing with saved data
Tests have no real device storage, so we give `shared_preferences` a fake one with
`SharedPreferences.setMockInitialValues({})`. Because the app now loads before showing
the page, tests call `pumpAndSettle()` to wait for loading to finish.

## Next week

We start a new project: a backend API with a database. See [week 5](../week5/README.md).
