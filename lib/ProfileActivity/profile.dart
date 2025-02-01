import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project/ProfileActivity/updateProfile.dart';

import '../LoginActivity/auth.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final User? user = Auth().currentUser;
  final databaseRef = FirebaseDatabase.instance.ref("users");

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Stream<DatabaseEvent> getUserDataStream() {
    return databaseRef.child(user!.uid).onValue;
  }

  // Future<Map<dynamic, dynamic>> fetchData() async {
  //   try {
  //     final snapshot = await databaseRef.child(user!.uid).get();
  //     print("UID pengguna: ${user!.uid}");
  //
  //     if (snapshot.exists) {
  //       return snapshot.value as Map<dynamic, dynamic>;
  //     } else {
  //       return {};
  //     }
  //   } catch (e) {
  //     throw Exception("Gagal mengambil data: $e");
  //   }
  // }

  // Widget _title() {
  //   return const Text("Firebase Auth");
  // }
  void update() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return const UpdateProfile();
          }
        )
    );
  }

  Widget _userUid() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            width: 0.5,
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(10)
      ),
      child: ListTile(
        title: const Text(
          "Email",
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          user?.email ?? 'User email',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
    );
    // return Text(user?.email ?? 'User email');
  }

  Widget _signOutButton() {
    return SizedBox(
      width: double.infinity,

      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          )
        ),
        onPressed: signOut,
        child: const Text(
          "Sign Out",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

  Widget _buttonUpdate() {
    return SizedBox(
      width: double.infinity,

      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            )
        ),
          onPressed: update,
          child: const Text(
            "Update Profile",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
            ),
          )
      ),
    );
  }

  Widget buildCard(String judul, String isi){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.5,
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(10)
      ),
      
      child: ListTile(
        title: Text(
          judul,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          isi,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DatabaseEvent>(
        stream: getUserDataStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final userData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            String nama =  userData['name'] ?? "Nama tidak tersedia";
            String number = userData['number'] ?? "Nomor tidak tersedia";
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 210,
                        color: const Color(0xFFDAC0A3),
                      ),
                      const Positioned(
                        bottom: 40,
                        left: 140,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                              "https://img.freepik.com/free-vector/smiling-young-man-illustration_1308-174401.jpg?semt=ais_hybrid"),
                        ),
                        // child: ClipRRect(
                        //   borderRadius: BorderRadius.circular(300.0),
                        //   child: const Image(
                        //     image: NetworkImage("https://img.freepik.com/free-vector/smiling-young-man-illustration_1308-174401.jpg?semt=ais_hybrid"),
                        //     width: 85,
                        //     height: 85,
                        //
                        //   ),
                        // ),
                      ),
                    ]
                ),
                Container(
                  padding: const EdgeInsets.all(23),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildCard("Nama", nama),
                      SizedBox(height: 10,),
                      _userUid(),
                      SizedBox(height: 10,),
                      buildCard("Nomor HP", number),
                      SizedBox(height: 10,),
                      _buttonUpdate(),
                      _signOutButton()
                    ],
                  ),
                )
              ],
            );
          }
        }),
    );
  }
}
