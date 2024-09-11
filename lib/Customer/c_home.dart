import 'package:flutter/material.dart';
import 'package:trashtrack/Customer/c_appbar.dart';
import 'package:trashtrack/Customer/c_bottom_nav_bar.dart';
import 'package:trashtrack/Customer/c_waste_info.dart';
import 'package:trashtrack/Customer/c_waste_request_pickup.dart';
import 'package:trashtrack/api_postgre_service.dart';
import 'package:trashtrack/api_token.dart';
import 'package:trashtrack/styles.dart';

import 'dart:convert';
import 'dart:typed_data';

import 'package:jwt_decoder/jwt_decoder.dart';

class C_HomeScreen extends StatefulWidget {
  // final String email;

  // C_HomeScreen({required this.email});

  @override
  State<C_HomeScreen> createState() => _C_HomeScreenState();
}

class _C_HomeScreenState extends State<C_HomeScreen> {
  //user data
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? errorMessage;
  Uint8List? imageBytes; // To store the image bytes

  //final email = 'mikenaill45@gmail.com';
  //final email = 'mikenaill22@gmail.com';
  String email = '';

  void getEmail() async {
     final useremail = await getEmailToken();
    if (useremail != null) {
      setState(() {
        email = useremail;
      });
      _dbData();
    } else {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to retrieve email';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getEmail();
    //_fetchData();
    
  }

// Fetch user data from the server
  Future<void> _dbData() async {
    try {
      final data = await fetchUserData(email);
      setState(() {
        userData = data;
        isLoading = false;

        // Decode base64 image only if it exists
        if (userData?['profileImage'] != null) {
          imageBytes = base64Decode(userData!['profileImage']);
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

//////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentColor,
      appBar: C_CustomAppBar(
        title: 'Home',
        userData: userData,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userData != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('First Name: ${userData!['cus_fname']}'),
                      Text('Last Name: ${userData!['cus_lname']}'),

                      // Display the image if the bytes are available
                      if (imageBytes != null)
                        Image.memory(imageBytes!, height: 100, width: 100)
                      else
                        Text('No profile image available'),

                      // You can add more widgets to display other data
                    ],
                  ),
                )
              : Center(child: Text('Error: $errorMessage')),

      // SingleChildScrollView(
      //   padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       // Welcome Container
      //       Container(
      //         padding: EdgeInsets.all(16.0),
      //         decoration: BoxDecoration(
      //           color: boxColor,
      //           borderRadius: BorderRadius.circular(20.0),
      //         ),
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Text(
      //               'Welcome Taehyung!',
      //               style: TextStyle(
      //                 color: Colors.white,
      //                 fontSize: 24.0,
      //                 fontWeight: FontWeight.bold,
      //               ),
      //             ),
      //             SizedBox(height: 10.0),
      //             Text(
      //               'Ready to keep things tidy? Schedule your garbage pickup today!',
      //               style: TextStyle(
      //                 color: Colors.white70,
      //                 fontSize: 14.0,
      //               ),
      //             ),
      //             SizedBox(height: 20.0),
      //             Center(
      //               child: ElevatedButton(
      //                 onPressed: () {
      //                   Navigator.push(
      //                     context,
      //                     MaterialPageRoute(
      //                       builder: (context) => RequestPickupScreen(),
      //                     ),
      //                   );
      //                 },
      //                 style: ElevatedButton.styleFrom(
      //                   backgroundColor: buttonColor,
      //                   shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.circular(30.0),
      //                   ),
      //                   padding: EdgeInsets.symmetric(
      //                       vertical: 16.0, horizontal: 30.0),
      //                 ),
      //                 child: Text(
      //                   'Request Pickup Now',
      //                   style: TextStyle(
      //                     color: Colors.white,
      //                     fontSize: 18.0,
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),

      //       ////
      //       SizedBox(height: 20.0),
      //       Text(
      //         '  Waste Collection Info',
      //         style: TextStyle(
      //           color: Colors.grey,
      //           fontSize: 18.0,
      //         ),
      //       ),
      //       SizedBox(height: 5.0),

      //       GestureDetector(
      //           onTap: () {
      //             Navigator.push(context,
      //                 MaterialPageRoute(builder: (context) => C_WasteInfo()));
      //           },
      //           child: Container(
      //             decoration: BoxDecoration(
      //               color: boxColor,
      //               borderRadius: BorderRadius.circular(10),
      //             ),
      //             child: ListTile(
      //               contentPadding: EdgeInsets.all(10),
      //               leading: Image.asset(
      //                 'assets/truck.png',
      //                 height: 100,
      //                 width: 100,
      //               ),
      //               title: Text(
      //                 'Type of waste',
      //                 style: TextStyle(
      //                   color: Colors.white,
      //                   fontSize: 18.0,
      //                 ),
      //               ),
      //             ),
      //           )),

      //       /////
      //       SizedBox(height: 20.0),
      //       Text(
      //         '  Previous waste pickup',
      //         style: TextStyle(
      //           color: Colors.grey,
      //           fontSize: 18.0,
      //         ),
      //       ),
      //       SizedBox(height: 5.0),

      //       // Statistic Boxes
      //       GridView.count(
      //         crossAxisCount: 2,
      //         shrinkWrap: true,
      //         physics: NeverScrollableScrollPhysics(),
      //         crossAxisSpacing: 10.0,
      //         mainAxisSpacing: 10.0,
      //         children: [
      //           StatisticBox(
      //             icon: Icons.schedule,
      //             title: 'Total Requests',
      //             value: '150',
      //             iconColor: accentColor,
      //           ),
      //           StatisticBox(
      //             icon: Icons.delete_outline,
      //             title: 'Total Tons Collected',
      //             value: '75',
      //             iconColor: accentColor,
      //           ),
      //         ],
      //       ),

      //       SizedBox(height: 20.0),
      //     ],
      //   ),
      // ),
      bottomNavigationBar: C_BottomNavBar(
        currentIndex: 0,
      ),
    );
  }
}

class StatisticBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color iconColor;

  StatisticBox({
    required this.icon,
    required this.title,
    required this.value,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(15.0),
      ),
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 30.0,
          ),
          SizedBox(height: 10.0),
          Center(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14.0,
              ),
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
