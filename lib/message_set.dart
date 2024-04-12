import 'package:flutter/material.dart';
import 'package:gwen_chat/user_provider.dart';
import 'package:provider/provider.dart';

import 'User.dart';
import 'message.dart';

class MessageSet extends StatelessWidget {
  const MessageSet({super.key, required this.messages});
  final List<Message> messages;

  @override
  Widget build(BuildContext context) {

    return ListenableBuilder(
      listenable: context.read<UserProvider>(),
      builder: (context, child) {
        UserDetails? currentUser = context.read<UserProvider>().currentUser;
        if(currentUser==null){
          return Center(child: CircularProgressIndicator());
        }

        bool isCurrentUserMessage = currentUser.id == messages.first.senderId;

        return Column(
          crossAxisAlignment: isCurrentUserMessage
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isCurrentUserMessage) Text(messages.first.senderUserName),
                CircleAvatar(
                  backgroundImage: NetworkImage(messages.first.senderImage),
                ),
                if (!isCurrentUserMessage) Text(messages.first.senderUserName),
              ],
            ),
            for (final message in messages)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    message.message,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                color: Colors.white,
              )
          ],
        );
      },
    );
  }
}
