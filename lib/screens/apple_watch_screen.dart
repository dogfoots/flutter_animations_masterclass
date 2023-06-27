import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppleWatchScreen extends StatefulWidget {
  const AppleWatchScreen({super.key});

  @override
  State<AppleWatchScreen> createState() => _AppleWatchScreenState();
}

class _AppleWatchScreenState extends State<AppleWatchScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: Duration(seconds: 2),
  )..forward();

  late final CurvedAnimation _curve =
      CurvedAnimation(parent: _animationController, curve: Curves.bounceOut);

  late List<Animation<double>> _progresses =
      List.generate(3, (index) => _makeTween(_curve));

  Animation<double> _makeTween(CurvedAnimation curve) {
    return Tween(
      begin: 0.005,
      end: Random().nextDouble() * 2.0,
    ).animate(curve);
  }

  /*
  late Animation<double> _progress = Tween(
    begin: 0.005,
    end: Random().nextDouble() * 2.0,
  ).animate(_curve);*/

  void _animatedValues() {
    //_animationController.forward();
    List<Animation<double>> newProgresses = [];
    _progresses.forEach((element) {
      final newBegin = element.value;
      final random = Random();
      final newEnd = random.nextDouble() * 2.0;
      newProgresses.add(Tween(begin: newBegin, end: newEnd).animate(_curve));
    });

    setState(() {
      _progresses = newProgresses;
    });
    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: Text('Apple Watch')),
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return CustomPaint(
              painter: AppleWatchPainter(
                  progresses: _progresses.map((e) => e.value).toList()),
              size: Size(400, 400),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _animatedValues,
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class AppleWatchPainter extends CustomPainter {
  final List<double> progresses;

  AppleWatchPainter({
    required this.progresses,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.width / 2);

    final redCircleRadius = (size.width / 2) * 0.9;
    final greenCircleRadius = (size.width / 2) * 0.76;
    final blueCircleRadius = (size.width / 2) * 0.62;

    const startingAngle = -0.5 * pi;

    final redCirclePaint = Paint()
      ..color = Colors.red.shade400.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;

    canvas.drawCircle(center, redCircleRadius, redCirclePaint);

    final greenCirclePaint = Paint()
      ..color = Colors.green.shade400.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;

    canvas.drawCircle(center, greenCircleRadius, greenCirclePaint);

    final blueCirclePaint = Paint()
      ..color = Colors.cyan.shade400.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;

    canvas.drawCircle(center, blueCircleRadius, blueCirclePaint);

    final redArcRect = Rect.fromCircle(center: center, radius: redCircleRadius);
    final redArcPaint = Paint()
      ..color = Colors.red.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;
    canvas.drawArc(
        redArcRect, startingAngle, progresses[0] * pi, false, redArcPaint);

    final greenArcRect =
        Rect.fromCircle(center: center, radius: greenCircleRadius);
    final greenArcPaint = Paint()
      ..color = Colors.green.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;
    canvas.drawArc(
        greenArcRect, startingAngle, progresses[1] * pi, false, greenArcPaint);

    final blueArcRect =
        Rect.fromCircle(center: center, radius: blueCircleRadius);
    final blueArcPaint = Paint()
      ..color = Colors.cyan.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;
    canvas.drawArc(
        blueArcRect, startingAngle, progresses[2] * pi, false, blueArcPaint);

    /*final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    final paint = Paint()..color = Colors.blue;
    canvas.drawRect(rect, paint);

    final circlePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    canvas.drawCircle(
        Offset(size.width / 2, size.width / 2), size.width / 2, circlePaint);*/
  }

  @override
  bool shouldRepaint(covariant AppleWatchPainter oldDelegate) {
    return !listEquals(oldDelegate.progresses, progresses);
  }
}
