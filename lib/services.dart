import 'package:flutter/widgets.dart';

import 'src/services/auth.dart';
import 'src/services/catalog.dart';
import 'src/services/settings.dart';
import 'src/services/storage.dart';

export 'src/services/auth.dart';
export 'src/services/catalog.dart';
export 'src/services/settings.dart';
export 'src/services/storage.dart';
export 'src/services/unique_ids.dart';

/// Provides [catalog] accessible via [getCatalog] to [child]'s [Widget] tree.
///
/// May optionally provide [updates].
Widget provideCatalog(
  Catalog catalog,
  Widget child, {
  Stream<Catalog> updates,
}) {
  return StreamBuilder<Catalog>(
    builder: (context, snapshot) {
      return _CatalogModel(
        catalog: snapshot.data,
        child: child,
      );
    },
    initialData: catalog,
    stream: updates,
  );
}

/// Returns the [Catalog] service provides at the widget tree of [context].
Catalog getCatalog(BuildContext context) {
  final model = context.inheritFromWidgetOfExactType(_CatalogModel);
  return (model as _CatalogModel).catalog;
}

class _CatalogModel extends InheritedWidget {
  final Catalog catalog;

  const _CatalogModel({
    @required this.catalog,
    @required Widget child,
  }) : super(child: child);

  @override
  bool operator ==(Object o) => o is _CatalogModel && catalog == o.catalog;

  @override
  int get hashCode => catalog.hashCode;

  @override
  bool updateShouldNotify(oldWidget) => this == oldWidget;
}

/// Provides [storage] accessible via [getStorage] to [child]'s [Widget] tree.
Widget provideStorage(JsonStorage storage, Widget child) {
  return _StorageModel(
    storage: storage,
    child: child,
  );
}

/// Returns the [Catalog] service provides at the widget tree of [context].
Catalog getStorage(BuildContext context) {
  final model = context.inheritFromWidgetOfExactType(_CatalogModel);
  return (model as _CatalogModel).catalog;
}

class _StorageModel extends InheritedWidget {
  final JsonStorage storage;

  const _StorageModel({
    @required this.storage,
    @required Widget child,
  }) : super(child: child);

  @override
  bool operator ==(Object o) => o is _StorageModel && storage == o.storage;

  @override
  int get hashCode => storage.hashCode;

  @override
  bool updateShouldNotify(oldWidget) => this == oldWidget;
}

/// Provides [settings] accessible via [getSettings] to [child]'s [Widget] tree.
Widget provideSettings(Settings settings, Widget child) {
  return _SettingsModel(
    settings: settings,
    child: child,
  );
}

/// Returns the [Settings] service provides at the widget tree of [context].
Settings getSettings(BuildContext context) {
  final model = context.inheritFromWidgetOfExactType(_SettingsModel);
  return (model as _SettingsModel).settings;
}

class _SettingsModel extends InheritedWidget {
  final Settings settings;

  const _SettingsModel({
    @required this.settings,
    @required Widget child,
  }) : super(child: child);

  @override
  bool operator ==(Object o) => o is _SettingsModel && settings == o.settings;

  @override
  int get hashCode => settings.hashCode;

  @override
  bool updateShouldNotify(oldWidget) => this == oldWidget;
}

/// Provides [auth] accessible via [getAuth] to [child]'s [Widget] tree.
Widget provideAuth(Auth auth, Widget child) {
  return _AuthModel(
    auth: auth,
    child: child,
  );
}

/// Returns the [Auth] service provides at the widget tree of [context].
Auth getAuth(BuildContext context) {
  final model = context.inheritFromWidgetOfExactType(_AuthModel);
  return (model as _AuthModel).auth;
}

class _AuthModel extends InheritedWidget {
  final Auth auth;

  const _AuthModel({
    @required this.auth,
    @required Widget child,
  }) : super(child: child);

  @override
  bool operator ==(Object o) => o is _AuthModel && auth == o.auth;

  @override
  int get hashCode => auth.hashCode;

  @override
  bool updateShouldNotify(oldWidget) => this == oldWidget;
}
