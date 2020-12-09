import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final Function(String, [String]) select;
  final String image, texture, model;

  FilterButton({
    @required this.select,
    @required this.image,
    @required this.texture,
    this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: 12,
        bottom: 16,
      ),
      child: GestureDetector(
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(
                'assets/images/filters/' + image + '.jpg',
              ),
              fit: BoxFit.cover,
            ),
            boxShadow: kElevationToShadow[3],
          ),
          child: SizedBox(
            height: 60,
            width: 60,
          ),
        ),
        onTap: () => select(texture, model),
      ),
    );
  }
}
