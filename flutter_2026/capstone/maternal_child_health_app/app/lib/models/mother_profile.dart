import 'app_user.dart';

class MotherProfile {
  final AppUser user;
  DateTime dob;
  DateTime? due;
  String address, marital;
  MotherProfile(this.user, this.dob, this.due, this.address, this.marital);
}
