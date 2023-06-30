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

  late final Tween<double> _scale = Tween(begin: 0.8, end: 1.0);

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _position.value += details.delta.dx;
  }

  void _goNextCard(bool direction) {
    final dropZone = size.width + 100;
    _position
        .animateTo(
      (direction ? -1.0 : 1.0) * dropZone,
      curve: Curves.easeIn,
    )
        .whenComplete(() {
      _position.value = 0;
      setState(() {
        _index = _index == 5 ? 1 : _index + 1;
      });
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final bound = size.width - 200;
    if (_position.value.abs() >= bound) {
      _goNextCard(_position.value.isNegative);
    } else {
      _position.animateTo(
        0,
        curve: Curves.easeIn,
      );
    }
  }

  @override
  void dispose() {
    _position.dispose();
    super.dispose();
  }

  int _index = 1;

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
          final scale =
              min(_scale.transform(_position.value.abs() / size.width), 1.0);
          final buttonScale = min(
              _scale.transform(_position.value.abs() / size.width) + 0.2, 1.2);
          return Stack(alignment: Alignment.topCenter, children: [
            Positioned(
              top: 50,
              child: Transform.scale(
                scale: scale,
                child: Card(index: _index == 5 ? 1 : _index + 1),
              ),
            ),
            Positioned(
              top: 50,
              child: GestureDetector(
                onHorizontalDragUpdate: _onHorizontalDragUpdate,
                onHorizontalDragEnd: _onHorizontalDragEnd,
                child: Transform.translate(
                  offset: Offset(_position.value, 0),
                  child: Transform.rotate(
                    angle: angle * pi / 180.0,
                    child: Card(
                      index: _index,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              child: Row(children: [
                GestureDetector(
                  onTap: () {
                    _goNextCard(true);
                  },
                  child: Transform.scale(
                    scale: _position.value.isNegative ? buttonScale : 1.0,
                    child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                  offset: Offset(0, 5),
                                  color: Colors.grey,
                                  blurRadius: 5)
                            ]),
                        child: const Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 40,
                        )),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    _goNextCard(false);
                  },
                  child: Transform.scale(
                    scale: !_position.value.isNegative ? buttonScale : 1.0,
                    child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                  offset: Offset(0, 5),
                                  color: Colors.grey,
                                  blurRadius: 5)
                            ]),
                        child: const Icon(
                          Icons.check,
                          color: Colors.green,
                          size: 40,
                        )),
                  ),
                )
              ]),
            )
          ]);
        },
      ),
    );
  }
}

class Card extends StatelessWidget {
  final int index;
  const Card({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: size.width * 0.8,
        height: size.height * 0.65,
        child: Image.asset(
          "assets/images/$index.jpg",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
