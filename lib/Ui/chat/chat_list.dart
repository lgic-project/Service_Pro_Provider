import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_pro_provider/Provider/chat_user_provider.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  void initState() {
    super.initState();
    Provider.of<ChatUserProvider>(context, listen: false).getChatUser(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.5),
          ],
        ),
      ),
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Column(
          children: [
            const Text(
              'Your Service Providers...',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Expanded(
              child: Consumer<ChatUserProvider>(
                  builder: (context, chatUser, child) {
                return ListView.builder(
                    itemCount: chatUser.users.length,
                    itemBuilder: (context, index) {
                      final chatUsers = chatUser.users[index];
                      if (chatUsers['Role'] == 'user') {
                        return Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  chatUsers['Image'].toString() != null
                                      ? chatUsers['Image'].toString()
                                      : AssetImage(
                                              'assets/profile/default_profile.jpg')
                                          .toString(),
                                ),
                              ),
                              title: Text(chatUsers['Name']),
                              trailing: const Text(
                                '5m',
                                style: TextStyle(color: Color(0xFF191645)),
                              ),
                            ),
                            const Divider(
                              color: Colors.white,
                            ),
                          ],
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    });
              }),
            ),
          ],
        ),
      ),
    );
  }
}
