import 'package:flutter/material.dart';
import '../constants.dart';

class ItemTile extends StatelessWidget {
  final bool isChecked;
  final String itemTitle;
  final double itemPrice;
  final String itemCategory;
  final Function checkboxCallback;
  final Function deleteCallback;
  final bool leading;

  ItemTile(
      {this.isChecked,
      this.itemTitle,
      this.itemPrice,
      this.itemCategory = "",
      this.checkboxCallback,
      this.deleteCallback,
      this.leading});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(itemTitle, overflow: TextOverflow.ellipsis)),
          Text(
            itemPrice.toString() + " €",
            textAlign: TextAlign.right,
          ),
        ],
      ),
      subtitle: Text(itemCategory),
      leading: leading
          ? Checkbox(
              activeColor: kAccentColor,
              value: isChecked,
              onChanged: checkboxCallback,
            )
          : Icon(Icons.add),
      trailing: IconButton(
        onPressed: deleteCallback,
        icon: Icon(Icons.delete_outline),
      ),
    );
  }
}
