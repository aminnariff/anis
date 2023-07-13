import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:project/screens/profile_screen.dart';
import 'package:project/screens/receiptlist_screen.dart';
import 'package:project/screens/service_screen.dart';
import 'package:provider/provider.dart';

import '../User/button_provider.dart';
import 'home_screen.dart';

class PersonalScreen extends StatefulWidget {
  const PersonalScreen({Key? key}) : super(key: key);

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  @override
  Widget build(BuildContext context) {
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
            }else if(index == 1){
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ServiceScreen()));
            }else if(index == 2){
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ProfileScreen()));
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
            
          ]
          ),
      ),
    ),
      appBar: AppBar(
        title: Text(
          'Service List',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0.0,
      ),
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          SizedBox(height: 16.0), // Add the desired gap height here
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.extent(
                maxCrossAxisExtent: 300.0,
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 20.0,
                children: [
                  _buildServiceButton(
                    'Education',
                    Icons.school,
                    Colors.purple,
                    ReceiptListScreen(),
                    'Education'
                  ),
                  _buildServiceButton(
                    'Husband/Wife Alimony',
                    Icons.wc,
                    Colors.orange,
                    ReceiptListScreen(),
                    'Alimony'
                  ),
                  _buildServiceButton(
                    'Disable Husband/Wife',
                    Icons.wheelchair_pickup_sharp,
                    Colors.blue,
                    ReceiptListScreen(),
                    'Disable HW'
                  ),
                  _buildServiceButton(
                    'Disable Individual',
                    Icons.personal_injury_outlined,
                    Colors.green,
                    ReceiptListScreen(),
                    'Disable Ind.'
                  ),
                  _buildServiceButton(
                    'Ind. Dependent Relative',
                    Icons.group,
                    Colors.red,
                    ReceiptListScreen(),
                    'Ind. Dependent',
                  ),
                  // Add more service buttons here
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceButton(
    String title,
    IconData icon,
    Color color,
    Widget screen,
    String name,
  ) {
    final buttonIdProvider = Provider.of<ButtonIdProvider>(context);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          buttonIdProvider.buttonId2 = name;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48.0,
                color: Colors.white,
              ),
              SizedBox(height: 8.0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
