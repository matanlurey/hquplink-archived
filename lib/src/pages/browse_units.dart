import 'package:flutter/material.dart';
import 'package:swlegion/swlegion.dart';

import '../services/catalog.dart';

class BrowseUnitsPage extends StatelessWidget {
  const BrowseUnitsPage();

  @override
  build(context) {
    final catalog = Catalog.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Units'),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: catalog.units.map((unit) {
            return ListTile(
              leading: _UnitPreview(unit),
              title: Text(
                unit.name,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: unit.subTitle != null ? Text(unit.subTitle) : null,
            );
          }).toList(),
        ).toList(),
      ),
    );
  }
}

class _UnitPreview extends StatelessWidget {
  // TODO: Generate at build time instead of hard-coded.
  // If images are missing from assets/cards/*, we just show a placeholder instead.
  static final _hasAssets = Set.of(const [
    '1_4_FD_LASER_CANNON_TEAM',
    '74_Z_SPEEDER_BIKES',
    'AT_RT',
    'AT_ST',
    'BOBA_FETT',
    'DARTH_VADER',
    'E_WEB_HEAVY_BLASTER_TEAM',
    'EMPEROR_PALPATINE',
    'FLEET_TROOPERS',
    'GENERAL_VEERS',
    'HAN_SOLO',
    'IMPERIAL_ROYAL_GUARDS',
    'LEIA_ORGANA',
    'REBEL_COMMANDOS_STRIKE_TEAM',
    'REBEL_COMMANDOS',
    'REBEL_TROOPERS',
    'SCOUT_TROOPERS_STRIKE_TEAM',
    'SCOUT_TROOPERS',
    'SNOWTROOPERS',
    'STORMTROOPERS',
    'T_47_AIRSPEEDER',
  ]);

  final Unit unit;

  const _UnitPreview(this.unit) : assert(unit != null);

  @override
  build(context) {
    return SizedBox(
      width: 72,
      height: 72,
      child: _hasAssets.contains(unit.id)
          ? Image.asset('assets/cards/${unit.id.toLowerCase()}.png')
          : _MissingPreview(unit),
    );
  }
}

class _MissingPreview extends StatelessWidget {
  final Unit unit;

  const _MissingPreview(this.unit);

  @override
  build(_) {
    return Stack(
      children: [
        Image.asset('assets/cards/__missing.png'),
        Center(
          child: Text(
            unit.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 8,
            ),
          ),
        )
      ],
    );
  }
}
