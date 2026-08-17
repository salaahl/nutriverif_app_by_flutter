import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:app_nutriverif/core/constants/custom_values.dart';

Widget myAppBar(
  BuildContext context, {
  String? route = '',
  Map<String, dynamic>? customStyles = const {
    'textColor': customGreen,
    'arrowColor': Colors.white,
  },
}) {
  const String bgBlobSvg = '''
<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 900 600'>
  <g transform='translate(416.34369726421266 281.01462663501235)'>
    <path d='M149 -145.8C185.3 -112.7 201.7 -56.3 208.9 7.2C216 70.7 214.1 141.4 177.8 180.8C141.4 220.1 70.7 228 11.7 216.4C-47.4 204.7 -94.8 173.4 -119.8 134.1C-144.8 94.8 -147.4 47.4 -143.3 4.1C-139.1 -39.1 -128.3 -78.3 -103.3 -111.4C-78.3 -144.6 -39.1 -171.8 8.6 -180.4C56.3 -189 112.7 -179 149 -145.8' fill='#00BD7E'/>
  </g>
</svg>
''';

  return SafeArea(
    child: Center(
      child: Container(
        height: 172,
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: maxWidth),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Spacer(flex: 1),
                Center(
                  child: SizedBox(
                    width: 275,
                    height: 275,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: -15,
                          bottom: -15,
                          left: -15,
                          right: -15,
                          child: IgnorePointer(
                            child: SvgPicture.string(
                              bgBlobSvg,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Tooltip(
                          message: 'Logo du site',
                          child: Image.asset(
                            appIcon,
                            height: 70,
                            width: 70,
                            cacheWidth: getCacheWidth(context, 80),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(flex: 1),
              ],
            ),
            if (Navigator.canPop(context) && route != '/')
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: customStyles?['arrowColor'],
                          borderRadius: BorderRadius.all(Radius.circular(999)),
                        ),
                        child: const Icon(Icons.arrow_back),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
