import 'package:flutter/material.dart';

class ReadingProgressWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const ReadingProgressWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = totalPages > 0 ? currentPage / totalPages : 0.0;
    final int percentage = (progress * 100).clamp(0, 100).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progreso: $percentage%',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              '$currentPage / $totalPages',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          color: Theme.of(context).colorScheme.primary,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}
