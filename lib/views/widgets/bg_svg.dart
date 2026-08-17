import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const String backgroundSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 900" width="100%" height="100%">
  <rect fill="#FFFFFF" width="100%" height="100%" />

  <g id="background-blobs" transform="scale(1.6, 1.5)">
    <g transform="translate(900, 0)" fill="#00BD7E" fill-opacity="1">
      <path d="M0 486.7C-52.4 455.1 -104.8 423.5 -168 405.6C-231.2 387.6 -305.1 383.3 -344.2 344.2C-383.3 305.1 -387.6 231.2 -405.6 168C-423.5 104.8 -455.1 52.4 -486.7 0L0 0Z" />
    </g>
    <g transform="translate(0, 600)" fill="#00BD7E" fill-opacity="1">
      <path d="M0 -486.7C58.5 -454.5 116.9 -422.2 160.3 -387.1C203.8 -352 232.2 -314.2 284.3 -284.3C336.3 -254.3 412 -232.3 449.7 -186.3C487.4 -140.2 487.1 -70.1 486.7 0L0 0Z" />
    </g>
  </g>
</svg>
''';

class AppBackgroundWrapper extends StatelessWidget {
  final Widget child;

  const AppBackgroundWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: SvgPicture.string(
              backgroundSvg,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
