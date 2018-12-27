import 'dart:async';

import 'package:flutter/material.dart';

/// Displays a confirmation dialog to confirm an action.
///
/// Returns a future that completse with `true` to confirm, `false` to cancel.
Future<bool> showConfirmDialog({
  @required BuildContext context,
  @required String discardText,
  String title = 'Are you sure?',
  String cancelText = 'Cancel',
}) {
  return showDialog(
    context: context,
    builder: (_) {
      return _ConfirmDialog(
        title: title,
        discardText: discardText,
        cancelText: cancelText,
      );
    },
  );
}

class _ConfirmDialog extends StatelessWidget {
  final String title;
  final String discardText;
  final String cancelText;

  _ConfirmDialog({
    @required this.title,
    @required this.discardText,
    @required this.cancelText,
  }) : super(key: Key('_ConfirmDialog:$title'));

  @override
  build(context) {
    return AlertDialog(
      content: Text(title),
      actions: [
        FlatButton(
          child: Text(cancelText.toUpperCase()),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        FlatButton(
          child: Text(discardText.toUpperCase()),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
