import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:virtual_council/Client/ClCompleteProfile.dart';
import 'package:virtual_council/Client/ClDashDesign.dart';

class ClFutureSignIn extends StatefulWidget {
  const ClFutureSignIn({Key? key}) : super(key: key);

  @override
  State<ClFutureSignIn> createState() => _ClFutureSignInState();
}

User? authUser = FirebaseAuth.instance.currentUser;
final userID = authUser?.uid;

CollectionReference users = FirebaseFirestore.instance.collection('Clients');

class _ClFutureSignInState extends State<ClFutureSignIn> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(userID).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic> data =
              snapshot.data?.data() as Map<String, dynamic>;
          if (data.containsKey('name')) {
            return ClPages();
          } else
            return ClCompleteProfile();
        }
        return Container(
          color: Colors.white,
          child: Center(
            child: SpinKitRipple(
              color: Colors.blue,
              size: 70,
            ),
          ),
        );
      },
    );
  }
}
