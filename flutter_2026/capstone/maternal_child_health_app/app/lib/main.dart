import 'package:flutter/material.dart';

void main() {
  seedDemoData();
  runApp(const MaternalHealthApp());
}

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

// =====================================================================
// DATA (kept in memory for now; later replace with your teammate's API)
// =====================================================================
class AppUser {
  String name, email, phone, password, role;
  bool active = true;
  AppUser(this.name, this.email, this.phone, this.password, this.role);
}

class MotherProfile {
  final AppUser user;
  DateTime dob;
  DateTime? due;
  String address, marital;
  MotherProfile(this.user, this.dob, this.due, this.address, this.marital);
}

class Child {
  final AppUser mother;
  String name, father, gender;
  DateTime dob;
  double birthWeight;
  Child(this.mother, this.name, this.father, this.dob, this.gender,
      this.birthWeight);
}

class Visit {
  final AppUser mother;
  DateTime date;
  String bp, notes;
  double weight;
  Visit(this.mother, this.date, this.bp, this.weight, this.notes);
}

class GrowthRecord {
  final Child child;
  DateTime date;
  double weight, height;
  GrowthRecord(this.child, this.date, this.weight, this.height);
}

class Immunization {
  final Child child;
  String vaccine, dose, batch;
  DateTime given, nextDue;
  Immunization(
      this.child, this.vaccine, this.dose, this.batch, this.given, this.nextDue);
}

class Appointment {
  final AppUser mother;
  DateTime when;
  String status;
  Appointment(this.mother, this.when, this.status);
}

class Store {
  static final List<AppUser> users = [
    AppUser('Admin', 'admin@mch.com', '0700000001', '1234', 'Admin'),
    AppUser('Nurse Jane', 'worker@mch.com', '0700000002', '1234',
        'Health Worker'),
    AppUser('Mary', 'mother@mch.com', '0700000003', '1234', 'Mother'),
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
}

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
];

String fmtDate(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

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

// =====================================================================
// APP + THEME + BACKGROUND
// =====================================================================
class MaternalHealthApp extends StatelessWidget {
  const MaternalHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Maternal and Child Health',
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
      ),
      builder: (context, child) =>
          AppBackground(child: child ?? const SizedBox()),
      home: const WelcomeScreen(),
    );
  }
}

/// Shows assets/images/background.png faintly behind every screen.
/// If the picture is missing, the background is just white.
class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => const SizedBox(),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

// =====================================================================
// SHARED HELPERS
// =====================================================================
void go(BuildContext c, Widget w) =>
    Navigator.push(c, MaterialPageRoute(builder: (_) => w));

void logout(BuildContext c) {
  Store.current = null;
  Navigator.pushAndRemoveUntil(
    c,
    MaterialPageRoute(builder: (_) => const LoginScreen()),
    (route) => false,
  );
}

void snack(BuildContext c, String msg) =>
    ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text(msg)));

Widget gap([double h = 14]) => SizedBox(height: h);

Widget field(String label, TextEditingController c,
    {bool required = true,
    TextInputType? type,
    int lines = 1,
    bool numeric = false,
    ValueChanged<String>? onChanged}) {
  return TextFormField(
    controller: c,
    keyboardType: type,
    maxLines: lines,
    onChanged: onChanged,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    ),
    validator: (v) {
      final t = (v ?? '').trim();
      if (t.isEmpty) return required ? 'Required' : null;
      if (numeric && double.tryParse(t) == null) return 'Enter a number';
      return null;
    },
  );
}

Widget dropdown<T>({
  required String label,
  required T? value,
  required List<T> items,
  required String Function(T) text,
  required ValueChanged<T?> onChanged,
}) {
  return DropdownButtonFormField<T>(
    value: value,
    isExpanded: true,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    ),
    items: items
        .map((e) => DropdownMenuItem<T>(value: e, child: Text(text(e))))
        .toList(),
    onChanged: onChanged,
    validator: (v) => v == null ? 'Please select' : null,
  );
}

class DateField extends FormField<DateTime> {
  DateField({
    super.key,
    required String label,
    DateTime? initial,
    required ValueChanged<DateTime> onPicked,
    bool required = true,
  }) : super(
          initialValue: initial,
          validator: (v) => required && v == null ? 'Required' : null,
          builder: (state) {
            return InkWell(
              onTap: () async {
                final d = await showDatePicker(
                  context: state.context,
                  initialDate: state.value ?? DateTime.now(),
                  firstDate: DateTime(1950),
                  lastDate: DateTime(2100),
                );
                if (d != null) {
                  state.didChange(d);
                  onPicked(d);
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: label,
                  border: const OutlineInputBorder(),
                  errorText: state.errorText,
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                child: Text(state.value == null ? '' : fmtDate(state.value!)),
              ),
            );
          },
        );
}

class FormPage extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const FormPage({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Column(children: children),
          ),
        ),
      ),
    );
  }
}

