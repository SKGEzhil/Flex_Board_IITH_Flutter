import 'package:flutter/material.dart';
import 'package:lost_flutter/controllers/bottom_nav_controller.dart';
import 'package:lost_flutter/utils/server_utils.dart';
import 'package:get/get.dart';
import 'package:lost_flutter/widgets/no_internet.dart';
import 'package:lost_flutter/widgets/post_list.dart';
import '../controllers/post_list_controller.dart';
import '../controllers/post_tag_controller.dart';
import '../models/post_model.dart';
import '../widgets/post_tag.dart';
import '../widgets/search_field.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  /// Declarations
  final serverUtils = ServerUtils();
  final tagSearch = TextEditingController();


  /// GetX Controllers
  final PostListController postListController = Get.put(PostListController());
  final PostTagController postTagController = Get.put(PostTagController());
  final BottomNavController bottomNavController =
      Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        postTagController.resetTags();
        postListController.resetSearch();
        bottomNavController.changeIndex(0);
      },
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: SearchField(
                onTextChanged: postListController.filterSearchResults)),
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10)),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Search with Tags',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black.withOpacity(0.7),
                                    fontSize: 13),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    height: 30,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        color:
                                            Colors.deepOrange.withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(60)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            const SizedBox(
                                              width: 7,
                                            ),
                                            Icon(
                                              Icons.search,
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              size: 17,
                                            ),
                                            const SizedBox(
                                              width: 7,
                                            ),
                                            Expanded(
                                              child: TextFormField(
                                                onChanged: (value) {
                                                  postTagController
                                                      .searchTags(value);
                                                },
                                                controller: tagSearch,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                ),
                                                decoration:
                                                    InputDecoration.collapsed(
                                                  hintText: "Search",
                                                  hintStyle: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black
                                                          .withOpacity(0.5)),
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 7,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Divider(
                            height: 10,
                            color: Colors.black.withOpacity(0.1),
                          ),
                          SingleChildScrollView(
                            scrollDirection:
                                Axis.horizontal, // Enable horizontal scrolling
                            child: Obx(() {
                              return Wrap(
                                direction: Axis.horizontal,
                                spacing: 5,
                                runSpacing: 5,
                                children: postTagController.resultTags
                                    .map((tag) => PostTag(
                                          tagName: tag,
                                          isSearch: true,
                                        ))
                                    .toList(),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Expanded(child: PostList())
              ],
            ),
            NoInternet()

            // BottomNav()
          ],
        ),
      ),
    );
  }
}
