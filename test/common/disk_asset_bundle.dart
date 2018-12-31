import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;

/// A simple implementation of [AssetBundle] that reads files from an asset dir.
///
/// This is meant to be similar to the default [rootBundle] for testing.
class DiskAssetBundle extends CachingAssetBundle {
  static const _assetManifestDotJson = 'AssetManifest.json';

  static String _findRootDir() {
    var dir = Directory.current.absolute;
    while (p.basename(dir.path) != 'hquplink') {
      dir = dir.parent;
    }
    return dir.path;
  }

  /// Creates a [DiskAssetBundle] by loading [globs] of assets under `assets/`.
  static Future<AssetBundle> loadGlob(
    Iterable<String> globs, {
    String from,
  }) async {
    from ??= _findRootDir();
    final cache = <String, ByteData>{};
    for (final pattern in globs) {
      await for (final path in Glob(pattern).list(root: from)) {
        if (path is File) {
          final bytes = await path.readAsBytes() as Uint8List;
          final asset = p.relative(path.path, from: from);
          cache[asset] = ByteData.view(bytes.buffer);
        }
      }
    }

    cache[_assetManifestDotJson] = ByteData.view(
      Uint8List.fromList('{}'.codeUnits).buffer,
    );

    return DiskAssetBundle._(cache);
  }

  final Map<String, ByteData> _cache;

  DiskAssetBundle._(this._cache);

  @override
  Future<ByteData> load(String key) async => _cache[key];
}
