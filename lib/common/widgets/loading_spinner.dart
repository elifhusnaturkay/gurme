import 'package:flutter/material.dart';
import 'package:gurme/common/constants/asset_constants.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        LoadingAnimationWidget.beat(
          color: Colors.indigo.shade400,
          size: 100,
        ),
        Image.asset(
          AssetConstants.shortLogoPurple,
          width: 75,
          height: 75,
        ),
        // Loading spinner
      ],
    );
  }
}
