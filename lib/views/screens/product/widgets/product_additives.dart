import 'package:flutter/material.dart';
import 'package:app_nutriverif/core/constants/additives.dart';

class ProductAdditives extends StatefulWidget {
  final List<String> additives;

  const ProductAdditives({super.key, required this.additives});

  @override
  State<ProductAdditives> createState() => _ProductAdditivesState();
}

class _ProductAdditivesState extends State<ProductAdditives> {
  String? _activeAdditive;

  @override
  void initState() {
    super.initState();
    _updateActiveAdditive();
  }

  @override
  void didUpdateWidget(covariant ProductAdditives oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.additives != widget.additives) {
      _updateActiveAdditive();
    }
  }

  void _updateActiveAdditive() {
    if (widget.additives.isNotEmpty) {
      _activeAdditive = widget.additives.first;
    } else {
      _activeAdditive = null;
    }
  }

  String _formatAdditiveCode(String additiveStr) {
    if (additiveStr.isEmpty || !additiveStr.contains(':')) return '';
    return additiveStr.split(':')[1].toUpperCase();
  }

  String _getAdditiveName(String additiveStr) {
    final code = _formatAdditiveCode(additiveStr);
    return additivesDatabase[code]?.name ?? 'Additif inconnu';
  }

  String _getAdditiveDescription(String additiveStr) {
    final code = _formatAdditiveCode(additiveStr);
    return additivesDatabase[code]?.description ??
        'Aucune description disponible pour cet additif.';
  }

  Color _getAdditiveTextColor(String additiveStr) {
    final code = _formatAdditiveCode(additiveStr);
    final score = additivesDatabase[code]?.score;
    switch (score) {
      case 1:
        return const Color(0xFF00BD7E);
      case 2:
        return Colors.yellow.shade700;
      case 3:
        return Colors.orange.shade600;
      case 4:
        return Colors.red.shade600;
      default:
        return Colors.grey.shade500;
    }
  }

  Color _getAdditiveUnderlineColor(String additiveStr) {
    final code = _formatAdditiveCode(additiveStr);
    final score = additivesDatabase[code]?.score;
    switch (score) {
      case 1:
        return const Color(0xFF00BD7E);
      case 2:
        return Colors.yellow.shade500;
      case 3:
        return Colors.orange.shade500;
      case 4:
        return Colors.red.shade500;
      default:
        return Colors.grey.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.additives.isEmpty) return const SizedBox.shrink();

    const darkBg = Color(0xFF343E40);

    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.translate(
            offset: const Offset(0, 3),
            child: Container(
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
                top: 8,
                bottom: 4,
              ),
              decoration: const BoxDecoration(
                color: darkBg,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children:
                    widget.additives.map((additive) {
                      final isActive = _activeAdditive == additive;
                      final code = _formatAdditiveCode(additive);

                      return InkWell(
                        onTap: () {
                          setState(() {
                            _activeAdditive = additive;
                          });
                        },
                        borderRadius: BorderRadius.circular(4),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: isActive ? 1.0 : 0.5,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(),
                            child: Column(
                              children: [
                                Text(
                                  code,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Container(
                                  height: 4,
                                  width: 4,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 1,
                                  ),
                                  color: _getAdditiveUnderlineColor(additive),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),

          if (_activeAdditive != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: darkBg, width: 3),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_formatAdditiveCode(_activeAdditive!)} - ${_getAdditiveName(_activeAdditive!)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _getAdditiveTextColor(_activeAdditive!),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getAdditiveDescription(_activeAdditive!),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
