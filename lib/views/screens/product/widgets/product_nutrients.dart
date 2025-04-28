import 'package:flutter/material.dart';

Widget productNutrients(Map<String, dynamic> nutrientLevels) {
  return nutrientLevels.isEmpty
      ? SizedBox.shrink()
      : Container(
        margin: const EdgeInsets.symmetric(vertical: 32),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              nutrientLevels.entries.map((entry) {
                String label;
                Color bgColor;

                switch (entry.key) {
                  case 'fat':
                    label = 'matières grasses';
                    break;
                  case 'salt':
                    label = 'sel';
                    break;
                  case 'sugars':
                    label = 'sucres';
                    break;
                  case 'saturated-fat':
                    label = 'graisses saturées';
                    break;
                  default:
                    label = entry.key;
                }

                switch (entry.value) {
                  case 'high':
                    bgColor = Colors.redAccent;
                    break;
                  case 'moderate':
                    bgColor = Colors.orangeAccent;
                    break;
                  case 'low':
                    bgColor = Colors.green;
                    break;
                  default:
                    bgColor = Colors.grey;
                }

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
        ),
      );
}
