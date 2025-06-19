import 'package:calculator/helpers/db.dart';
import 'package:calculator/history_screen.dart';
import 'package:calculator/widgets/glass_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';

import 'button_values.dart'; // keep your enum/list exactly as before

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen>  with SingleTickerProviderStateMixin {
  final TextEditingController controller = TextEditingController();
  String result = '0';
  final DatabaseHelper _dbHelper = DatabaseHelper();
    late AnimationController _animationController;

  late Animation<double> _scaleAnimation;

  @override
  void initState() {
  super.initState();
     _animationController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
 _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  void _copyResult(context) {
    Clipboard.setData(ClipboardData(text: result));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Result copied to clipboard!'),
        backgroundColor: Colors.green.withValues(alpha:0.8),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showHistory(context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => HistorySheet(dbHelper: _dbHelper),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor:Color(0xFFF6F6F6),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
                          // Top Bar
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 24,
                  bottom: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GlassButton(
                      onTap: () => _showHistory(context),
                      child: Icon(
                        Icons.history,
                        color: Color(0xFF222222),
                        size: 26,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha:0.07),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        'Calculator',
                        style: TextStyle(
                          color: Color(0xFF222222),
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    GlassButton(
                      onTap: () => _copyResult(context),
                      child: Icon(
                        Icons.copy,
                        color: Color(0xFF222222),
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ),
            // ────────── DISPLAY (editable line + result) ──────────
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha:0.07),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  reverse: true,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ScaleTransition(
                           scale: _scaleAnimation,
                          child: TextField(
                            controller: controller,
                            readOnly: true, // hide keyboard
                            showCursor: true, // keep caret visible
                            enableInteractiveSelection: true, // allow tap‑to‑move
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF222222),
                             
                            ),
                            
                            textAlign: TextAlign.right, // <- align text to right
                            maxLines: null,
                            cursorHeight: 26,
                            cursorColor: Color(0xFFFF9800),
                            
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '0',
                              hintStyle: TextStyle(
                                color: Color(0xFF222222).withValues(alpha:0.5),
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        if (result != '0' && result != controller.text)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '= $result',
                              style: TextStyle(
                                fontSize: 24,
                                color: Color(0xFFFF9800),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        const SizedBox(height: 6),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ─────────────────── BUTTON GRID ────────────────────
          Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFF6F6F6),
        Color(0xFFEEEEEE),
      ],
    ),
  ),
  child: Column(
    children: [
      // Row 1: Clear, Delete, Percent, Divide
      _buildButtonRow([
        Btn.clr,
        Btn.del,
        Btn.per,
        Btn.divide,
      ], size),
      
      // Row 2: 7, 8, 9, Multiply
      _buildButtonRow([
        Btn.n7,
        Btn.n8,
        Btn.n9,
        Btn.multiply,
      ], size),
      
      // Row 3: 4, 5, 6, Subtract
      _buildButtonRow([
        Btn.n4,
        Btn.n5,
        Btn.n6,
        Btn.subtract,
      ], size),
      
      // Row 4: 1, 2, 3, Add
      _buildButtonRow([
        Btn.n1,
        Btn.n2,
        Btn.n3,
        Btn.add,
      ], size),
      
      // Row 5: 0 (double width), Dot, Equals
      _buildBottomRow(size),
    ],
  ),
),
          ],
        ),
      ),
    );
  }Widget _buildButtonRow(List<String> buttons, Size size) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: buttons.map((value) => 
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: _buildEnhancedButton(value, size),
          ),
        ),
      ).toList(),
    ),
  );
}

Widget _buildBottomRow(Size size) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        // Zero button (double width)
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.only(right: 6, left: 6),
            child: _buildEnhancedButton(Btn.n0, size, isWide: true),
          ),
        ),
        // Dot button
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: _buildEnhancedButton(Btn.dot, size),
          ),
        ),
        // Equals button
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 6, right: 6),
            child: _buildEnhancedButton(Btn.calculate, size),
          ),
        ),
      ],
    ),
  );
}

