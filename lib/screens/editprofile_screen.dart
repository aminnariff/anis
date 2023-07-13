import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/profile_screen.dart';
import 'package:provider/provider.dart';

import '../User/user_provider.dart';
import '../reusable_widgets/reusable_widget.dart';
import '../utils/color_utils.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final password = TextEditingController();
  final email = TextEditingController();
  final username = TextEditingController();
  final work = TextEditingController();
  final salary = TextEditingController();
  bool _dataFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_dataFetched) {
      init();
      _dataFetched = true;
    }
  }

  Future<void> init() async {
    await fetchUserData();
  }

  Future<void> fetchUserData() async {
    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    String? userId = userProvider.userId;
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('User').doc(userId).get();
    
    // Retrieve the data from the snapshot
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
    
    // Update the text fields with the retrieved data
    username.text = userData['Username'];
    work.text = userData['Work'];
    salary.text = userData['Annual Salary'];
    email.text = userData['Email'];
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    String? userId = userProvider.userId;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) =>ProfileScreen()));
            },
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            hexStringColor("016064"),
            hexStringColor("48AAAD"),
            hexStringColor("52B2BF")
          ], begin: Alignment.topCenter,end: Alignment.bottomCenter)
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.width*0.2, 20, 0),
          child: Column(
            children:  <Widget>[
              const SizedBox(
                height: 20,
              ),
              //reusableTextField(text, icon, isPasswordType, controller, param4)
              reusableTextField("Enter Username", Icons.person_outline, false, username, null),
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Enter Job", Icons.work, false, work, null),
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Enter Annual Salary", Icons.money_outlined, false, salary, null),
              const SizedBox(
                height: 20,
              ),
              //reusableTextField("Enter Email ", Icons.person_outline, false, email, null),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async { 
                  // Assuming you have a reference to the user's document in Firestore
                  DocumentReference userDocRef = FirebaseFirestore.instance.collection('User').doc(userId);

                  // Perform the update
                  await userDocRef.update({
                    'Username': username.text,
                    'Annual Salary': salary.text, 
                    'Work': work.text, 
                    'Email': email.text,  // Replace with the updated value
                  });

                  //widget.refreshCallback?.call();
                  // Navigate back to the profile screen
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
                child: const Text('Update'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // <-- Radius
                  ),               
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
