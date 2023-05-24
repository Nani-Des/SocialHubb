import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'ChatScreen.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({Key? key}) : super(key: key);

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  final roomsCollection = FirebaseFirestore.instance.collection('chatRooms');
  final lawyersCollection = FirebaseFirestore.instance.collection('Lawyers');
  final clientsCollection = FirebaseFirestore.instance.collection('Clients');
  String clientId = FirebaseAuth.instance.currentUser!.uid;
  User? client = FirebaseAuth.instance.currentUser;
  bool isLawyer = false;
  List rooms = [];

  @override
  void initState() {
    super.initState();
    getChatList();
  }

  getChatList() async {
    final lawyer = await lawyersCollection
        .where('emailID', isEqualTo: client!.email)
        .get();

    print('lawyer rooms data ${lawyer.docs}');

    if (lawyer.docs.isNotEmpty) {
      isLawyer = true;
    }

    if (isLawyer) {
      var lawyerRooms = await roomsCollection
          .where('lawyerEmail', isEqualTo: client!.email)
          .get();

      for (var room in lawyerRooms.docs) {
        print('room data ${room.data()}');
        rooms.add(room.data());
        setState(() {});
      }
    } else {
      var clientRooms = await roomsCollection
          .where('clientEmail', isEqualTo: client!.email)
          .get();
      for (var room in clientRooms.docs) {
        print('room data ${room.data()}');
        rooms.add(room.data());
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Messages",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF8C1F85),
        ),
        body: SafeArea(
          child: rooms.length < 1
              ? Center(
                  child: Text(
                    'No Messages',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              : ListView.builder(
                  reverse: false,
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => ChatScreen(
                                      isLawyer: isLawyer,
                                      lawyerID: rooms[index]['lawyerId'],
                                      userID: rooms[index]['clientId'],
                                    ))));
                      },
                      child: ListTile(
                        leading: Icon(Icons.person),
                        title: Text(isLawyer
                            ? rooms[index]['clientName']
                            : rooms[index]['lawyerName']),
                      ),
                    );
                  },
                ),
        ));
  }
}
