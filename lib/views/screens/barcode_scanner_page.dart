import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import 'package:app_nutriverif/core/constants/custom_values.dart';

import 'package:app_nutriverif/providers/products_provider.dart';

import '../widgets/app_bar.dart';
import '../widgets/loader.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  bool _isScannerRunning = true;

  Future<void> stopScanner() async {
    if (_isScannerRunning) {
      setState(() {
        _isScannerRunning = false;
      });
    }
  }

  Future<void> startScanner() async {
    if (!_isScannerRunning) {
      setState(() {
        _isScannerRunning = true;
      });
    }
  }

  bool _isValidEAN13(String code) {
    return RegExp(r'^\d{13}$').hasMatch(code);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductsProvider>();
    final MobileScannerController controller = MobileScannerController(
      useNewCameraSelector: true,
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      returnImage: false,
    );

    return Scaffold(
      body: Padding(
        padding: screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            myAppBar(context),
            Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                style: Theme.of(context).textTheme.titleMedium,
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
            _isScannerRunning
                ? AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 8, color: Colors.white),
                    ),
                    child: MobileScanner(
                      controller: controller,
                      onDetect: (capture) async {
                        await stopScanner();

                        // Laisser un temps minimal au loader
                        await Future.delayed(const Duration(seconds: 1));

                        final List<Barcode> barcodes = capture.barcodes;
                        for (final barcode in barcodes) {
                          final String? rawValue = barcode.rawValue;

                          // Validation
                          if (rawValue != null && _isValidEAN13(rawValue)) {
                            await provider.loadProductById(rawValue);

                            if (context.mounted) {
                              if (provider.product.id.isNotEmpty) {
                                Navigator.pushNamed(
                                  context,
                                  '/product',
                                  arguments: provider.product,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Produit non trouvé',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    backgroundColor: Colors.redAccent,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            }
                          } else if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Center(
                                  child: Text(
                                    'Code-barres invalide',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                backgroundColor: Colors.redAccent,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        }

                        // Prevenir le scan au changement de page
                        await Future.delayed(const Duration(seconds: 3));

                        if (mounted) {
                          await startScanner();
                        }
                      },
                    ),
                  ),
                )
                : AspectRatio(
                  aspectRatio: 1,
                  child: SizedBox(
                    width: double.infinity,
                    child: const Loader(),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
