import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:virtual_council/utils/Video_Call.dart/lawyerCallScreen.dart';
import 'utils/Video_Call.dart/Signaling.dart';

class roomNoti extends StatefulWidget {
  const roomNoti({Key? key}) : super(key: key);

  @override
  State<roomNoti> createState() => _roomNotiState();
}

class _roomNotiState extends State<roomNoti> {
  var getroomID = FirebaseFirestore.instance.collection('IDroom');
  User? admin = FirebaseAuth.instance.currentUser;
  Signaling signaling = Signaling();
  String? roomIDToJoin;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: getroomID.where('lawyerUID', isEqualTo: admin!.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              body: ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot docsSnap) {
                  // Map<String, dynamic> room =
                  //     snapshot.data! as Map<String, dynamic>;
                  Map<String, dynamic> data = docsSnap.data()! as Map<String,
                      dynamic>; // Map<String, dynamic> data = docsSnap.data()! as Map<String, dynamic>;
                  roomIDToJoin = data['roomId'];

                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: Card(
                      elevation: 2,
                      color: Colors.grey[200],
                      shadowColor: Colors.black12,
                      shape: RoundedRectangleBorder(
                          side: new BorderSide(color: Colors.black, width: 0.5),
                          borderRadius: BorderRadius.circular(20)),
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            Icon(
                              Icons.info_outline,
                              color: Colors.amber,
                              size: 25,
                            ),
                            Text(
                              data['clientUID'] +
                                  " is requesting a virtual meeting with you",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        primary: Colors.blue),
                                    child: Padding(
                                      child: Text(
                                        "Join meeting",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      padding: EdgeInsets.all(14),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => lawCall(
                                                  roomId: data["roomId"])));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text('Loading'),
                                        duration: Duration(seconds: 3),
                                      ));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }
          return Center();
        });
  }
}
