import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../widgets/app_bar.dart';

class BarcodeScannerPage extends StatelessWidget {
  const BarcodeScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(172),
        child: customAppBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                style: Theme.of(context).textTheme.displayLarge!,
                children: [
                  TextSpan(text: 'Retrouver un produit par son '),
                  TextSpan(
                    text: 'code-barres',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 8,
                    color: Color.fromRGBO(0, 189, 126, 1),
                  ),
                ),
                child: MobileScanner(
                  controller: MobileScannerController(
                    detectionSpeed: DetectionSpeed.normal,
                    facing: CameraFacing.back,
                    returnImage: false,
                  ),
                  onDetect: (capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    for (final barcode in barcodes) {
                      final String? rawValue = barcode.rawValue;

                      if (rawValue != null && _isValidEAN13(rawValue)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Center(
                              child: Text(
                                'Code-barres détecté',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            backgroundColor: Colors.greenAccent,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );

                        Timer(const Duration(milliseconds: 1500), () async {
                          final result = await Navigator.pushNamed(
                            context,
                            '/product',
                            arguments: rawValue,
                          );
                          if (context.mounted && result != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  result.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                backgroundColor: Colors.redAccent,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Center(
                              child: Text(
                                'Code-barres invalide',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            backgroundColor: Colors.redAccent,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  bool _isValidEAN13(String code) {
    return RegExp(r'^\d{13}$').hasMatch(code);
  }
}
