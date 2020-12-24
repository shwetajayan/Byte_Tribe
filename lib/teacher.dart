import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as http;
import 'package:http/http.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:exam_wand/create_pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart' hide PdfAnnotWidget;
import 'package:pdf/widgets.dart' as pw;
import 'User_model.dart';
import 'contents.dart';
class TeachersScreen extends StatefulWidget {
  @override
  _TeachersScreenState createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen> {


  final TextEditingController nameController = TextEditingController();
  final TextEditingController QidController = TextEditingController();
  final TextEditingController answerController = TextEditingController();
  File _image = null;
  String S;
  String filename;
  var Questions;
  Future getImage(bool isCamera) async {
    File image;
    if (isCamera)
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  Future readText() async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(_image);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);
    S = "";
    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          S += word.text;
          S += " ";
        }
      }
      S += "\n\n";
    }
  }

  var pdf = pw.Document();

  writeOnPdf() {
    pdf.addPage(
      pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(32),

          build: (pw.Context context) {
            return <pw.Widget>[
              pw.Paragraph(
                  text: S, style: pw.TextStyle(fontSize: 16)
              )
            ];
          }
      ),
    );
  }

  Future savePdf() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    File file = File("$documentPath/$filename.pdf");
    file.writeAsBytesSync(pdf.save());
  }


  Future<String> NoofQuestions(BuildContext context){

    TextEditingController customController =  TextEditingController();

    return showDialog(context: context,builder: (context){
      return AlertDialog(
          title: Text("Enter the Question number to correct"),
          content: TextField(controller:customController),
          actions: <Widget>[
            MaterialButton(
                elevation:5.0,
                child: Text("Submit"),
                onPressed:() {
                  Navigator.of(context).pop(customController.text.toString());
                }
            )
          ]
      );
    });
  }



  Future<bool> _onBackPressed() {
    return showDialog(context: context,
      builder: (context) =>
          AlertDialog(
            title: Text("Do you really want to exit the app?"),
            actions: <Widget>[
              FlatButton(
                child: Text("No"),
                onPressed: () => Navigator.pop(context, false),
              ),
              FlatButton(
                child: Text("Yes"),
                onPressed: () => exit(0),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Teacher"),
          backgroundColor: Colors.blueGrey[700],
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
              ),
            ),
          ],
          leading: Icon(Icons.menu),
        ),
        body:
        Container(
          padding:EdgeInsets.all(32),
          child:Column(
          children: <Widget>[
            TextField(
              controller:nameController ,
            ),
            TextField(
              controller:QidController ,
            ),
            TextField(
              controller:answerController ,
            ),

          ],
        ),
        ),



    ),
    );
  }
}
