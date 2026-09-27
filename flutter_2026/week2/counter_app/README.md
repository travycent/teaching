# Week 2: Your First Flutter App (Counter)

This week we moved from plain Dart to **Flutter**. We took the default counter app and
extended it so we could see how a screen updates when data changes.

## How to run this week's code

```bash
cd flutter_2026/week2/counter_app
flutter run
```

Or in **VS Code**: open [lib/main.dart](lib/main.dart) and press **F5**.

> **Tip:** While the app is running, save the file (or press `r` in the terminal) to
> **hot reload**. Your changes show up in about a second, and the counter keeps its value.

## What we built in class

| Feature | Where to look in `main.dart` |
|---------|------------------------------|
| **−** button that decreases the count | `_decrementCounter()` |
| **Reset** button in the top bar | `_resetCounter()` and `AppBar(actions: ...)` |
| Number changes color: red below 0, grey at 0, green above 0 | the `color:` inside the counter `Text` |
| Two buttons side by side in the corner | `floatingActionButton: Row(...)` |

## Key ideas

### `setState` redraws the screen
Changing a variable on its own does **nothing** visible. Wrap the change in `setState`
so Flutter knows to run `build()` again:
```dart
void _resetCounter() {
  setState(() {
    _counter = 0;
  });
}
```

### Conditionals inside widgets
The ternary operator `condition ? a : b` lets you choose a value right inside a widget:
```dart
color: _counter < 0
    ? Colors.red
    : (_counter == 0 ? Colors.grey : Colors.green),
```

### Showing a widget only sometimes
Use `if` inside a list of `children`:
```dart
children: [
  Text('$_counter'),
  if (_counter > 10) const Text('That is a lot of taps!'),
],
```

## Assignment (due before next week)

Add **one** new feature on your own, and pick the one you like. Each option needs
`setState` and at least one conditional.

1. **Step size.** Add a way to count by 5 instead of 1. For example, a third button
   or a `Switch` that toggles between steps of 1 and 5. The + and − buttons should both
   respect the chosen step.
2. **Even / Odd label.** Show the word `Even` or `Odd` next to (or under) the number,
   and make sure it updates with every tap.
   *Hint:* `_counter % 2 == 0` is `true` when the number is even.
3. **Divisible by 5 message.** When the number is a multiple of 5 (5, 10, 15, ...),
   show a message such as `"High five! 🖐 That's a multiple of 5"`. Hide it for every
   other number.
   *Hint:* `_counter % 5 == 0`. What should happen at `0`? You decide, and explain
   your choice in a comment.

**Bonus:** do more than one, e.g. step size of 5 **and** the divisible-by-5 message.
What do you notice?

### Optional stretch: limits
Finished early? Keep the counter between **−10** and **10**.

- The number must never go past either limit.
- When the count reaches `10`, the **+** button should be disabled (greyed out), and
  when it reaches `-10`, the **−** button should be disabled.

*Hint:* a button with `onPressed: null` is disabled automatically:
```dart
onPressed: _counter < 10 ? _incrementCounter : null,
```
If you also did the step-size option, what happens at `8` with a step of 5?
Make sure the count still stops at the limit.

### What to bring next week
- Your updated `lib/main.dart`
- Be ready to explain in one or two sentences **where** you called `setState`
  and **why**.
