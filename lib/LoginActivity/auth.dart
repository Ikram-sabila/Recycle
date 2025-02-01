import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();


  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanged => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _firebaseFirestore.collection('user').doc(userCredential.user!.uid).set({
      'uid': userCredential.user!.uid,
      'email': email,
    });
    return;
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _databaseRef.child('users').child(userCredential.user!.uid).set({
      'email' : email
    });
    await _firebaseFirestore.collection('user').doc(userCredential.user!.uid).set({
      'uid': userCredential.user!.uid,
      'email': email,
    });
    return;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}