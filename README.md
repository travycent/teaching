# Flutter 2026 Course

Code and notes for a weekly course on building apps with **Dart** and **Flutter**.
Each week lives in its own folder under [`flutter_2026/`](flutter_2026/) and has its own README with the lesson notes.

## Weekly lessons

| Week | Topic | Folder |
|------|-------|--------|
| 1 | Dart basics: variables, control flow, functions, collections, null safety, classes | [week1](flutter_2026/week1/README.md) |
| 2 | Your first Flutter app: the counter app, widgets, `setState` | [week2](flutter_2026/week2/) |

<!-- Add a new row here each week -->

---

## 1. Setting up your computer

You need three things installed:

1. **Flutter SDK** (Dart comes bundled with it). Follow the official guide for your OS:
   https://docs.flutter.dev/get-started/install
2. **VS Code** with the **Flutter** extension (this also installs the Dart extension).
3. **Git** so you can download this repository.

Check that everything works by running this in a terminal:

```bash
flutter doctor
dart --version
```

`flutter doctor` lists anything still missing. For this course you only need a green tick
next to **Flutter** and at least one device (Chrome or macOS/Windows desktop is fine to start).
Android Studio and Xcode are only needed later when we run on phones.

## 2. Getting the code

```bash
git clone <repo-url>
cd teaching
```

To get the latest lessons each week:

```bash
git pull
```

## 3. Running code

There are two kinds of code in this course, and they run differently.

### A. Plain Dart files (e.g. week 1)

A single `.dart` file with a `main()` function. Run it from the terminal:

```bash
cd flutter_2026/week1
dart run variables.dart
```

The output is printed straight to the terminal.

**In VS Code:** open the file and click the **Run** link that appears just above `void main()`,
or press **F5**.

### B. Flutter apps (week 2 onwards)

A Flutter app is a whole folder (a *project*) containing a `pubspec.yaml` file.
Always `cd` into that folder first:

```bash
cd flutter_2026/week2/counter_app
flutter pub get          # download the app's packages (first time only)
flutter devices          # see which devices you can run on
flutter run -d chrome    # run in the Chrome browser
flutter run -d macos     # or as a desktop app (use -d windows on Windows)
```

While the app is running, in the terminal press:

| Key | What it does |
|-----|--------------|
| `r` | **Hot reload**: apply your code changes instantly, keeping the app's state |
| `R` | **Hot restart**: restart the app from scratch |
| `q` | Quit |

**In VS Code:** open the project folder, pick a device in the bottom-right status bar,
open `lib/main.dart` and press **F5**. Saving a file triggers a hot reload automatically.

### Other useful commands

```bash
dart analyze             # check Dart code for errors and warnings
flutter analyze          # same, for a Flutter project
flutter test             # run the tests in the project's test/ folder
dart format .            # auto-format all code in the current folder
```

## 4. Troubleshooting

| Problem | Fix |
|---------|-----|
| `command not found: dart` / `flutter` | Flutter's `bin` folder isn't on your PATH. Revisit the install guide. |
| `Could not find a file named "pubspec.yaml"` | You ran a `flutter` command outside an app folder. `cd` into the app first. |
| `No devices found` | Run `flutter devices`. Use `-d chrome` if nothing else is set up. |
| Red squiggles everywhere in a Flutter app | Run `flutter pub get` inside the app folder. |
| `Error: Undefined name 'main'` | The file has no `main()` function, so there's nothing to run. |

## Repository layout

```
teaching/
├── README.md            ← you are here
└── flutter_2026/
    ├── week1/           ← Dart language basics (plain .dart files)
    └── week2/           ← Flutter counter app
```
