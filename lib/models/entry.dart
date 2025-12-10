import 'package:isar/isar.dart';
part 'entry.g.dart';  // ← will be generated

@collection
class Entry {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late DateTime createdAt;

  String? text;
  String? photoPath;   // local file path
}
