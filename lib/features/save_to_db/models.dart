
class QuickSnapNote{
  final String deltaJson;
  /// Milliseconds since epoch.
  late int dateCreated;
  QuickSnapNote({required this.deltaJson,}){
    dateCreated = DateTime.now().millisecondsSinceEpoch;
  }
  
}