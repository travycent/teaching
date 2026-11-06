// Run me with:  dart run collections.dart

void collections() {
  List<String> fruits = ['Apple', 'Banana', 'Orange'];
  fruits.add('Mango'); // Adding an element to the list
  print(fruits); // Output: [Apple, Banana, Orange, Mango]

  for (var fruit in fruits) {
    print(fruit); // Output: Apple, Banana, Orange, Mango (one per line)
  }

  Map<String, int> ages = {
    
     'Alice': 25,
    'Bob': 30,
    'Charlie': 35,
  };
  print(ages['Alice']); // Output: 25
  print(ages['Bob']); // Output: 30
  print(ages['Charlie']); // Output: 35

//ANSWER 4
// we added a new person to the ages map using ages[' Shau_faizah_faith'] =27;
//then we used a for loop over ages.etries to print everyone. 
//entry.key is the name andentry.value is the age.

  ages['Shau_faizah_faith'] = 27;
    for (var entry in ages.entries)
    {
      print('${entry.key} are ${entry.value}');

    }
}

void main() {
  collections();
}
