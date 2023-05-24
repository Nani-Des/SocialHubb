import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:virtual_council/utils/Video_Call.dart/Signaling.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class Call extends StatefulWidget {
  final String lawyerDocId;

  Call({required this.lawyerDocId});

  @override
  _CallState createState() => _CallState();
}

class _CallState extends State<Call> {
  User? user = FirebaseAuth.instance.currentUser;
  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;
  String? lawyerDocID;
  TextEditingController textEditingController = TextEditingController(text: '');

  var notificationData =
      FirebaseFirestore.instance.collection("Notification").get();

  @override
  void initState() {
    _localRenderer.initialize();
    _remoteRenderer.initialize();

    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });
    getUser();

    super.initState();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  Future _meetingDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Icon(
              Icons.done_outline,
              color: Colors.green,
              size: 40,
            ),
            content: Text(
              "Meeting ID has been sent to the Lawyer",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              Center(
                child: new ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('Ok'),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Video Conference",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF8C1F85),
      ),
      body: Column(
        children: [
          SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.blue),
              // onPressed: () {
              //   signaling.openUserMedia(_localRenderer, _remoteRenderer);
              //   setState(() {});
              //   signaling.openUserMedia(_localRenderer, _remoteRenderer);
              //   setState(() {});
              //   setState(() {});
              // },

              onPressed: () async {
                Map<Permission, PermissionStatus> statuses = await [
                  Permission.camera,
                  Permission.microphone,
                ].request();

                if (statuses[Permission.camera]!.isGranted) {
                  setState(() {
                    signaling.openUserMedia(_localRenderer, _remoteRenderer);
                  });
                  signaling.openUserMedia(_localRenderer, _remoteRenderer);
                  if (statuses[Permission.microphone]!.isGranted) {
                  } else {
                    Fluttertoast.showToast(
                        msg:
                            'Camera needs to access your microphone, please provide permission');
                  }
                } else {
                  Fluttertoast.showToast(
                      msg: 'Provide Camera permission to use camera.');
                }
              },
              child: Text(
                "Open camera & microphone",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(primary: Colors.blue),
            //   onPressed: () async {
            //     roomId = await signaling.createRoom(_remoteRenderer);
            //     textEditingController.text = roomId!;
            //     setState(() {});
            //   },
            //   child: Text(
            //     "Create room",
            //     style: TextStyle(color: Colors.white),
            //   ),
            // ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.blue),
              onPressed: () {
                signaling.hangUp(_localRenderer);
                _localRenderer.dispose();
                _remoteRenderer.dispose();
              },
              child: Text(
                "Hangup",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ]),
          SizedBox(
            width: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Join Room disabled for client making call
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(primary: Colors.blue),
              //   onPressed: () {
              //     // Add roomId
              //     signaling.joinRoom(
              //       textEditingController.text,
              //       _remoteRenderer,
              //     );
              //   },
              //   child: Text(
              //     "Join room",
              //     style: TextStyle(color: Colors.white),
              //   ),
              // ),
              SizedBox(
                width: 8,
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.blue),
                onPressed: () async {
                  roomId = await signaling.createRoom(_remoteRenderer);
                  textEditingController.text = roomId!;
                  lawyerDocID = widget.lawyerDocId;
                  sendRoomID(roomId!, lawyerDocID!);
                  _meetingDialog(context);
                },
                child: Text(
                  "Request Meeting",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),

          //SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: RTCVideoView(_localRenderer, mirror: true)),
                  Expanded(child: RTCVideoView(_remoteRenderer)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Join the following Room: "),
                Flexible(
                  child: TextFormField(
                    controller: textEditingController,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 8)
        ],
      ),
    );
  }

  String? clientName;
  getUser() {
    final docRef =
        FirebaseFirestore.instance.collection("Clients").doc(user!.uid);
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        clientName = data['name'];
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  void sendRoomID(String roomId, String lawyerDocID) async {
    var idrooms = FirebaseFirestore.instance.collection("IDroom");
    idrooms.doc().set({
      'roomId': roomId,
      'lawyerUID': lawyerDocID,
      'clientUID': user!.uid,
      'clientName': clientName,
    });
  }
}
