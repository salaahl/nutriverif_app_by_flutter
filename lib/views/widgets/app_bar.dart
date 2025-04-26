import 'package:flutter/material.dart';

Widget myAppBar(
  BuildContext context, {
  String? route = '',
  Map<String, dynamic>? customStyles = const {
    'textColor': Color(0xFF00BD7E),
    'arrowColor': Colors.white,
  },
}) {
  return SafeArea(
    child: SizedBox(
      height: 172,
      width: double.infinity,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Spacer(flex: 1),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo.png', height: 80, width: 80),
                  const SizedBox(height: 4),
                  if (route != '/')
                    Text.rich(
                      TextSpan(
                        text: 'Nutri',
                        style: const TextStyle(
                          fontFamily: 'Grand Hotel',
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                        ),
                        children: [
                          TextSpan(
                            text: 'Vérif',
                            style: TextStyle(color: customStyles?['textColor']),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const Spacer(flex: 1),
            ],
          ),
          if (Navigator.canPop(context) && route != '/')
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              child: IconButton(
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
            ),
        ],
      ),
    ),
  );
}
