import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/extensions/string.dart';
import 'package:lunasea/modules/search.dart';

class SearchResultTile extends StatelessWidget {
  final NewznabResultData data;

  const SearchResultTile({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LunaExpandableListTile(
      title: data.title,
      collapsedSubtitles: [
        _subtitle1(),
        _subtitle2(),
      ],
      expandedTableContent: _tableContent(),
      collapsedTrailing: _trailing(context),
      expandedTableButtons: _tableButtons(context),
    );
  }

  TextSpan _subtitle1() {
    return TextSpan(children: [
      TextSpan(text: data.size.lunaBytesToString()),
      TextSpan(text: LunaUI.TEXT_BULLET.pad()),
      TextSpan(text: data.category),
    ]);
  }

  TextSpan _subtitle2() {
    return TextSpan(text: data.age);
  }

  List<LunaTableContent> _tableContent() {
    return [
      LunaTableContent(title: 'search.Age'.tr(), body: data.age),
      LunaTableContent(
          title: 'search.Size'.tr(), body: data.size.lunaBytesToString()),
      LunaTableContent(title: 'search.Category'.tr(), body: data.category),
      if (SearchDatabaseValue.SHOW_LINKS.data)
        LunaTableContent(title: '', body: ''),
      if (SearchDatabaseValue.SHOW_LINKS.data)
        LunaTableContent(
            title: 'search.Comments'.tr(),
            body: data.linkComments,
            bodyIsUrl: true),
      if (SearchDatabaseValue.SHOW_LINKS.data)
        LunaTableContent(
            title: 'search.Download'.tr(),
            body: data.linkDownload,
            bodyIsUrl: true),
    ];
  }

  List<LunaButton> _tableButtons(BuildContext context) {
    return [
      LunaButton.text(
        icon: Icons.download_rounded,
        text: 'search.Download'.tr(),
        onTap: () async => _sendToClient(context),
      ),
    ];
  }

  LunaIconButton _trailing(BuildContext context) {
    return LunaIconButton(
      icon: Icons.download_rounded,
      onPressed: () => _sendToClient(context),
    );
  }

  Future<void> _sendToClient(BuildContext context) async {
    Tuple2<bool, SearchDownloadType?> result =
        await SearchDialogs().downloadResult(context);
    if (result.item1) result.item2!.execute(context, data);
  }
}
