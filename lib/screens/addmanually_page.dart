import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kassenzettel_app/components/items_list.dart';
import 'package:kassenzettel_app/components/main_app_bar.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:kassenzettel_app/models/item_data.dart';
import 'package:kassenzettel_app/models/receipt_data.dart';
import 'file:///C:/Users/johan/Desktop/Johanna/Uni/SS%2021/Vertiefung/kassenzettel_app/lib/models/supermarket_data.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import 'add_items_page.dart';

class AddManually extends StatefulWidget {
  @override
  _AddManuallyState createState() => _AddManuallyState();
}

class _AddManuallyState extends State<AddManually> {
  String _selectedSupermarket;
  DateTime _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        'Manuell hinzufügen',
        action: <Widget>[
          TextButton(
            child: Text(
              'Fertig',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              if (_selectedSupermarket == null ||
                  _selectedDate == null ||
                  Provider.of<ItemData>(context, listen: false).items.length ==
                      0) {
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
                      new TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Ok'),
                      ),
                    ],
                  ),
                );
              } else {
                Provider.of<ReceiptData>(context, listen: false).addReceipt(
                  0,
                  _selectedDate,
                  _selectedSupermarket,
                  Provider.of<ItemData>(context, listen: false).items,
                  Provider.of<ItemData>(context, listen: false).getSum(),
                );
                Provider.of<ReceiptData>(context, listen: false)
                    .saveLastAddedReceipt();
                Navigator.pop(context);
                Navigator.pushNamed(context, '/statistics');
              }
            },
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Form(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('Füge deinen Einkauf manuell hinzu.',
                        style: TextStyle(fontSize: 18.0)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: DropdownButton(
                      isExpanded: true,
                      hint: Center(child: Text('Supermarkt')),
                      value: _selectedSupermarket,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedSupermarket = newValue;
                        });
                      },
                      items: SupermarketData.supermarkets
                          .map((label) => DropdownMenuItem(
                              child: new Text(label), value: label))
                          .toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        DateTimeField(
                          textAlign: TextAlign.center,
                          cursorColor: kAccentColor,
                          format: DateFormat("dd.MM.yyyy"),
                          onShowPicker: (context, currentValue) {
                            return showDatePicker(
                                helpText: 'Datum',
                                context: context,
                                firstDate: DateTime(1900),
                                initialDate: currentValue ?? DateTime.now(),
                                lastDate: DateTime(2100));
                          },
                          onChanged: (newValue) {
                            setState(() {
                              _selectedDate = newValue;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: "Datum",
                            hintStyle: TextStyle(),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      child: ItemsList(leading: false),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AddItemsScreen();
                        });
                  },
                  child: Text(
                    'Artikel hinzufügen',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: kAccentColor,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
