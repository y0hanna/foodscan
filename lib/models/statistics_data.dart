import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kassenzettel_app/models/receipt.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:kassenzettel_app/models/category_list_data.dart';

class StatisticsData extends ChangeNotifier {
  String key;
  double value;

  StatisticsData({this.key, this.value});

  List<charts.Series<StatisticsData, String>> _seriesData = [];
  List<ScannedReceipt> myData = [];

  static List calculate(
      List<ScannedReceipt> receipts, String sortBy, String time) {
    List<StatisticsData> result = [];
    List<ScannedReceipt> workWith = [];
    DateTime timestamp = DateTime.now();
    DateTime currentDate =
        new DateTime(timestamp.year, timestamp.month, timestamp.day);

    var currentDay = currentDate.weekday;
    var currentWeek = currentDate.subtract(Duration(days: currentDay - 1));
    var currentMonth = currentDate.month;
    var currentYear = currentDate.year;

    receipts.forEach((receipt) {
      switch (time) {
        case 'week':
          if (receipt.date.isAtSameMomentAs(currentWeek) ||
              receipt.date.isAfter(currentWeek)) {
            workWith.add(receipt);
          }
          break;
        case 'month':
          if (receipt.date.month == currentMonth) {
            workWith.add(receipt);
          }
          break;
        case 'year':
          if (receipt.date.year == currentYear) {
            workWith.add(receipt);
          }
      }
    });
    if (sortBy == 'supermarket') {
      Map<String, double> supermarketsMap = {};
      workWith.forEach((receipt) {
        String key = receipt.supermarket;
        if (supermarketsMap.containsKey(key)) {
          supermarketsMap[key] += receipt.sum;
        } else {
          supermarketsMap[key] = receipt.sum;
        }
        double finalSum =
            ((supermarketsMap[key] * pow(10.0, 2)).round().toDouble() /
                pow(10.0, 2));
        supermarketsMap[key] = finalSum;
      });
      result = supermarketsMap.entries
          .map((entry) => StatisticsData(key: entry.key, value: entry.value))
          .toList();
    }
    if (sortBy == 'category') {
      Map<String, double> categoryMap = {};
      workWith.forEach((receipt) {
        for (var item in receipt.items) {
          String key = item.category;
          if (categoryMap.containsKey(key)) {
            categoryMap[key] += item.price;
          } else {
            categoryMap[key] = item.price;
          }
          double finalSum =
              ((categoryMap[key] * pow(10.0, 2)).round().toDouble() /
                  pow(10.0, 2));
          categoryMap[key] = finalSum;
        }
      });
      result = categoryMap.entries
          .map((entry) => StatisticsData(key: entry.key, value: entry.value))
          .toList();
    }

    if (sortBy == 'month') {
      Map<String, double> categoryMap = {};
      workWith.forEach((receipt) {
        for (var item in receipt.items) {
          String key = item.category;
          if (categoryMap.containsKey(key)) {
            categoryMap[key] += item.price;
          } else {
            categoryMap[key] = item.price;
          }
        }
      });
    }
    return result;
  }

