import 'package:flutter/material.dart';

class ImplicitAnimationsScreen extends StatefulWidget {
  const ImplicitAnimationsScreen({super.key});

  @override
  State<ImplicitAnimationsScreen> createState() =>
      ImplicitAnimationsScreenState();
}

class ImplicitAnimationsScreenState extends State<ImplicitAnimationsScreen> {
  bool _visible = true;

  void _trigger() {
    setState(() {
      _visible = !_visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Implicit Animations')),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //implicit animations
          //https://docs.flutter.dev/ui/widgets/animation
          /*
          AnimatedAlign(
            alignment: _visible ? Alignment.topLeft : Alignment.topRight,
            duration: Duration(seconds: 2),
            child: AnimatedOpacity(
              opacity: _visible ? 1 : 0.2,
              duration: Duration(seconds: 2),
              child: Container(
                width: size.width * 0.8,
                height: size.width * 0.8,
                color: Colors.amber,
              ),
            ),
          ),*/
          /*AnimatedContainer(
            curve: Curves
                .elasticOut, //https://api.flutter.dev/flutter/animation/Curves-class.html
            duration: Duration(seconds: 2),
            width: _visible ? size.width : size.width * 0.8,
            height: _visible ? size.width : size.width * 0.8,
            transform: Matrix4.rotationZ(_visible ? 1 : 0),
            transformAlignment: Alignment.center,
            decoration: BoxDecoration(
                color: _visible ? Colors.red : Colors.amber,
                borderRadius: BorderRadius.circular(_visible ? 300 : 0)),
          ),*/
          TweenAnimationBuilder(
            //tween: Tween(begin: 10.0, end: 20.0),
            tween: ColorTween(begin: Colors.purple, end: Colors.green),
            curve: Curves.elasticOut,
            duration: const Duration(seconds: 10),
            builder: (context, value, child) {
              //return Text('$value');
              return Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/Dash%2C_the_mascot_of_the_Dart_programming_language.png/640px-Dash%2C_the_mascot_of_the_Dart_programming_language.png',
                color: value,
                colorBlendMode: BlendMode.colorBurn,
              );
            },
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(onPressed: _trigger, child: Text('Go!'))
        ],
      )),
    );
  }
}
