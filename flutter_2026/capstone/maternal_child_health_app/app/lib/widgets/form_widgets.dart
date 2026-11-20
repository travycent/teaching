import 'package:flutter/material.dart';
import '../services/formatters.dart';

Widget field(String label, TextEditingController c,
    {bool required = true,
    TextInputType? type,
    int lines = 1,
    bool numeric = false,
    ValueChanged<String>? onChanged}) {
  return TextFormField(
    controller: c,
    keyboardType: type,
    maxLines: lines,
    onChanged: onChanged,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    ),
    validator: (v) {
      final t = (v ?? '').trim();
      if (t.isEmpty) return required ? 'Required' : null;
      if (numeric && double.tryParse(t) == null) return 'Enter a number';
      return null;
    },
  );
}

Widget dropdown<T>({
  required String label,
  required T? value,
  required List<T> items,
  required String Function(T) text,
  required ValueChanged<T?> onChanged,
}) {
  return DropdownButtonFormField<T>(
    value: value,
    isExpanded: true,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    ),
    items: items
        .map((e) => DropdownMenuItem<T>(value: e, child: Text(text(e))))
        .toList(),
    onChanged: onChanged,
    validator: (v) => v == null ? 'Please select' : null,
  );
}

class DateField extends FormField<DateTime> {
  DateField({
    super.key,
    required String label,
    DateTime? initial,
    required ValueChanged<DateTime> onPicked,
    bool required = true,
  }) : super(
          initialValue: initial,
          validator: (v) => required && v == null ? 'Required' : null,
          builder: (state) {
            return InkWell(
              onTap: () async {
                final d = await showDatePicker(
                  context: state.context,
                  initialDate: state.value ?? DateTime.now(),
                  firstDate: DateTime(1950),
                  lastDate: DateTime(2100),
                );
                if (d != null) {
                  state.didChange(d);
                  onPicked(d);
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: label,
                  border: const OutlineInputBorder(),
                  errorText: state.errorText,
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                child: Text(state.value == null ? '' : fmtDate(state.value!)),
              ),
            );
          },
        );
}

class FormPage extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const FormPage({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Column(children: children),
          ),
        ),
      ),
    );
  }
}
