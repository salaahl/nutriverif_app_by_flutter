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

class _BarcodeScannerPageState extends State<BarcodeScannerPage>
    with WidgetsBindingObserver {
  late MobileScannerController _controller;
  bool _isScannerRunning = true;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _controller = MobileScannerController(
      useNewCameraSelector: true,
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      returnImage: false,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        _controller.stop();
        break;
      case AppLifecycleState.resumed:
        if (mounted && _isScannerRunning) {
          _controller.start();
        }
        break;
      case AppLifecycleState.inactive:
        break;
    }
  }

  Future<void> _stopScanner() async {
    if (_isScannerRunning && mounted) {
      setState(() {
        _isScannerRunning = false;
      });
      await _controller.stop();
    }
  }

  Future<void> _startScanner() async {
    if (!_isScannerRunning && mounted) {
      setState(() {
        _isScannerRunning = true;
      });
      await _controller.start();
    }
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
      await provider.loadProductById(rawValue);

      if (!mounted) return;

      if (provider.product.id.isNotEmpty) {
        await Navigator.pushNamed(
          context,
          '/product',
          arguments: provider.product,
        );

        // Quand on revient de la page produit, relancer le scanner
        if (mounted) {
          await Future.delayed(const Duration(milliseconds: 500));
          await _startScanner();
        }
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
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 8, color: Colors.white),
                ),
                child:
                    _isScannerRunning && !_isProcessing
                        ? MobileScanner(
                          controller: _controller,
                          onDetect: (capture) {
                            final List<Barcode> barcodes = capture.barcodes;
                            for (final barcode in barcodes) {
                              final String? rawValue = barcode.rawValue;
                              if (rawValue != null) {
                                _handleBarcode(rawValue);
                                return; // Traiter seulement le premier code-barres
                              }
                            }
                          },
                        )
                        : const Center(child: Loader()),
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
