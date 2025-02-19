import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/extensions/string_links.dart';
import 'package:lunasea/modules/sonarr.dart';

class SonarrSeriesDetailsOverviewLinksSection extends StatelessWidget {
  final SonarrSeries series;

  const SonarrSeriesDetailsOverviewLinksSection({
    Key? key,
    required this.series,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LunaButtonContainer(
      buttonsPerRow: 4,
      children: [
        if (series.imdbId != null && series.imdbId!.isNotEmpty)
          LunaCard(
            context: context,
            child: InkWell(
              child: Padding(
                child: Image.asset(LunaAssets.serviceImdb),
                padding: const EdgeInsets.all(12.0),
              ),
              borderRadius: BorderRadius.circular(LunaUI.BORDER_RADIUS),
              onTap: () async => await series.imdbId!.openImdb(),
            ),
            height: 50.0,
            margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
          ),
        if (series.tvdbId != null && series.tvdbId != 0)
          LunaCard(
            context: context,
            child: InkWell(
              child: Padding(
                child: Image.asset(LunaAssets.serviceTrakt),
                padding: const EdgeInsets.all(12.0),
              ),
              borderRadius: BorderRadius.circular(LunaUI.BORDER_RADIUS),
              onTap: () async =>
                  await series.tvdbId!.toString().openTraktSeries(),
            ),
            height: 50.0,
            margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
          ),
        if (series.tvdbId != null && series.tvdbId != 0)
          LunaCard(
            context: context,
            child: InkWell(
              child: Padding(
                child: Image.asset(LunaAssets.serviceThetvdb),
                padding: const EdgeInsets.all(12.0),
              ),
              borderRadius: BorderRadius.circular(LunaUI.BORDER_RADIUS),
              onTap: () async =>
                  await series.tvdbId!.toString().openTvdbSeries(),
            ),
            height: 50.0,
            margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
          ),
        if (series.tvMazeId != null && series.tvMazeId != 0)
          LunaCard(
            context: context,
            child: InkWell(
              child: Padding(
                child: Image.asset(LunaAssets.serviceTvmaze),
                padding: const EdgeInsets.all(12.0),
              ),
              borderRadius: BorderRadius.circular(LunaUI.BORDER_RADIUS),
              onTap: () async => await series.tvMazeId!.toString().openTvMaze(),
            ),
            height: 50.0,
            margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
          ),
      ],
    );
  }
}
