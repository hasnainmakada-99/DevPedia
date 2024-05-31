import 'package:devpedia/auth%20and%20cloud/auth_provider.dart';
import 'package:devpedia/gemini/chatController.dart';
import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String? userEmail;

  const ChatScreen({Key? key, required this.userEmail}) : super(key: key);

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

  void _sendMessage() {
    final text = _textController.text;
    if (text.isNotEmpty) {
      ref.watch(chatControllerProvider.notifier).fromText(text);
      _textController.clear();
      _scrollToBottom();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot submit empty text'),
        ),
      );
    }
  }

  void _scrollToBottom() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatController = ref.watch(chatControllerProvider);
    final authRepoController = ref.watch(authRepositoryProvider);

    // Check for null before accessing userEmail
    final userEmail = authRepoController.userEmail;
    if (userEmail == null) {
      return Text('Error: User email not available');
    }

    return Scaffold(
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: chatController.firestore
            .collection('chats')
            .where('user', isEqualTo: userEmail)
            .orderBy('timestamp',
                descending: false) // Sort ascending by timestamp
            .snapshots()
            .map(
              (event) => event.docs.map((e) => e.data()).toList(),
            ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final chatList = snapshot.data!;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom();
            });
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
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
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      Consumer(
                        builder: (context, watch, child) {
                          final loading = chatController.loading;
                          return IconButton(
                            icon: loading
                                ? CircularProgressIndicator()
                                : Icon(Icons.send),
                            onPressed: _sendMessage,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const Center(child: Text('No Chats Found'));
          }
        },
      ),
    );
  }
}
