// Run me with:  dart run functions.dart

// Basic function — looks just like Java minus the access modifier requirement
int add(int a, int b) {
  return a + b;
}

// Arrow syntax for one-line functions (like a lambda, but for named functions too)
int square(int x) => x * x; // same as { return x * x; } but shorter

// Optional named parameters — this one is very Flutter-specific and important
void greet({required String name, String greeting = 'Hello'}) {
  print('$greeting, $name!');
}

//ANSWER 3
//isEven checks whether a numberis using arrow syntax (=>) otherwise false.
//isEven (4) printed true, and isEven (7) printed false.

void main() {
  print(add(2, 3));
  print(square(5));
  print(isEven(4));
  print(isEven(7));
  greet(name: 'Beatrice');                    // uses default greeting
  greet(name: 'Sam', greeting: 'Hey there');   // overrides it
}

bool isEven(int n) => n % 2 == 0;