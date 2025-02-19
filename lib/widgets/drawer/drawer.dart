import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/wake_on_lan/api/wake_on_lan.dart';

class LunaDrawer extends StatelessWidget {
  final String page;

  const LunaDrawer({
    Key? key,
    required this.page,
  }) : super(key: key);

  static List<LunaModule> moduleOrderedList() {
    final db = LunaDatabaseValue.DRAWER_MANUAL_ORDER.data as List?;
    final modules = db?.cast<LunaModule>() ?? LunaModule.DASHBOARD.allModules();

    // Add any modules that were added after the user set their drawer order preference
    List<LunaModule> _missing = LunaModule.DASHBOARD.allModules()
      ..retainWhere((module) => !modules.contains(module));
    modules
      ..addAll(_missing)
      ..retainWhere((module) => module.featureFlag);

    return modules;
  }

  @override
  Widget build(BuildContext context) {
    return LunaDatabaseValue.ENABLED_PROFILE.listen(
      builder: (context, lunaBox, widget) => ValueListenableBuilder(
        valueListenable: Database.indexers.box.listenable(),
        builder: (context, dynamic indexerBox, widget) => Drawer(
          elevation: LunaUI.ELEVATION,
          backgroundColor: Theme.of(context).primaryColor,
          child: LunaDatabaseValue.DRAWER_AUTOMATIC_MANAGE.listen(
            builder: (context, _, __) => Column(
              children: [
                LunaDrawerHeader(page: page),
                Expanded(
                  child: LunaListView(
                    controller: PrimaryScrollController.of(context),
                    children: LunaDatabaseValue.DRAWER_AUTOMATIC_MANAGE.data
                        ? _getAlphabeticalOrder(context)
                        : _getManualOrder(context),
                    physics: const ClampingScrollPhysics(),
                    padding: MediaQuery.of(context).padding.copyWith(top: 0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _sharedHeader(BuildContext context) {
    return [
      _buildEntry(
        context: context,
        module: LunaModule.DASHBOARD,
      ),
    ];
  }

  List<Widget> _getAlphabeticalOrder(BuildContext context) {
    List<LunaModule> _modules = LunaModule.DASHBOARD.allModules()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return <Widget>[
      ..._sharedHeader(context),
      ..._modules.map((module) {
        if (module.isEnabled) {
          return _buildEntry(
            context: context,
            module: module,
            onTap: module == LunaModule.WAKE_ON_LAN ? _wakeOnLAN : null,
          );
        }
        return const SizedBox(height: 0.0);
      }),
    ];
  }

  List<Widget> _getManualOrder(BuildContext context) {
    List<LunaModule> _modules = moduleOrderedList();
    return <Widget>[
      ..._sharedHeader(context),
      ..._modules.map((module) {
        if (module.isEnabled) {
          return _buildEntry(
            context: context,
            module: module,
            onTap: module == LunaModule.WAKE_ON_LAN ? _wakeOnLAN : null,
          );
        }
        return const SizedBox(height: 0.0);
      }),
    ];
  }

  Widget _buildEntry({
    required BuildContext context,
    required LunaModule module,
    Function? onTap,
  }) {
    bool currentPage = page == module.key.toLowerCase();
    return SizedBox(
      height: LunaTextInputBar.defaultAppBarHeight,
      child: InkWell(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              child: Icon(
                module.icon,
                color: currentPage ? module.color : LunaColours.white,
              ),
              padding: LunaUI.MARGIN_DEFAULT_HORIZONTAL * 1.5,
            ),
            Text(
              module.name,
              style: TextStyle(
                color: currentPage ? module.color : LunaColours.white,
                fontWeight: LunaUI.FONT_WEIGHT_BOLD,
              ),
            ),
          ],
        ),
        onTap: onTap as void Function()? ??
            () async {
              LayoutBreakpoint _bp = context.breakpoint;
              if (_bp < LayoutBreakpoint.md) Navigator.of(context).pop();
              if (!currentPage) module.launch();
            },
      ),
    );
  }

  Future<void> _wakeOnLAN() async => LunaWakeOnLAN().wake();
}
