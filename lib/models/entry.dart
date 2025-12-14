import 'package:isar_plus/isar_plus.dart';
part 'entry.g.dart'; // ← will be generated

@collection
class Entry {
  Entry(this.id);
  final int id;
  @Index()
  late DateTime createdAt;

  String? text;
  String? photoPath; // local file path
}
