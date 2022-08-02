import 'package:flutter/material.dart';

import '../../themes/app_colors.dart';
import '../../models/game_model.dart';

class GameItem extends StatelessWidget {
  GameItem(this.gameModel);
  GameModel gameModel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image.network(
              gameModel.imageUrl!,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                15.0,
              ),
              color: const Color.fromARGB(223, 36, 36, 36)),
          height: 30,
          width: double.infinity,
        ),
        Positioned(
          bottom: 7.0,
          child: FittedBox(
            child: Text(
              gameModel.name!,
              style: const TextStyle(
                  color: AppColors.sndDefaultColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
