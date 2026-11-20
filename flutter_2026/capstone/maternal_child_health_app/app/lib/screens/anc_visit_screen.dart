import 'package:flutter/material.dart';
import '../models/app_user.dart';
import '../models/visit.dart';
import '../services/store.dart';
import '../widgets/form_widgets.dart';
import '../widgets/helpers.dart';

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
