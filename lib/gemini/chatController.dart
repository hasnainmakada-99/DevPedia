import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_gemini/google_gemini.dart';
import 'package:uuid/uuid.dart';

final chatControllerProvider =
    StateNotifierProvider<ChatController, ChatState>((ref) {
  return ChatController(ref);
});

class ChatController extends StateNotifier<ChatState> {
  ChatController(this.ref) : super(ChatState());

  FirebaseAuth get auth => FirebaseAuth.instance;

  final Ref ref;
  final geminiService = GoogleGemini(
    apiKey: dotenv.env['GEMINI_KEY'] ?? 'YOUR_GEMINI_API_KEY',
  );
  final uuid = const Uuid();

  Future<void> fromText(String query) async {
    state = state.copyWith(loading: true);
    query = query.trim(); // Ignore leading and trailing whitespaces

    try {
      final timestamp = DateTime.now();

      await FirebaseFirestore.instance.collection('chats').add({
        'user': auth.currentUser!.email!,
        'role': 'You',
        'text': query,
        'timestamp': timestamp,
      });

      // Delay the response generation for 2 seconds
      await Future.delayed(Duration(seconds: 2));

      final response = await geminiService.generateFromText(query);

      await FirebaseFirestore.instance.collection('chats').add({
        'user': auth.currentUser!.email!,
        'role': 'DevAi',
        'text': response.text,
        'timestamp': timestamp,
      });

      state = state.copyWith(loading: false);
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
    }
  }
}

class ChatState {
  final bool loading;
  final String? error;
  ChatState({
    this.loading = false,
    this.error,
  });

  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  ChatState copyWith({
    bool? loading,
    String? error,
  }) {
    return ChatState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }
}
