import 'package:arcore_flutter/camera/bottom_bar/filter_menu/filter_button.dart';
import 'package:flutter/material.dart';

class FilterMenu extends StatefulWidget {
  final Key key;
  final Function(String, [String]) changeFilter;

  FilterMenu(
    this.key, {
    @required this.changeFilter,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FilterMenuState();
  }
}

class FilterMenuState extends State<FilterMenu>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _offset;
  Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..addListener(() => setState(() {}));
    _opacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_animationController);
    _offset = Tween<double>(
      begin: 80,
      end: 0,
    ).animate(_animationController);
  }

  void show() => _animationController.forward();

  void hide() => _animationController.reverse();

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _opacity.value,
      child: Transform.translate(
        offset: Offset(0, _offset.value),
        child: SizedBox(
          height: 76,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // Remove filter button
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                child: GestureDetector(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: kElevationToShadow[2],
                      color: Colors.white,
                    ),
                    child: SizedBox(
                      height: 60,
                      width: 60,
                      child: Center(
                        child: Icon(Icons.close, size: 36, color: Colors.red),
                      ),
                    ),
                  ),
                  // 00 is a transparent image texture, so this function effectively removes any filter
                  onTap: () => widget.changeFilter('00'),
                ),
              ),

              // Add your filters here, example below

              // Button image files are located in the assets/images/ folder
              // Face textures must be located in the unity/arcore/Assets/Resources and named "texture_$yourName"
              // 3D models must be added to the FaceAttachment gameobject in Unity and marked as inactive.

              // Please see:
              // https://developers.google.com/ar/develop/developer-guides/creating-assets-for-augmented-faces
              // README

              /*FilterButton(
                select: widget.changeFilter,
                image: '01',
                texture: '01',
                model: 'fox_sample',
              ),*/
            ],
          ),
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