Widget statCard(String label, String value, {VoidCallback? onTap}) {
  return Card(
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          children: [
            Text(value,
                style:
                    const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            Text(label),
          ],
        ),
      ),
    ),
  );
}

class LinePainter extends CustomPainter {
  final List<double> values;
  final Color color;
  LinePainter(this.values, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final axis = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), axis);
    canvas.drawLine(const Offset(0, 0), Offset(0, size.height), axis);
    if (values.isEmpty) return;
    double minV = values.first, maxV = values.first;
    for (final v in values) {
      if (v < minV) minV = v;
      if (v > maxV) maxV = v;
    }
    final range = (maxV - minV) == 0 ? 1.0 : (maxV - minV);
    final pts = <Offset>[];
    for (int i = 0; i < values.length; i++) {
      final x = values.length == 1
          ? size.width / 2
          : 10 + i * (size.width - 20) / (values.length - 1);
      final y = size.height - 12 - (values[i] - minV) / range * (size.height - 24);
      pts.add(Offset(x, y));
    }
    final line = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (final p in pts.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path, line);
    final dot = Paint()..color = color;
    for (final p in pts) {
      canvas.drawCircle(p, 4, dot);
    }
  }

  @override
  bool shouldRepaint(covariant LinePainter old) => true;
}

Widget growthChart(Child? child) {
  final recs = Store.growth.where((g) => g.child == child).toList()
    ..sort((a, b) => a.date.compareTo(b.date));
  return Container(
    height: 170,
    width: double.infinity,
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(8),
    ),
    child: recs.isEmpty
        ? const Center(child: Text('No growth records yet'))
        : CustomPaint(
            painter: LinePainter(recs.map((r) => r.weight).toList(), Colors.teal),
            size: Size.infinite,
          ),
  );
}

