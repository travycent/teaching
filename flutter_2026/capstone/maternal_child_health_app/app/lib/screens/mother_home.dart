import 'package:flutter/material.dart';
import '../models/app_user.dart';
import 'appointment_screen.dart';
import 'child_detail_screen.dart';
import 'mother_profile_screen.dart';
import 'register_child_screen.dart';
import '../services/formatters.dart';
import '../services/store.dart';
import '../widgets/helpers.dart';

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
                : 'Dear ${me.name.split(' ').first}, your appointment is set for ${next.when.day} ${kMonths[next.when.month - 1]}, ${fmtTime(next.when)}.'),
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
