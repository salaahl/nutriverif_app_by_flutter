import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:app_nutriverif/core/constants/custom_values.dart';
import 'package:app_nutriverif/models/model_products.dart';
import 'package:app_nutriverif/providers/products_provider.dart';

import '../widgets/app_bar.dart';
import '../widgets/loader.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  late MobileScannerController _controller;
  bool _isScannerRunning = false;
  bool _isProcessing = false;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _stopScanner() async {
    if (_isScannerRunning && mounted) {
      setState(() {
        _isScannerRunning = false;
      });
    }
    await _controller.stop();
  }

  Future<void> _startScanner() async {
    if (!_isScannerRunning && mounted) {
      setState(() {
        _isScannerRunning = true;
      });
    }
    // Redéfinition du controller car "cassé" lors du retour sur la page
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      returnImage: false,
    );
  }

  bool _isValidEAN13(String code) {
    return RegExp(r'^\d{13}$').hasMatch(code);
  }

  Future<void> _handleBarcode(String rawValue) async {
    if (_isProcessing) return; // Éviter les scans multiples

    setState(() {
      _isProcessing = true;
    });

    try {
      await _stopScanner();

      if (!_isValidEAN13(rawValue)) {
        _showErrorSnackBar('Code-barres invalide');
        return;
      }

      // Laisser un temps minimal au loader
      await Future.delayed(const Duration(milliseconds: 500));

      final provider = context.read<ProductsProvider>();
      await provider.loadProductById(rawValue, complete: true);

      if (!mounted) return;

      if (provider.product.id.isNotEmpty) {
        productTransition(context, provider.product);
      } else {
        _showErrorSnackBar('Produit non trouvé');
        // Relancer le scanner après un délai
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          await _startScanner();
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Erreur lors du scan: ${e.toString()}');
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          await _startScanner();
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                children: const [
                  TextSpan(text: 'Retrouver un produit par son '),
                  TextSpan(
                    text: 'code-barres',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            VisibilityDetector(
              key: Key('scanner'),
              onVisibilityChanged: (info) {
                if (info.visibleFraction == 1.0) {
                  _startScanner();
                } else {
                  _stopScanner();
                }
              },
              child: AspectRatio(
                aspectRatio: 1,
                child: Selector<ProductsProvider, Product>(
                  selector: (_, provider) => provider.product,
                  builder: (context, product, _) {
                    final provider = context.read<ProductsProvider>();

                    return Hero(
                      key: Key(provider.product.id),
                      tag: provider.product.id,
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(48),
                        ),
                        child:
                            _isScannerRunning && !_isProcessing
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(48),
                                  child: MobileScanner(
                                    controller: _controller,
                                    tapToFocus: true,
                                    onDetect: (capture) {
                                      final List<Barcode> barcodes =
                                          capture.barcodes;
                                      for (final barcode in barcodes) {
                                        final String? rawValue =
                                            barcode.rawValue;
                                        if (rawValue != null) {
                                          _handleBarcode(rawValue);
                                          return; // Traiter seulement le premier code-barres
                                        }
                                      }
                                    },
                                  ),
                                )
                                : const Center(child: Loader()),
                      ),
                    );
                  },
                ),
              ),
            ),
            if (_isProcessing) ...[
              const SizedBox(height: 16),
              const Text('Traitement en cours...'),
            ],
          ],
        ),
      ),
    );
  }
}
