import 'package:flutter/widgets.dart';

import 'src/services/catalog.dart';

export 'src/services/catalog.dart';
export 'src/services/json_storage.dart';
export 'src/services/unique_ids.dart';

/// Provides [catalog] accessible via [getCatalog] to [child]'s [Widget] tree.
///
/// May optionally provide [updates].
Widget provideCatalog(Catalog catalog, Widget child,
    {Stream<Catalog> updates}) {
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
  bool updateShouldNotify(_CatalogModel oldWidget) => this == oldWidget;
}
