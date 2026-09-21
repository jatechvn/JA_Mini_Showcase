import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;

/// Repository managing persistent search history queries per category (e.g. 'devices', 'components').
class SearchHistoryRepository {
  static final SearchHistoryRepository _instance =
      SearchHistoryRepository._internal();
  factory SearchHistoryRepository() => _instance;
  SearchHistoryRepository._internal();

  File? _customStorageFile;
  final Map<String, List<String>> _cache = {};
  bool _isLoaded = false;
  Future<void>? _loading;
  Future<void> _pendingSave = Future.value();
  static const int maxHistoryPerCategory = 10;

  /// Allows unit tests to redirect JSON storage to a temporary file.
  void setStorageFileForTesting(File? file) {
    _customStorageFile = file;
    _isLoaded = false;
    _loading = null;
    _cache.clear();
  }

  File _getStorageFile() {
    if (_customStorageFile != null) return _customStorageFile!;
    final dataDir = Directory(p.join(Directory.current.path, 'data'));
    if (!dataDir.existsSync()) {
      try {
        dataDir.createSync(recursive: true);
      } catch (_) {}
    }
    return File(p.join(dataDir.path, 'search_history.json'));
  }

  Future<void> _load() {
    if (_isLoaded) return Future.value();
    return _loading ??= _loadOnce();
  }

  Future<void> _loadOnce() async {
    try {
      final file = _getStorageFile();
      if (await file.exists()) {
        final raw = await file.readAsString();
        if (raw.trim().isNotEmpty) {
          final decoded = jsonDecode(raw);
          if (decoded is Map<String, dynamic>) {
            _cache.clear();
            for (final entry in decoded.entries) {
              if (entry.value is List) {
                _cache[entry.key] = (entry.value as List)
                    .map((e) => e.toString())
                    .where((s) => s.trim().isNotEmpty)
                    .toList();
              }
            }
          }
        }
      }
    } catch (_) {}

    // Seed default demo history for showcase if category is empty
    _seedInitialShowcaseData();
    _isLoaded = true;
  }

  void _seedInitialShowcaseData() {
    if (!_cache.containsKey('devices')) {
      _cache['devices'] = [
        'iPhone 15 Pro',
        '192.168.10.102',
        'MacBook Pro M3',
        '192.168.20.108',
      ];
    }
    if (!_cache.containsKey('components')) {
      _cache['components'] = [
        'GlassTerminal',
        'BentoCard',
        'Dropdown',
        'GlowingButton',
      ];
    }
  }

  Future<void> _save() {
    final file = _getStorageFile();
    final snapshot = jsonEncode(_cache);
    return _pendingSave = _pendingSave.then((_) async {
      try {
        await file.writeAsString(snapshot);
      } catch (_) {}
    });
  }

  /// Returns recent search queries for a category (most recent first).
  Future<List<String>> getHistory(String category) async {
    await _load();
    return List.unmodifiable(_cache[category] ?? []);
  }

  /// Adds or moves a query to the top of recent history.
  Future<void> addQuery(String category, String query) async {
    final clean = query.trim();
    if (clean.isEmpty) return;

    await _load();
    final list = _cache.putIfAbsent(category, () => []);
    list.remove(clean);
    list.insert(0, clean);
    if (list.length > maxHistoryPerCategory) {
      list.removeRange(maxHistoryPerCategory, list.length);
    }
    await _save();
  }

  /// Removes a single query entry from category history.
  Future<void> removeQuery(String category, String query) async {
    await _load();
    final list = _cache[category];
    if (list != null) {
      list.remove(query.trim());
      await _save();
    }
  }

  /// Clears all history for a category.
  Future<void> clearHistory(String category) async {
    await _load();
    _cache[category]?.clear();
    await _save();
  }
}
