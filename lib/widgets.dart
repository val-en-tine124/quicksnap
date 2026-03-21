import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';


ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
customScaffoldMessenger(BuildContext context, Text content) {
  return ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: content, duration: 7.seconds));
}
