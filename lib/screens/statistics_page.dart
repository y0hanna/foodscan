import 'package:flutter/material.dart';
import 'package:kassenzettel_app/components/bottom_nav_bar.dart';
import 'package:kassenzettel_app/components/fab_with_speed_dial.dart';
import 'package:kassenzettel_app/models/category_list_data.dart';
import 'package:kassenzettel_app/models/receipt_data.dart';
import 'package:kassenzettel_app/models/statistics_data.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  String _selectedSupermarketTime = 'week';
  String _selectedCategoryTime = 'week';

  // List<charts.Series<StatisticsData, String>> _seriesData = [];
  // List<ScannedReceipt> myData = [];

  @override
  Widget build(BuildContext context) {
    print("now building statistics");
    CategoryListData.fillList();
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kAccentColor,
          title: Center(child: Text('Statistik')),
          actions: [
            IconButton(
              icon: Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.shopping_cart_outlined)),
              Tab(icon: Icon(Icons.restaurant)),
              Tab(icon: Icon(Icons.event)),
            ],
          ),
        ),
        backgroundColor: kBackgroundColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(width: 50.0, child: FABWithSpeedDial()),
        bottomNavigationBar: BottomNavBar(2),
        body: Consumer2<ReceiptData, StatisticsData>(
            builder: (context, receiptData, statisticsData, child) {
          if (receiptData.scannedReceipts.length == 0) {
            return CircularProgressIndicator();
          } else {
            return TabBarView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DropdownButton(
                      isExpanded: true,
                      hint: Center(child: Text('Filter')),
                      value: _selectedSupermarketTime,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedSupermarketTime = newValue;
                          statisticsData.buildBody(
                              context,
                              Provider.of<ReceiptData>(context, listen: false)
                                  .scannedReceipts,
                              'supermarket',
                              _selectedSupermarketTime);
                        });
                      },
                      items: [
                        DropdownMenuItem(
                            child: Text('Filter: Aktuelles Jahr'),
                            value: 'year'),
                        DropdownMenuItem(
                            child: Text('Filter nach: Aktueller Monat'),
                            value: 'month'),
                        DropdownMenuItem(
                            child: Text('Filter nach: Aktuelle Woche'),
                            value: 'week')
                      ],
                    ),
                    statisticsData.buildBody(
                        context,
                        receiptData.scannedReceipts,
                        'supermarket',
                        _selectedSupermarketTime),
                  ],
                ),
                Column(
                  children: [
                    DropdownButton(
                      isExpanded: true,
                      hint: Center(child: Text('Filter')),
                      value: _selectedCategoryTime,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCategoryTime = newValue;
                          statisticsData.buildBody(
                              context,
                              receiptData.scannedReceipts,
                              'category',
                              _selectedCategoryTime);
                        });
                      },
                      items: [
                        DropdownMenuItem(
                            child: Text('Filter: Aktuelles Jahr'),
                            value: 'year'),
                        DropdownMenuItem(
                            child: Text('Filter nach: Aktueller Monat'),
                            value: 'month'),
                        DropdownMenuItem(
                            child: Text('Filter nach: Aktuelle Woche'),
                            value: 'week')
                      ],
                    ),
                    statisticsData.buildBody(
                        context,
                        receiptData.scannedReceipts,
                        'category',
                        _selectedCategoryTime),
                  ],
                ),
                statisticsData.stackChartData(
                    context, receiptData.scannedReceipts),
              ],
            );
          }
        }),
      ),
    );
  }
}
