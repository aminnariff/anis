import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project/screens/addreceipt_screen.dart';
import 'package:project/screens/home_screen.dart';
import 'package:project/screens/profile_screen.dart';
import 'package:project/screens/service_screen.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../User/button_provider.dart';
import '../User/user_provider.dart';
import '../reusable_widgets/reusable_widget.dart';
import 'package:http/http.dart' as http;

class ReceiptListScreen extends StatefulWidget {
  const ReceiptListScreen({super.key});

  @override
  State<ReceiptListScreen> createState() => _ReceiptListScreenState();
}

class _ReceiptListScreenState extends State<ReceiptListScreen> {
  final TextEditingController _receiptnameTextController = TextEditingController();
  final TextEditingController _amountTextController = TextEditingController();
  final TextEditingController _dateTextController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  late String imageUrl;

  double totalAmount = 0.0;

  late String receiptname;
  late String amount;
  late String datewaspick;

  get child => null;

  //gambar
  String defaultImageUrl = '';
  String selctFile = '';
  late XFile file;
  late Uint8List selectedImageInBytes;
  List<Uint8List> pickedImagesInBytes = [];
  int imageCounts = 0;

  showModalBox(BuildContext context, String docId) {
    //tolong onn utk multiple collection
    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    String? userId = userProvider.userId;
    //retrieve button id
    final buttonIdProvider = Provider.of<ButtonIdProvider>(context, listen: false);
    final buttonId = buttonIdProvider.buttonId1;
    final buttonId2 = buttonIdProvider.buttonId2;
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        builder: (BuildContext context) => Container(
              height: MediaQuery.of(context).size.height * 10.0,
              width: MediaQuery.of(context).size.width * 0.9,
              color: Colors.deepPurple,
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  reusableTextField(
                      "Enter receipt name", Icons.person_outline, false, _receiptnameTextController, null),
                  const SizedBox(
                    height: 10,
                  ),
                  reusableTextField("Enter amount", Icons.work, false, _amountTextController, null),
                  const SizedBox(
                    height: 10,
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
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.height * 0.8,
                    height: MediaQuery.of(context).size.width * 0.5,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      border: Border.all(width: 8, color: Colors.black12),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection("Receipt")
                          .doc(userId)
                          .collection(buttonId!)
                          .doc(userId)
                          .collection(buttonId2!)
                          .doc(docId) // Replace `documentId` with the actual document ID
                          .get(),
                      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return const Icon(
                            Icons.error,
                            color: Colors.red,
                          );
                        }
                        if (!snapshot.hasData || !snapshot.data!.exists) {
                          return const Text('Image not available');
                        }

                        final data = snapshot.data!.data() as Map<String, dynamic>;
                        final imageUrl = data['itemImageUrl'];

                        return GestureDetector(
                          onTap: () {
                            _showImageDialog(imageUrl);
                          },
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
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
                            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //betulkan firebase masuk data and tuka button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                    crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          Map<String, dynamic> data = {
                            "Receipt name": _receiptnameTextController.text,
                            "Date": _dateTextController.text,
                            "Amount": _amountTextController.text,
                          };

                          FirebaseFirestore.instance
                              .collection("Receipt")
                              .doc(userId)
                              .collection(buttonId)
                              .doc(userId)
                              .collection(buttonId2)
                              .doc(docId)
                              .update(data)
                              .then((value) {
                            _receiptnameTextController.text = '';
                            _amountTextController.text = '';
                            _dateTextController.text = '';
                            Navigator.of(context).pop();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Update'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          FirebaseFirestore.instance.collection("Receipt").doc(docId).delete().then((value) {
                            _receiptnameTextController.text = '';
                            _amountTextController.text = '';
                            _dateTextController.text = '';
                            imageUrl = ''; // Clear the image URL
                            Navigator.of(context).pop();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // <-- Radius
                          ),
                        ),
                        child: const Text('Delete'),
                      )
                    ],
                  ),
                ],
              ),
            ));
  }

  @override
  void dispose() {
    _receiptnameTextController.dispose();
    _amountTextController.dispose();
    _dateTextController.dispose();
    super.dispose();
  }

  double maximumValue = 20000;

  void updateMaximumValue(String buttonId, buttonId2) {
    setState(() {
      if (buttonId == 'Personal') {
        if (buttonId2 == 'Education') {
          maximumValue = 7000;
        } else if (buttonId2 == 'Alimony') {
          maximumValue = 4000;
        } else if (buttonId2 == 'Disable HW') {
          maximumValue = 5000;
        } else if (buttonId2 == 'Disable Ind.') {
          maximumValue = 6000;
        } else if (buttonId2 == 'Ind. Dependent') {
          maximumValue = 2000;
        }
        // Set maximum value for button1
      } else if (buttonId == 'Lifestyle') {
        if (buttonId2 == 'Domestic Travel') {
          maximumValue = 1000;
        } else if (buttonId2 == 'Need') {
          maximumValue = 2500;
        } else if (buttonId2 == 'Additional') {
          maximumValue = 2500;
        } else if (buttonId2 == 'Sport') {
          maximumValue = 500;
        }
      } else if (buttonId == 'Medical') {
        if (buttonId2 == 'Parent') {
          maximumValue = 1000;
        } else if (buttonId2 == 'Dieasesfertelity') {
          maximumValue = 2500;
        } else if (buttonId2 == 'Mental Health') {
          maximumValue = 2500;
        } // Set maximum value for button2
      } else {
        if (buttonId2 == 'Basic Supporting') {
          maximumValue = 1000;
        } else if (buttonId2 == 'Breastfeeding') {
          maximumValue = 2500;
        } // Set default maximum value
      }
    });
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

    updateMaximumValue(buttonId!, buttonId2);

    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.deepPurple,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: GNav(
              gap: 8,
              backgroundColor: Colors.deepPurple,
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.purple.shade800,
              padding: const EdgeInsets.all(16),
              onTabChange: (index) {
                if (index == 0) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                } else if (index == 1) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ServiceScreen()));
                } else if (index == 2) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                }
              },
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.widgets,
                  text: 'Service Type',
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Profile',
                ),
              ]),
        ),
      ),
      appBar: AppBar(
        title: Text('Receipt List: $buttonId2'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10.0), // Add the desired gap height here
          SizedBox(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SizedBox(
                  width: 250,
                  height: 250,
                  child: SfRadialGauge(axes: <RadialAxis>[
                    RadialAxis(
                        minimum: 0,
                        maximum: maximumValue,
                        showLabels: false,
                        showTicks: false,
                        axisLineStyle: const AxisLineStyle(
                          thickness: 0.2,
                          cornerStyle: CornerStyle.bothCurve,
                          color: Color.fromARGB(30, 0, 169, 181),
                          thicknessUnit: GaugeSizeUnit.factor,
                        ),
                        pointers: <GaugePointer>[
                          RangePointer(
                            value: totalAmount,
                            cornerStyle: CornerStyle.bothCurve,
                            width: 0.2,
                            sizeUnit: GaugeSizeUnit.factor,
                          )
                        ],
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                              positionFactor: 0.1,
                              angle: 90,
                              widget: Text(
                                // ignore: prefer_interpolation_to_compose_strings
                                totalAmount.toStringAsFixed(0) + ' / $maximumValue',
                                style: const TextStyle(fontSize: 15),
                              ))
                        ]),
                  ]),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Receipt')
                    .doc(userId) // Document 1
                    .collection(buttonId) // Collection 2 with buttonKey
                    .doc(userId) // Document 2
                    .collection(buttonId2!)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    totalAmount = 0; // Reset the totalAmount variable
                    calculateTotalAmount(); // Calculate total amount when the screen initializes

                    return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: ((context, index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 60,
                              decoration:
                                  BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(15)),
                              child: Row(
                                children: [
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: 100,
                                    child: Text(snapshot.data!.docs[index]['Receipt name']),
                                  ),
                                  SizedBox(
                                      width: 120,
                                      child: Text(
                                        snapshot.data!.docs[index]['Date'],
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        _receiptnameTextController.text = snapshot.data!.docs[index]['Receipt name'];
                                        _amountTextController.text = snapshot.data!.docs[index]['Amount'];
                                        _dateTextController.text = snapshot.data!.docs[index]['Date'];
                                        imageUrl = snapshot.data!.docs[index]['itemImageUrl'];
                                        showModalBox(context, snapshot.data!.docs[index].id);
                                      },
                                      icon: const Icon(Icons.edit)),
                                  IconButton(
                                      onPressed: () {
                                        _receiptnameTextController.text = snapshot.data!.docs[index]['Receipt name'];
                                        _amountTextController.text = snapshot.data!.docs[index]['Amount'];
                                        _dateTextController.text = snapshot.data!.docs[index]['Date'];
                                        imageUrl = snapshot.data!.docs[index]['itemImageUrl'];
                                        showModalBox2(snapshot.data!.docs[index].id);
                                      },
                                      icon: const Icon(Icons.arrow_forward)),
                                ],
                              ),
                            ),
                          )),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
          const SizedBox(
            child: SizedBox(
              height: 55,
              //child: Text('Total Amount: $totalAmount'),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 10.0,
        label: const Text('Add Receipt'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddReceiptScreen()));
        },
      ),
    );
  }

  void calculateTotalAmount() {
    //tolong onn utk multiple collection
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    String? userId = userProvider.userId;
    //retrieve button id
    final buttonIdProvider = Provider.of<ButtonIdProvider>(context);
    final buttonId = buttonIdProvider.buttonId1;
    final buttonId2 = buttonIdProvider.buttonId2;

    FirebaseFirestore.instance
        .collection('Receipt')
        .doc(userId) // Document 1
        .collection(buttonId!) // Collection 2 with buttonKey
        .doc(userId) // Document 2
        .collection(buttonId2!)
        .snapshots()
        .listen((snapshot) {
      double sum = 0.0;

      // Iterate over the documents and sum the 'Amount' values
      for (var doc in snapshot.docs) {
        sum += double.parse(doc['Amount']);
      }

      setState(() {
        totalAmount = sum;
      });
    });
  }

  void showModalBox2(String docId) async {
    //tolong onn utk multiple collection
    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    String? userId = userProvider.userId;
    //retrieve button id
    final buttonIdProvider = Provider.of<ButtonIdProvider>(context, listen: false);
    final buttonId = buttonIdProvider.buttonId1;
    final buttonId2 = buttonIdProvider.buttonId2;
    //final image = imageUrl;

    // ignore: use_build_context_synchronously
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => Container(
        height: MediaQuery.of(context).size.height * 5,
        width: MediaQuery.of(context).size.width * 0.9,
        color: Colors.deepPurple,
        child: Column(
          children: <Widget>[
            const Text("Receipt Detail", style: TextStyle(fontSize: 28, fontFamily: 'Oswald')),
            const SizedBox(height: 10),
            Row(
              children: [
                const SizedBox(width: 10),
                const Text("Receipt Name: ", style: TextStyle(fontSize: 18, fontFamily: 'Oswald')),
                Text(_receiptnameTextController.text, style: const TextStyle(fontSize: 18, fontFamily: 'Oswald')),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const SizedBox(width: 10),
                const Text("Receipt Amount: RM", style: TextStyle(fontSize: 18, fontFamily: 'Oswald')),
                Text(_amountTextController.text, style: const TextStyle(fontSize: 18, fontFamily: 'Oswald')),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const SizedBox(width: 10),
                const Text("Receipt Date: ", style: TextStyle(fontSize: 18, fontFamily: 'Oswald')),
                Text(_dateTextController.text, style: const TextStyle(fontSize: 18, fontFamily: 'Oswald')),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.height * 0.8,
              height: MediaQuery.of(context).size.width * 0.5,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey,
                border: Border.all(width: 8, color: Colors.black12),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection("Receipt")
                    .doc(userId)
                    .collection(buttonId!)
                    .doc(userId)
                    .collection(buttonId2!)
                    .doc(docId) // Replace `documentId` with the actual document ID
                    .get(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return const Icon(
                      Icons.error,
                      color: Colors.red,
                    );
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Text('Image not available');
                  }

                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  final imageUrl = data['itemImageUrl'];

                  return GestureDetector(
                    onTap: () {
                      _showImageDialog(imageUrl);
                    },
                    onLongPress: () {
                      _downloadImage(imageUrl);
                    },
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
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
                      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  void _downloadImage(String imageUrl) async {
    var response = await http.get(Uri.parse(imageUrl));
    final documentDirectory = await getExternalStorageDirectory();

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final fileName = '$receiptname.png';
      File file = File('${documentDirectory!.path}/$fileName');
      await file.writeAsBytes(bytes);
      final snackBar = const SnackBar(content: Text('Image downloaded'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = const SnackBar(content: Text('Failed to download image'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
