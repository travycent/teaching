import '../models/app_user.dart';
import '../models/appointment.dart';
import '../models/child.dart';
import '../models/growth_record.dart';
import '../models/immunization.dart';
import '../models/mother_profile.dart';
import '../models/visit.dart';
import 'store.dart';

void seedDemoData() {
  final now = DateTime.now();
  final mary = Store.users.firstWhere((u) => u.email == 'mother@mch.com');
  final grace =
      AppUser('Grace Akello', 'grace@mch.com', '0700000004', '1234', 'Mother');
  final sarah =
      AppUser('Sarah Nambi', 'sarah@mch.com', '0700000005', '1234', 'Mother');
  Store.users.addAll([
    grace,
    sarah,
    AppUser('Nurse Peter', 'peter@mch.com', '0700000006', '1234',
        'Health Worker'),
  ]);

  Store.profiles.addAll([
    MotherProfile(mary, DateTime(1995, 3, 12),
        now.add(const Duration(days: 60)), 'Kampala', 'Married'),
    MotherProfile(grace, DateTime(1998, 7, 2),
        now.add(const Duration(days: 20)), 'Entebbe', 'Single'),
    MotherProfile(sarah, DateTime(1992, 11, 21), null, 'Jinja', 'Married'),
  ]);

  final joy = Child(mary, 'Baby Joy', 'John',
      now.subtract(const Duration(days: 120)), 'Female', 3.2);
  final liam = Child(grace, 'Liam', 'David',
      now.subtract(const Duration(days: 300)), 'Male', 3.5);
  Store.children.addAll([joy, liam]);

  Store.visits.addAll([
    Visit(mary, now.subtract(const Duration(days: 12)), '118/76', 62.5,
        'Routine check, all well'),
    Visit(mary, now.subtract(const Duration(days: 45)), '120/80', 61.0,
        'First visit'),
    Visit(grace, now.subtract(const Duration(days: 8)), '150/95', 70.2,
        'High BP, advised to rest and return in one week'),
    Visit(sarah, now.subtract(const Duration(days: 75)), '110/70', 58.4,
        'Routine check'),
    Visit(grace, now.subtract(const Duration(days: 100)), '125/82', 68.0,
        'Second visit'),
  ]);

  Store.growth.addAll([
    GrowthRecord(joy, now.subtract(const Duration(days: 120)), 3.2, 50),
    GrowthRecord(joy, now.subtract(const Duration(days: 90)), 4.4, 54),
    GrowthRecord(joy, now.subtract(const Duration(days: 60)), 5.3, 58),
    GrowthRecord(joy, now.subtract(const Duration(days: 30)), 6.1, 61),
    GrowthRecord(liam, now.subtract(const Duration(days: 60)), 8.2, 70),
    GrowthRecord(liam, now.subtract(const Duration(days: 10)), 8.9, 73),
  ]);

  Store.immunizations.addAll([
    Immunization(joy, 'BCG', '1', 'B-1001',
        now.subtract(const Duration(days: 118)),
        now.subtract(const Duration(days: 90))),
    Immunization(joy, 'Pentavalent', '1', 'P-2040',
        now.subtract(const Duration(days: 40)),
        now.subtract(const Duration(days: 12))),
    Immunization(joy, 'OPV', '1', 'O-3321',
        now.subtract(const Duration(days: 10)),
        now.add(const Duration(days: 18))),
    Immunization(liam, 'Measles', '1', 'M-7788',
        now.subtract(const Duration(days: 20)),
        now.add(const Duration(days: 8))),
  ]);

  Store.appointments.addAll([
    Appointment(mary,
        DateTime(now.year, now.month, now.day, 9, 0)
            .add(const Duration(days: 5)),
        'Pending'),
    Appointment(grace,
        DateTime(now.year, now.month, now.day, 10, 30)
            .subtract(const Duration(days: 2)),
        'Pending'),
  ]);
  Store.smsSent = 3;
}
