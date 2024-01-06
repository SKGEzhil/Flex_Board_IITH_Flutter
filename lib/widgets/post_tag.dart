import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../controllers/post_list_controller.dart';
import '../controllers/post_tag_controller.dart';
import 'package:get/get.dart';

class PostTag extends StatelessWidget {
  PostTag({
    super.key,
    required this.tagName, this.isSearch,
  });

  /// GetX Controllers
  final PostTagController postTagController = Get.put(PostTagController());
  final PostListController postListController = Get.put(PostListController());

  /// Declarations
  final createTagController = TextEditingController();
  final tagName;
  final isSearch;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      onTap: () {

        if(isSearch == true) {
          if(postTagController.selectedTags.contains(tagName)) {
            postListController.resetSearch();
          } else {
            postTagController.resetTags();
            postListController.filterTagResults(tagName);
          }
        }

        if (tagName == 'Create new tag') {
          showCupertinoDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: const Text('Create new tag'),
                  content: CupertinoTextField(
                    controller: createTagController,
                    placeholder: 'Enter tag name',
                  ),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text('Cancel',
                          style: TextStyle(color: Colors.deepOrangeAccent)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    CupertinoDialogAction(
                      child: const Text('Create',
                          style: TextStyle(color: Colors.deepOrangeAccent)),
                      onPressed: () {
                        postTagController.allTags
                            .add(createTagController.text);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              });

        } else {
          if (postTagController.selectedTags.contains(tagName)) {
            postTagController.selectedTags.remove(tagName);
            if(tagName == 'Cab Sharing') {
              postTagController.isCabSharing.value = false;
            }
          } else {
            postTagController.selectedTags.add(tagName);
            if(tagName == 'Cab Sharing') {
              postTagController.isCabSharing.value = true;
            }
          }
        }
      },
      child: Obx(() {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.black.withOpacity(0.1),
              border: postTagController.selectedTags.contains(tagName)
                  ? Border.all(color: Colors.deepOrangeAccent, width: 1)
                  : null
            // color: Color.fromRGBO(255, 114, 33, 0.3),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 5,
                ),
                Icon(
                  tagName == 'Create new tag' ? Icons.add :
                  tagName == 'Time' ? Icons.time_to_leave :
                  Icons.sell,
                  color: const Color.fromRGBO(0, 0, 0, 0.7),
                  size: 15,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  '$tagName',
                  style: const TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 0.7), fontSize: 12),
                ),
                const SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
