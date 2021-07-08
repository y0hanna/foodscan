import 'package:kassenzettel_app/models/statistics_data.dart';

class CategoryList {
  String name;
  List<StatisticsData> categoryPerMonth;

  CategoryList({this.name, this.categoryPerMonth});
}
