void collections(){
  List<String> fruits = ['Apple', 'Banana', 'Orange'];
  fruits.add('Mango'); // Adding an element to the list
  //print(fruits); // Output: [Apple, Banana, Orange, Mango]

  for (var fruit in fruits) {
    print(fruit); // Output: Apple, Banana, Orange, Mango
  }

  Map<String, int> ages = {
    'Alice': 25,
    'Bob': 30,
    'Charlie': 35,
  };
  print(ages['Alice']); // Output: 25
  print(ages['Bob']);   // Output: 30
  print(ages['Charlie']); // Output: 35

}