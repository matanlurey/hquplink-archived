import 'package:flutter/material.dart';
import 'package:hquplink/fakes.dart';
import 'package:hquplink/services.dart';

import '../shell.dart';

void main() {
  runApp(
    provideCatalog(
      Catalog.builtIn,
      AppShell(
        initialRoster: fakeRoster,
      ),
    ),
  );
}
