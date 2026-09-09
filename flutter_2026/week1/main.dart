void variables(){
    // type inference, like var in Java or just assignment in Python
    var name = 'Alice';        // inferred as String
    String city = 'Kampala';   // explicit type, same idea as Java

    // final = "assign once" (like Java's `final`, similar to a Python constant convention)
    final int age = 25;
    // age = 26; // ERROR: can't reassign a final variable

    // const = compile-time constant (stronger than final, must be known at compile time)
    const double pi = 3.14159;

    print('$name lives in $city, age $age'); // string interpolation with $
    print('Next year: ${age + 1}');          // ${} for expressions
}