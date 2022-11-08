# platform_widget_mixin
Plugin to decouple widgets based on various platform properties.

## Features
Build different UIs for Android, iOS, Web, Desktop, Wear, TV etc without the if/else checks in your widgets.

## Getting started
```
pub add platform_widget_mixin
```

## Example Screenshots
![Android Mobile](https://github.com/imrhk/platform_widget_mixin/blob/main/screenshots/android_mobile.png )

![Android Wear](https://github.com/imrhk/platform_widget_mixin/blob/main/screenshots/android_wear.png )

![Android TV](https://github.com/imrhk/platform_widget_mixin/blob/main/screenshots/android_tv.png )

## Example code
```dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platform_widget_mixin/platform_widget_mixin.dart';
import 'package:wear/wear.dart';

void main() async {
  await initialize();
  runApp(const MyApp());
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
  Widget buildWear(BuildContext context, WearShape shape) {
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
  Widget buildWear(BuildContext context, WearShape wearShape) =>
      const Text('Wear');

  @override
  Widget buildWatchOS(BuildContext context, WearShape shape) =>
      const Text('Apple Watch');

  @override
  Widget buildWearOS(BuildContext context, WearShape shape) =>
      const Text('Android Wear');
}
```

## Additional information

### Default relationship
![Default Relationship](https://github.com/imrhk/platform_widget_mixin/blob/main/default_relations.svg )

Please raise a issue/provide feedback in github repository.

## Licence
Apache License 2.0