import 'package:flutter_quill/quill_delta.dart';

class QuickSnapNote{
  final Delta delta;
  /// Milliseconds since epoch.
  final int dateCreated;
  QuickSnapNote({required this.delta,required this.dateCreated});
}