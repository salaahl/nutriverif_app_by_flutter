import 'package:flutter/material.dart';
import 'dart:math';

import 'package:app_nutriverif/core/constants/custom_values.dart';

class Loader extends StatefulWidget {
  const Loader({super.key});

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubicEmphasized,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(999),
            ),
            clipBehavior: Clip.hardEdge,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.rotate(
                  angle: _animation.value * 6 * pi,
                  child: Container(
                    width: 0,
                    height: 0,
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(width: 48, color: Colors.transparent),
                        right: BorderSide(width: 48, color: Colors.transparent),
                        bottom: BorderSide(width: 64, color: customGreen),
                      ),
                    ),
                  ),
                ),
                Transform.rotate(
                  angle: _animation.value * 8 * pi,
                  child: Container(
                    width: 0,
                    height: 0,
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(width: 48, color: Colors.transparent),
                        right: BorderSide(width: 48, color: Colors.transparent),
                        top: BorderSide(width: 64, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
