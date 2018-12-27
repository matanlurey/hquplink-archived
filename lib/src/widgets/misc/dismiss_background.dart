import 'package:flutter/material.dart';

class DismissBackground extends StatelessWidget {
  const DismissBackground();

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
