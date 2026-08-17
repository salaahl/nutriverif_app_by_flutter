import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:app_nutriverif/providers/products_provider.dart';

import 'package:app_nutriverif/views/screens/products/products_page.dart';

import './product_nutriments.dart';

class ProductDetails extends StatefulWidget {
  final String id;
  final List<String> categories;
  final String quantity;
  final String servingSize;
  final String ingredients;
  final Map<String, dynamic> nutriments;
  final String manufacturingPlace;
  final String link;

  const ProductDetails({
    super.key,
    this.id = '',
    this.categories = const [],
    this.quantity = '',
    this.servingSize = '',
    this.ingredients = '',
    this.nutriments = const {},
    this.manufacturingPlace = '',
    this.link = '',
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  late ProductsProvider _provider;

  List<Map<String, String>> categoriesTranslated = [];
  bool categoriesIsLoading = true;

  @override
  void initState() {
    super.initState();

    _provider = context.read<ProductsProvider>();
    _provider.getTranslatedCategories(widget.categories).then((categories) {
      if (mounted) {
        setState(() {
          categoriesTranslated = categories;
          categoriesIsLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const String quantityIconSvg = '''
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 640">
      <path fill="#1F2937" d="M118.2 126.4C101.5 120.8 92.4 102.6 98 85.9C103.6 69.2 121.7 60.1 138.5 65.6L251.5 103.3C265.4 79.8 291.1 64 320.4 64C364.6 64 400.4 99.8 400.4 144C400.4 147 400.2 149.9 399.9 152.8L522.5 193.7C539.3 199.3 548.3 217.4 542.7 234.2C537.1 251 519 260 502.2 254.4L366.7 209.2C362.2 212.4 357.4 215.1 352.3 217.4L352.3 544.1C352.3 561.8 338 576.1 320.3 576.1L128.3 576.1C110.6 576.1 96.3 561.8 96.3 544.1C96.3 526.4 110.6 512.1 128.3 512.1L288.3 512.1L288.3 217.4C267.3 208.2 251.1 190.4 244.1 168.4L118.2 126.4zM200.8 352L128.3 227.8L55.9 352L200.8 352zM128.4 448C65.5 448 13.2 414 2.4 369.1C-.2 358.1 3.4 346.8 9.1 337L104.3 173.8C109.3 165.2 118.5 160 128.4 160C138.3 160 147.5 165.3 152.5 173.8L247.7 337C253.4 346.8 257 358.1 254.4 369.1C243.6 413.9 191.3 448 128.4 448zM511.2 355.8L438.8 480L583.7 480L511.3 355.8zM637.2 497.1C626.4 542 574.1 576 511.2 576C448.3 576 396 542 385.2 497.1C382.6 486.1 386.2 474.8 391.9 465L487.1 301.8C492.1 293.2 501.3 288 511.2 288C521.1 288 530.3 293.3 535.3 301.8L630.5 465C636.2 474.8 639.8 486.1 637.2 497.1z"/>
    </svg>
    ''';
    const String ingredientsIconSvg = '''
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 640" data-v-27a423c5=""><path d="M453.1 27.3L440.9 39.4C409.7 70.6 409.7 121.3 440.9 152.5C456.5 168.1 472.1 183.7 487.8 199.4C519 230.6 569.7 230.6 600.9 199.4L613 187.3C619.2 181.1 619.2 170.9 613 164.7L600.9 152.6C569.7 121.4 519 121.4 487.8 152.6C519 121.4 519 70.7 487.8 39.5L475.7 27.3C469.5 21.1 459.3 21.1 453.1 27.3zM331.6 160C286.4 160 244.5 180.4 216.6 214.3L273.3 271C282.7 280.4 282.7 295.6 273.3 304.9C263.9 314.2 248.7 314.3 239.4 304.9L191.6 257.2L67.2 530.8C61.7 542.9 64.3 557.2 73.7 566.7C83.1 576.2 97.4 578.7 109.6 573.2L251.2 508.8L207.4 465C198 455.6 198 440.4 207.4 431.1C216.8 421.8 232 421.7 241.3 431.1L297.8 487.6L393.1 444.3C446.2 420.2 480.3 367.2 480.3 308.8C480.3 226.6 413.7 160 331.5 160z" data-v-27a423c5=""></path></svg>
    ''';
    const String globeIconSvg = '''
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 640">
      <path fill="#1F2937" d="M511.6 239C480 164.4 406.1 112 320 112C297.9 112 276.6 115.5 256.6 121.8C256.2 123.8 256 125.9 256 128L256 201.4C256 213.9 266.1 224 278.6 224C284.6 224 290.4 221.6 294.6 217.4L310.6 201.4C316.6 195.4 324.7 192 333.2 192L338.7 192C367.2 192 381.5 226.5 361.3 246.6C355.3 252.6 347.2 256 338.7 256L277.2 256C268.7 256 260.6 259.4 254.6 265.4L233.3 286.7C227.3 292.7 223.9 300.8 223.9 309.3L223.9 352C223.9 369.7 238.2 384 255.9 384L287.9 384C305.6 384 319.9 398.3 319.9 416L319.9 448C319.9 465.7 334.2 480 351.9 480L354.6 480C363.1 480 371.2 476.6 377.2 470.6L406.5 441.3C412.5 435.3 415.9 427.2 415.9 418.7L415.9 400C415.9 391.2 423.1 384 431.9 384C440.7 384 447.9 376.8 447.9 368L447.9 333.3C447.9 324.8 444.5 316.7 438.5 310.7L422.5 294.7C418.3 290.5 415.9 284.7 415.9 278.7C415.9 266.2 426 256.1 438.5 256.1L483.5 256.1C495.9 256.1 506.2 249 511.5 239.1zM64 320C64 178.6 178.6 64 320 64C461.4 64 576 178.6 576 320C576 461.4 461.4 576 320 576C178.6 576 64 461.4 64 320z"/>
    </svg>
    ''';
    const String externalLinkIconSvg = '''
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 640">
      <path fill="#2563EB" d="M354.4 83.8C359.4 71.8 371.1 64 384 64L544 64C561.7 64 576 78.3 576 96L576 256C576 268.9 568.2 280.6 556.2 285.6C544.2 290.6 530.5 287.8 521.3 278.7L464 221.3L310.6 374.6C298.1 387.1 277.8 387.1 265.3 374.6C252.8 362.1 252.8 341.8 265.3 329.3L418.7 176L361.4 118.6C352.2 109.4 349.5 95.7 354.5 83.7zM64 240C64 195.8 99.8 160 144 160L224 160C241.7 160 256 174.3 256 192C256 209.7 241.7 224 224 224L144 224C135.2 224 128 231.2 128 240L128 496C128 504.8 135.2 512 144 512L400 512C408.8 512 416 504.8 416 496L416 416C416 398.3 430.3 384 448 384C465.7 384 480 398.3 480 416L480 496C480 540.2 444.2 576 400 576L144 576C99.8 576 64 540.2 64 496L64 240z"/>
    </svg>
    ''';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.quantity.isNotEmpty) ...[
          Container(
            constraints: const BoxConstraints(maxWidth: 672),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  initiallyExpanded: false,
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                  collapsedBackgroundColor: Colors.white,
                  backgroundColor: Colors.white,
                  iconColor: const Color(0xFF9CA3AF),
                  collapsedIconColor: const Color(0xFF9CA3AF),
                  title: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: SvgPicture.string(quantityIconSvg),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Quantité',
                        style: TextStyle(
                          color: Color(0xFF1F2937),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB).withValues(alpha: 0.5),
                        border: const Border(
                          top: BorderSide(color: Color(0xFFF3F4F6), width: 3),
                        ),
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(12),
                        ),
                      ),
                      child: Text(
                        widget.quantity,
                        style: const TextStyle(
                          color: Color(0xFF4B5563),
                          fontSize: 14, // text-sm
                          fontWeight: FontWeight.w600,
                          height: 1.625,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        if (widget.ingredients.isNotEmpty) ...[
          Container(
            margin: const EdgeInsets.only(top: 8),
            constraints: const BoxConstraints(maxWidth: 672),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  initiallyExpanded: false,
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                  collapsedBackgroundColor: Colors.white,
                  backgroundColor: Colors.white,
                  iconColor: const Color(0xFF9CA3AF),
                  collapsedIconColor: const Color(0xFF9CA3AF),
                  title: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: SvgPicture.string(ingredientsIconSvg),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Ingrédients',
                        style: TextStyle(
                          color: Color(0xFF1F2937),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB).withValues(alpha: 0.5),
                        border: const Border(
                          top: BorderSide(color: Color(0xFFF3F4F6), width: 3),
                        ),
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(12),
                        ),
                      ),
                      child: Text(
                        widget.ingredients.replaceAll(RegExp(r'<[^>]*>'), ''),
                        style: const TextStyle(
                          color: Color(0xFF4B5563),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 1.625,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        if (widget.id.isNotEmpty) ...[
          Container(
            margin: const EdgeInsets.only(top: 8),
            constraints: const BoxConstraints(maxWidth: 672),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  initiallyExpanded: false,
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                  collapsedBackgroundColor: Colors.white,
                  backgroundColor: Colors.white,
                  iconColor: const Color(0xFF9CA3AF),
                  collapsedIconColor: const Color(0xFF9CA3AF),
                  title: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: SvgPicture.string(globeIconSvg),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Informations complémentaires',
                        style: TextStyle(
                          color: Color(0xFF1F2937),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16), // p-4
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB).withValues(alpha: 0.5),
                        border: const Border(
                          top: BorderSide(color: Color(0xFFF3F4F6), width: 3),
                        ),
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(12), // rounded-b-xl
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lieu de fabrication',
                            style: const TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.manufacturingPlace,
                            style: const TextStyle(
                              color: Color(0xFF374151),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 16),
                          Text(
                            'Code-barres',
                            style: const TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.id,
                            style: const TextStyle(
                              color: Color(0xFF374151),
                              fontSize: 14,
                              fontFamily: 'monospace',
                            ),
                          ),

                          const SizedBox(height: 16),
                          Text(
                            'Fiche produit',
                            style: const TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          InkWell(
                            onTap: () => launchUrlString(widget.link),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Voir la fiche officielle',
                                  style: TextStyle(
                                    color: Color(0xFF2563EB),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.redAccent,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: SvgPicture.string(externalLinkIconSvg),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
        if (widget.nutriments.keys.any(
          (key) => _provider.ajrValues.containsKey(key),
        )) ...[
          NutritionalTable(
            nutriments: widget.nutriments,
            servingSize: widget.servingSize,
          ),
          const SizedBox(height: 32),
        ],
        Wrap(
          spacing: 8,
          children:
              categoriesIsLoading
                  ? [const CategoriesLoader()]
                  : categoriesTranslated.isEmpty
                  ? [const SizedBox.shrink()]
                  : categoriesTranslated
                      .where(
                        (category) => category['translated']!.trim().isNotEmpty,
                      ) // Empêcher les chaines de caractères vides
                      .map(
                        (category) => CategoryButton(
                          searchTerm: category['original']!,
                          name: category['translated']!,
                        ),
                      )
                      .toList(),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

class CategoriesLoader extends StatefulWidget {
  const CategoriesLoader({super.key});

  @override
  State<CategoriesLoader> createState() => _CategoriesLoaderState();
}

class _CategoriesLoaderState extends State<CategoriesLoader> {
  int _animationKey = 0;

  void _restartAnimation() {
    setState(() {
      _animationKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(_animationKey),
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1200),
      builder: (context, value, child) {
        final dotsCount = (value * 4).floor().clamp(0, 3);
        return Text(
          "Chargement des catégories${'.' * dotsCount}",
          style: TextStyle(fontWeight: FontWeight.bold),
        );
      },
      onEnd: _restartAnimation,
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String searchTerm;
  final String name;

  const CategoryButton({
    super.key,
    required this.searchTerm,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProductsProvider>();

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey[400],
      ),
      onPressed: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductSearchPage()),
        );
        await provider.searchProducts(query: searchTerm, method: 'complete');
      },
      child: Text(
        "#$name",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
