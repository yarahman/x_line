import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../themes/app_colors.dart';
import '../news_feed_page/status_item.dart';
import '../../providers/home_methods.dart';
import '../../models/status_model.dart';
import '../custom/custom_page_route.dart';
import '../../screens/search_screen.dart';

class NewsFeedsPage extends StatelessWidget {
  HomeMethods? homeMethods;

  @override
  Widget build(BuildContext context) {
    homeMethods = Provider.of<HomeMethods>(context, listen: false);
    return Column(
      children: [
        AppBar(
          backgroundColor: AppColors.toggleScreenLIght(),
          title: const Text(
            'X-Line',
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w900,
              color: AppColors.defautlColor,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  CustomPageRoute(
                    child:  SearchScreen(),
                  ),
                );
              },
              icon: const Icon(
                Icons.search_sharp,
                size: 30.0,
                color: AppColors.defautlColor,
              ),
            ),
          ],
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: homeMethods!.fatchAllPosts(),
            builder: (context, snapShot) {
              if (snapShot.hasData) {
                final docList = snapShot.data!.docs;
                return ListView.builder(
                  itemBuilder: (context, index) {
                    StatusModel statusModel = StatusModel.formMap(
                        docList[index].data() as Map<String, dynamic>);
                    return StatusItem(statusModel: statusModel);
                  },
                  itemCount: docList.isEmpty ? 0 : docList.length,
                );
              }
              return const Center(
                child: CircularProgressIndicator(color: AppColors.defautlColor),
              );
            },
          ),
        ),
      ],
    );
  }
}
