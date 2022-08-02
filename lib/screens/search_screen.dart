import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x_line/models/status_model.dart';

import '../themes/app_colors.dart';
import '../providers/home_methods.dart';
import '../widgets/news_feed_page/status_item.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchText = '';
  // HomeMethods homeMethods;
  List<StatusModel> postLists = [];

  @override
  Widget build(BuildContext context) {
    final homeMethods = Provider.of<HomeMethods>(context, listen: false);

    homeMethods.fetchSearchedPosts().then((value) {
      setState(() {
        postLists = value;
      });
    });

    final List<StatusModel> suggestionList = searchText.isEmpty
        ? []
        : postLists.where((status) {
            String getStatusText = status.status!.toLowerCase();
            String inputText = searchText.toLowerCase();

            bool isMatched = getStatusText.contains(inputText);

            return isMatched;
          }).toList();
    return Scaffold(
      backgroundColor: AppColors.toggleScreenLIght(),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: AppColors.iconColor(),
                  ),
                ),
                Flexible(
                  child: TextField(
                    onChanged: (value) {
                      searchText = value;
                    },
                    cursorColor: AppColors.textDefultColor(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDefultColor(),
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      label: const Text(
                        'search...',
                        style: TextStyle(
                            color: AppColors.defautlColor, fontSize: 20.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(
                          width: 1.0,
                          color: AppColors.defautlColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: const BorderSide(
                          width: 1.0,
                          color: AppColors.defautlColor,
                        ),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            suggestionList.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: suggestionList.length,
                      itemBuilder: (context, index) {
                        StatusModel statusModel = StatusModel(
                          createAt: suggestionList[index].createAt,
                          id: suggestionList[index].id,
                          imageUrl: suggestionList[index].imageUrl,
                          likeCount: suggestionList[index].likeCount,
                          status: suggestionList[index].status,
                          userId: suggestionList[index].userId,
                        );
                        return StatusItem(
                          statusModel: statusModel,
                        );
                      },
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported_rounded,
                          size: 180.0,
                          color: Colors.grey.withOpacity(0.4),
                        ),
                        Text(
                          'Noting found',
                          style: TextStyle(
                              color: Colors.grey.withOpacity(0.6),
                              fontSize: 27.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
