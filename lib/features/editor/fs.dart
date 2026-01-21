import 'dart:io';

class EditorFile {
  EditorFile(this.dirPath);
  final String dirPath;
  Directory? dirHandle;

  Future<List<File?>> getTxtFiles() async {
    final handle = dirHandle ?? Directory(dirPath);
    Stream<FileSystemEntity> fsEntities = await handle.list();

    var fileList = fsEntities.map((entity) {
      if (entity is File && entity.path.endsWith(".txt")) return entity;
    }).toList();

    return fileList;
  }
}