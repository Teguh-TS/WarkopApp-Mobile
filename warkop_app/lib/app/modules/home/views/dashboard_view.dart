import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'admin_list_view.dart';
import 'userlist_view.dart';

class DashboardView extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<int> getTotalUsers() async {
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'user')
        .get();
    return snapshot.docs.length;
  }

  Future<int> getTotalAdmins() async {
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'admin')
        .get();
    return snapshot.docs.length;
  }

  Future<void> addUser(String email, String password, String username) async {
    // Add to Firebase Auth
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    // Add to Firestore
    await _firestore.collection('users').doc(userCredential.user?.uid).set({
      'username': username,
      'email': email,
      'role': 'user',
    });
  }

  Future<void> addAdmin(String email, String password, String username) async {
    // Add to Firebase Auth
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    // Add to Firestore
    await _firestore.collection('users').doc(userCredential.user?.uid).set({
      'username': username,
      'email': email,
      'role': 'admin',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            FutureBuilder<int>(
              future: getTotalUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                final totalUsers = snapshot.data ?? 0;
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.people, color: Colors.blue),
                    title: Text('Total Users'),
                    trailing: Text(totalUsers.toString()),
                    onTap: () {
                      Get.to(UserListView());
                    },
                  ),
                );
              },
            ),
            FutureBuilder<int>(
              future: getTotalAdmins(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                final totalAdmins = snapshot.data ?? 0;
                return Card(
                  child: ListTile(
                    leading:
                        Icon(Icons.admin_panel_settings, color: Colors.green),
                    title: Text('Total Admins'),
                    trailing: Text(totalAdmins.toString()),
                    onTap: () {
                      Get.to(AdminListView());
                    },
                  ),
                );
              },
            ),
            FutureBuilder<int>(
              future: Future.wait([getTotalUsers(), getTotalAdmins()])
                  .then((values) {
                return values[0] + values[1];
              }),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                final totalAccounts = snapshot.data ?? 0;
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.account_circle, color: Colors.orange),
                    title: Text('Total Accounts'),
                    trailing: Text(totalAccounts.toString()),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
