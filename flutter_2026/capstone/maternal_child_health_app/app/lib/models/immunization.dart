import 'child.dart';

class Immunization {
  final Child child;
  String vaccine, dose, batch;
  DateTime given, nextDue;
  Immunization(
      this.child, this.vaccine, this.dose, this.batch, this.given, this.nextDue);
}
