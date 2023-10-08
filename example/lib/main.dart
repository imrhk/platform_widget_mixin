import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platform_widget_mixin/platform_widget_mixin.dart';

void main() async {
  runApp(const AdaptiveConfigurationWidget(child: MyApp()));
}

class MyApp extends StatelessWidget with PlatformWidgetMixin {
  const MyApp({super.key});

  @override
  Widget buildAndroid(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.purple),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: child,
    );
  }

  @override
  Widget buildIOS(BuildContext context) {
    return CupertinoApp(
      theme: const CupertinoThemeData(primaryColor: Colors.purple),
      home: child,
    );
  }

  @override
  Widget? get child => const HomePage();
}

class HomePage extends StatelessWidget with PlatformWidgetMixin {
  const HomePage({super.key});

  @override
  Widget buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const _ToolbarTitle(),
      ),
      body: child,
    );
  }

  @override
  Widget buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: _ToolbarTitle(),
        ),
        child: child);
  }

  @override
  Widget buildWear(BuildContext context) {
    return Scaffold(
      body: child,
    );
  }

  @override
  Widget get child => const Center(child: PlatformNameWidget());
}

class _ToolbarTitle extends StatelessWidget {
  const _ToolbarTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('Example App');
  }
}

class PlatformNameWidget extends StatefulWidget {
  const PlatformNameWidget({super.key});

  @override
  State<PlatformNameWidget> createState() => _PlatformNameWidgetState();
}

class _PlatformNameWidgetState extends State<PlatformNameWidget>
    with PlatformWidgetMixin {
  @override
  Widget buildAndroid(BuildContext context) => const Text('Android mobile');

  @override
  Widget buildIOS(BuildContext context) => const Text('iPhone');

  @override
  Widget buildIPad(BuildContext context) => const Text('iPad');

  @override
  Widget buildMacOS(BuildContext context) => const Text('Mac');

  @override
  Widget buildAndroidTV(BuildContext context) => const Text('Android TV');

  @override
  Widget buildAndroidTablet(BuildContext context) =>
      const Text('Android Tablet');

  @override
  Widget buildDesktop(BuildContext context) => const Text('Desktop');

  @override
  Widget buildTV(BuildContext context) => const Text('TV');

  @override
  Widget buildTablet(BuildContext context) => const Text('Tablet');

  @override
  Widget buildTvOS(BuildContext context) => const Text('Apple TV');

  @override
  Widget buildWeb(BuildContext context) => const Text('Web');

  @override
  Widget buildWebDesktop(BuildContext context) => const Text('Web Desktop');

  @override
  Widget buildWebMobile(BuildContext context) => const Text('Web Mobile');

  @override
  Widget buildWebTablet(BuildContext context) => const Text('Web Tablet');

  @override
  Widget buildWear(BuildContext context) => const Text('Wear');

  @override
  Widget buildWatchOS(BuildContext context) => const Text('Apple Watch');

  @override
  Widget buildWearOS(BuildContext context) => const Text('Android Wear');
}
