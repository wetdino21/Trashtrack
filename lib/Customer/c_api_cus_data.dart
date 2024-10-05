import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trashtrack/api_network.dart';
import 'package:trashtrack/api_token.dart';
import 'package:flutter/material.dart';

import 'package:trashtrack/styles.dart';

import 'package:provider/provider.dart'; 
import 'package:trashtrack/data_model.dart';

//final String baseUrl = 'http://localhost:3000';

//final String baseUrl = 'http://192.168.254.187:3000';
String baseUrl = globalUrl();

Future<Map<String, dynamic>?> fetchCusData(BuildContext context) async {
  Map<String, String?> tokens = await getTokens();
  String? accessToken = tokens['access_token'];

  if (accessToken == null) {
    print('No access token available. User needs to log in.');
    await deleteTokens(context);
    return null;
  }

  final response = await http.post(
    Uri.parse('$baseUrl/customer/fetch_data'),
    headers: {
      'Authorization': 'Bearer $accessToken',
    },
  );
  if (response.statusCode == 200) {
    // final data = jsonDecode(response.body);
    
    // // Access the provider and update the user data
    // Provider.of<UserData>(context, listen: false).setUserData(
    //   data['cus_fname'],
    //   data['cus_lname'],
    //   data['cus_email'],
    // );

    return jsonDecode(response.body);
  } else {
    showErrorSnackBar(context, 'User not found!');
    if (response.statusCode == 401) {
      // Access token might be expired, attempt to refresh it
      print('Access token expired. Attempting to refresh...');
      String? refreshMsg = await refreshAccessToken(context);
      if (refreshMsg == null) {
        return await fetchCusData(context);
      } else {
        // Refresh token is invalid or expired, logout the user
        await deleteTokens(context); // Logout user
        return null;
      }
    } else if (response.statusCode == 403) {
      // Access token is invalid. logout
      print('Access token invalid. Attempting to logout...');
      await deleteTokens(context); // Logout use
    } else {
      print('Response: ${response.body}');
    }

    showErrorSnackBar(context, response.body);
    return null;
  }
}

//fetch profile pic
Future<String?> fetchProfile(BuildContext context) async {
  Map<String, String?> tokens = await getTokens();
  String? accessToken = tokens['access_token'];

  if (accessToken == null) {
    print('No access token available. User needs to log in.');
    await deleteTokens(context);
    return null;
  }

  final response = await http.post(
    Uri.parse('$baseUrl/customer/fetch_profile'),
    headers: {
      'Authorization': 'Bearer $accessToken',
    },
  );
  if (response.statusCode == 200) {
    // Extract the profile image from the JSON response
    final responseData = jsonDecode(response.body);
    return responseData['profileImage']; // Returns the base64 image string
  } else {
    if (response.statusCode == 401) {
      // Access token might be expired, attempt to refresh it
      print('Access token expired. Attempting to refresh...');
      String? refreshMsg = await refreshAccessToken(context);
      if (refreshMsg == null) {
        return await fetchProfile(context);
      } else {
        // Refresh token is invalid or expired, logout the user
        await deleteTokens(context); // Logout user
        return null;
      }
    } else if (response.statusCode == 403) {
      // Access token is invalid. logout
      print('Access token invalid. Attempting to logout...');
      await deleteTokens(context); // Logout use
    } else {
      print('Response: ${response.body}');
    }

    showErrorSnackBar(context, response.body);
    return null;
  }
}

//notification
Future<List<Map<String, dynamic>>?> fetchCusNotifications(
    BuildContext context) async {
  Map<String, String?> tokens = await getTokens();
  String? accessToken = tokens['access_token'];

  if (accessToken == null) {
    print('No access token available. User needs to log in.');
    await deleteTokens(context);
    return null;
  }

  final response = await http.post(
    Uri.parse('$baseUrl/customer/fetch_notifications'),
    headers: {
      'Authorization': 'Bearer $accessToken',
    },
  );

  if (response.statusCode == 200) {
    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  } else {
    if (response.statusCode == 401) {
      // Access token might be expired, attempt to refresh it
      print('Access token expired. Attempting to refresh...');
      String? refreshMsg = await refreshAccessToken(context);
      if (refreshMsg == null) {
        return await fetchCusNotifications(context);
      } else {
        // Refresh token is invalid or expired, logout the user
        await deleteTokens(context); // Logout user
        return null;
      }
    } else if (response.statusCode == 403) {
      // Access token is invalid. logout
      print('Access token invalid. Attempting to logout...');
      await deleteTokens(context); // Logout user
    } else if (response.statusCode == 404) {
      print('No notification found');
      return null;
    }

    //showErrorSnackBar(context, response.body);
    print('Response: ${response.body}');
    return null;
  }
}


// Future<Map<String, dynamic>?> fetchCusNotification() async {
//   final response = await http.post(
//     Uri.parse('$baseUrl/customer/notification'),
//     headers: {'Content-Type': 'application/json'},
//   );

//   if (response.statusCode == 200) {
//     return jsonDecode(response.body);
//   } else {
//     print('Failed to fetch user data: ${response.body}');
//     return null;
//   }
// }