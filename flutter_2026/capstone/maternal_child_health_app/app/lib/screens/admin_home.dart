import 'package:flutter/material.dart';
import 'appointment_screen.dart';
import 'manage_users_view.dart';
import 'reports_view.dart';
import '../services/store.dart';
import '../widgets/helpers.dart';
import '../widgets/stat_card.dart';

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
