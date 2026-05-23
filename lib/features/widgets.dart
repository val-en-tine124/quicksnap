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

  /// List of possible color value.
  final List<UserColorEnum> colors;

  /// Callback to that will run when the button is clicked.
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
        margin: .symmetric(horizontal: 10.0),
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
  ).showSnackBar(SnackBar(content: content, duration: 4.seconds));
}

class CustomImageButton extends StatelessWidget {
  const CustomImageButton({
    super.key,
    required this.onTap,
    required this.imagePath,
  });
  final VoidCallback onTap;

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        radius: 50.0,
        splashColor: Theme.of(context).focusColor.withValues(alpha: 0.32),
        child: Image.asset(imagePath, width: 200.0, height: 100.0),
      ),
    );
  }
}

class ImageCardButton extends StatelessWidget {
  const ImageCardButton({
    super.key,
    required this.textSize,
    required this.textBgColor,
    required this.textFgColor,
    required this.color,
    required this.iconPath,
    required this.imageText,
    required this.onTap,
  });
  final Color color;
  final VoidCallback onTap;
  final double textSize;
  final Color textBgColor;
  final Color textFgColor;
  final String iconPath;
  final String imageText;
  @override
  Widget build(BuildContext context) {
    // return InkWell(
    //   child: Card(
    //     margin: .symmetric(horizontal: 10.0, vertical: 10.0),
    //     color: color,
    //     shape: RoundedRectangleBorder(
    //       side: BorderSide(),
    //       borderRadius: .circular(5.0),
    //     ),
    //     child: Row(
    //       children: [
    //         Image.asset(iconPath, cacheHeight: 50, cacheWidth: 50),
    //         Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: Text(
    //             imageText,
    //             style: TextStyle(
    //               backgroundColor: textBgColor,
    //               color: textFgColor,
    //               fontFamily: "CodePro",
    //               fontStyle: .italic,
    //               fontSize: textSize,
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Image.asset(iconPath, width: 50.0, height: 50.0),
      iconAlignment: .start,
      label: Text(
        imageText,
        style: TextStyle(
          backgroundColor: textBgColor,
          color: textFgColor,
          fontFamily: "CodePro",
          fontStyle: .italic,
          fontSize: textSize,
        ),
      ),
      style: ButtonStyle(),
      clipBehavior: .hardEdge,
    );
  }
}

///THis is a rainbow text, that repeatedly animate itself with the colors of the rainbow.
class RainBowButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  const RainBowButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 2.seconds,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red,
            Colors.orange,
            Colors.yellow,
            Colors.green,
            Colors.blue,
            Colors.indigo,
            Colors.purple,
          ],
          begin: .topLeft,
          end: .bottomRight,
        ),
      ),
      child: TextButton(onPressed: onPressed, child: Text(text)),
    );
  }
}

class RainBowText extends StatefulWidget {
  final String text;
  const RainBowText({super.key, required this.text});

  @override
  State<RainBowText> createState() => _RainBowTextState();
}

class _RainBowTextState extends State<RainBowText>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: 5.seconds, vsync: this)
      ..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: controller,
        child: Text(
          widget.text,
          style: TextStyle(fontWeight: .w400, fontSize: 15),
        ),
        builder: (context, child) {
          return ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: .topLeft,
                end: .bottomRight,
                colors: [
                  Colors.red,
                  Colors.orange,
                  Colors.yellow,
                  Colors.green,
                  Colors.blue,
                  Colors.indigo,
                  Colors.purple,
                ],
                tileMode: .mirror,
                transform: GradientRotation(12),
              ).createShader(Offset.zero & bounds.size);
            },
            child: child,
          );
        },
      ),
    );
  }
}
