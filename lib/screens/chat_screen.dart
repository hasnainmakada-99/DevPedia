// // Import required packages
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';

// const apiKey = "AIzaSyA6bT6-9ZwIw_k10imdMlyGXRzsTJhpPbk";

// // State providers for chat data and loading state
// final chatProvider = StateProvider<List<Map<String, String>>>(
//   (ref) => [],
// );

// final loadingProvider = StateProvider<bool>((ref) => false);

// class ChatScreen1 extends ConsumerStatefulWidget {
//   final String userEmail;
//   ChatScreen1({Key? key, required this.userEmail}) : super(key: key);

//   @override
//   _ChatScreen1State createState() => _ChatScreen1State();
// }

// class _ChatScreen1State extends ConsumerState<ChatScreen1> {
//   final textController = TextEditingController();
//   final model = GenerativeModel(
//     model: 'gemini-1.5-flash',
//     apiKey: 'AIzaSyCHmrIMLrf-xKMC2NNFn5iV3Z5GK8UDW9U',
//   );

//   final ScrollController _controller = ScrollController();

//   @override
//   void dispose() {
//     textController.dispose();
//     _controller.dispose();
//     super.dispose();
//   }

//   void _scrollToBottom() {
//     _controller.animateTo(
//       _controller.position.maxScrollExtent,
//       duration: Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final chatList = ref.watch(chatProvider);
//     final isLoading = ref.watch(loadingProvider);
//     // final gemini = GoogleGemini(apiKey: apiKey);

//     void fromText({required String query}) async {
//       _scrollToBottom();
//       if (query.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Please enter a message to send'),
//           ),
//         );
//         return;
//       }
//       final content = [Content.text(query)];
//       ref.read(loadingProvider.notifier).state = true;

//       final userMessage = {
//         'email': widget.userEmail,
//         'role': 'You',
//         'text': query,
//       };
//       chatList.add(userMessage);
//       textController.clear();

//       try {
//         final response = await model.generateContent(content);
//         final aiMessage = {
//           'email': widget.userEmail,
//           'role': 'DevAi',
//           'text': response.text!,
//         };

//         // Add both user and AI messages to Firebase
//         await addToFirebase(userMessage);
//         await addToFirebase(aiMessage);

//         chatList.add(aiMessage.cast<String, String>());
//       } catch (error) {
//         final errorMessage = {
//           'email': widget.userEmail,
//           'role': 'DevAi',
//           'text': error.toString(),
//         };
//         chatList.add(errorMessage);
//       } finally {
//         ref.read(loadingProvider.notifier).state = false;
//       }
//     }

//     return Scaffold(
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               controller: _controller,
//               itemCount: chatList.length,
//               padding: const EdgeInsets.only(bottom: 20),
//               itemBuilder: (context, index) {
//                 final message = chatList[index];
//                 return ListTile(
//                   isThreeLine: true,
//                   leading: CircleAvatar(
//                     child: Text(message['role']!.substring(0, 1)),
//                   ),
//                   title: Text(message['role']!),
//                   subtitle: Text(message['text']!),
//                 );
//               },
//             ),
//           ),
//           Container(
//             alignment: Alignment.bottomRight,
//             margin: const EdgeInsets.all(20),
//             padding: const EdgeInsets.symmetric(horizontal: 15.0),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10.0),
//               border: Border.all(color: Colors.grey),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: textController,
//                     decoration: InputDecoration(
//                       hintText: "Type a message",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                         borderSide: BorderSide.none,
//                       ),
//                       fillColor: Colors.transparent,
//                     ),
//                     maxLines: null,
//                     keyboardType: TextInputType.multiline,
//                   ),
//                 ),
//                 IconButton(
//                     icon: isLoading
//                         ? const CircularProgressIndicator()
//                         : const Icon(Icons.send),
//                     onPressed: () => fromText(query: textController.text)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// Future<void> addToFirebase(Map<String, String> message) async {
//   final messagesRef = FirebaseFirestore.instance.collection('chatMessages');
//   await messagesRef.add(message);
// }

// Testing Code

// Import required packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

const apiKey = "AIzaSyA6bT6-9ZwIw_k10imdMlyGXRzsTJhpPbk";

// State providers for chat data and loading state
final chatProvider = StateProvider<List<Map<String, String>>>(
  (ref) => [],
);

final loadingProvider = StateProvider<bool>((ref) => false);

class ChatScreen1 extends ConsumerStatefulWidget {
  final String userEmail;
  ChatScreen1({Key? key, required this.userEmail}) : super(key: key);

  @override
  _ChatScreen1State createState() => _ChatScreen1State();
}

class _ChatScreen1State extends ConsumerState<ChatScreen1> {
  final textController = TextEditingController();
  final model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: 'AIzaSyCHmrIMLrf-xKMC2NNFn5iV3Z5GK8UDW9U',
  );

  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    textController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadPreviousChats();
  }

  Future<void> _loadPreviousChats() async {
    final chatList = ref.read(chatProvider.notifier);
    final snapshot = await FirebaseFirestore.instance
        .collection('chatMessages')
        .where('email', isEqualTo: widget.userEmail)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final chats = snapshot.docs.map((doc) => doc.data()).toList();
      chatList.state = List<Map<String, String>>.from(chats);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatList = ref.watch(chatProvider);
    final isLoading = ref.watch(loadingProvider);

    void fromText({required String query}) async {
      if (query.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a message to send'),
          ),
        );
        return;
      }

      final content = [Content.text(query)];
      ref.read(loadingProvider.notifier).state = true;

      final userMessage = {
        'email': widget.userEmail,
        'role': 'You',
        'text': query,
      };
      chatList.add(userMessage);
      textController.clear();

      try {
        final response = await model.generateContent(content);
        final aiMessage = {
          'email': widget.userEmail,
          'role': 'DevAi',
          'text': response.text!,
        };

        // Add both user and AI messages to Firebase
        await addToFirebase(userMessage);
        await addToFirebase(aiMessage);

        chatList.add(aiMessage.cast<String, String>());
      } catch (error) {
        final errorMessage = {
          'email': widget.userEmail,
          'role': 'DevAi',
          'text': error.toString(),
        };
        chatList.add(errorMessage);
      } finally {
        ref.read(loadingProvider.notifier).state = false;
      }

      _scrollToBottom();
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: chatList.isEmpty
                ? const Center(
                    child: Text('No chats to display'),
                  )
                : ListView.builder(
                    controller: _controller,
                    itemCount: chatList.length,
                    padding: const EdgeInsets.only(bottom: 20),
                    itemBuilder: (context, index) {
                      final message = chatList[index];
                      return ListTile(
                        isThreeLine: true,
                        leading: CircleAvatar(
                          child: Text(message['role']!.substring(0, 1)),
                        ),
                        title: Text(message['role']!),
                        subtitle: Text(message['text']!),
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
                    controller: textController,
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
                IconButton(
                    icon: isLoading
                        ? const CircularProgressIndicator()
                        : const Icon(Icons.send),
                    onPressed: () => fromText(query: textController.text)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> addToFirebase(Map<String, String> message) async {
  final messagesRef = FirebaseFirestore.instance.collection('chatMessages');
  await messagesRef.add(message);
}
