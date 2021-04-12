import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:places/environment/build_type.dart';

/// Баннеры билда.
///
/// В правом верхнем углу: debug, profile или release. В левом нижнем:
/// flavor. Если `buildType == BuildType.prod`, баннеры не отображаются.
class FlavorBanner extends StatefulWidget {
  const FlavorBanner({
    Key? key,
    required this.buildType,
    required this.child,
  }) : super(key: key);

  final BuildType buildType;
  final Widget child;

  @override
  _FlavorBannerState createState() => _FlavorBannerState();
}

class _FlavorBannerState extends State<FlavorBanner> {
  @override
  Widget build(BuildContext context) {
    if (widget.buildType == BuildType.prod) {
      return widget.child;
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Banner(
        location: BannerLocation.bottomStart,
        message: widget.buildType.name.toUpperCase(),
        child: Banner(
          location: BannerLocation.topEnd,
          message: kReleaseMode
              ? 'RELEASE'
              : kProfileMode
                  ? 'PROFILE'
                  : 'DEBUG',
          child: widget.child,
        ),
      ),
    );
  }
}
