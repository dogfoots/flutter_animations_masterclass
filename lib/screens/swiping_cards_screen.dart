import 'dart:math';

import 'package:flutter/material.dart';

class SwipingCardsScreen extends StatefulWidget {
  const SwipingCardsScreen({super.key});

  @override
  State<SwipingCardsScreen> createState() => _SwipingCardsScreenState();
}

class _SwipingCardsScreenState extends State<SwipingCardsScreen>
    with SingleTickerProviderStateMixin {
  late final size = MediaQuery.of(context).size;
  late final AnimationController _position = AnimationController(
      vsync: this,
      lowerBound: -1.0 * (size.width + 100),
      upperBound: (size.width + 100),
      value: 0.0,
      duration: Duration(
        milliseconds: 300,
      ));

  late final Tween<double> _rotation = Tween(
    begin: -15,
    end: 15,
  );

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _position.value += details.delta.dx;
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final bound = size.width - 100;
    if (_position.value.abs() >= bound) {
      _position.animateTo(
        (_position.value.isNegative ? -1.0 : 1.0) * (size.width + 100),
        curve: Curves.bounceOut,
      );
    } else {
      _position.animateTo(
        0,
        curve: Curves.bounceOut,
      );
    }
  }

  @override
  void dispose() {
    _position.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Swiping Cards'),
      ),
      body: AnimatedBuilder(
        animation: _position,
        builder: (context, child) {
          final angle = _rotation
              .transform((_position.value + (size.width / 2)) / size.width);
          return Stack(alignment: Alignment.topCenter, children: [
            Positioned(
              top: 100,
              child: GestureDetector(
                onHorizontalDragUpdate: _onHorizontalDragUpdate,
                onHorizontalDragEnd: _onHorizontalDragEnd,
                child: Transform.translate(
                  offset: Offset(_position.value, 0),
                  child: Transform.rotate(
                    angle: angle * pi / 180.0,
                    child: Material(
                      elevation: 10,
                      color: Colors.red.shade100,
                      child: SizedBox(
                        width: size.width * 0.8,
                        height: size.height * 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ]);
        },
      ),
    );
  }
}
