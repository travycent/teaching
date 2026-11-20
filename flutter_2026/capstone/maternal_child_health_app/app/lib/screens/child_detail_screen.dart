import 'package:flutter/material.dart';
import '../models/child.dart';
import '../services/formatters.dart';
import '../services/store.dart';
import '../widgets/growth_chart.dart';
import '../widgets/helpers.dart';

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