  Widget buildBody(BuildContext context, List<ScannedReceipt> receipts,
      String sortBy, String time) {
    List myData = calculate(receipts, sortBy, time);

    if (myData.length == 0) {
      return Expanded(
          child: Center(child: Text('Noch keine Daten für diesen Zeitraum')));
    } else {
      _seriesData = [];

      _seriesData.add(
        charts.Series(
          data: myData,
          id: 'Receipts',
          domainFn: (StatisticsData data, _) => data.key,
          measureFn: (StatisticsData data, _) => data.value,
          labelAccessorFn: (StatisticsData row, _) => '${row.value} €',
          // colorFn: (_, index) =>
          //     charts.MaterialPalette.indigo.makeShades(15)[index],
        ),
      );
      if (sortBy == 'supermarket') {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text('SUPERMARKT'),
                    SizedBox(height: 10.0),
                    Container(
                      child: Expanded(
                        child: charts.PieChart(
                          _seriesData,
                          animate: true,
                          animationDuration: Duration(seconds: 2),
                          behaviors: [
                            charts.DatumLegend(
                              showMeasures: true,
                              legendDefaultMeasure:
                                  charts.LegendDefaultMeasure.firstValue,
                              measureFormatter: (num value) {
                                return value == null ? '-' : '${value} €';
                              },
                              position: charts.BehaviorPosition.bottom,
                              outsideJustification:
                                  charts.OutsideJustification.middleDrawArea,
                              horizontalFirst: true,
                              desiredMaxColumns: 2,
                              desiredMaxRows: 2,
                              cellPadding:
                                  new EdgeInsets.only(right: 4.0, bottom: 4.0),
                              entryTextStyle: charts.TextStyleSpec(
                                  color:
                                      charts.MaterialPalette.teal.shadeDefault,
                                  fontSize: 15),
                            ),
                          ],
                          defaultRenderer: new charts.ArcRendererConfig(
                            arcRendererDecorators: [
                              new charts.ArcLabelDecorator(
                                labelPosition: charts.ArcLabelPosition.auto,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      } else if (sortBy == 'category') {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text('KATEGORIE'),
                    SizedBox(height: 10.0),
                    Container(
                      child: Expanded(
                        child: charts.BarChart(
                          _seriesData,
                          animate: true,
                          vertical: false,
                          barRendererDecorator:
                              new charts.BarLabelDecorator<String>(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      } else if (sortBy == 'month') {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text('KATEGORIE'),
                    SizedBox(height: 10.0),
                    Container(
                      child: Expanded(
                        child: charts.BarChart(
                          _seriesData,
                          animate: true,
                          vertical: false,
                          barRendererDecorator:
                              new charts.BarLabelDecorator<String>(),
                          // Hide domain axis.
                          domainAxis: new charts.OrdinalAxisSpec(
                              renderSpec: new charts.NoneRenderSpec()),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      } else {
        return CircularProgressIndicator();
      }
    }
  }

  Widget stackChartData(BuildContext context, List<ScannedReceipt> receipts) {
    DateTime timestamp = DateTime.now();
    DateTime currentDate =
        new DateTime(timestamp.year, timestamp.month, timestamp.day);

    var currentYear = currentDate.year;

    List workWith = [];

    receipts.forEach((receipt) {
      if (receipt.date.year == currentYear) {
        workWith.add(receipt);
      }
    });

    CategoryListData.resetList();
    CategoryListData.fillList();

    List months = [
      'Januar',
      'Februar',
      'März',
      'April',
      'Mai',
      'Juni',
      'Juli',
      'August',
      'September',
      'Oktober',
      'November',
      'Dezember'
    ];

    Map categoryMap = {};
    List result = [];

    for (int i = 0; i < months.length; i++) {
      categoryMap = {};
      workWith.forEach((receipt) {
        if (receipt.date.month == i + 1) {
          for (var item in receipt.items) {
            for (var list in CategoryListData.catlistData) {
              if (item.category == list.name) {
                String key = item.category;
                if (categoryMap.containsKey(key)) {
                  categoryMap[key] += item.price;
                } else {
                  categoryMap[key] = item.price;
                }

                double finalSum =
                    ((categoryMap[key] * pow(10.0, 2)).round().toDouble() /
                        pow(10.0, 2));
                categoryMap[key] = finalSum;
              }
            }
          }
        }
      });
      result = categoryMap.entries //TODO evtl nach Monaten sortieren
          .map((entry) => StatisticsData(key: entry.key, value: entry.value))
          .toList();

      Map finalMap = {};
      List<StatisticsData> finalList = [];
      for (var res in result) {
        finalList.add(StatisticsData(key: months[i], value: res.value));
        finalMap[months[i]] = finalList;

        for (var entry in finalMap.entries) {
          for (var val in entry.value) {
            result = finalMap.entries //TODO evtl nach Monaten sortieren
                .map(
                    (entry) => StatisticsData(key: entry.key, value: val.value))
                .toList();
          }
        }

        for (var list in CategoryListData.catlistData) {
          if (res.key == list.name) {
            list.categoryPerMonth += result;
          }
        }
      }
    }

    List<charts.Series<StatisticsData, String>> seriesData = [];

    for (var list in CategoryListData.catlistData) {
      seriesData.add(new charts.Series<StatisticsData, String>(
        id: list.name,
        domainFn: (StatisticsData data, _) => data.key,
        measureFn: (StatisticsData data, _) => data.value,
        data: list.categoryPerMonth,
        labelAccessorFn: (StatisticsData data, _) => '',
        //colorFn: (_, index) => charts.MaterialPalette.red.makeShades(15)[index],
      ));
    }

    return AbsorbPointer(
      absorbing: true,
      child: new charts.BarChart(
        seriesData,
        animate: true,
        barGroupingType: charts.BarGroupingType.stacked,
        //barRendererDecorator: new charts.BarLabelDecorator(),
        behaviors: [
          new charts.SeriesLegend(
            position: charts.BehaviorPosition.top,
            outsideJustification: charts.OutsideJustification.middleDrawArea,
            horizontalFirst: false,
            desiredMaxRows: 5,
            cellPadding: new EdgeInsets.all(2.0),
            entryTextStyle: charts.TextStyleSpec(fontSize: 12),
          )
        ],
      ),
    );
  }
}
