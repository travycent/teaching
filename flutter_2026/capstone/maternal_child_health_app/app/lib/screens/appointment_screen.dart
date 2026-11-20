import 'package:flutter/material.dart';
import '../models/app_user.dart';
import '../models/appointment.dart';
import '../services/formatters.dart';
import '../services/store.dart';
import '../widgets/form_widgets.dart';
import '../widgets/helpers.dart';

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
    return 'Dear $first, your appointment is set for ${_when!.day} ${kMonths[_when!.month - 1]}, ${fmtTime(_when!)}.';
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
