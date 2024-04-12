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
    apiKey:
        dotenv.env['GEMINI_KEY'] ?? 'AIzaSyBPnIGkp6HzHm0S6eHGxHvPnNnojM6nSj0',
  );
  final uuid = const Uuid();

  Future<void> fromText(String query) async {
    state = state.copyWith(loading: true);
    query = query.trim(); // Ignore leading and trailing whitespaces

    try {
      final timestamp = DateTime.now();

      // Store user's query
      final userDocRef =
          await FirebaseFirestore.instance.collection('chats').add({
        'user': auth.currentUser!.email!,
        'role': 'You',
        'text': query,
        'timestamp': timestamp,
      });

      // Generate response using Gemini
      final response = await geminiService.generateFromText(query);

      // Store Gemini response
      await FirebaseFirestore.instance.collection('chats').add({
        'user': auth.currentUser!.email!,
        'role': 'DevAi',
        'text': response.text,
        'timestamp': timestamp,
        // Reference the user's query document
        'parent': userDocRef,
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
