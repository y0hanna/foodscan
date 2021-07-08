import 'package:flutter/material.dart';
import 'package:kassenzettel_app/components/main_app_bar.dart';
import 'package:kassenzettel_app/models/receipt_data.dart';

import 'package:provider/provider.dart';

class Details extends StatelessWidget {
  final int index;

  Details(this.index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        'Übersicht',
        action: <Widget>[
          IconButton(
            icon: Icon(Icons.home, color: Colors.white),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, count) {
          final item = Provider.of<ReceiptData>(context, listen: false)
              .scannedReceipts[index]
              .items[count];
          return Card(
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: Text(item.name, overflow: TextOverflow.ellipsis)),
                  Text(
                    item.price.toString() + " €",
                    textAlign: TextAlign.right,
                  )
                ],
              ),
              subtitle: Text(item.category),
            ),
          );
        },
        itemCount: Provider.of<ReceiptData>(context, listen: false)
            .scannedReceipts[index]
            .items
            .length,
      ),
    );
  }
}
