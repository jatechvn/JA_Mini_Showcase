import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:ja_mini_showcase/modules/search_history_repository.dart';

void main() {
  test(
    'Concurrent writes survive reload and cleared demo history stays empty',
    () async {
      final dir = await Directory.systemTemp.createTemp('ja-history-');
      final file = File('${dir.path}/history.json');
      final repo = SearchHistoryRepository()..setStorageFileForTesting(file);
      addTearDown(() async {
        repo.setStorageFileForTesting(null);
        await dir.delete(recursive: true);
      });
      await file.writeAsString('{"devices":[],"components":[]}');
      await Future.wait(
        List.generate(10, (i) => repo.addQuery('devices', 'query-$i')),
      );
      expect(
        (jsonDecode(await file.readAsString()) as Map)['devices'],
        hasLength(10),
      );
      repo.setStorageFileForTesting(file);
      expect(await repo.getHistory('devices'), hasLength(10));
      await repo.clearHistory('devices');
      repo.setStorageFileForTesting(file);
      expect(await repo.getHistory('devices'), isEmpty);
    },
  );
}
