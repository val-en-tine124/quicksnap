import 'dart:typed_data';
import 'dart:math';
import 'package:hex/hex.dart';

extension Uint8ListToHex on Uint8List {
  String toHex() {
    // Convert each byte to a 2-digit hexadecimal string using radix 16
    return map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }
}

Uint8List generateEncryptionKey() {
  final random = Random.secure();
  final key = Uint8List(32);
  for (int i = 0; i < 32; i++) {
    key[i] = random.nextInt(256);
  }
  return key;
}

void main() {
  Uint8List key = generateEncryptionKey();
  String str1 = key.toHex();
  String str2 = HexEncoder().convert(key);
  print(str1);
  print(str2);
  assert(str1 == str2);
}
