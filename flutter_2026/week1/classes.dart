// Run me with:  dart run classes.dart

class Person {
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

//ANSWER6
//Teacher extends Person, so it gets name and age from Person (Inheritance). It adds its own field subject.
//super (name, age, ) passes name and age to the Person constructor. @override replaces Person's introduce ()with Teacher's own version.   

class Teacher extends Person {
  String subject;

  Teacher(String name, int age, this.subject) : super(name, age);

  @override
  void introduce() {
    print("Hi, our names are $name, we are $age years old and we study  $subject.");
  }
}

void main() {
  var person = Person('Alice', 30);
  person.introduce();

  var student = Student('Sam', 20, 'Makerere University');
  student.introduce(); // uses the overridden version from Student
  
  var teacher = Teacher('Shau_faizah_faith', 40, 'Math_science_english');
  teacher.introduce(); // uses the overridden version from 
  
}
