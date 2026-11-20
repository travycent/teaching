import 'package:flutter/material.dart';
import '../services/formatters.dart';
import '../services/store.dart';
import '../widgets/helpers.dart';
import '../widgets/stat_card.dart';

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
                      Text(kMonths[months6[i].month - 1]),
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
