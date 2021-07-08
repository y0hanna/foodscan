import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kassenzettel_app/components/main_app_bar.dart';
import 'package:kassenzettel_app/text_recognition.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import '../constants.dart';

class AddReceipt extends StatefulWidget {
  @override
  _AddReceiptState createState() => _AddReceiptState();
}

class _AddReceiptState extends State<AddReceipt> {
  bool showSpinner = false;
  File _image;
  bool imageAdded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        'Foto hinzufügen',
      ),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: _image == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.receipt_long, size: 300.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          await Provider.of<TextRecognition>(context,
                                  listen: false)
                              .getImage(context, "camera");
                          setState(() {
                            if (Provider.of<TextRecognition>(context,
                                        listen: false)
                                    .pickedFile !=
                                null) {
                              _image = File(Provider.of<TextRecognition>(
                                      context,
                                      listen: false)
                                  .pickedFile
                                  .path);
                              imageAdded = true;
                            } else {
                              print('No image selected');
                            }
                          });
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.add_a_photo_outlined),
                            SizedBox(width: 30),
                            Text(
                              'Foto aufnehmen',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: kAccentColor,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                      child: ElevatedButton(
                        onPressed: () =>
                            Provider.of<TextRecognition>(context, listen: false)
                                .getImage(context, "gallery"),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.collections,
                            ),
                            SizedBox(width: 30),
                            Text(
                              'Galerie',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: kAccentColor,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                        ),
                      ),
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: <Widget>[
                      Expanded(child: Image.file(_image, fit: BoxFit.fitWidth)),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            showSpinner = true;
                          });
                          await Provider.of<TextRecognition>(context,
                                  listen: false)
                              .scanText(context);
                          if (Provider.of<TextRecognition>(context,
                                  listen: false)
                              .scanSuccess) {
                            setState(() {
                              showSpinner = false;
                            });
                            Navigator.pushNamed(context, '/showitems');
                          } else {
                            setState(() {
                              showSpinner = false;
                            });
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Das hat nicht geklappt'),
                                content: new Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                        "Leider konnte dein Kassenbon nicht erfasst werden. Versuche es erneut oder füge die Artikel manuell hinzu."),
                                  ],
                                ),
                                actions: <Widget>[
                                  new TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/addreceipt');
                                    },
                                    child: const Text('Schließen'),
                                  ),
                                ],
                              ),
                            );
                            print("ScanAgain");
                          }
                        },
                        child: Text('Scannen'),
                        style: ElevatedButton.styleFrom(
                          primary: kAccentColor,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
