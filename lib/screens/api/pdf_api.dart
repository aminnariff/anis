/*import 'dart:io';
//import 'package:flutter/widgets.dart';
//import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class PdfApi {
  static Future<File> generateReceiptPdf({
    required String receiptName,
    required String receiptAmount,
    required String receiptDate,
    required String imageUrl,
  }) async {
    final pdf = Document();

    pdf.addPage(Page(
      build: (context) => 
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Receipt Detail"),
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(width: 10),
              Text("Receipt Name: "),
              Text(receiptName),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(width: 10),
              Text("Receipt Amount: RM"),
              Text(receiptAmount),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(width: 10),
              Text("Receipt Date:" ),
              Text(receiptDate),
            ],
          ),
          SizedBox(height: 10),
          Container(
            /*width: MediaQuery.of(context).size.height * 0.8,
            height: MediaQuery.of(context).size.width * 0.5,*/
            alignment: Alignment.center,
            decoration: BoxDecoration(
              //color: Colors.grey,
              border: Border.all(width: 8),
              borderRadius: BorderRadius.circular(12.0),
            ),
             child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, Widget child,loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, Object error, StackTrace? stackTrace) {
                return Center(
                  child: Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                );
              },
            ),
        
            /*Image.network(
              ,
              ,
            ),*/
          ),
        ],
      ),
    ));

    return saveDocument(name: 'receipt.pdf', pdf: pdf);
  }

  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }
}*/
