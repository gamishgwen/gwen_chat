
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var message= TextEditingController();



  void dispose(){
    message.dispose();
    super.dispose();}

    void save(){
      final sendMessage=message.text;
      if(sendMessage.trim().isEmpty){
        return;
      }message.clear();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Column(
        children: [Expanded(child: Text('no messsges')),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16,right: 14,bottom: 18, top: 4),
                  child: TextField(
                    decoration: InputDecoration(label: Text('Send a Message')),
                    controller: message,
                  ),
                ),
              ),
              IconButton(onPressed: () {
                save();
              }, icon: Icon(Icons.send))
            ],
          ),
        ],
      ),
    );
  }
}
