import 'package:flutter/material.dart';
import '../models/child.dart';
import '../services/store.dart';

class LinePainter extends CustomPainter {
  final List<double> values;
  final Color color;
  LinePainter(this.values, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final axis = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), axis);
    canvas.drawLine(const Offset(0, 0), Offset(0, size.height), axis);
    if (values.isEmpty) return;
    double minV = values.first, maxV = values.first;
    for (final v in values) {
      if (v < minV) minV = v;
      if (v > maxV) maxV = v;
    }
    final range = (maxV - minV) == 0 ? 1.0 : (maxV - minV);
    final pts = <Offset>[];
    for (int i = 0; i < values.length; i++) {
      final x = values.length == 1
          ? size.width / 2
          : 10 + i * (size.width - 20) / (values.length - 1);
      final y = size.height - 12 - (values[i] - minV) / range * (size.height - 24);
      pts.add(Offset(x, y));
    }
    final line = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (final p in pts.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path, line);
    final dot = Paint()..color = color;
    for (final p in pts) {
      canvas.drawCircle(p, 4, dot);
    }
  }

  @override
  bool shouldRepaint(covariant LinePainter old) => true;
}

Widget growthChart(Child? child) {
  final recs = Store.growth.where((g) => g.child == child).toList()
    ..sort((a, b) => a.date.compareTo(b.date));
  return Container(
    height: 170,
    width: double.infinity,
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(8),
    ),
    child: recs.isEmpty
        ? const Center(child: Text('No growth records yet'))
        : CustomPaint(
            painter: LinePainter(recs.map((r) => r.weight).toList(), Colors.teal),
            size: Size.infinite,
          ),
  );
}
