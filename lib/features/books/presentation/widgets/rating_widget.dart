import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onRatingChanged;

  const RatingWidget({
    super.key,
    required this.rating,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        return IconButton(
          icon: Icon(
            starValue <= rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 32,
          ),
          onPressed: () {
            onRatingChanged(starValue);
          },
        );
      }),
    );
  }
}
