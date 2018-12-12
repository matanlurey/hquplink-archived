import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:swlegion/swlegion.dart';

/// Synchronous access to Star Wars: Legion data.
///
/// It's expected that access to the catalog is either pre-fetched, cached, or
/// bundled with the application. If downloading for the first time then parts
/// of the app may want to indicate unavailable.
class Catalog {
  /// Returns the currently provided [Catalog] given a build [context].
  static Catalog of(BuildContext context) {
    final model = context.inheritFromWidgetOfExactType(CatalogModel);
    if (model is CatalogModel) {
      return model.catalog;
    }
    throw StateError('No provider found for $Catalog.');
  }

  /// Units in the catalog.
  final List<Unit> units;

  /// Upgrades in the catalog.
  final List<Upgrade> upgrades;

  /// Weapons in the catalog.
  final List<Weapon> weapons;

  /// Version of the catalog.
  ///
  /// **NOTE**: This is used to determine if updates are necessary!
  final int version;

  const Catalog({
    @required this.units,
    @required this.upgrades,
    @required this.weapons,
    @required this.version,
  });

  @override
  bool operator ==(Object o) => o is Catalog && o.version == version;

  @override
  int get hashCode => version;
}

/// An [InheritedModel] that provides access to the [Catalog].
class CatalogModel extends InheritedModel<Catalog> {
  final Catalog catalog;

  const CatalogModel({
    @required this.catalog,
    Widget child,
  })  : assert(catalog != null),
        super(child: child);

  @override
  bool updateShouldNotify(CatalogModel old) => old.catalog != catalog;

  @override
  bool updateShouldNotifyDependent(
    CatalogModel old,
    Set<Catalog> dependencies,
  ) {
    return updateShouldNotify(old) && dependencies.contains(catalog);
  }
}
