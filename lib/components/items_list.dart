import 'package:flutter/material.dart';
import 'package:kassenzettel_app/models/item_data.dart';
import 'package:provider/provider.dart';
import 'item_tile.dart';

class ItemsList extends StatelessWidget {
  Function wasChecked;
  bool checkTrue = false;
  bool leading = false;

  ItemsList({this.wasChecked, this.leading});

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemData>(builder: (context, itemData, child) {
      if (itemData.items.length == 0) {
        return Container(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text('Noch keine Artikel hinzugefügt')
            ],
          ),
        );
      } else {
        return ListView.builder(
            itemBuilder: (context, index) {
              final item = itemData.items[index];
              print(item.category);
              return ItemTile(
                leading: leading,
                itemTitle: item.name,
                itemPrice: item.price,
                isChecked: item.isChecked,
                itemCategory: item.category,
                checkboxCallback: (checkboxState) {
                  itemData.updateItem(item);
                  for (var item in itemData.items) {
                    if (item.isChecked) {
                      checkTrue = true;
                    }
                    wasChecked(checkTrue);
                  }
                },
                deleteCallback: () {
                  itemData.deleteItem(item);
                },
              );
            },
            itemCount: itemData.items.length);
      }
    });
  }
}
