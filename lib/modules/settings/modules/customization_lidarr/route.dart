import 'package:fluro_fork/fluro_fork.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/settings.dart';

class SettingsCustomizationLidarrRoute extends StatefulWidget {
    static const ROUTE_NAME = '/settings/customization/lidarr';
    static String route() => ROUTE_NAME;

    static void defineRoute(Router router) => router.define(
        ROUTE_NAME,
        handler: Handler(handlerFunc: (context, params) => SettingsCustomizationLidarrRoute()),
        transitionType: LunaRouter.transitionType,
    );

    @override
    State<SettingsCustomizationLidarrRoute> createState() => _State();
}

class _State extends State<SettingsCustomizationLidarrRoute> {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    @override
    Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
        appBar: _appBar,
        body: _body,
    );

    Widget get _appBar => LSAppBar(
        title: 'Lidarr',
        actions: [
            LSIconButton(
                icon: Icons.settings,
                onPressed: () async => SettingsRouter.router.navigateTo(context, SettingsModulesLidarrRoute.route()),
            ),
        ]
    );

    Widget get _body => LSListView(
        children: [
            SettingsCustomizationLidarrDefaultPageTile(),
        ],
    );
}
