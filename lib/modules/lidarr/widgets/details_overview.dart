import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/extensions/string_links.dart';
import 'package:lunasea/modules/lidarr.dart';

class LidarrDetailsOverview extends StatefulWidget {
  final LidarrCatalogueData data;

  const LidarrDetailsOverview({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<LidarrDetailsOverview> createState() => _State();
}

class _State extends State<LidarrDetailsOverview>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LunaListView(
      controller: LidarrArtistNavigationBar.scrollControllers[0],
      children: <Widget>[
        LidarrDescriptionBlock(
          title: widget.data.title,
          description: widget.data.overview == ''
              ? 'No Summary Available'
              : widget.data.overview,
          uri: widget.data.posterURI(),
          squareImage: true,
          headers: LunaProfile.current.getLidarr()['headers'],
        ),
        LunaButtonContainer(
          buttonsPerRow: 4,
          children: [
            if (widget.data.bandsintownURI?.isNotEmpty ?? false)
              LunaCard(
                context: context,
                child: InkWell(
                  child: Padding(
                    child: Image.asset(LunaAssets.serviceBandsintown),
                    padding: const EdgeInsets.all(12.0),
                  ),
                  borderRadius: BorderRadius.circular(LunaUI.BORDER_RADIUS),
                  onTap: () async => widget.data.bandsintownURI!.openLink(),
                ),
                height: 50.0,
                margin:
                    const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
              ),
            if (widget.data.discogsURI?.isNotEmpty ?? false)
              LunaCard(
                context: context,
                child: InkWell(
                  child: Padding(
                    child: Image.asset(LunaAssets.serviceDiscogs),
                    padding: const EdgeInsets.all(12.0),
                  ),
                  borderRadius: BorderRadius.circular(LunaUI.BORDER_RADIUS),
                  onTap: () async => widget.data.discogsURI!.openLink(),
                ),
                height: 50.0,
                margin:
                    const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
              ),
            if (widget.data.lastfmURI?.isNotEmpty ?? false)
              LunaCard(
                context: context,
                child: InkWell(
                  child: Padding(
                    child: Image.asset(LunaAssets.serviceLastfm),
                    padding: const EdgeInsets.all(12.0),
                  ),
                  borderRadius: BorderRadius.circular(LunaUI.BORDER_RADIUS),
                  onTap: () async => widget.data.lastfmURI!.openLink(),
                ),
                height: 50.0,
                margin:
                    const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
              ),
          ],
        ),
        LunaTableCard(
          content: [
            LunaTableContent(
              title: 'Path',
              body: widget.data.path,
            ),
            LunaTableContent(
              title: 'Quality',
              body: widget.data.quality,
            ),
            LunaTableContent(
              title: 'Metadata',
              body: widget.data.metadata,
            ),
            LunaTableContent(
              title: 'Albums',
              body: widget.data.albums,
            ),
            LunaTableContent(
              title: 'Tracks',
              body: widget.data.tracks,
            ),
            LunaTableContent(
              title: 'Genres',
              body: widget.data.genre,
            ),
          ],
        ),
      ],
    );
  }
}
