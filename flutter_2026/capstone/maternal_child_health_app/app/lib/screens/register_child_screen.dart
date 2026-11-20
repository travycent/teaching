import 'package:flutter/material.dart';
import '../models/app_user.dart';
import '../models/child.dart';
import '../services/store.dart';
import '../widgets/form_widgets.dart';
import '../widgets/helpers.dart';

class RegisterChildScreen extends StatefulWidget {
  final AppUser? fixedMother;
  const RegisterChildScreen({super.key, this.fixedMother});

  @override
  State<RegisterChildScreen> createState() => _RegisterChildScreenState();
}

class _RegisterChildScreenState extends State<RegisterChildScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _father = TextEditingController();
  final _weight = TextEditingController();
  AppUser? _mother;
  DateTime? _dob;
  String? _gender;

  @override
  void initState() {
    super.initState();
    _mother = widget.fixedMother;
  }

  void _save() {
    if (!_form.currentState!.validate()) return;
    Store.children.add(Child(_mother!, _name.text.trim(), _father.text.trim(),
        _dob!, _gender!, double.parse(_weight.text.trim())));
    snack(context, 'Child registered');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return FormPage(
      title: 'Register child',
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
                      label: 'Select mother',
                      value: _mother,
                      items: Store.mothers,
                      text: (u) => u.name,
                      onChanged: (v) => setState(() => _mother = v),
                    ),
              gap(),
              field('Child name', _name),
              gap(),
              field("Father's name", _father, required: false),
              gap(),
              DateField(label: 'Date of birth', onPicked: (d) => _dob = d),
              gap(),
              dropdown<String>(
                label: 'Gender',
                value: _gender,
                items: const ['Female', 'Male'],
                text: (s) => s,
                onChanged: (v) => setState(() => _gender = v),
              ),
              gap(),
              field('Birth weight (kg)', _weight,
                  numeric: true, type: TextInputType.number),
              gap(20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                    onPressed: _save, child: const Text('Save child')),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
