import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../Provider/user_provider.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String userName;

  const ChatScreen({
    Key? key,
    required this.userId,
    required this.userName,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    initSocket();
    fetchMessages();
  }

  void initSocket() {
    final token =
        Provider.of<LoginLogoutProvider>(context, listen: false).token;
    socket = IO.io('http://20.52.185.247:8000', <String, dynamic>{
      'transports': ['websocket'],
      'query': {'token': token},
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected');
    });

    socket.on('liveMessage', (data) {
      setState(() {
        _messages.add({
          'sender': 'receiver',
          'message': data['message'],
        });
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    socket.disconnect();
    super.dispose();
  }

  void sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      final token =
          Provider.of<LoginLogoutProvider>(context, listen: false).token;
      final response = await http.post(
        Uri.parse('http://20.52.185.247:8000/message'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'receiver': widget.userId,
          'message': message,
        }),
      );

      print('Send Message Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        _messageController.clear();
        setState(() {
          _messages.add({
            'sender': 'sender',
            'message': message,
          });
        });
      } else {
        print(
            'Failed to send message: ${response.statusCode} - ${response.body}');
      }
    }
  }

  Future<void> fetchMessages() async {
    final token =
        Provider.of<LoginLogoutProvider>(context, listen: false).token;
    final response = await http.post(
      Uri.parse('http://20.52.185.247:8000/message'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'receiver': widget.userId}),
    );

    if (response.statusCode == 200) {
      print('Response: ${response.body}');
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final messages = data['data'] as List<dynamic>;

      setState(() {
        _messages = messages.map<Map<String, dynamic>>((message) {
          return {
            'sender': message['status'] == 'sender' ? 'sender' : 'receiver',
            'message': message['message'],
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to load messages');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isSentByMe = message['sender'] == 'sender';
                return Align(
                  alignment:
                  isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    margin:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSentByMe ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(message['message']),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}