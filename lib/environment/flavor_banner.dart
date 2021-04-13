import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:places/environment/build_type.dart';

/// Баннеры билда.
///
/// В правом верхнем углу: debug, profile или release. В левом нижнем:
/// flavor. Если `buildType == BuildType.prod`, баннеры не отображаются.
class FlavorBanner extends StatelessWidget {
  const FlavorBanner({
    Key? key,
    required this.buildType,
    required this.child,
  }) : super(key: key);

  final BuildType buildType;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (buildType == BuildType.prod) return child;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Banner(
        location: BannerLocation.bottomStart,
        message: buildType.name.toUpperCase(),
        child: Banner(
          location: BannerLocation.topEnd,
          message: kReleaseMode
              ? 'RELEASE'
              : kProfileMode
                  ? 'PROFILE'
                  : 'DEBUG',
          child: child,
        ),
      ),
    );
  }
}
