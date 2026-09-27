// Run me with:  dart run variables.dart

void variables() {
  // type inference, like var in Java or just assignment in Python
  var name = 'Alice'; // inferred as String
  String city = 'Kampala'; // explicit type, same idea as Java

  // final = "assign once" (like Java's `final`, similar to a Python constant convention)
  final int age = 25;
  // age = 26; // ERROR: can't reassign a final variable

  // const = compile-time constant (stronger than final, must be known at compile time)
  const double pi = 3.14159;
  // pi = 3.0; // ERROR: can't reassign a const either

  print('$name lives in $city, age $age'); // string interpolation with $
  print('Next year: ${age + 1}'); // ${} for expressions
  print('Area of a circle with radius 2: ${pi * 2 * 2}');
}

// Every Dart program starts running from main()
void main() {
  variables();
}
