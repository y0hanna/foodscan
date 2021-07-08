import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kassenzettel_app/screens/details_page.dart';

class ReceiptTile extends StatelessWidget {
  final DateTime date;
  final String supermarket;
  final double sum;
  final int index;

  ReceiptTile({this.date, this.supermarket, this.sum, this.index});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              child: Text(
            "Einkauf bei " +
                supermarket +
                " am " +
                DateFormat('dd.MM.yyy').format(date),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 15.0),
          )),
        ],
      ),
      subtitle: Text(
        "Gesamtbetrag: " + sum.toString() + " €",
      ),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Details(index)));
      },
      trailing: Icon(Icons.chevron_right),
    );
  }
}
