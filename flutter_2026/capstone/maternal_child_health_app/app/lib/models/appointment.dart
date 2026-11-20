import 'app_user.dart';

class Appointment {
  final AppUser mother;
  DateTime when;
  String status;
  Appointment(this.mother, this.when, this.status);
}
