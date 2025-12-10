import 'dart:math';
import 'dart:typed_data';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'models/entry.dart';

late final Isar isar;
final secureStorage = const FlutterSecureStorage();

Uint8List generateEncryptionKey() {
  final random = Random.secure();
  final key = Uint8List(32);
  for (int i = 0; i < 32; i++) {
    key[i] = random.nextInt(256);
  }
  return key;
}

Future<List<int>> _getEncryptionKey() async {
  String? keyString = await secureStorage.read(key: 'isar_enc_key');
  if (keyString == null) {
    final key = generateEncryptionKey();
    await secureStorage.write(key: 'isar_enc_key', value: key.toString());
    return key;
  }
  return List<int>.generate(
    32,
    (i) => int.parse(keyString.substring(i * 2, i * 2 + 2), radix: 16),
  );
}

Future<void> initDb() async {
  final dir = await getApplicationDocumentsDirectory();
  final encryptionKey = await _getEncryptionKey();

  isar = await Isar.open(
    [EntrySchema],
    directory: dir.path,
    
  );
}
