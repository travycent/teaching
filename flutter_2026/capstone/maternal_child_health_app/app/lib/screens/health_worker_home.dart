import 'package:flutter/material.dart';
import 'anc_visit_screen.dart';
import 'appointment_screen.dart';
import 'child_detail_screen.dart';
import 'growth_record_screen.dart';
import 'immunization_screen.dart';
import 'mother_profile_screen.dart';
import 'register_child_screen.dart';
import 'register_screen.dart';
import '../services/formatters.dart';
import '../services/store.dart';
import '../widgets/helpers.dart';
import '../widgets/stat_card.dart';

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
