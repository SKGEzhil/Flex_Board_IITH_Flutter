import 'package:get/get.dart';

class PostTagController extends GetxController {

  /// Observables
  var selectedTags = <String>[].obs;
  var allTags = <String>['Lost and Found', 'Cab Sharing', 'Sales'].obs;
  var isCabSharing = false.obs;
  var resultTags = <String>[].obs;

  /// To search tags
  void searchTags(String query) {
    if(query.isEmpty) {
      resultTags.value = allTags.value;
    } else {
      resultTags.value = allTags.value.where((tag) =>
          tag.toLowerCase().contains(query.toLowerCase())).toList();
    }
  }

  @override
  void onInit() {
    super.onInit();
    resultTags.value = allTags.value;
  }

  /// Clears selected tags
  void resetTags() {
    selectedTags.value = [];
  }

  /// Adds tag to selected tags
  void addTag(String tag_) {
    allTags.add(tag_);
  }
}