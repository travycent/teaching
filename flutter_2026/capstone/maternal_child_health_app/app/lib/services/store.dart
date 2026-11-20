import '../models/app_user.dart';
import '../models/appointment.dart';
import '../models/child.dart';
import '../models/growth_record.dart';
import '../models/immunization.dart';
import '../models/mother_profile.dart';
import '../models/visit.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
class Store {
  static List<AppUser> users = [
    AppUser('Admin', 'admin@mch.com', '0700000001',('Pass#1'), 'Admin'),
    AppUser('Nurse Jane', 'worker@mch.com', '0700000002',('Pass#1'),
        'Health Worker'),
    AppUser('Mary', 'mother@mch.com', '0700000003',('Pass#1'), 'Mother'),
  ];
  static final List<MotherProfile> profiles = [];
  static final List<Child> children = [];
  static final List<Visit> visits = [];
  static final List<GrowthRecord> growth = [];
  static final List<Immunization> immunizations = [];
  static final List<Appointment> appointments = [];
  static int smsSent = 0;
  static AppUser? current;

  static List<AppUser> get mothers =>
      users.where((u) => u.role == 'Mother').toList();
      static String hashPassword(String plainTextPassword) {
    final bytes = utf8.encode(plainTextPassword);
    return sha256.convert(bytes).toString();
  }
}
