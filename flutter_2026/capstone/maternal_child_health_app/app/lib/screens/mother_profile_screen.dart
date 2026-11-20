import 'package:flutter/material.dart';
import '../models/app_user.dart';
import '../models/mother_profile.dart';
import '../services/store.dart';
import '../widgets/form_widgets.dart';
import '../widgets/helpers.dart';

class MotherProfileScreen extends StatefulWidget {
  final AppUser? fixedMother;
  const MotherProfileScreen({super.key, this.fixedMother});

  @override
  State<MotherProfileScreen> createState() => _MotherProfileScreenState();
}

class _MotherProfileScreenState extends State<MotherProfileScreen> {
  final _form = GlobalKey<FormState>();
  final _address = TextEditingController();
  AppUser? _mother;
  DateTime? _dob, _due;
  String? _marital;

  @override
  void initState() {
    super.initState();
    _mother = widget.fixedMother;
    final existing = Store.profiles.where((p) => p.user == _mother).toList();
    if (existing.isNotEmpty) {
      final p = existing.first;
      _dob = p.dob;
      _due = p.due;
      _address.text = p.address;
      _marital = p.marital;
    }
  }

  void _save() {
    if (!_form.currentState!.validate()) return;
    Store.profiles.removeWhere((p) => p.user == _mother);
    Store.profiles.add(MotherProfile(
        _mother!, _dob!, _due, _address.text.trim(), _marital!));
    snack(context, 'Profile saved');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return FormPage(
      title: 'Mother profile',
      children: [
        Form(
          key: _form,
          child: Column(
            children: [
              widget.fixedMother != null
                  ? InputDecorator(
                      decoration: const InputDecoration(
                          labelText: 'Mother',
                          border: OutlineInputBorder()),
                      child: Text(widget.fixedMother!.name),
                    )
                  : dropdown<AppUser>(
                      label: 'Select user (mother)',
                      value: _mother,
                      items: Store.mothers,
                      text: (u) => u.name,
                      onChanged: (v) => setState(() => _mother = v),
                    ),
              gap(),
              DateField(
                  label: 'Date of birth',
                  initial: _dob,
                  onPicked: (d) => _dob = d),
              gap(),
              DateField(
                  label: 'Delivery due date (optional)',
                  initial: _due,
                  required: false,
                  onPicked: (d) => _due = d),
              gap(),
              field('Address', _address),
              gap(),
              dropdown<String>(
                label: 'Marital status',
                value: _marital,
                items: const ['Single', 'Married', 'Divorced', 'Widowed'],
                text: (s) => s,
                onChanged: (v) => setState(() => _marital = v),
              ),
              gap(20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                    onPressed: _save, child: const Text('Save profile')),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
