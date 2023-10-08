import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:is_tv/is_tv.dart';
import 'package:is_wear/is_wear.dart';
import 'package:universal_io/io.dart';

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
      if (_config.isAndroid) {
        return buildWearOS(context);
      }
      if (_config.isApple) {
        return buildWatchOS(context);
      }
      return buildWear(context);
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
        return buildIPad(context);
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
  Widget buildWear(
    BuildContext context,
  ) =>
      buildAndroid(context);
  Widget buildWearOS(
    BuildContext context,
  ) =>
      buildWear(
        context,
      );
  Widget buildWatchOS(
    BuildContext context,
  ) =>
      buildWear(
        context,
      );
  Widget buildTV(BuildContext context) => buildTablet(context);
  Widget buildAndroidTV(BuildContext context) => buildTV(context);
  Widget buildTvOS(BuildContext context) => buildTV(context);
}

/// Method to initialize different properties
/// This should be done before run app is called.
Future<void> _initializeAdaptiveConfiguration(BuildContext context,
    [PlatformConfig? platformConfig]) async {
  if (platformConfig != null) {
    _config = platformConfig;
    return;
  }

  WidgetsFlutterBinding.ensureInitialized();
  bool isWeb = kIsWeb;
  bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
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

late final PlatformConfig _config;

@immutable
class PlatformConfig {
  final bool isWeb;
  final bool isTablet;
  final bool isTV;
  final bool isWear;
  final bool isApple;
  final bool isDesktop;
  final bool isAndroid;
  final bool isMobile;

  const PlatformConfig({
    this.isWeb = false,
    this.isTablet = false,
    this.isTV = false,
    this.isWear = false,
    this.isApple = false,
    this.isDesktop = false,
    this.isAndroid = false,
    this.isMobile = false,
  }) : assert(
            isWear ||
                isTablet ||
                isTV ||
                isWear ||
                isApple ||
                isDesktop ||
                isAndroid ||
                isMobile,
            'incorrect config _PlatformConfig(isWeb: $isWeb, isTablet: $isTablet, isTV: $isTV, isWear: $isWear, isApple: $isApple, isDesktop: $isDesktop, isAndroid: $isAndroid, isMobile: $isMobile)');

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

class AdaptiveConfigurationWidget extends StatefulWidget {
  final Widget? child;
  final Widget? loading;
  final PlatformConfig? platformConfig;
  const AdaptiveConfigurationWidget({
    super.key,
    this.child,
    this.loading,
    this.platformConfig,
  });

  @override
  State<AdaptiveConfigurationWidget> createState() =>
      _AdaptiveConfigurationWidgetState();
}

class _AdaptiveConfigurationWidgetState
    extends State<AdaptiveConfigurationWidget> {
  bool _isInitialized = false;
  bool _isInitializing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialized || _isInitializing) return;
    _isInitializing = true;
    _initializeAdaptiveConfiguration(context, widget.platformConfig).then((_) {
      setState(() {
        _isInitialized = true;
      });
    }).catchError((_) {
      {
        setState(() {
          _isInitialized = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _isInitialized,
      replacement: widget.loading ?? const SizedBox.shrink(),
      child: widget.child ?? const SizedBox.shrink(),
    );
  }
}

T getAdaptiveValue<T>({
  required T forAndroid,
  T? forIOS,
  T? forWebMobile,
  T? forTablet,
  T? forAndroidTablet,
  T? forIPad,
  T? forWeb,
  T? forWebTablet,
  T? forWebDesktop,
  T? forMacOS,
  T? forDesktop,
  T? forWear,
  T? forWearOS,
  T? forWatchOS,
  T? forTV,
  T? forAndroidTV,
  T? forTvOS,
}) {
  final getAndroidValue = forAndroid;
  final getIOSValue = forIOS ?? getAndroidValue;
  final getWebValue = forWeb ?? getAndroidValue;
  final getWebMobileValue = forWebMobile ?? getWebValue;
  final getAndroidTabletValue = forAndroidTablet ?? getAndroidValue;
  final getIpadValue = forIPad ?? getIOSValue;
  final getTabletValue = forTablet ??
      switch (Platform.isIOS) {
        true => getIpadValue,
        false => getAndroidTabletValue,
      };
  final getWebTabletValue = forWebTablet ?? getWebValue;
  final getWebDesktopValue = forWebDesktop ?? getWebValue;
  final getMacOSValue = forMacOS ?? getIpadValue;
  final getDesktopValue = forDesktop ?? getAndroidTabletValue;
  final getWearValue = forWear ?? getAndroidValue;
  final getWearOSValue = forWearOS ?? getWearValue;
  final getWatchOSValue = forWatchOS ?? getWearValue;
  final getTVValue = forTV ?? getTabletValue;
  final getAndroidTVValue = forAndroidTV ?? getTVValue;
  final getTVOSValue = forTvOS ?? getTVValue;

  if (_config.isTV) {
    if (_config.isAndroid) {
      return getAndroidTVValue;
    }
    if (_config.isApple) {
      return getTVOSValue;
    }
    return getTVValue;
  } else if (_config.isWear) {
    if (_config.isAndroid) {
      return getWearOSValue;
    } else if (_config.isApple) {
      return getWatchOSValue;
    } else {
      return getWearValue;
    }
  } else if (_config.isDesktop) {
    if (_config.isWeb) {
      return getWebDesktopValue;
    }
    if (_config.isApple) {
      return getMacOSValue;
    }
    return getDesktopValue;
  } else if (_config.isTablet) {
    if (_config.isWeb) {
      return getWebTabletValue;
    }
    if (_config.isAndroid) {
      return getAndroidTabletValue;
    }
    if (_config.isApple) {
      return getIpadValue;
    }
    assert(false, 'configuration didn\'t match $_config');
  } else if (_config.isMobile) {
    if (_config.isWeb) {
      return getWebMobileValue;
    }
    if (_config.isAndroid) {
      return getAndroidValue;
    }
    if (_config.isApple) {
      return getIOSValue;
    }
    assert(false, 'configuration didn\'t match $_config');
  }

  return getAndroidValue;
}
