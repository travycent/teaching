import 'package:flutter/material.dart';
import '../models/child.dart';
import '../models/growth_record.dart';
import '../services/store.dart';
import '../widgets/form_widgets.dart';
import '../widgets/growth_chart.dart';
import '../widgets/helpers.dart';

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
