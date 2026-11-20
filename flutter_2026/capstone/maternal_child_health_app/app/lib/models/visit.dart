import 'app_user.dart';

class Visit {
  final AppUser mother;
  DateTime date;
  String bp, notes;
  double weight;
  Visit(this.mother, this.date, this.bp, this.weight, this.notes);
}
