import 'package:flutter/material.dart';
import 'package:quicksnap/features/settings/models.dart';
import 'package:flutter_animate/flutter_animate.dart';


///Creates an horizontal array of circular colored widget.

class ColorButtonTray extends StatefulWidget {
  ColorButtonTray({
    super.key,
    required this.value,
    required this.colors,
    required this.onTap,
  });
  /// The  current value of the button.
  UserColorEnum value;
  /// List of possibel color value.
  final List<UserColorEnum> colors;
  /// Callback to that will run when te button is clicked.
  final void Function(UserColorEnum) onTap;
  @override
  State<ColorButtonTray> createState() => CircularColorButton();
}

class CircularColorButton extends State<ColorButtonTray> {
  CircularColorButton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          children: widget.colors
              .map((color) => _singleColorPicker(color))
              .toList(),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            "Select A Color Style",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }

  Widget _singleColorPicker(UserColorEnum color) {
    bool isSelected = widget.value == color;
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.value = color;
        });
        widget.onTap(color);
      },
      
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 4.0,
            color: isSelected
                ? Theme.of(context).focusColor
                : Colors.transparent,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
        margin: .symmetric(horizontal:10.0),
        padding: .all(2.0),
        child: CircleAvatar(backgroundColor: color.toMaterialColor()),
      ),
    );
  }
}


ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
customScaffoldMessenger(BuildContext context, Text content) {
  return ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: content, duration: 7.seconds));
}
