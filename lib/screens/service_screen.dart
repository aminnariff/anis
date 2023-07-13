import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:project/screens/equipment_screen.dart';
import 'package:project/screens/home_screen.dart';
import 'package:project/screens/lifestyle_screen.dart';
import 'package:project/screens/medical_screen.dart';
import 'package:project/screens/personal_screen.dart';
import 'package:project/screens/profile_screen.dart';
import 'package:provider/provider.dart';

import '../User/button_provider.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({Key? key}) : super(key: key);

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
      color: Colors.deepPurple,
      child: Padding(
        padding: const EdgeInsets.all(10),
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
                  context, MaterialPageRoute(builder: (context) => ProfileScreen()));
            }
          },
          tabs: const [ 
            GButton(
              icon: Icons.home,
              text: 'Home',
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
                    'Personal Deduction',
                    Icons.person,
                    Colors.purple,
                    PersonalScreen(),
                    'Personal'
                  ),
                  _buildServiceButton(
                    'Lifestyle',
                    Icons.shopping_cart,
                    Colors.orange,
                    LifestyleScreen(),
                    'Lifestyle'
                  ),
                  _buildServiceButton(
                    'Medical',
                    Icons.local_hospital,
                    Colors.blue,
                    MedicalScreen(),
                    'Medical'
                  ),
                  _buildServiceButton(
                    'Equipment',
                    Icons.handyman_outlined,
                    Colors.green,
                    EquipmentScreen(),
                    'Equipment'
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
          buttonIdProvider.buttonId1 = name;
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
