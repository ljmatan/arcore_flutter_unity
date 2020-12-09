import 'package:flutter/material.dart';

class FlashEffect extends StatefulWidget {
  FlashEffect({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FlashEffectState();
  }
}

class FlashEffectState extends State<FlashEffect>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..addListener(() => setState(() {}));
    _opacity = Tween<double>(begin: 1, end: 0).animate(_animationController);
  }

  /// Displays the front camera flash effect.
  void startFlash() => _animationController
      .forward()
      .whenComplete(() => _animationController.reverse());

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _opacity.value,
      child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.white),
        child: SizedBox(
          height: _animationController.isAnimating
              ? MediaQuery.of(context).size.height
              : 0,
          width: _animationController.isAnimating
              ? MediaQuery.of(context).size.width
              : 0,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
