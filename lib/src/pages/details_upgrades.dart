import 'package:flutter/material.dart';
import 'package:swlegion/swlegion.dart';

class DetailsUpgradePage extends StatelessWidget {
  final Upgrade upgrade;

  const DetailsUpgradePage(this.upgrade);

  @override
  build(context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 128,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                child: Text(
                  upgrade.name,
                  textScaleFactor: 0.8,
                ),
              ),
            ),
          ),
          const SliverList(
            delegate: SliverChildListDelegate([]),
          ),
        ],
      ),
    );
  }
}
