import 'package:isar_plus/isar_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'models/entry.dart';

late final Isar isar;
final secureStorage = const FlutterSecureStorage();




Future<void> initDb() async {
  final dir = await getApplicationDocumentsDirectory();
  isar = Isar.open(schemas: [EntrySchema], directory: dir.path,);
}
