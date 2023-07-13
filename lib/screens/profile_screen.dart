import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:project/screens/editprofile_screen.dart';
import 'package:provider/provider.dart';

import '../User/user_provider.dart';
import 'home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void refreshProfile() {
    setState(() {
      // Fetch the updated user data from Firestore or any other source
      // Update the necessary state variables to reflect the new data
    });
  }

  @override 
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    String? userId = userProvider.userId;

    return Scaffold(
      bottomNavigationBar: Container(
      color: Colors.deepPurple,
      child: Padding(
        padding: const EdgeInsets.all(10),
        //symmetric(horizontal: 15, vertical: 10),
        child: GNav(
          gap: 8,
          backgroundColor: Colors.deepPurple,
          color: Colors.white,
          activeColor: Colors.white,
          tabBackgroundColor: Colors.purple.shade800,
          padding: EdgeInsets.all(16),
          onTabChange: (index){
            if(index == 0){
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomeScreen()));
            }
          },
          tabs: const [ 
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            
            
          ]
          ),
      ),
    ),
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomeScreen()));
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: Container(
        padding: EdgeInsets.all(50.0),
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('User').doc(userId).get(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center( 
                child: CircularProgressIndicator(),
              );
            }
      
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
      
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(
                child: Text('User data not found'),
              );
            }
      
            Map<String, dynamic>? userData = snapshot.data!.data() as Map<String, dynamic>?;
      
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
      
                    SizedBox(height: 20),
                    Text(
                      'Name: ${userData?['Username'] ?? ''}',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Job: ${userData?['Work'] ?? ''}',
                      style: TextStyle(fontSize: 18, color: Colors.grey[800]),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Annual Salary: RM ${userData?['Annual Salary'] ?? ''}',
                      style: TextStyle(fontSize: 18, color: Colors.grey[800]),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Email: ${userData?['Email'] ?? ''}',
                      style: TextStyle(fontSize: 18, color: Colors.grey[800]),
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditProfileScreen()),
                        );
                      },
                      child: Text('Edit Profile'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
                        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
