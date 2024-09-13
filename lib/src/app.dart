import 'package:flutter/material.dart';

import 'route/router_config.dart';

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    RouterAppConfig().initialize();
    return MaterialApp.router(
      theme: ThemeData(
        useMaterial3: true,
      ),
      title: 'Flutter - Interview Demo App (BaoTDK)',
      debugShowCheckedModeBanner: false,
      routerConfig: RouterAppConfig().router,
      
    );
  }
}
