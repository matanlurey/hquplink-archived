import 'package:flutter/material.dart';
import 'package:hquplink/models.dart';
import 'package:hquplink/services.dart';
import 'package:hquplink/widgets.dart';

class PreviewArmyTile extends StatelessWidget {
  /// Army being previewed.
  final Army army;

  /// Invoked when the tile is being dismissed to delete it.
  final void Function() onDismiss;

  /// Invoked when the user confirms they want the army deleted.
  final void Function() onDeleted;

  /// Invoked when the user declines wanting the army deleted.
  final void Function() onRestore;

  /// Invoked when the user modifies the instance and updates it.
  final void Function(Army) onUpdate;

  PreviewArmyTile({
    @required this.army,
    @required this.onDismiss,
    @required this.onDeleted,
    @required this.onRestore,
    @required this.onUpdate,
  }) : super(key: Key(army.id));

  @override
  build(context) {
    final catalog = getCatalog(context);
    return Dismissible(
      key: Key(army.id),
      child: ListTile(
        title: Text(army.name),
        subtitle: Text('${catalog.sumArmyPoints(army)} points'),
        leading: FactionIcon(
          army.faction,
          height: 24,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) {
                return ManageArmyPage(
                  army: army,
                  onDelete: () => _onDismiss(context, catalog),
                  onSave: onUpdate,
                );
              },
              fullscreenDialog: true,
            ),
          );
        },
      ),
      background: const _DismissBackground(),
      onDismissed: (_) => _onDismiss(context, catalog),
    );
  }

  void _onDismiss(
    BuildContext context,
    Catalog catalog, {
    bool confirm = false,
  }) async {
    onDismiss();
    if (confirm && catalog.sumArmyPoints(army) > 0) {
      if (await showConfirmDialog(
        context: context,
        title: 'Delete army?',
        discardText: 'Delete',
      )) {
        return onRestore();
      }
    }
    onDeleted();
  }
}

class _DismissBackground extends StatelessWidget {
  const _DismissBackground();

  @override
  build(context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.primaryColor,
      child: Row(
        children: const [
          Icon(Icons.delete),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}
