import 'package:flutter/material.dart';
import 'package:hquplink/models.dart';

class UnitCreatePage extends StatelessWidget {
  final Army army;

  const UnitCreatePage({
    @required this.army,
  }) : assert(army != null);

  @override
  build(_) {
    return Center(
      child: Text(army.name),
    );
  }
}
