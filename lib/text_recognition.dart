import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kassenzettel_app/models/receipt_data.dart';
import 'package:kassenzettel_app/models/supermarket_data.dart';
import 'package:provider/provider.dart';
import 'package:string_similarity/string_similarity.dart';
import 'models/item_data.dart';

class TextRecognition extends ChangeNotifier {
  File _image;
  final ImagePicker picker = ImagePicker();
  bool imageAdded = false;
  PickedFile pickedFile;
  double sum = 0;
  String date;
  DateTime formattedDate;
  String price;
  List<double> prices;
  List items;
  RegExp regExSum = RegExp('s ?u ?m ?', caseSensitive: false);
  RegExp regExDate =
      RegExp('[0-3][0-9][.][0-3][0-9][.](?:[0-9][0-9])?[0-9][0-9]');
  RegExp regExPrice = RegExp('[0-9]+[,.][0-9]{1,2}[ ][A-Z0-9]{1,2}(\s)*(?!.)');
  String supermarket;
  bool scanSuccess = false;
  bool scanDone = false;

  DateTime formatDate(String date) {
    DateTime result;

    String formattedDate = date.replaceAll(".", "-");
    List formatted = formattedDate.split('-');
    String finalDate = "";

    if (date.length == 8) {
      formatted[formatted.length - 1] = "20" + formatted[formatted.length - 1];
    }

    for (int k = formatted.length - 1; k >= 0; k--) {
      finalDate += "-" + formatted[k];
    }
    result = DateTime.parse(finalDate.substring(1));
    return result;
  }

  Future getImage(context, String source) async {
    Provider.of<ItemData>(context, listen: false).resetList();
    if (source == 'camera') {
      pickedFile = await picker.getImage(
          source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);
    } else if (source == 'gallery') {
      pickedFile = await picker.getImage(source: ImageSource.gallery);
    }
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      imageAdded = true;
    } else {
      print('No image selected');
    }
    notifyListeners();
  }

  Future scanText(context) async {
    final InputImage visionImage = InputImage.fromFile(File(_image.path));
    final textDetector = GoogleMlKit.vision.textDetector();
    final RecognisedText recognisedText =
        await textDetector.processImage(visionImage);

    items = [];
    prices = [];
    scanSuccess = true;
    scanDone = false;

    while (scanSuccess && !scanDone) {
      for (int i = 0; i < recognisedText.blocks.length; i++) {
        print("BLOCK" + i.toString() + recognisedText.blocks[i].text);
        for (int j = 0; j < recognisedText.blocks[i].lines.length; j++) {
          print("Line" + j.toString() + recognisedText.blocks[i].lines[j].text);
          if (regExPrice.hasMatch(recognisedText.blocks[i].lines[j].text)) {
            Iterable matches =
                regExPrice.allMatches(recognisedText.blocks[i].lines[j].text);
            matches.forEach(
              (match) {
                price = recognisedText.blocks[i].lines[j].text
                    .substring(match.start, match.end);
                if (price.contains(",")) {
                  price = price.replaceAll(",", ".");
                }
                try {
                  double formattedPrice =
                      double.parse(price.substring(0, price.length - 1));
                  prices.add(formattedPrice);
                } catch (e) {
                  scanSuccess = false; //all prices of purchase
                }
              },
            );
            try {
              if (recognisedText.blocks[i].lines[0].text == "EUR") {
                items.add(recognisedText.blocks[i - 1].lines[j - 1].text);
              } else {
                items.add(recognisedText.blocks[i - 1].lines[j].text);
              }
            } catch (e) {
              scanSuccess = false;
            }
            //all items of purchase
          } else if (regExSum
              .hasMatch(recognisedText.blocks[i].lines[j].text)) {
            try {
              //search for sum in textblocks with regular expression, when found - sum is assigned to value at same index in next block (because text and prices are seen as two blocks)
              sum = double.parse(recognisedText.blocks[i + 1].lines[j].text
                  .replaceAll(",", ".")); //sum of whole purchase
            } catch (e) {
              for (int j = 0; j < prices.length; j++) {
                sum += prices[j];
              }
              scanSuccess = false;
            }
          } else if (regExDate
              .hasMatch(recognisedText.blocks[i].lines[j].text)) {
            Iterable matches =
                regExDate.allMatches(recognisedText.blocks[i].lines[j].text);
            matches.forEach((match) {
              date = recognisedText.blocks[i].lines[j].text
                  .substring(match.start, match.end);
            });

            formattedDate = formatDate(date);
            //date on the receipt
          }
          List supermarkets = SupermarketData.supermarkets;

          for (int k = 0; k < supermarkets.length; k++) {
            final bestMatch =
                recognisedText.blocks[i].lines[j].text.bestMatch(supermarkets);
            if (recognisedText.blocks[i].lines[j].text
                .toUpperCase()
                .contains(supermarkets[k].toUpperCase())) {
              supermarket = supermarkets[k];
            } else {
              if (bestMatch.bestMatch.rating > 0.4) {
                supermarket = bestMatch.bestMatch.target;
              }
            }
          }
          if (supermarket == null) {
            scanSuccess = false;
          }
        }
        scanDone = true;
      }

      if (scanSuccess) {
        if (items.length == prices.length) {
          for (int i = 0; i < items.length; i++) {
            Provider.of<ItemData>(context, listen: false)
                .addItem(items[i], prices[i]);
          }
        } else {
          scanSuccess = false;
        }
        if (formattedDate == null) {
          formattedDate = DateTime.now();
        }
        Provider.of<ReceiptData>(context, listen: false).addReceipt(
            0,
            formattedDate,
            supermarket,
            Provider.of<ItemData>(context, listen: false).items,
            Provider.of<ItemData>(context, listen: false).getSum());
        print("SUMME in textregocnition");
        print(Provider.of<ItemData>(context, listen: false).getSum());
      }
    }
    notifyListeners();
  }
}
