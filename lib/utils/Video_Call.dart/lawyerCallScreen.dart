import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:virtual_council/utils/Video_Call.dart/Signaling.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class lawCall extends StatefulWidget {
  lawCall({super.key, required this.roomId});
  // String roomId;
  final String roomId;

  @override
  _lawCallState createState() => _lawCallState();
}

class _lawCallState extends State<lawCall> {
  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;
  TextEditingController textEditingController = TextEditingController(text: '');

  var notificationData =
      FirebaseFirestore.instance.collection("Notification").get();

  @override
  void initState() {
    _localRenderer.initialize();
    _remoteRenderer.initialize();
    textEditingController.text = widget.roomId;

    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {
        textEditingController.text = widget.roomId;
        print("The room ID at lawyer end is " + roomId!);
      });
    });

    open_cam_connect();

    super.initState();
  }

  void open_cam_connect() async {
    //
    // Open Camera
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    if (statuses[Permission.camera]!.isGranted) {
      setState(() {
        signaling.openUserMedia(_localRenderer, _remoteRenderer);
      });
      signaling.openUserMedia(_localRenderer, _remoteRenderer);

      // signaling.
      if (statuses[Permission.microphone]!.isGranted) {
      } else {
        Fluttertoast.showToast(
            msg:
                'Camera needs to access your microphone, please provide permission');
      }
    } else {
      Fluttertoast.showToast(msg: 'Provide Camera permission to use camera.');
    }

    signaling.joinRoom(
      widget.roomId,
      _remoteRenderer,
    );
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
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      primary: Colors.blue),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('Ok'),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
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
        title: Center(
          child: Text(
            "Video Conference",
            style: TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF8C1F85),
      ),
      body: Column(
        children: [
          SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              // onPressed: () {
              //   signaling.openUserMedia(_localRenderer, _remoteRenderer);
              //   setState(() {});
              //   signaling.openUserMedia(_localRenderer, _remoteRenderer);
              //   setState(() {});
              //   setState(() {});
              // },
              style: ElevatedButton.styleFrom(primary: Colors.blue),
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

                  // signaling.
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
            // SizedBox(
            //   width: 8,
            // ),
            // ElevatedButton(
            //   onPressed: () async {
            //     roomId = await signaling.createRoom(_remoteRenderer);
            //     textEditingController.text = roomId!;
            //     setState(() {});
            //   },
            //   child: Text("Create room"),
            // ),
          ]),
          SizedBox(
            width: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.blue),
                onPressed: () {
                  // Add roomId
                  textEditingController.text = widget.roomId;
                  signaling.joinRoom(
                    textEditingController.text,
                    _remoteRenderer,
                  );
                },
                child: Text(
                  "Join room",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                width: 8,
              ),
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
              SizedBox(
                width: 8,
              ),
              // ElevatedButton(
              //   onPressed: () async {
              //     Map<Permission, PermissionStatus> statuses = await [
              //       Permission.camera,
              //       Permission.microphone,
              //     ].request();

              //     if (statuses[Permission.camera]!.isGranted) {
              //       setState(() {
              //         signaling.openUserMedia(_localRenderer, _remoteRenderer);
              //       });
              //       signaling.openUserMedia(_localRenderer, _remoteRenderer);
              //       if (statuses[Permission.microphone]!.isGranted) {
              //       } else {
              //         Fluttertoast.showToast(
              //             msg:
              //                 'Camera needs to access your microphone, please provide permission');
              //       }
              //     } else {
              //       Fluttertoast.showToast(
              //           msg: 'Provide Camera permission to use camera.');
              //     }
              //     roomId = await signaling.createRoom(_remoteRenderer);
              //     _meetingDialog(context);
              //   },
              //   child: Text("Request Meeting"),
              // ),
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

  void sendRoomID(String roomId, String docId) async {
    await FirebaseFirestore.instance
        .collection('Notification')
        .where('lawyerUID', isEqualTo: docId)
        .get() // <-- You missed this
        .then((value) => value.docs.map((e) {
              FirebaseFirestore.instance
                  .collection('Notification')
                  .doc(e.id)
                  .update({'roomId': roomId});
            }));
  }
}
