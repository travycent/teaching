import 'package:flutter/material.dart';
import '../models/child.dart';
import '../models/immunization.dart';
import '../services/formatters.dart';
import '../services/store.dart';
import '../widgets/form_widgets.dart';
import '../widgets/helpers.dart';

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
