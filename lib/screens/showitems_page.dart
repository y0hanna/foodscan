import 'package:flutter/material.dart';
import 'package:kassenzettel_app/components/items_list.dart';
import 'package:kassenzettel_app/components/main_app_bar.dart';
import 'package:kassenzettel_app/models/category_data.dart';
import 'package:kassenzettel_app/models/item_data.dart';
import 'package:kassenzettel_app/models/receipt_data.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import 'add_items_page.dart';

class ShowItems extends StatefulWidget {
  @override
  _ShowItemsState createState() => _ShowItemsState();
}

class _ShowItemsState extends State<ShowItems> {
  bool wasChecked = false;
  String _selectedCategory;
  bool allCategoriesChecked;

  void onChecked(bool state) {
    setState(() {
      if (state) {
        wasChecked = true;
      } else {
        wasChecked = false;
      }
    });
  }

  void addCategories() {
    for (var item in Provider.of<ItemData>(context, listen: false).items) {
      if (item.isChecked) {
        setState(() {
          item.category = _selectedCategory;
        });
        item.isChecked = false;
        wasChecked = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        'Artikel',
        action: <Widget>[
          TextButton(
            child: Text(
              'Fertig',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              allCategoriesChecked = true;
              for (var item
                  in Provider.of<ItemData>(context, listen: false).items) {
                if (item.category == 'Keine') {
                  allCategoriesChecked = false;
                }
              }
              if (!allCategoriesChecked) {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Hast du nicht etwas vergessen?'),
                    content: new Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            "Bitte ordne allen Artikeln eine Kategorie zu, sonst können sie in der Statistik nicht berücksichtigt werden."),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child:
                            Text('Ok', style: TextStyle(color: kAccentColor)),
                      ),
                    ],
                  ),
                );
              } else {
                // await Provider.of<ReceiptData>(context, listen: false)
                //     .getReceipts(context);
                await Provider.of<ReceiptData>(context, listen: false)
                    .saveLastAddedReceipt();
                print(Provider.of<ReceiptData>(context, listen: false)
                    .scannedReceipts
                    .length);
                Navigator.pop(context);
                Navigator.pushNamed(context, '/statistics');
              }
            },
          )
        ],
      ),
      backgroundColor: kBackgroundColor,
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Ordne deine Artikel zu den passenden Kategorien hinzu, lösche sie, oder füge neue hinzu.",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: ItemsList(wasChecked: onChecked, leading: true),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: !wasChecked
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AddItemsScreen();
                                });
                          },
                          child: Text('Artikel hinzufügen',
                              style: TextStyle(fontSize: 18)),
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              padding: EdgeInsets.all(12.0),
                              primary: kAccentColor),
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Kategorie hinzufügen'),
                                    content: SingleChildScrollView(
                                      physics: ScrollPhysics(),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            child: ListView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: CategoryData
                                                  .categories.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return ListTile(
                                                    title: Text(CategoryData
                                                        .categories[index]),
                                                    onTap: () {
                                                      _selectedCategory =
                                                          CategoryData
                                                                  .categories[
                                                              index];
                                                      addCategories();
                                                      Navigator.pop(context);
                                                    });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: Text(
                            'Kategorie hinzufügen',
                            style: TextStyle(fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              padding: EdgeInsets.all(12.0),
                              primary: kAccentColor),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
