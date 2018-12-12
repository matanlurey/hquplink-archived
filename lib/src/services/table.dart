import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

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

  /// Version of the table.
  ///
  /// **NOTE**: This is used to determine if updates are necessary!
  final int version;

  const Table({
    @required this.version,
  });

  @override
  bool operator ==(Object o) => o is Table && o.version == version;

  @override
  int get hashCode => version;
}

/// An [InheritedModel] that provides access to the [Table].
class TableModel extends InheritedModel<Table> {
  final Table table;

  const TableModel({
    @required this.table,
    Widget child,
  })  : assert(table != null),
        super(child: child);

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
