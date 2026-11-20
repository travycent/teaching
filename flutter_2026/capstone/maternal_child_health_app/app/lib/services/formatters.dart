import 'store.dart';

const kMonths = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
];

String fmtDate(DateTime d) => '${d.day} ${kMonths[d.month - 1]} ${d.year}';

String fmtTime(DateTime d) {
  final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
  final m = d.minute.toString().padLeft(2, '0');
  return '$h:$m ${d.hour >= 12 ? 'PM' : 'AM'}';
}

int overdueCount() {
  final now = DateTime.now();
  return Store.appointments
          .where((a) => a.status == 'Pending' && a.when.isBefore(now))
          .length +
      Store.immunizations.where((i) => i.nextDue.isBefore(now)).length;
}
