import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import '../utils/Video_Call.dart/call.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {super.key,
      required this.lawyerID,
      required this.userID,
      required this.isLawyer});

  final String lawyerID;
  final String userID;
  final bool isLawyer;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Chat',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFF8C1F85),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              toCall(lawyerDocId: widget.lawyerID);
            },
            icon: Icon(Icons.video_call),
            iconSize: 40,
            color: Colors.blue,
          ),
        ],
      ),
      persistentFooterButtons: [
        TextFormField(
          controller: messageController,
          decoration: InputDecoration(
              suffixIcon: IconButton(
                  onPressed: () {
                    sendMessage(
                        isLawyer: widget.isLawyer,
                        message: messageController.text,
                        lawyerID: widget.lawyerID,
                        userID: widget.userID);
                    messageController.clear();
                  },
                  icon: Icon(
                    Icons.send_outlined,
                    color: Colors.blue,
                  ))),
        )
      ],
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: FirebaseAnimatedList(
              query: FirebaseDatabase.instance.ref(
                  'chats/${widget.lawyerID}${widget.userID}'), // put room id here
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                print('snapshot dat: ${snapshot.value!}');
                final snapData = snapshot.value as Map;
                if (snapData['sender'] ==
                    FirebaseAuth.instance.currentUser!.uid) {
                  return Send(message: snapData['message']);
                }
                return Reply(message: snapData['message']);
              },
            ),
          ),
        ],
      )),
    );
  }

  void toCall({required String lawyerDocId}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Call(lawyerDocId: lawyerDocId)));
  }
}

void sendMessage(
    {required String message,
    required String lawyerID,
    required bool isLawyer,
    required String userID}) {
  FirebaseDatabase.instance.ref('chats/${lawyerID}${userID}').push().set({
    'message': message,
    'sender': FirebaseAuth.instance.currentUser!.uid,
    'receiver': isLawyer ? userID : lawyerID,
    'time': DateTime.now().millisecondsSinceEpoch,
  });
}

class Send extends StatelessWidget {
  const Send({Key? key, required this.message}) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topRight,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        margin: const EdgeInsets.only(left: 100, right: 5, bottom: 10),
        decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30))),
        child: ListTile(
            // subtitle: Text(
            //   DateFormatter.timeParsed(message.time),
            //   style: Theme.of(context).textTheme.caption,
            // ),
            title: Text(message),
            trailing: const Icon(
              Icons.check,
              color: Colors.blue,
            )));
  }
}

class Reply extends StatelessWidget {
  /// Constructor
  const Reply({super.key, required this.message});

  /// Message body
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        margin: const EdgeInsets.only(left: 5, right: 150, top: 20, bottom: 20),
        decoration: BoxDecoration(
            color: Colors.purple[100],
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
                bottomRight: Radius.circular(30))),
        child: ListTile(title: Text(message)));
  }
}
