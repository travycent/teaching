import 'package:flutter/material.dart';
import 'register_screen.dart';
import '../services/store.dart';
import '../widgets/helpers.dart';

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
