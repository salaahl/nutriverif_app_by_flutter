import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:provider/provider.dart';

import 'package:app_nutriverif/core/constants/custom_values.dart';
import 'package:app_nutriverif/providers/products_provider.dart';

import 'package:app_nutriverif/views/widgets/app_container.dart';
import '../widgets/app_bar.dart';
import '../widgets/loader.dart';

class DishScannerPage extends StatefulWidget {
  const DishScannerPage({super.key});

  @override
  State<DishScannerPage> createState() => _DishScannerPageState();
}

class _DishScannerPageState extends State<DishScannerPage>
    with WidgetsBindingObserver {
  late bool _cookiesStatus =
      false; // Variable pour stocker l'acceptation des cookies

  CameraController? _cameraController;
  final TextEditingController notesController = TextEditingController();

  bool _isProcessing = false;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _getCookiesStatus();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      final backCamera = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        backCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      _cameraController = controller;
      await controller.initialize();

      if (!mounted) return;

      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      debugPrint("Erreur initialisation caméra : $e");
    }
  }

  Future<void> _getCookiesStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final status = prefs.getBool('acceptGeminiCookies') ?? false;

      setState(() {
        _cookiesStatus = status;
      });
    } catch (e) {
      setState(() {
        _cookiesStatus = false;
      });
    }
  }

  Future<void> _setCookiesStatus(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('acceptGeminiCookies', value);
      setState(() {
        _cookiesStatus = value;
      });
    } catch (e) {
      setState(() {
        _cookiesStatus = true;
      });
    }
  }

  Future<bool?> acceptCookies(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              const Text(
                "Cookies",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationThickness: 4,
                  decorationColor: Colors.black, // couleur noire
                ),
              ),
            ],
          ),
          content: Text(
            'L\'analyse de vos plats est réalisée par l\'IA de Google (Gemini). Pour protéger votre vie privée, cadrez uniquement vos aliments : veillez à ne laisser apparaître aucun visage, document ni élément personnel.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Annuler"),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: customGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
                _setCookiesStatus(true);
              },
              child: const Text(
                "Accepter",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? controller = _cameraController;

    if (controller == null || !controller.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> _takePhotoAndAnalyze() async {
    final controller = _cameraController;
    if (controller == null ||
        !controller.value.isInitialized ||
        _isProcessing) {
      return;
    }

    try {
      // Capture directe du flux
      final XFile photoXFile = await controller.takePicture();
      final File photoFile = File(photoXFile.path);

      await _handleDish(photoFile);
    } catch (e) {
      debugPrint("Erreur capture : $e");
      _showErrorSnackBar("Erreur lors de la capture : ${e.toString()}");
    }
  }

  Future<void> _handleDish(File photo) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      if (!mounted) return;

      final provider = context.read<ProductsProvider>();
      await provider.loadDish(photo, notesController.text.trim());

      if (!mounted) return;

      if (provider.product.id.isNotEmpty &&
          provider.product.id != 'dish_unknown') {
        productTransition(context, provider.product, from: 'dish-scanner');
      } else {
        _showErrorSnackBar(
          'Erreur lors de la récupération des informations nutritionnelles du plat',
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Erreur lors du traitement : ${e.toString()}');
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
      body: AppContainer(
        child: Padding(
          padding:
              MediaQuery.of(context).size.width >
                      maxWidth + screenPadding.left * 2
                  ? const EdgeInsets.symmetric(horizontal: 0)
                  : screenPadding,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                myAppBar(context),
                Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    style: Theme.of(context).textTheme.titleMedium,
                    children: const [
                      TextSpan(text: 'Prenez en photo votre '),
                      TextSpan(
                        text: 'plat cuisiné',
                        style: TextStyle(color: Color(0xFFCD5C5C)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Viseur Caméra
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: maxWidth - 100,
                      maxWidth: maxWidth,
                    ),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(48),
                        ),
                        child:
                            _isCameraInitialized && !_isProcessing
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(48),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      final size = constraints.biggest;
                                      // Récupération de l'aspect ratio réel du flux caméra
                                      var scale =
                                          size.aspectRatio *
                                          _cameraController!.value.aspectRatio;

                                      // Inversion du ratio en mode portrait si nécessaire
                                      if (scale < 1) scale = 1 / scale;

                                      return Transform.scale(
                                        scale: scale,
                                        child: Center(
                                          child: CameraPreview(
                                            _cameraController!,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                                : const Center(child: Loader()),
                      ),
                    ),
                  ),
                ),

                // Contrôles (Notes + Déclencheur)
                if (!_isProcessing)
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextField(
                          controller: notesController,
                          maxLength: 300,
                          buildCounter:
                              (
                                _, {
                                required currentLength,
                                required isFocused,
                                maxLength,
                              }) => null,
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            hintText:
                                "Précisions sur le plat (ex: 1 c.à.s d'huile, 150g de riz...)",
                            hintStyle: const TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 14,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.all(12),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFF3F4F6),
                                width: 4,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFE5E7EB),
                                width: 4,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Material(
                            color: const Color(0xFFCD5C5C),
                            shape: const CircleBorder(),
                            elevation: 2,
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () async {
                                if (!_cookiesStatus) {
                                  final accepted = await acceptCookies(context);
                                  if (accepted != true) return;
                                }
                                _takePhotoAndAnalyze();
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(24),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 32,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else ...[
                  const SizedBox(height: 16),
                  const Text('Traitement en cours...'),
                  const SizedBox(height: 256),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
