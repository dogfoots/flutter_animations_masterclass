import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ExplicitAnimationsScreen extends StatefulWidget {
  const ExplicitAnimationsScreen({super.key});

  @override
  State<ExplicitAnimationsScreen> createState() =>
      _ExplicitAnimationsScreenState();
}

class _ExplicitAnimationsScreenState extends State<ExplicitAnimationsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: Duration(seconds: 2),
    reverseDuration: Duration(seconds: 1),
    /*lowerBound: 50.0,
    upperBound: 100.0,*/
  )..addListener(() {
      _range.value = _animationController.value;
    });
  /*..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });*/

/*
  late final Animation<Color?> _color =
      ColorTween(begin: Colors.amber, end: Colors.red)
          .animate(_animationController);
*/
  late final Animation<Decoration> _decoration = DecorationTween(
          begin: BoxDecoration(
              color: Colors.amber, borderRadius: BorderRadius.circular(20)),
          end: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(120)))
      .animate(_curved);

  late final Animation<double> _rotation =
      Tween(begin: 0.0, end: 0.5).animate(_curved);

  late final Animation<double> _scale =
      Tween(begin: 1.0, end: 1.1).animate(_curved);

  late final Animation<Offset> _position =
      Tween(begin: Offset.zero, end: Offset(0, -0.2)).animate(_curved);

  late final CurvedAnimation _curved = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
      reverseCurve: Curves.bounceIn);

  void _play() {
    _animationController.forward();
  }

  void _pause() {
    _animationController.stop();
  }

  void _rewind() {
    _animationController.reverse();
  }

  @override
  void initState() {
    super.initState();

    /*
    SingleTickerProviderStateMixin 아래 코드는 이 with mixed 기능의 축소판.
    그러나 아래 코드는 다시 화면 재진입시 계속 스택에 쌓여서 실행됨.
    SingleTickerProviderStateMixin는 화면에 있을때만 실행.
    Ticker((elapsed) => print(elapsed)).start();
    */

    /*Timer.periodic(Duration(microseconds: 500), (timer) {
      print(_animationController.value);
    });*/
  }

  @override
  void dispose() {
    _animationController.dispose(); // 없으면 애니매이션 중간에 화면 나가면 에러남
    super.dispose();
  }

  //double _value = 0;
  final ValueNotifier<double> _range = ValueNotifier(0.0);

  void _onChanged(double value) {
    /*setState(() {
      _value = value;
    });*/

    _range.value = 0;
    _animationController.animateTo(value);
    //_animationController.value = value;
  }

  bool _looping = false;

  void _toggleLooping() {
    if (_looping) {
      _animationController.stop();
    } else {
      _animationController.repeat(reverse: true);
    }

    setState(() {
      _looping = !_looping;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Explicit Animations',
          style: TextStyle(fontSize: 28),
        ),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /*AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Opacity(
                opacity: _animationController.value,
                child: Container(
                  color: Colors.amber,
                  width: 400,
                  height: 400,
                ),
              );
            },
          ),*/
          /*
          AnimatedBuilder(
            animation: _color,
            builder: (context, child) {
              return Container(
                color: _color.value,
                width: 400,
                height: 400,
              );
            },
          ),*/
          SlideTransition(
            position: _position,
            child: ScaleTransition(
              scale: _scale,
              child: RotationTransition(
                turns: _rotation,
                child: DecoratedBoxTransition(
                    decoration: _decoration,
                    child: SizedBox(
                      height: 400,
                      width: 400,
                    )),
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          ValueListenableBuilder(
              valueListenable: _range,
              builder: (context, value, child) {
                return Slider(
                  value: value,
                  onChanged: _onChanged,
                );
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: _play, child: Text("Play")),
              ElevatedButton(onPressed: _pause, child: Text("Pause")),
              ElevatedButton(onPressed: _rewind, child: Text("Rewind")),
              ElevatedButton(
                  onPressed: _toggleLooping,
                  child: Text(_looping ? "Stop looping" : "Start looping")),
            ],
          )
        ],
      )),
    );
  }
}
