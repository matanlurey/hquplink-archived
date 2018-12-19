import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:swlegion/swlegion.dart';

final _modelOfTable = Expando<TableModel>();

/// Synchronous access to the "table" state of the application.
class Table {
  /// Returns the currently provided [Table] given a build [context].
  static Table of(BuildContext context) {
    final model = context.inheritFromWidgetOfExactType(TableModel);
    if (model is TableModel) {
      return model.table;
    }
    throw StateError('No provider found for $Table.');
  }

  /// Elements currently inside of the table.
  final List<Object> elements;

  /// Version of the table.
  ///
  /// **NOTE**: This is used to determine if updates are necessary!
  final int version;

  const Table({
    @required this.elements,
    @required this.version,
  });

  factory Table.fromJson(Map<String, Object> json) {
    final elements = json['elements'] as List;
    return Table(
      elements: elements.map(serializers.deserialize).toList(),
      version: json['version'] as int,
    );
  }

  static Future<Table> fromDisk() async {
    final appDir = await getApplicationDocumentsDirectory();
    final diskFile = File(p.join(appDir.path, 'table.json'));
    try {
      final jsonData = jsonDecode(
        await diskFile.readAsString(),
      ) as Map<String, Object>;
      return Table.fromJson(jsonData);
    } on FileSystemException catch (_) {
      return const Table(elements: [], version: 1);
    }
  }

  @override
  bool operator ==(Object o) => o is Table && o.version == version;

  @override
  int get hashCode => version;

  /// Maps [elements] visiting the functions providing as needed.
  Iterable<T> mapElements<T>({
    @required T Function(ArmyUnit) buildUnit,
  }) sync* {
    for (final e in elements) {
      if (e is ArmyUnit) {
        yield buildUnit(e);
      }
    }
  }

  void appendUnit(Unit unit) {
    final armyUnit = ArmyUnit(
      (b) => b..unit = unit.toBuilder(),
    );
    final elements = this.elements.toList()..add(armyUnit);
    final version = this.version + 1;
    _model.onUpdate(Table(
      elements: elements,
      version: version,
    ));
  }

  void removeUnit(ArmyUnit unit) {
    _model.onUpdate(Table(
      elements: elements.toList()..remove(unit),
      version: version + 1,
    ));
  }

  Map<String, Object> toJson() {
    return {
      'elements': elements.map(serializers.serialize),
      'version': version,
    };
  }

  Future<void> writeToDisk() async {
    final appDir = await getApplicationDocumentsDirectory();
    final diskFile = File(p.join(appDir.path, 'table.json'));
    await diskFile.writeAsString(jsonEncode(toJson()));
  }

  // Used to refer back to the [TableModel].
  TableModel get _model => _modelOfTable[this];
}

/// An [InheritedModel] that provides access to the [Table].
class TableModel extends InheritedModel<Table> {
  /// Table data model.
  final Table table;

  /// Update the currently accessed [Table].
  final void Function(Table) onUpdate;

  TableModel({
    @required this.table,
    @required this.onUpdate,
    Widget child,
  })  : assert(table != null),
        super(child: child) {
    _modelOfTable[table] = this;
  }

  @override
  bool updateShouldNotify(TableModel old) => old.table != table;

  @override
  bool updateShouldNotifyDependent(
    TableModel old,
    Set<Table> dependencies,
  ) {
    return updateShouldNotify(old) && dependencies.contains(table);
  }
}
