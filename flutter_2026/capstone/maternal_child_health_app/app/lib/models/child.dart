import 'app_user.dart';

class Child {
  final AppUser mother;
  String name, father, gender;
  DateTime dob;
  double birthWeight;
  Child(this.mother, this.name, this.father, this.dob, this.gender,
      this.birthWeight);
}
