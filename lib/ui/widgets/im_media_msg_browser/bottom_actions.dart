import 'package:flutter/material.dart';

class BottomActions extends StatelessWidget {
  const BottomActions({
    super.key,
    this.onDownload,
  });

  final VoidCallback? onDownload;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: Navigator.of(context).pop,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            alignment: Alignment.center,
            decoration: const ShapeDecoration(
              color: Colors.black12,
              shape: CircleBorder(),
            ),
            width: 44,
            height: 44,
            child: const Icon(
              Icons.close,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        GestureDetector(
          onTap: onDownload,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            alignment: Alignment.center,
            decoration: const ShapeDecoration(
              color: Colors.black26,
              shape: CircleBorder(),
            ),
            width: 44,
            height: 44,
            child: const Icon(
              Icons.arrow_downward_sharp,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
