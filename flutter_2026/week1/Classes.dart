class Person{
  String name;
  int age;

  Person(this.name, this.age);

  void introduce() {
    print("Hi, my name is $name and I am $age years old.");
  }
}

//inheritance
class Student extends Person {
  String school;

  Student(String name, int age, this.school) : super(name, age);

  @override
  void introduce() {
    print("Hi, my name is $name, I am $age years old and I study at $school.");
  }
}