// ────────────────── ENHANCED BUTTON BUILDER ────────────────────
Widget _buildEnhancedButton(String value, Size size, {bool isWide = false}) {
  final buttonHeight = (size.width - 80) / 5; // Responsive height
 
  
  return Container(
    height: buttonHeight,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(isWide ? 32 : 24),
      gradient: _getButtonGradient(value),
      boxShadow: [
        BoxShadow(
          color: _getButtonShadowColor(value),
          blurRadius: 8,
          offset: Offset(0, 4),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.white.withValues(alpha:0.9),
          blurRadius: 1,
          offset: Offset(0, -1),
          spreadRadius: 0,
        ),
      ],
      border: Border.all(
        color: Colors.white.withValues(alpha:0.3),
        width: 1,
      ),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onBtnTap(value),
        borderRadius: BorderRadius.circular(isWide ? 32 : 24),
        splashColor: Colors.white.withValues(alpha:0.3),
        highlightColor: Colors.white.withValues(alpha:0.1),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isWide ? 32 : 24),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: _getButtonFontSize(value),
                fontWeight: FontWeight.w600,
                color: _getEnhancedTextColor(value),
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}



  // ─────────────────── BUTTON TAP LOGIC ──────────────────────
  void _onBtnTap(String value) {
    switch (value) {
      // CLEAR ALL
      case Btn.clr:
        controller.clear();
         FocusScope.of(context).unfocus();
        setState(() => result = '0');
        return;

      // DELETE (backspace)
      case Btn.del:
      
        _deleteAtCursor();
        return;

      // PERCENT
      case Btn.per:
        _applyPercentageAtCursor();
        return;

      // EQUALS
      case Btn.calculate:
      FocusScope.of(context).unfocus();
        _evaluate();
        return;

      // DEFAULT: insert value at caret
      default:
        _insertAtCursor(value);
    }
  
  }

  // ──────────────── CURSOR‑AWARE OPERATIONS ─────────────────
  void _insertAtCursor(String value) {
    final text = controller.text;
    int cursor = controller.selection.baseOffset;
    if (cursor < 0 || cursor > text.length) cursor = text.length;

    final newText = text.replaceRange(cursor, cursor, value);
    controller.text = newText;
    controller.selection = TextSelection.collapsed(
      offset: cursor + value.length,
    );

    _evaluateSilently();
  }

  void _deleteAtCursor() {
    final text = controller.text;
    if (text.isEmpty) return;

    int cursor = controller.selection.baseOffset;
    if (cursor < 0 || cursor > text.length) cursor = text.length;

    // nothing to delete if cursor at start
    if (cursor == 0) return;

    final newText = text.replaceRange(cursor - 1, cursor, '');
    controller.text = newText;
    controller.selection = TextSelection.collapsed(offset: cursor - 1);

    _evaluateSilently();
  }

  void _applyPercentageAtCursor() {
    final text = controller.text;
    if (text.isEmpty) return;

    int cursor = controller.selection.baseOffset;
    if (cursor < 0 || cursor > text.length) cursor = text.length;

    // find number immediately before cursor
    final regex = RegExp(r'(\d+\.?\d*)$');
    final match = regex.matchAsPrefix(text.substring(0, cursor));
    if (match == null) return;

    final numStr = match.group(0)!;
    final start = cursor - numStr.length;
    final replaced = (double.parse(numStr) / 100).toString();

    final newText = text.replaceRange(start, cursor, replaced);
    controller.text = newText;
    controller.selection = TextSelection.collapsed(
      offset: start + replaced.length,
    );

    _evaluateSilently();
  }

  // ─────────────────── EVALUATION LOGIC ─────────────────────
  void _evaluateSilently() {
    try {
      result = _parseAndEval(controller.text);
      setState(() {});
    } catch (_) {
      // ignore typing errors
    }
  }

  void _evaluate() {
    try {
      final eval = _parseAndEval(controller.text);
      final expression = controller.text;
      controller.text = eval;
      controller.selection = TextSelection.collapsed(offset: eval.length);
      result = eval;
      
      // Save calculation to history database
      _dbHelper.insertHistory(expression, eval);
      
      setState(() {});
    } catch (_) {
      setState(() => result = 'Error');
    }
  }

  String _parseAndEval(String expr) {
    if (expr.trim().isEmpty) return '0';

    final parsed = expr
        .replaceAll(Btn.multiply, '*')
        .replaceAll(Btn.divide, '/');

    final node = GrammarParser().parse(parsed);
    final val = node.evaluate(EvaluationType.REAL, ContextModel()) as double;

    return val
        .toStringAsFixed(12)
        .replaceAll(RegExp(r'\.?0+$'), ''); // trim trailing zeros
  }

 
}

// ──────────────────── ENHANCED STYLING HELPERS ──────────────────────
LinearGradient _getButtonGradient(String value) {
  if ([Btn.del, Btn.clr].contains(value)) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFF44336),
        Color(0xFFD32F2F),
      ],
    );
  }
  
  if ([
    Btn.per, Btn.multiply, Btn.add, Btn.subtract, 
    Btn.divide, Btn.calculate,
  ].contains(value)) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFFFB74D),
        Color(0xFFFF9800),
      ],
    );
  }
  
  return LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.white,
      Color(0xFFF8F8F8),
    ],
  );
}

Color _getButtonShadowColor(String value) {
  if ([Btn.del, Btn.clr].contains(value)) {
    return Color(0xFFF44336).withValues(alpha:0.3);
  }
  
  if ([
    Btn.per, Btn.multiply, Btn.add, Btn.subtract, 
    Btn.divide, Btn.calculate,
  ].contains(value)) {
    return Color(0xFFFF9800).withValues(alpha:0.3);
  }
  
  return Colors.black.withValues(alpha:0.1);
}

Color _getEnhancedTextColor(String value) {
  if ([
    Btn.del, Btn.clr, Btn.per, Btn.multiply, Btn.add, 
    Btn.subtract, Btn.divide, Btn.calculate,
  ].contains(value)) {
    return Colors.white;
  }
  return Color(0xFF222222);
}

double _getButtonFontSize(String value) {
  if (value == Btn.del) return 20; // Smaller for delete icon
  if ([Btn.multiply, Btn.divide, Btn.subtract, Btn.add].contains(value)) {
    return 28; // Larger for operators
  }
  return 24; // Default size
}