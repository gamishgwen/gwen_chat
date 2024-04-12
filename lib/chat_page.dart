import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gwen_chat/User.dart';
import 'package:gwen_chat/message.dart';
import 'package:gwen_chat/user_provider.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var message = TextEditingController();

  void dispose() {
    message.dispose();
    super.dispose();
  }

  void save() async {
    final sendMessage = message.text;
    if (sendMessage.trim().isEmpty) {
      return;
    }
    UserDetails userDetails = context.read<UserProvider>().currentUser!;
    Message messages = Message(
        message: sendMessage,
        senderId: userDetails.id,
        senderImage: userDetails.imageUrl,
        senderUserName: userDetails.userName,
        time: DateTime.now());

    await FirebaseFirestore.instance
        .collection('messages')
        .doc(messages.id)
        .set(messages.toJson());

    message.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Screen'),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('messages')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final List<Message> messages = snapshot.data!.docs
                      .map((doc) => Message.fromJson(doc.data()))
                      .toList()
                    ..sort(
                      (a, b) => a.time.compareTo(b.time),
                    );
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) => Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(messages[index].senderImage),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: [
                            Card(
                              child: Text(messages[index].message),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
          ),
          // Expanded(child: Text('no messsges')),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 14, bottom: 18, top: 4),
                  child: TextField(
                    decoration:
                        const InputDecoration(label: Text('Send a Message')),
                    controller: message,
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    save();
                  },
                  icon: const Icon(Icons.send))
            ],
          ),
        ],
      ),
    );
  }
}
