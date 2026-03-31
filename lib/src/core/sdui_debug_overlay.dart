import 'package:flutter/material.dart';

/// A developer experience utility that visibly highlights missing or broken
/// components instead of throwing a blank or generic text screen.
class SduiDebugOverlay extends StatelessWidget {
  final String componentType;
  final String? errorReason;

  const SduiDebugOverlay({
    super.key,
    required this.componentType,
    this.errorReason,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(
          color: Colors.red.shade400,
          width: 2,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_rounded, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Text(
                'Missing Component: $componentType',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          if (errorReason != null) ...[
            const SizedBox(height: 6),
            Text(
              errorReason!,
              style: TextStyle(color: Colors.red.shade700, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}
