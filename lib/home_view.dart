// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final Map<Color, bool> matched = {
    Colors.red: false,
    Colors.blue: false,
    Colors.green: false,
  };

  // Track active drag (for bounce effect)
  Color? currentlyDragging;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Physics Playground"),
        leading: const Icon(Icons.arrow_back_ios),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 🔵 Balls Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDraggableBall(Colors.red),
              _buildDraggableBall(Colors.blue),
              _buildDraggableBall(Colors.green),
            ],
          ),
          const SizedBox(height: 300),
          // 🟥 Targets Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTarget(Colors.red),
              _buildTarget(Colors.blue),
              _buildTarget(Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  // 🎱 Draggable Ball
  Widget _buildDraggableBall(Color color) {
    return Draggable<Color>(
      data: color,
      onDragStarted: () {
        setState(() => currentlyDragging = color);
      },
      onDraggableCanceled: (_, __) {
        setState(() => currentlyDragging = null);
      },
      onDragCompleted: () {
        setState(() => currentlyDragging = null);
      },
      // feedback & childWhenDragging are static, no animation
      feedback: _ballShape(color, 40),
      childWhenDragging: Opacity(opacity: 0.3, child: _ballShape(color, 40)),
      // normal child animates
      child: matched[color]!
          ? const SizedBox(width: 40)
          : _buildBall(color, 40),
    );
  }

  // 🟩 Drop Target
  Widget _buildTarget(Color color) {
    return DragTarget<Color>(
      onWillAccept: (data) => data == color,
      onAccept: (_) {
        setState(() {
          matched[color] = true;
        });
      },
      builder: (context, candidateData, rejectedData) {
        bool isMatched = matched[color]!;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.all(12),
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: isMatched
                ? color
                : color.withOpacity(candidateData.isNotEmpty ? 0.4 : 0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color, width: 2),
          ),
          child: isMatched
              ? const Icon(Icons.check, color: Colors.white)
              : null,
        );
      },
    );
  }

  // 🎱 Animated Ball
  Widget _buildBall(Color color, double size) {
    final staticBall = _ballShape(color, size); // stable widget

    return TweenAnimationBuilder<double>(
      key: ValueKey(color), // unique identity for each ball
      tween: Tween<double>(
        begin: 1.0,
        end: (currentlyDragging == color) ? 1.1 : 1.0,
      ),
      duration: const Duration(milliseconds: 400),
      curve: Curves.elasticOut,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: staticBall, // reuse same child each rebuild ✅
    );
  }

  // 🎨 Pure Circle Shape
  Widget _ballShape(Color color, double size) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
    );
  }
}
