/// Represents the remote version configuration for app updates.
/// 
/// This model is used to parse the JSON response from the update server
/// and determine if an update is available.
class UpdateConfig {
  /// The latest version string (e.g., "1.0.1")
  final String latestVersion;
  
  /// The URL to download the armeabi_v8a APK file from
  final String downloadUrlV8a;
  /// The URL to download the armeabi_v7a APK file from
  final String downloadUrlV7a;
  
  /// Whether this update is mandatory (user cannot skip it)
  final bool isMandatory;
  
  /// Optional: Release notes or description of changes
  final String? releaseNotes;

  const UpdateConfig({
    required this.latestVersion,
    required this.downloadUrlV8a,
    required this.downloadUrlV7a,
    required this.isMandatory,
    this.releaseNotes,
  });

  /// Creates an UpdateConfig from a JSON map.
  factory UpdateConfig.fromJson(Map<String, dynamic> json) {
    return UpdateConfig(
      latestVersion: json['latest_version'] as String,
      downloadUrlV8a: json['download_url_v8a'] as String,
      downloadUrlV7a: json['download_url_v7a'] as String,
      isMandatory: json['is_mandatory'] as bool? ?? false,
      releaseNotes: json['release_notes'] as String?,
    );
  }

  /// Converts the UpdateConfig to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'latest_version': latestVersion,
      'download_url': downloadUrlV8a,
      'is_mandatory': isMandatory,
      if (releaseNotes != null) 'release_notes': releaseNotes,
    };
  }

  @override
  String toString() {
    return 'UpdateConfig(latestVersion: $latestVersion, downloadUrlV8a: $downloadUrlV8a,downloadUrlV7a: $downloadUrlV7a, '
        'isMandatory: $isMandatory, releaseNotes: $releaseNotes)';
  }
}