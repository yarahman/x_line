import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game_screen/game_item.dart';
import '../../themes/app_colors.dart';
import '../../providers/games_methods.dart';
import '../../models/game_model.dart';

class GamePage extends StatelessWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameMethods = Provider.of<GameMethods>(context, listen: false);
    return SafeArea(
      child: Column(
        children: [
          const Text(
            'Games',
            style: TextStyle(
              color: AppColors.defautlColor,
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: gameMethods.fetchAllGames(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final docList = snapshot.data!.docs;
                  return GridView.builder(
                    padding: const EdgeInsets.all(10.0),
                    itemCount: docList.isEmpty ? 0 : docList.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            childAspectRatio: 3 / 2,
                            maxCrossAxisExtent: 200.0,
                            mainAxisSpacing: 5.0,
                            crossAxisSpacing: 5.0),
                    itemBuilder: (context, index) {
                      final model = GameModel.fromMap(
                          docList[index].data() as Map<String, dynamic>);
                      return GameItem(model);
                    },
                  );
                }
                return const Center(
                  child:
                      CircularProgressIndicator(color: AppColors.defautlColor),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
