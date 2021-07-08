import 'package:flutter/material.dart';
import 'package:kassenzettel_app/models/receipt_data.dart';
import 'package:provider/provider.dart';
import 'receipt_tile.dart';

class ReceiptsList extends StatelessWidget {
  Widget build(BuildContext context) {
    return Consumer<ReceiptData>(
      builder: (context, receiptData, child) {
        if (receiptData.scannedReceipts.length == 0) {
          return CircularProgressIndicator();
        } else {
          return ListView.builder(
            itemBuilder: (context, index) {
              final receipt = receiptData.scannedReceipts[index];
              return Card(
                child: ReceiptTile(
                  supermarket: receipt.supermarket,
                  date: receipt.date,
                  sum: receipt.sum,
                  index: index,
                ),
              );
            },
            itemCount: receiptData.scannedReceipts.length,
          );
        }
      },
    );
  }
}
