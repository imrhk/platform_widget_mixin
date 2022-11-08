import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:is_tv/is_tv.dart';
import 'package:is_wear/is_wear.dart';
import 'package:universal_io/io.dart';
import 'package:wear/wear.dart';

mixin PlatformWidgetMixin {
  // child widget
  Widget? get child => null;

  /// Some of the properties overlap hence sequence in which correct
  /// configuration should be checked
  /// 1. isTV
  /// 2. isWear
  /// 3. isDesktop
  /// 4. isTablet
  /// 5. isMobile
  ///
  /// You don't have to override build but all the other methods inside your
  /// StatelessWidget or StatefulWidget
  Widget build(BuildContext context) {
    if (_config.isTV) {
      if (_config.isAndroid) {
        return buildAndroidTV(context);
      }
      if (_config.isApple) {
        return buildTvOS(context);
      }
      return buildTV(context);
    } else if (_config.isWear) {
      return WatchShape(builder: (context, shape, _) {
        if (_config.isAndroid) {
          return buildWearOS(context, shape);
        }
        if (_config.isApple) {
          return buildWatchOS(context, shape);
        }
        return buildWear(context, shape);
      });
    } else if (_config.isDesktop) {
      if (_config.isWeb) {
        return buildWebDesktop(context);
      }
      if (_config.isApple) {
        return buildMacOS(context);
      }
      return buildDesktop(context);
    } else if (_config.isTablet) {
      if (_config.isWeb) {
        return buildWebTablet(context);
      }
      if (_config.isAndroid) {
        return buildAndroidTablet(context);
      }
      if (_config.isApple) {
        return buildIOS(context);
      }
      assert(false, 'configuration didn\'t match $_config');
    } else if (_config.isMobile) {
      if (_config.isWeb) {
        return buildWebMobile(context);
      }
      if (_config.isAndroid) {
        return buildAndroid(context);
      }
      if (_config.isApple) {
        return buildIOS(context);
      }
      assert(false, 'configuration didn\'t match $_config');
    }

    return buildAndroid(context);
  }

  /// Default build method.
  Widget buildAndroid(BuildContext context);

  Widget buildIOS(BuildContext context) => buildAndroid(context);

  Widget buildWebMobile(BuildContext context) => buildWeb(context);

  Widget buildTablet(BuildContext context) {
    if (Platform.isIOS) {
      return buildIPad(context);
    } else {
      return buildAndroidTablet(context);
    }
  }

  Widget buildAndroidTablet(BuildContext context) => buildAndroid(context);
  Widget buildIPad(BuildContext context) => buildIOS(context);
  Widget buildWeb(BuildContext context) => buildAndroid(context);
  Widget buildWebTablet(BuildContext context) => buildWeb(context);
  Widget buildWebDesktop(BuildContext context) => buildWeb(context);
  Widget buildMacOS(BuildContext context) => buildIPad(context);
  Widget buildDesktop(BuildContext context) => buildAndroidTablet(context);
  Widget buildWear(BuildContext context, WearShape shape) =>
      buildAndroid(context);
  Widget buildWearOS(BuildContext context, WearShape shape) =>
      buildWear(context, shape);
  Widget buildWatchOS(BuildContext context, WearShape shape) =>
      buildWear(context, shape);
  Widget buildTV(BuildContext context) => buildTablet(context);
  Widget buildAndroidTV(BuildContext context) => buildTV(context);
  Widget buildTvOS(BuildContext context) => buildTV(context);
}

/// Method to initialize different properties
/// This should be done before run app is called.
Future<void> initialize([PlatformConfig? platformConfig]) async {
  if (platformConfig != null) {
    _config = platformConfig;
    return;
  }

  WidgetsFlutterBinding.ensureInitialized();
  bool isWeb = kIsWeb;
  bool isTablet = MediaQueryData.fromWindow(WidgetsBinding.instance.window)
          .size
          .shortestSide >
      600;
  bool isWear = await IsWear().check().catchError((_) => false) ?? false;
  bool isApple = Platform.isIOS || Platform.isMacOS;
  bool isDesktop = Platform.isLinux || Platform.isWindows || Platform.isMacOS;
  bool isAndroid = Platform.isAndroid;

  bool isTV = await IsTV().check().catchError((_) => false) ?? false;
  bool isMobile = !isWear && !isTV && !isDesktop && !isTablet;

  _config = PlatformConfig(
    isWeb: isWeb,
    isAndroid: isAndroid,
    isApple: isApple,
    isDesktop: isDesktop,
    isTV: isTV,
    isTablet: isTablet,
    isWear: isWear,
    isMobile: isMobile,
  );
}

late PlatformConfig _config;

class PlatformConfig {
  final bool isWeb;
  final bool isTablet;
  final bool isTV;
  final bool isWear;
  final bool isApple;
  final bool isDesktop;
  final bool isAndroid;
  final bool isMobile;

  PlatformConfig({
    this.isWeb = false,
    this.isTablet = false,
    this.isTV = false,
    this.isWear = false,
    this.isApple = false,
    this.isDesktop = false,
    this.isAndroid = false,
    this.isMobile = false,
  }) : assert(
            isWear |
                isTablet |
                isTV |
                isWear |
                isApple |
                isDesktop |
                isAndroid |
                isMobile,
            'incorrect config');

  @override
  String toString() {
    return '_PlatformConfig(isWeb: $isWeb, isTablet: $isTablet, isTV: $isTV, isWear: $isWear, isApple: $isApple, isDesktop: $isDesktop, isAndroid: $isAndroid, isMobile: $isMobile)';
  }
}

String getPlatformConfig([Stdout? stdout]) {
  if (stdout != null) {
    stdout.write(_config);
  }
  return _config.toString();
}
