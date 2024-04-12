// import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_gemini/google_gemini.dart';

const apiKey = "AIzaSyA6bT6-9ZwIw_k10imdMlyGXRzsTJhpPbk";

class ChatScreen1 extends ConsumerStatefulWidget {
  const ChatScreen1({
    super.key,
  });

  @override
  ConsumerState<ChatScreen1> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen1> {
  bool loading = false;

  List<Map<String, String>> textChat = [];

  final TextEditingController _textController = TextEditingController();
  final ScrollController _controller = ScrollController();

  // Create Gemini Instance
  final gemini = GoogleGemini(
    apiKey: apiKey,
  );

  // Text only input
  void fromText({required String query}) async {
    setState(() {
      loading = true;
      textChat.add({
        "role": "User",
        "text": query,
      });
      _textController.clear();
    });
    scrollToTheEnd();

    try {
      final response = await gemini.generateFromText(query);
      final message = {
        "role": "DevAi",
        "text": response.text,
      };
      textChat.add(message);
      await addToFirebase(
          message); // Add to Firebase after successful Gemini response
      setState(() {
        loading = false;
      });
      scrollToTheEnd();
    } catch (error) {
      setState(() {
        loading = false;
        textChat.add({
          "role": "Gemini",
          "text": error.toString(),
        });
      });
      scrollToTheEnd();
    }
  }

  void scrollToTheEnd() {
    _controller.jumpTo(_controller.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _controller,
            itemCount: textChat.length,
            padding: const EdgeInsets.only(bottom: 20),
            itemBuilder: (context, index) {
              return ListTile(
                isThreeLine: true,
                leading: CircleAvatar(
                  child:
                      Text(textChat[index]["role"].toString().substring(0, 1)),
                ),
                title: Text(textChat[index]["role"]!),
                subtitle: Text(textChat[index]["text"]!),
              );
            },
          ),
        ),
        Container(
          alignment: Alignment.bottomRight,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.grey),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: "Type a message",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none),
                    fillColor: Colors.transparent,
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
              ),
              IconButton(
                icon: loading
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.send),
                onPressed: () {
                  fromText(query: _textController.text);
                },
              ),
            ],
          ),
        )
      ],
    ));
  }

  Future<void> addToFirebase(Map<String, String> message) async {
    // Replace with your actual Firebase Firestore collection reference
    final messagesRef = FirebaseFirestore.instance.collection('chatMessages');
    await messagesRef.add(message);
  }
}
