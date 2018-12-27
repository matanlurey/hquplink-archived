import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Provides a mutable interface for a [State] object's state [T].
abstract class Mutex<T, Y extends StatefulWidget> extends State<Y> {
  T _value;

  /// Value that is potentially mutated.
  @protected
  T get value => _value;

  @protected
  void setValue(
    T value, {
    String Function(T) describeRevert,
    BuildContext notifyRevert,
  }) {
    setState(() => _value = value);
    onUpdate(value, widget);
    if (notifyRevert != null) {
      assert(describeRevert != null);
      _promptUndo(notifyRevert, describeRevert(value), value);
    }
  }

  void _promptUndo(BuildContext context, String description, T oldValue) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(description),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setValue(oldValue);
          },
        ),
      ),
    );
  }

  @override
  initState() {
    _value = initMutex(widget);
    super.initState();
  }

  /// Override to provide updates to a parent widget about a [newValue].
  ///
  /// Updates should be provided via `=`.
  @protected
  @visibleForOverriding
  void onUpdate(T newValue, Y widget);

  /// Override to provide the initial mutable value, often from the parent [widget].
  @protected
  @visibleForOverriding
  T initMutex(Y widget);
}
