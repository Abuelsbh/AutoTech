
import 'package:flutter/material.dart';

class ConditionWidget extends StatelessWidget {
  final Widget child,conditionWidget;
  final bool condition;
  const ConditionWidget({super.key, required this.child, required this.conditionWidget, required this.condition});

  @override
  Widget build(BuildContext context) {
    if(condition) return conditionWidget;
    return child;
  }
}
