import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpedia/gemini/chatController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _TextOnlyState createState() => _TextOnlyState();
}

class _TextOnlyState extends ConsumerState<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatController = ref.watch(chatControllerProvider);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, String>>>(
              stream: chatController.firestore
                  .collection('chats')
                  .orderBy('timestamp', descending: true)
                  .snapshots()
                  .map((event) => event.docs
                      .map((e) => e.data() as Map<String, String>)
                      .toList()),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final chatList = snapshot.data!;
                  return ListView.builder(
                    controller: _controller,
                    itemCount: chatList.length,
                    padding: const EdgeInsets.only(bottom: 20),
                    itemBuilder: (context, index) {
                      final chat = chatList[index];
                      return ListTile(
                        isThreeLine: true,
                        leading: CircleAvatar(
                          child: Text(chat["role"]!.substring(0, 1)),
                        ),
                        title: Text(chat["role"]!),
                        subtitle: Text(chat["text"]!),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
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
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Colors.transparent,
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                Consumer(
                  builder: (context, watch, child) {
                    final loading = chatController.loading;
                    return IconButton(
                      icon: loading
                          ? CircularProgressIndicator()
                          : Icon(Icons.send),
                      onPressed: () {
                        ref
                            .watch(chatControllerProvider.notifier)
                            .fromText(_textController.text);
                        _textController.clear();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
