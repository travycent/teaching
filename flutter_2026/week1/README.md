# Week 1: Dart Basics

Flutter apps are written in **Dart**. This week we learn the core of the language using
small, standalone programs. There's no Flutter yet, just Dart printing to the terminal.

If you already know **Java** or **Python**, most of this will feel familiar. The comments in
each file point out the similarities and differences.

## How to run this week's code

Every file in this folder is a complete program with its own `main()` function,
so you can run each one on its own:

```bash
cd flutter_2026/week1
dart run variables.dart
```

Or in **VS Code**: open any file and click **Run** above `void main()` (or press **F5**).

> **Why `main()`?** Every Dart program starts running from a function called `main`.
> If a file has no `main()`, Dart doesn't know where to start.

## Lessons (work through them in this order)

| # | File | What you'll learn | Run it |
|---|------|-------------------|--------|
| 1 | [variables.dart](variables.dart) | `var`, explicit types, `final` vs `const`, string interpolation | `dart run variables.dart` |
| 2 | [controlstructures.dart](controlstructures.dart) | `if` / `else if` / `else`, `for` loops, `while` loops | `dart run controlstructures.dart` |
| 3 | [functions.dart](functions.dart) | Functions, arrow syntax `=>`, named & `required` parameters, default values | `dart run functions.dart` |
| 4 | [collections.dart](collections.dart) | `List` and `Map`, looping with `for-in` | `dart run collections.dart` |
| 5 | [nullsafety.dart](nullsafety.dart) | Nullable types `String?`, `?.`, `??`, type promotion | `dart run nullsafety.dart` |
| 6 | [classes.dart](classes.dart) | Classes, constructors, inheritance with `extends`, `@override` | `dart run classes.dart` |

## Key ideas

### Variables
```dart
var name = 'Alice';        // type is inferred (String)
String city = 'Kampala';   // type written explicitly
final int age = 25;        // can only be assigned once (decided at runtime)
const double pi = 3.14159; // fixed at compile time
print('$name is $age');    // $ inserts a variable into a string
print('Next year: ${age + 1}'); // ${ } for expressions
```

### Functions and named parameters
Named parameters (in `{ }`) are used **everywhere** in Flutter, so get comfortable with them:
```dart
void greet({required String name, String greeting = 'Hello'}) {
  print('$greeting, $name!');
}

greet(name: 'Beatrice');                  // Hello, Beatrice!
greet(name: 'Sam', greeting: 'Hey there'); // Hey there, Sam!
```

### Null safety
By default a variable **cannot** be `null`. Add `?` to the type to allow it:
```dart
String? nickname;              // may be null
print(nickname?.length);       // ?.  only call if not null (else gives null)
print(nickname ?? 'Anonymous'); // ??  use a fallback if null
```

### Classes
```dart
class Person {
  String name;
  int age;
  Person(this.name, this.age); // shorthand constructor
}

class Student extends Person {  // inheritance
  String school;
  Student(String name, int age, this.school) : super(name, age);
}
```

## Exercises

1. In `variables.dart`, try uncommenting `age = 26;`. What error do you get and why?
2. In `controlstructures.dart`, change `score` to `95` and then `40`. Predict the output before running.
3. In `functions.dart`, write a function `isEven(int n)` using arrow syntax that returns a `bool`.
4. In `collections.dart`, add a new person to the `ages` map and print everyone using a `for` loop
   over `ages.entries`.
5. In `nullsafety.dart`, call `findNickname` with your own name. What gets printed?
6. In `classes.dart`, create a `Teacher` class that extends `Person` and adds a `subject`.
   Override `introduce()` and call it from `main()`.
