// ignore_for_file: unused_import

import 'dart:typed_data';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:intl/intl.dart';
import 'package:project/reusable_widgets/reusable_widget.dart';
import 'package:project/screens/home_screen.dart';
import 'package:project/screens/receiptlist_screen.dart';
import 'package:project/utils/color_utils.dart';
import 'package:provider/provider.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:http/http.dart' as http;

import '../User/button_provider.dart';
import '../User/user_provider.dart';

List<CameraDescription>? cameras;

class AddReceiptScreen extends StatefulWidget {
  static const routeName = "/uploadIklan";
  const AddReceiptScreen({super.key});

  @override
  State<AddReceiptScreen> createState() => _AddReceiptScreenState();
}

class _AddReceiptScreenState extends State<AddReceiptScreen> {
  final TextEditingController _receiptnameTextController = TextEditingController();
  final TextEditingController _amountTextController = TextEditingController();
  final TextEditingController _dateTextController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    _receiptnameTextController.dispose();
    _amountTextController.dispose();
    _dateTextController.dispose();
    _cameraController!.dispose();
    super.dispose();
  }

  //picture
  CameraController? _cameraController;
  //gambar
  String defaultImageUrl = 'https://cdn.pixabay.com/photo/2016/03/23/15/00/ice-cream-1274894_1280.jpg';
  String selctFile = '';
  late XFile file;
  late Uint8List selectedImageInBytes;
  List<Uint8List> pickedImagesInBytes = [];
  // List<String> imageUrls = [];
  int imageCounts = 0;

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(cameras![0], ResolutionPreset.medium);
    _cameraController!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  //This modal shows image selection either from gallery or camera
  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      //backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.15,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Wrap(
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                    leading: const Icon(
                      Icons.photo_library,
                    ),
                    title: const Text(
                      'Gallery',
                      style: TextStyle(),
                    ),
                    onTap: () {
                      _selectFile(true);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(
                    Icons.photo_camera,
                  ),
                  title: const Text(
                    'Camera',
                    style: TextStyle(),
                  ),
                  onTap: () {
                    _selectFile(false);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

//gambar
  _selectFile(bool imageFrom) async {
    FilePickerResult? fileResult = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (fileResult != null) {
      selctFile = fileResult.files.first.name;
      for (var element in fileResult.files) {
        final Uint8List bytes = element.bytes!;
        setState(() {
          pickedImagesInBytes.add(bytes);
          imageCounts += 1;
        });
      }
    }
    print(selctFile);
  }

//upload punya
  Future<void> _uploadFile() async {
    try {
      final Uint8List imageBytes = pickedImagesInBytes.first;
      final String imageName = '${_receiptnameTextController.text}_${_dateTextController.text}.jpg';

      final firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref().child('product/$imageName');

      final firebase_storage.UploadTask uploadTask = ref.putData(imageBytes);

      final firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;

      final String imageUrl = await taskSnapshot.ref.getDownloadURL();

      setState(() {
        defaultImageUrl = imageUrl;
      });
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    //tolong onn utk multiple collection
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    String? userId = userProvider.userId;
    //retrieve button id
    final buttonIdProvider = Provider.of<ButtonIdProvider>(context);
    final buttonId = buttonIdProvider.buttonId1;
    final buttonId2 = buttonIdProvider.buttonId2;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ReceiptListScreen()));
            },
          ),
        ],
        title: const Text(
          "Add Receipt",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [hexStringColor("4b0082"), hexStringColor("800080"), hexStringColor("4b0082")],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.width * 0.2, 20, 0),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Enter receipt name", Icons.person_outline, false, _receiptnameTextController, null),
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Enter amount", Icons.work, false, _amountTextController, null),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        selectedDate = value;
                        _dateTextController.text = DateFormat.yMMMd().format(selectedDate);
                      });
                    }
                  });
                },
                child: AbsorbPointer(
                  child: reusableTextField("Enter date", Icons.calendar_today, false, _dateTextController, null),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width * 1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: selctFile.isEmpty
                    ? Image.network(
                        defaultImageUrl,
                        fit: BoxFit.cover,
                      )
                    : Image.memory(
                        pickedImagesInBytes.first,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                child: ElevatedButton.icon(
                  onPressed: () {
                    //_showPicker(context);
                    _selectFile(true);
                  },
                  icon: const Icon(
                    Icons.camera,
                  ),
                  label: const Text(
                    'Pick Image',
                    style: TextStyle(),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //betulkan firebase masuk data and tuka button
              ElevatedButton(
                onPressed: () async {
                  await _uploadFile();

                  Map<String, dynamic> data = {
                    "Receipt name": _receiptnameTextController.text,
                    "Date": _dateTextController.text,
                    "Amount": _amountTextController.text,
                    "itemImageUrl": defaultImageUrl,
                  };
                  //utk save many collection
                  FirebaseFirestore.instance
                      .collection("Receipt") // Collection 1
                      .doc(userId) // Document 1
                      .collection(buttonId!) // Collection 2 with buttonKey
                      .doc(userId) // Document 2
                      .collection(buttonId2!) // Collection 3
                      .add(data);
                  //.then((value));
                  //FirebaseFirestore.instance.collection("Receipt").add(data);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ReceiptListScreen()));
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // <-- Radius
                  ),
                ),
                child: const Text('Add Receipt'),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
