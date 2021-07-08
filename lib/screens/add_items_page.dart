import 'package:flutter/material.dart';
import 'package:kassenzettel_app/constants.dart';
import 'package:kassenzettel_app/models/item_data.dart';
import 'package:kassenzettel_app/models/category_data.dart';
import 'package:provider/provider.dart';
import 'package:easy_mask/easy_mask.dart';

class AddItemsScreen extends StatefulWidget {
  @override
  _AddItemsScreenState createState() => _AddItemsScreenState();
}

class _AddItemsScreenState extends State<AddItemsScreen> {
  String _selectedCategory;
  bool manuallyAdded = false;
  final itemController = TextEditingController();
  final priceController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    itemController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              heightFactor: 0.5,
              alignment: Alignment.topRight,
              child: IconButton(
                alignment: Alignment.topRight,
                padding: EdgeInsets.all(0.0),
                icon: Icon(Icons.close),
                color: Colors.grey,
                iconSize: 20.0,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Artikel hinzufügen',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0, color: kAccentColor),
                  ),
                  TextField(
                    controller: itemController,
                    textAlign: TextAlign.center,
                    cursorColor: kAccentColor,
                    decoration: InputDecoration(
                      hintText: 'Artikel',
                      fillColor: kAccentColor,
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            const BorderSide(color: kAccentColor, width: 2.0),
                      ),
                    ),
                  ),
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    cursorColor: kAccentColor,
                    decoration: InputDecoration(
                      hintText: 'Preis',
                      fillColor: kAccentColor,
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            const BorderSide(color: kAccentColor, width: 2.0),
                      ),
                    ),
                    inputFormatters: [
                      TextInputMask(
                        mask: '\€! !9+,99',
                        placeholder: '',
                        maxPlaceHolders: 3,
                        reverse: true,
                      ),
                    ],
                  ),
                  DropdownButton(
                    isExpanded: true,
                    hint: Center(child: Text('Kategorie')),
                    value: _selectedCategory,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                        for (var d in CategoryData.categories) {
                          print(d);
                        }
                      });
                    },
                    items: CategoryData.categories
                        .map((label) => DropdownMenuItem(
                            child: new Text(label), value: label))
                        .toList(),
                  ),
                  ElevatedButton(
                    child: Text('Hinzufügen'),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(kAccentColor),
                    ),
                    onPressed: () {
                      try {
                        String newItemTitle = itemController.text;
                        String price = priceController.text;
                        double newItemPrice = double.parse(
                            price.substring(2).replaceAll(",", "."));
                        Provider.of<ItemData>(context, listen: false)
                            .addItem(newItemTitle, newItemPrice);
                        Provider.of<ItemData>(context, listen: false)
                            .addCategory(newItemTitle, _selectedCategory);
                        Navigator.pop(context);
                      } catch (e) {
                        print("Couldn't add Item");
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
