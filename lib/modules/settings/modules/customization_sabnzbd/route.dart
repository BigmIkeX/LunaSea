import 'package:fluro_fork/fluro_fork.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/settings.dart';

class SettingsCustomizationSABnzbdRoute extends StatefulWidget {
    static const ROUTE_NAME = '/settings/customization/sabnzbd';
    static String route() => ROUTE_NAME;

    static void defineRoute(Router router) => router.define(
        ROUTE_NAME,
        handler: Handler(handlerFunc: (context, params) => SettingsCustomizationSABnzbdRoute()),
        transitionType: LunaRouter.transitionType,
    );

    @override
    State<SettingsCustomizationSABnzbdRoute> createState() => _State();
}

class _State extends State<SettingsCustomizationSABnzbdRoute> {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    @override
    Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
        appBar: _appBar,
        body: _body,
    );

    Widget get _appBar => LSAppBar(
        title: 'SABnzbd',
        actions: [
            LSIconButton(
                icon: Icons.settings,
                onPressed: () async => SettingsRouter.router.navigateTo(context, SettingsModulesSABnzbdRoute.route()),
            ),
        ]
    );

    Widget get _body => LSListView(
        children: [
            SettingsCustomizationSABnzbdDefaultPageTile(),
        ],
    );
}
