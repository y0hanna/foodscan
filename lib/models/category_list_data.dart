import 'package:kassenzettel_app/models/category_data.dart';
import 'package:kassenzettel_app/models/category_list.dart';
import 'package:kassenzettel_app/models/statistics_data.dart';

class CategoryListData {
  static List<CategoryList> catlistData = [];

  static void addCategory(String newItemTitle, List<StatisticsData> list) {
    final cat = CategoryList(name: newItemTitle, categoryPerMonth: list);
    catlistData.add(cat);
  }

  static void resetList() {
    catlistData = [];
  }

  static void fillList() {
    CategoryData.categories.forEach((category) {
      addCategory(category, []);
    });
  }
}
