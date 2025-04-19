import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../widgets/app_bar.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  bool _isDetected = false;

  bool _isValidEAN13(String code) {
    return RegExp(r'^\d{13}$').hasMatch(code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 32, right: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            myAppBar(context),
            Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                style: Theme.of(context).textTheme.displayLarge!,
                children: [
                  const TextSpan(text: 'Retrouver un produit par son '),
                  const TextSpan(
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
                    color:
                        _isDetected
                            ? const Color.fromRGBO(0, 189, 126, 1)
                            : Colors.redAccent,
                  ),
                ),
                child: MobileScanner(
                  controller: MobileScannerController(
                    useNewCameraSelector: true,
                    detectionSpeed: DetectionSpeed.normal,
                    facing: CameraFacing.back,
                    returnImage: false,
                  ),
                  onDetect: (capture) {
                    if (_isDetected) return;

                    final List<Barcode> barcodes = capture.barcodes;
                    for (final barcode in barcodes) {
                      final String? rawValue = barcode.rawValue;

                      if (rawValue != null && _isValidEAN13(rawValue)) {
                        setState(() {
                          _isDetected = true;
                        });

                        // Delay de 500ms pour les besoins de l'animation
                        Timer(const Duration(milliseconds: 500), () async {
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

                          setState(() {
                            Timer(const Duration(milliseconds: 1500), () {
                              _isDetected = false;
                            });
                          });
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
}