// =====================================================================
// WELCOME + AUTH SCREENS
// =====================================================================
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 60,
                child: Text('MCH',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              ),
              gap(24),
              const Text(
                'Welcome to Maternal and Child Health Monitoring System!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              gap(32),
              FilledButton(
                onPressed: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const LoginScreen())),
                child: const Text('Get Started'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget homeFor(AppUser u) {
  switch (u.role) {
    case 'Admin':
      return const AdminHome();
    case 'Health Worker':
      return const HealthWorkerHome();
    default:
      return const MotherHome();
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _id = TextEditingController();
  final _pass = TextEditingController();
  bool _hide = true;

  @override
  void dispose() {
    _id.dispose();
    _pass.dispose();
    super.dispose();
  }

  void _login() {
    if (!_form.currentState!.validate()) return;
    final id = _id.text.trim();
    final matches = Store.users.where(
        (u) => (u.email == id || u.phone == id) && u.password == _pass.text);
    if (matches.isEmpty) {
      snack(context, 'Wrong email/phone or password');
      return;
    }
    final u = matches.first;
    if (!u.active) {
      snack(context, 'This account is inactive');
      return;
    }
    Store.current = u;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => homeFor(u)));
  }

  @override
  Widget build(BuildContext context) {
    return FormPage(
      title: 'Login',
      children: [
        Form(
          key: _form,
          child: Column(
            children: [
              const CircleAvatar(
                radius: 45,
                child: Text('MCH',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              gap(12),
              const Text('Maternal & Child Health Platform',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Text('Sign in to continue'),
              gap(24),
              field('Email / Phone number', _id),
              gap(16),
              TextFormField(
                controller: _pass,
                obscureText: _hide,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _hide ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _hide = !_hide),
                  ),
                ),
                validator: (v) =>
                    (v == null || v.length < 4) ? 'Minimum 4 characters' : null,
              ),
              gap(20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                    onPressed: _login, child: const Text('Log in')),
              ),
              TextButton(
                onPressed: () => go(context, const ForgotPasswordScreen()),
                child: const Text('Forgot password?'),
              ),
              TextButton(
                onPressed: () => go(context, const RegisterScreen()),
                child: const Text('Create new account'),
              ),
              gap(8),
              const Text(
                'Demo logins (password 1234):\nmother@mch.com  |  worker@mch.com  |  admin@mch.com',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _pass = TextEditingController();
  String? _role = 'Mother';

  void _save() {
    if (!_form.currentState!.validate()) return;
    final email = _email.text.trim();
    if (Store.users.any((u) => u.email == email)) {
      snack(context, 'That email is already registered');
      return;
    }
    Store.users.add(AppUser(_name.text.trim(), email, _phone.text.trim(),
        _pass.text, _role ?? 'Mother'));
    snack(context, 'Account created');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return FormPage(
      title: 'New account',
      children: [
        Form(
          key: _form,
          child: Column(
            children: [
              field('Full name', _name),
              gap(),
              field('Email', _email, type: TextInputType.emailAddress),
              gap(),
              field('Phone', _phone, type: TextInputType.phone),
              gap(),
              TextFormField(
                controller: _pass,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Password', border: OutlineInputBorder()),
                validator: (v) =>
                    (v == null || v.length < 4) ? 'Minimum 4 characters' : null,
              ),
              gap(),
              dropdown<String>(
                label: 'Role',
                value: _role,
                items: const ['Mother', 'Health Worker', 'Admin'],
                text: (s) => s,
                onChanged: (v) => setState(() => _role = v),
              ),
              gap(20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                    onPressed: _save, child: const Text('Register')),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Have an account? Log in'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _form = GlobalKey<FormState>();
  final _id = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FormPage(
      title: 'Forgot password',
      children: [
        Form(
          key: _form,
          child: Column(
            children: [
              const CircleAvatar(
                radius: 45,
                child: Text('MCH',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              gap(16),
              const Text('Reset your password',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Text('Enter your email or phone number.\nWe send a code by SMS.',
                  textAlign: TextAlign.center),
              gap(20),
              field('Email or phone', _id),
              gap(16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (_form.currentState!.validate()) {
                      snack(context, 'Code sent (demo)');
                    }
                  },
                  child: const Text('Send code'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to log in'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =====================================================================
// HEALTH WORKER
// =====================================================================
class HealthWorkerHome extends StatefulWidget {
  const HealthWorkerHome({super.key});

  @override
  State<HealthWorkerHome> createState() => _HealthWorkerHomeState();
}

class _HealthWorkerHomeState extends State<HealthWorkerHome> {
  int _tab = 0;
  String _query = '';

  void _open(Widget w) => Navigator.push(
          context, MaterialPageRoute(builder: (_) => w))
      .then((_) => setState(() {}));

  Widget _action(String label, IconData icon, VoidCallback onTap) {
    return SizedBox(
      width: 150,
      height: 90,
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(icon, size: 30), gap(6), Text(label)],
          ),
        ),
      ),
    );
  }

  void _register() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('New account'),
              onTap: () {
                Navigator.pop(ctx);
                _open(const RegisterScreen());
              },
            ),
            ListTile(
              leading: const Icon(Icons.pregnant_woman),
              title: const Text('Mother profile'),
              onTap: () {
                Navigator.pop(ctx);
                _open(const MotherProfileScreen());
              },
            ),
            ListTile(
              leading: const Icon(Icons.child_care),
              title: const Text('Register child'),
              onTap: () {
                Navigator.pop(ctx);
                _open(const RegisterChildScreen());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _homeTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search patient',
            border: OutlineInputBorder(),
          ),
          onChanged: (v) => _query = v,
          onSubmitted: (v) => setState(() {
            _query = v;
            _tab = 1;
          }),
        ),
        gap(),
        Row(
          children: [
            Expanded(
                child: statCard('Visits', '${Store.visits.length}',
                    onTap: () => _open(const AncVisitScreen()))),
            Expanded(
                child: statCard('Overdue', '${overdueCount()}',
                    onTap: () => setState(() => _tab = 2))),
          ],
        ),
        gap(8),
        const Text('Quick actions',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        gap(8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            _action('Register', Icons.person_add, _register),
            _action('Visit', Icons.medical_services,
                () => _open(const AncVisitScreen())),
            _action('Growth', Icons.show_chart,
                () => _open(const GrowthRecordScreen())),
            _action('Vaccine', Icons.vaccines,
                () => _open(const ImmunizationScreen())),
            _action('Appointment', Icons.event,
                () => _open(const AppointmentScreen())),
          ],
        ),
        gap(16),
        FilledButton.tonal(
          onPressed: () => setState(() => _tab = 2),
          child: const Text('Patients overdue'),
        ),
      ],
    );
  }

  Widget _patientsTab() {
    final q = _query.toLowerCase();
    final mothers = Store.mothers
        .where((m) => m.name.toLowerCase().contains(q))
        .toList();
    final kids = Store.children
        .where((c) => c.name.toLowerCase().contains(q))
        .toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Mothers',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        if (mothers.isEmpty) const ListTile(title: Text('None found')),
        for (final m in mothers)
          Card(
            child: ListTile(
              leading: const Icon(Icons.pregnant_woman),
              title: Text(m.name),
              subtitle: Text(m.phone),
            ),
          ),
        gap(),
        const Text('Children',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        if (kids.isEmpty) const ListTile(title: Text('None found')),
        for (final c in kids)
          Card(
            child: ListTile(
              leading: const Icon(Icons.child_care),
              title: Text(c.name),
              subtitle: Text('Mother: ${c.mother.name} · Born ${fmtDate(c.dob)}'),
              onTap: () => go(context, ChildDetailScreen(child: c)),
            ),
          ),
      ],
    );
  }

  Widget _alertsTab() {
    final now = DateTime.now();
    final apps = Store.appointments
        .where((a) => a.status == 'Pending' && a.when.isBefore(now))
        .toList();
    final vacs =
        Store.immunizations.where((i) => i.nextDue.isBefore(now)).toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (apps.isEmpty && vacs.isEmpty)
          const Center(child: Text('No overdue patients 🎉')),
        for (final a in apps)
          Card(
            child: ListTile(
              leading: const Icon(Icons.event_busy, color: Colors.red),
              title: Text('${a.mother.name} - missed appointment'),
              subtitle: Text('${fmtDate(a.when)}, ${fmtTime(a.when)}'),
              trailing: TextButton(
                onPressed: () => setState(() => a.status = 'Missed'),
                child: const Text('Mark missed'),
              ),
            ),
          ),
        for (final i in vacs)
          Card(
            child: ListTile(
              leading: const Icon(Icons.vaccines, color: Colors.red),
              title: Text('${i.child.name} - ${i.vaccine} due'),
              subtitle: Text('Due ${fmtDate(i.nextDue)}'),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [_homeTab(), _patientsTab(), _alertsTab()];
    return Scaffold(
      appBar: AppBar(
        title: Text('Health worker - ${Store.current?.name ?? ''}'),
        actions: [
          IconButton(
              onPressed: () => logout(context),
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: tabs[_tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.people), label: 'Patients'),
          NavigationDestination(icon: Icon(Icons.notifications), label: 'Alerts'),
        ],
      ),
    );
  }
}

class MotherProfileScreen extends StatefulWidget {
  final AppUser? fixedMother;
  const MotherProfileScreen({super.key, this.fixedMother});

  @override
  State<MotherProfileScreen> createState() => _MotherProfileScreenState();
}

class _MotherProfileScreenState extends State<MotherProfileScreen> {
  final _form = GlobalKey<FormState>();
  final _address = TextEditingController();
  AppUser? _mother;
  DateTime? _dob, _due;
  String? _marital;

  @override
  void initState() {
    super.initState();
    _mother = widget.fixedMother;
    final existing = Store.profiles.where((p) => p.user == _mother).toList();
    if (existing.isNotEmpty) {
      final p = existing.first;
      _dob = p.dob;
      _due = p.due;
      _address.text = p.address;
      _marital = p.marital;
    }
  }

  void _save() {
    if (!_form.currentState!.validate()) return;
    Store.profiles.removeWhere((p) => p.user == _mother);
    Store.profiles.add(MotherProfile(
        _mother!, _dob!, _due, _address.text.trim(), _marital!));
    snack(context, 'Profile saved');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return FormPage(
      title: 'Mother profile',
      children: [
        Form(
          key: _form,
          child: Column(
            children: [
              widget.fixedMother != null
                  ? InputDecorator(
                      decoration: const InputDecoration(
                          labelText: 'Mother',
                          border: OutlineInputBorder()),
                      child: Text(widget.fixedMother!.name),
                    )
                  : dropdown<AppUser>(
                      label: 'Select user (mother)',
                      value: _mother,
                      items: Store.mothers,
                      text: (u) => u.name,
                      onChanged: (v) => setState(() => _mother = v),
                    ),
              gap(),
              DateField(
                  label: 'Date of birth',
                  initial: _dob,
                  onPicked: (d) => _dob = d),
              gap(),
              DateField(
                  label: 'Delivery due date (optional)',
                  initial: _due,
                  required: false,
                  onPicked: (d) => _due = d),
              gap(),
              field('Address', _address),
              gap(),
              dropdown<String>(
                label: 'Marital status',
                value: _marital,
                items: const ['Single', 'Married', 'Divorced', 'Widowed'],
                text: (s) => s,
                onChanged: (v) => setState(() => _marital = v),
              ),
              gap(20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                    onPressed: _save, child: const Text('Save profile')),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AncVisitScreen extends StatefulWidget {
  const AncVisitScreen({super.key});

  @override
  State<AncVisitScreen> createState() => _AncVisitScreenState();
}

class _AncVisitScreenState extends State<AncVisitScreen> {
  final _form = GlobalKey<FormState>();
  final _bp = TextEditingController();
  final _weight = TextEditingController();
  final _notes = TextEditingController();
  AppUser? _mother;
  DateTime? _date;

  bool get _highBp {
    final p = _bp.text.split('/');
    if (p.length != 2) return false;
    final s = int.tryParse(p[0].trim());
    final d = int.tryParse(p[1].trim());
    return (s != null && s >= 140) || (d != null && d >= 90);
  }

  void _save() {
    if (!_form.currentState!.validate()) return;
    Store.visits.add(Visit(_mother!, _date!, _bp.text.trim(),
        double.parse(_weight.text.trim()), _notes.text.trim()));
    snack(context, 'Visit saved');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return FormPage(
      title: 'ANC visit',
      children: [
        Form(
          key: _form,
          child: Column(
            children: [
              dropdown<AppUser>(
                label: 'Select mother',
                value: _mother,
                items: Store.mothers,
                text: (u) => u.name,
                onChanged: (v) => setState(() => _mother = v),
              ),
              gap(),
              DateField(label: 'Visit date', onPicked: (d) => _date = d),
              gap(),
              field('Blood pressure (e.g. 120/80)', _bp,
                  onChanged: (_) => setState(() {})),
              if (_highBp)
                Card(
                  color: Colors.red.shade100,
                  child: const ListTile(
                    leading: Icon(Icons.warning, color: Colors.red),
                    title: Text('High BP alert'),
                    subtitle: Text('Refer to a clinician.'),
                  ),
                ),
              gap(),
              field('Weight (kg)', _weight,
                  numeric: true, type: TextInputType.number),
              gap(),
              field('Notes', _notes, required: false, lines: 3),
              gap(20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                    onPressed: _save, child: const Text('Save visit')),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RegisterChildScreen extends StatefulWidget {
  final AppUser? fixedMother;
  const RegisterChildScreen({super.key, this.fixedMother});

  @override
  State<RegisterChildScreen> createState() => _RegisterChildScreenState();
}

class _RegisterChildScreenState extends State<RegisterChildScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _father = TextEditingController();
  final _weight = TextEditingController();
  AppUser? _mother;
  DateTime? _dob;
  String? _gender;

  @override
  void initState() {
    super.initState();
    _mother = widget.fixedMother;
  }

  void _save() {
    if (!_form.currentState!.validate()) return;
    Store.children.add(Child(_mother!, _name.text.trim(), _father.text.trim(),
        _dob!, _gender!, double.parse(_weight.text.trim())));
    snack(context, 'Child registered');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return FormPage(
      title: 'Register child',
      children: [
        Form(
          key: _form,
          child: Column(
            children: [
              widget.fixedMother != null
                  ? InputDecorator(
                      decoration: const InputDecoration(
                          labelText: 'Mother',
                          border: OutlineInputBorder()),
                      child: Text(widget.fixedMother!.name),
                    )
                  : dropdown<AppUser>(
                      label: 'Select mother',
                      value: _mother,
                      items: Store.mothers,
                      text: (u) => u.name,
                      onChanged: (v) => setState(() => _mother = v),
                    ),
              gap(),
              field('Child name', _name),
              gap(),
              field("Father's name", _father, required: false),
              gap(),
              DateField(label: 'Date of birth', onPicked: (d) => _dob = d),
              gap(),
              dropdown<String>(
                label: 'Gender',
                value: _gender,
                items: const ['Female', 'Male'],
                text: (s) => s,
                onChanged: (v) => setState(() => _gender = v),
              ),
              gap(),
              field('Birth weight (kg)', _weight,
                  numeric: true, type: TextInputType.number),
              gap(20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                    onPressed: _save, child: const Text('Save child')),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class GrowthRecordScreen extends StatefulWidget {
  const GrowthRecordScreen({super.key});

  @override
  State<GrowthRecordScreen> createState() => _GrowthRecordScreenState();
}

class _GrowthRecordScreenState extends State<GrowthRecordScreen> {
  final _form = GlobalKey<FormState>();
  final _weight = TextEditingController();
  final _height = TextEditingController();
  Child? _child;
  DateTime? _date;

  void _save() {
    if (!_form.currentState!.validate()) return;
    Store.growth.add(GrowthRecord(_child!, _date!,
        double.parse(_weight.text.trim()), double.parse(_height.text.trim())));
    _weight.clear();
    _height.clear();
    setState(() {});
    snack(context, 'Growth record saved');
  }

  @override
  Widget build(BuildContext context) {
    return FormPage(
      title: 'Growth record',
      children: [
        Form(
          key: _form,
          child: Column(
            children: [
              dropdown<Child>(
                label: 'Select child',
                value: _child,
                items: Store.children,
                text: (c) => c.name,
                onChanged: (v) => setState(() => _child = v),
              ),
              gap(),
              DateField(label: 'Date measured', onPicked: (d) => _date = d),
              gap(),
              Row(
                children: [
                  Expanded(
                      child: field('Weight (kg)', _weight,
                          numeric: true, type: TextInputType.number)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: field('Height (cm)', _height,
                          numeric: true, type: TextInputType.number)),
                ],
              ),
              gap(),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Weight over time (kg)'),
              ),
              gap(6),
              growthChart(_child),
              gap(),
              OutlinedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Normal range'),
                    content: const Text(
                        'Compare the child\'s weight and height with the WHO child growth standards for their age and sex. A health worker should interpret the result.'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('OK'))
                    ],
                  ),
                ),
                child: const Text('Normal range'),
              ),
              gap(8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                    onPressed: _save, child: const Text('Save record')),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ImmunizationScreen extends StatefulWidget {
  const ImmunizationScreen({super.key});

  @override
  State<ImmunizationScreen> createState() => _ImmunizationScreenState();
}

class _ImmunizationScreenState extends State<ImmunizationScreen> {
  final _form = GlobalKey<FormState>();
  final _dose = TextEditingController();
  final _batch = TextEditingController();
  Child? _child;
  String? _vaccine;
  DateTime? _given;

  DateTime? get _nextDue => _given?.add(const Duration(days: 28));

  void _save() {
    if (!_form.currentState!.validate()) return;
    Store.immunizations.add(Immunization(_child!, _vaccine!, _dose.text.trim(),
        _batch.text.trim(), _given!, _nextDue!));
    snack(context, 'Immunization saved');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return FormPage(
      title: 'Immunization',
      children: [
        Form(
          key: _form,
          child: Column(
            children: [
              dropdown<Child>(
                label: 'Select child',
                value: _child,
                items: Store.children,
                text: (c) => c.name,
                onChanged: (v) => setState(() => _child = v),
              ),
              gap(),
              dropdown<String>(
                label: 'Vaccine name',
                value: _vaccine,
                items: const [
                  'BCG', 'OPV', 'Pentavalent', 'PCV', 'Rotavirus', 'Measles'
                ],
                text: (s) => s,
                onChanged: (v) => setState(() => _vaccine = v),
              ),
              gap(),
              Row(
                children: [
                  Expanded(
                      child: field('Dose no.', _dose, type: TextInputType.number)),
                  const SizedBox(width: 12),
                  Expanded(child: field('Batch no.', _batch)),
                ],
              ),
              gap(),
              DateField(
                  label: 'Date given',
                  onPicked: (d) => setState(() => _given = d)),
              gap(),
              InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Next due (automatic: 4 weeks later)',
                  border: OutlineInputBorder(),
                ),
                child: Text(_nextDue == null ? '-' : fmtDate(_nextDue!)),
              ),
              gap(20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                    onPressed: _save, child: const Text('Save record')),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AppointmentScreen extends StatefulWidget {
  final AppUser? fixedMother;
  const AppointmentScreen({super.key, this.fixedMother});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  AppUser? _mother;
  DateTime? _when;

  bool get _isMother => widget.fixedMother != null;

  @override
  void initState() {
    super.initState();
    _mother = widget.fixedMother;
  }

  Future<void> _pickWhen() async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (d == null || !mounted) return;
    final t =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (t == null) return;
    setState(() => _when = DateTime(d.year, d.month, d.day, t.hour, t.minute));
  }

  String get _sms {
    if (_mother == null || _when == null) {
      return 'Choose a mother and a date/time to preview the SMS.';
    }
    final first = _mother!.name.split(' ').first;
    return 'Dear $first, your appointment is set for ${_when!.day} ${_months[_when!.month - 1]}, ${fmtTime(_when!)}.';
  }

  void _save() {
    if (_mother == null || _when == null) {
      snack(context, 'Select a mother and a date/time');
      return;
    }
    Store.appointments.add(Appointment(_mother!, _when!, 'Pending'));
    if (_isMother) {
      snack(context, 'Appointment requested (Pending)');
    } else {
      Store.smsSent++;
      snack(context, 'Appointment saved and SMS sent (demo)');
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return FormPage(
      title: _isMother ? 'Request appointment' : 'Appointment',
      children: [
        _isMother
            ? InputDecorator(
                decoration: const InputDecoration(
                    labelText: 'Mother', border: OutlineInputBorder()),
                child: Text(widget.fixedMother!.name),
              )
            : dropdown<AppUser>(
                label: 'Select mother',
                value: _mother,
                items: Store.mothers,
                text: (u) => u.name,
                onChanged: (v) => setState(() => _mother = v),
              ),
        gap(),
        InkWell(
          onTap: _pickWhen,
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Date and time',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.event),
            ),
            child: Text(
                _when == null ? '' : '${fmtDate(_when!)}, ${fmtTime(_when!)}'),
          ),
        ),
        gap(),
        InputDecorator(
          decoration: const InputDecoration(
              labelText: 'Status', border: OutlineInputBorder()),
          child: const Text('Pending'),
        ),
        gap(),
        if (!_isMother)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('SMS preview',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  gap(6),
                  Text(_sms),
                ],
              ),
            ),
          ),
        gap(20),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
              onPressed: _save,
              child: Text(_isMother ? 'Request appointment' : 'Save and send SMS')),
        ),
      ],
    );
  }
}

class ChildDetailScreen extends StatelessWidget {
  final Child child;
  const ChildDetailScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final vacs = Store.immunizations.where((i) => i.child == child).toList();
    return Scaffold(
      appBar: AppBar(title: Text(child.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: Text(child.name),
              subtitle: Text(
                  '${child.gender} · Born ${fmtDate(child.dob)} · Birth weight ${child.birthWeight} kg\nMother: ${child.mother.name}'),
            ),
          ),
          gap(),
          const Text('Growth chart (weight)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          gap(8),
          growthChart(child),
          gap(),
          const Text('Vaccine schedule',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          if (vacs.isEmpty) const ListTile(title: Text('No vaccines recorded')),
          for (final v in vacs)
            Card(
              child: ListTile(
                leading: const Icon(Icons.vaccines),
                title: Text('${v.vaccine} (dose ${v.dose})'),
                subtitle: Text(
                    'Given ${fmtDate(v.given)} · Next due ${fmtDate(v.nextDue)}'),
              ),
            ),
        ],
      ),
    );
  }
}

// =====================================================================
// MOTHER
// =====================================================================
class MotherHome extends StatefulWidget {
  const MotherHome({super.key});

  @override
  State<MotherHome> createState() => _MotherHomeState();
}

class _MotherHomeState extends State<MotherHome> {
  int _tab = 0;

  void _open(Widget w) => Navigator.push(
          context, MaterialPageRoute(builder: (_) => w))
      .then((_) => setState(() {}));

  Widget _action(String label, IconData icon, VoidCallback onTap) {
    return SizedBox(
      width: 150,
      height: 90,
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28),
              gap(6),
              Text(label, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  Widget _homeTab(AppUser me) {
    final upcoming = Store.appointments
        .where((a) => a.mother == me && a.status == 'Pending')
        .toList()
      ..sort((a, b) => a.when.compareTo(b.when));
    final next = upcoming.isEmpty ? null : upcoming.first;
    final kids = Store.children.where((c) => c.mother == me).toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.event, size: 32),
            title: const Text('Next appointment'),
            subtitle: Text(next == null
                ? 'No appointment yet'
                : '${fmtDate(next.when)}, ${fmtTime(next.when)}'),
          ),
        ),
        gap(),
        const Text('Enter my details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        gap(8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            _action('My profile', Icons.person,
                () => _open(MotherProfileScreen(fixedMother: me))),
            _action('Add my child', Icons.child_care,
                () => _open(RegisterChildScreen(fixedMother: me))),
            _action('Request appointment', Icons.event,
                () => _open(AppointmentScreen(fixedMother: me))),
          ],
        ),
        gap(),
        const Text('My children',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        if (kids.isEmpty) const ListTile(title: Text('No children registered')),
        for (final c in kids)
          Card(
            child: ListTile(
              leading: const Icon(Icons.child_care),
              title: Text(c.name),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => go(context, ChildDetailScreen(child: c)),
            ),
          ),
        gap(),
        Card(
          color: Colors.teal.shade50,
          child: ListTile(
            leading: const Icon(Icons.sms),
            title: const Text('SMS reminder'),
            subtitle: Text(next == null
                ? 'You will get an SMS before your next visit.'
                : 'Dear ${me.name.split(' ').first}, your appointment is set for ${next.when.day} ${_months[next.when.month - 1]}, ${fmtTime(next.when)}.'),
          ),
        ),
      ],
    );
  }

  Widget _visitsTab(AppUser me) {
    final mine = Store.visits.where((v) => v.mother == me).toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (mine.isEmpty) const Center(child: Text('No visits recorded yet')),
        for (final v in mine)
          Card(
            child: ListTile(
              leading: const Icon(Icons.medical_services),
              title: Text(fmtDate(v.date)),
              subtitle:
                  Text('BP ${v.bp} · ${v.weight} kg\n${v.notes}'),
            ),
          ),
      ],
    );
  }

  Widget _childTab(AppUser me) {
    final kids = Store.children.where((c) => c.mother == me).toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (kids.isEmpty) const Center(child: Text('No children registered')),
        for (final c in kids)
          Card(
            child: ListTile(
              leading: const Icon(Icons.child_care),
              title: Text(c.name),
              subtitle: const Text('Tap for growth chart and vaccines'),
              onTap: () => go(context, ChildDetailScreen(child: c)),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final me = Store.current!;
    final tabs = [_homeTab(me), _visitsTab(me), _childTab(me)];
    return Scaffold(
      appBar: AppBar(
        title: const Text('My health'),
        actions: [
          IconButton(
              onPressed: () => logout(context),
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: tabs[_tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.medical_services), label: 'Visits'),
          NavigationDestination(icon: Icon(Icons.child_care), label: 'Child'),
        ],
      ),
    );
  }
}

// =====================================================================
// ADMIN
// =====================================================================
class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _tab = 0;

  Widget _homeTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
                child: statCard('Users', '${Store.users.length}',
                    onTap: () => setState(() => _tab = 1))),
            Expanded(
                child: statCard('Children', '${Store.children.length}')),
          ],
        ),
        Row(
          children: [
            Expanded(child: statCard('Visits', '${Store.visits.length}')),
            Expanded(
                child: statCard('SMS sent', '${Store.smsSent}',
                    onTap: () => setState(() => _tab = 2))),
          ],
        ),
        gap(16),
        FilledButton.icon(
          onPressed: () => go(context, const AppointmentScreen()),
          icon: const Icon(Icons.event),
          label: const Text('Book appointment'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [_homeTab(), const ManageUsersView(), const ReportsView()];
    return Scaffold(
      appBar: AppBar(
        title: Text(['Admin', 'Manage users', 'Reports'][_tab]),
        actions: [
          IconButton(
              onPressed: () => logout(context),
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: tabs[_tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.people), label: 'Users'),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Reports'),
        ],
      ),
    );
  }
}

class ManageUsersView extends StatefulWidget {
  const ManageUsersView({super.key});

  @override
  State<ManageUsersView> createState() => _ManageUsersViewState();
}

class _ManageUsersViewState extends State<ManageUsersView> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final list = Store.users.where((u) {
      if (_filter == 'Mothers') return u.role == 'Mother';
      if (_filter == 'Workers') return u.role == 'Health Worker';
      return true;
    }).toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Wrap(
          spacing: 8,
          children: [
            for (final f in ['All', 'Mothers', 'Workers'])
              ChoiceChip(
                label: Text(f),
                selected: _filter == f,
                onSelected: (_) => setState(() => _filter = f),
              ),
          ],
        ),
        gap(),
        for (final u in list)
          Card(
            child: ListTile(
              leading: Icon(u.role == 'Mother'
                  ? Icons.pregnant_woman
                  : u.role == 'Admin'
                      ? Icons.admin_panel_settings
                      : Icons.medical_services),
              title: Text(u.name),
              subtitle: Text('${u.role} · ${u.email}'),
              trailing: Switch(
                value: u.active,
                onChanged: (v) => setState(() => u.active = v),
              ),
            ),
          ),
        gap(),
        OutlinedButton.icon(
          onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()))
              .then((_) => setState(() {})),
          icon: const Icon(Icons.add),
          label: const Text('Add user'),
        ),
      ],
    );
  }
}

class ReportsView extends StatelessWidget {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final months6 =
        List.generate(6, (i) => DateTime(now.year, now.month - 5 + i, 1));
    final counts = months6
        .map((m) => Store.visits
            .where((v) => v.date.year == m.year && v.date.month == m.month)
            .length)
        .toList();
    int maxC = 1;
    for (final c in counts) {
      if (c > maxC) maxC = c;
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(child: statCard('Visits', '${Store.visits.length}')),
            Expanded(child: statCard('Children', '${Store.children.length}')),
          ],
        ),
        Row(
          children: [
            Expanded(
                child: statCard('Vaccines', '${Store.immunizations.length}')),
            Expanded(child: statCard('SMS sent', '${Store.smsSent}')),
          ],
        ),
        gap(),
        const Text('Visits per month',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        gap(8),
        Container(
          height: 180,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (int i = 0; i < 6; i++)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('${counts[i]}'),
                      Container(
                        height: 4 + counts[i] / maxC * 110,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        color: Colors.teal,
                      ),
                      Text(_months[months6[i].month - 1]),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
