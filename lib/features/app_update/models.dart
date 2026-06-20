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

  /// The URL to download the universal APK file from
  final String downloadUrlUniversal;

  /// Whether this update is mandatory (user cannot skip it)
  final bool isMandatory;

  /// Optional: Release notes or description of changes
  final String? releaseNotes;

  /// The build number from the release tag (e.g., 3 from "v1.0.0+3")
  final int buildNumber;

  const UpdateConfig({
    required this.latestVersion,
    required this.downloadUrlV8a,
    required this.downloadUrlV7a,
    this.downloadUrlUniversal = '',
    this.isMandatory = false,
    this.releaseNotes,
    this.buildNumber = 0,
  });

  /// Creates an UpdateConfig from a JSON map.
  factory UpdateConfig.fromJson(Map<String, dynamic> json) {
    return UpdateConfig(
      latestVersion: json['latest_version'] as String,
      downloadUrlV8a: json['download_url_v8a'] as String,
      downloadUrlV7a: json['download_url_v7a'] as String,
      downloadUrlUniversal: json['download_url_universal'] as String? ?? '',
      isMandatory: json['is_mandatory'] as bool? ?? false,
      releaseNotes: json['release_notes'] as String?,
      buildNumber: json['build_number'] as int? ?? 0,
    );
  }

  /// Creates an UpdateConfig from a GitHub Release API response.
  ///
  /// Parses the release JSON returned by:
  ///   GET /repos/{owner}/{repo}/releases?per_page=1
  ///
  /// The release tag format is: v{version}+{buildNumber} (e.g., "v1.0.0+3")
  /// APK assets are matched by their filenames.
  factory UpdateConfig.fromGitHubRelease(Map<String, dynamic> release) {
    final tagName = release['tag_name'] as String? ?? '';
    // Strip leading "v" and split version+build: "v1.0.0+3" → "1.0.0" and 3
    final versionWithoutV = tagName.startsWith('v')
        ? tagName.substring(1)
        : tagName;
    // Split on "+" to extract build number: "1.2.0+3" → ["1.2.0", "3"]
    final parts = versionWithoutV.split('+');
    // Strip prerelease suffix from the version: "3.19.0-0.1.pre" → "3.19.0"
    final rawVersion = parts.isNotEmpty ? parts[0] : '';
    final version = rawVersion.split('-').first;
    final buildNumber = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;

    // Parse release body as release notes
    final body = release['body'] as String?;

    // Find APK assets from the release assets list
    final assets = release['assets'] as List<dynamic>? ?? [];
    String? v8aUrl;
    String? v7aUrl;
    String? universalUrl;

    for (final asset in assets) {
      final assetMap = asset as Map<String, dynamic>;
      final name = assetMap['name'] as String? ?? '';
      final downloadUrl = assetMap['browser_download_url'] as String? ?? '';

      if (name.contains('arm64-v8a')) {
        v8aUrl = downloadUrl;
      } else if (name.contains('armeabi-v7a')) {
        v7aUrl = downloadUrl;
      } else if (name.contains('universal')) {
        universalUrl = downloadUrl;
      }
    }

    return UpdateConfig(
      latestVersion: version,
      downloadUrlV8a: v8aUrl ?? universalUrl ?? '',
      downloadUrlV7a: v7aUrl ?? universalUrl ?? '',
      downloadUrlUniversal: universalUrl ?? '',
      isMandatory: false, // GitHub prereleases are always optional
      releaseNotes: body,
      buildNumber: buildNumber,
    );
  }

  /// Converts the UpdateConfig to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'latest_version': latestVersion,
      'download_url': downloadUrlV8a,
      'is_mandatory': isMandatory,
      'build_number': buildNumber,
      if (releaseNotes != null) 'release_notes': releaseNotes,
    };
  }

  @override
  String toString() {
    return 'UpdateConfig(latestVersion: $latestVersion, '
        'downloadUrlV8a: $downloadUrlV8a, '
        'downloadUrlV7a: $downloadUrlV7a, '
        'downloadUrlUniversal: $downloadUrlUniversal, '
        'isMandatory: $isMandatory, '
        'buildNumber: $buildNumber, '
        'releaseNotes: $releaseNotes)';
  }
}
