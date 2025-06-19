import 'package:flutter/material.dart';

class CalculatorButton extends StatefulWidget {
  final String text;
  final bool isOperator;
  final bool isSpecial;
  final VoidCallback onPressed;

  const CalculatorButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isOperator = false,
    this.isSpecial = false,
  });

  @override
  State<CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
  late final Animation<double> _scale = Tween<double>(begin: 1, end: .95).animate(_ctrl);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.isOperator
        ? const Color(0xFFFF9800)
        : Colors.white;
    final fg = widget.isOperator
        ? Colors.white
        : widget.isSpecial
            ? Colors.red
            : const Color(0xFF222222);

    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTapDown: (_) => _ctrl.forward(),
        onTapUp: (_) => _ctrl.reverse(),
        onTapCancel: () => _ctrl.reverse(),
        onTap: widget.onPressed,
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(.07), blurRadius: 8, offset: const Offset(0, 4))
            ],
          ),
          alignment: Alignment.center,
          child: Text(widget.text,
              style: TextStyle(
                  fontSize: 32, fontWeight: FontWeight.w600, color: fg, letterSpacing: 1.5, height: 1)),
        ),
      ),
    );
  }
}
