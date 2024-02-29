import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final geminiControllerProvider =
    StateNotifierProvider<GeminiController, List<String>>((ref) {
  return GeminiController();
});

class GeminiController extends StateNotifier<List<String>> {
  GeminiController() : super([]);

  final gemini = Gemini.instance;
  final firestore = FirebaseFirestore.instance;

  Stream<String?> generateContentStream(String content) {
    return gemini
        .streamGenerateContent(content)
        .map((value) => value.output)
        .handleError((e) {
      log('streamGenerateContent exception', error: e);
    });
  }

  Future<void> insertOutputToFirestore(String output) async {
    if (output.isEmpty) {
      return;
    }

    try {
      await firestore.collection('chat_outputs').add({
        'output': output,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('Chat Inserted');
    } catch (e) {
      log('insertOutputToFirestore exception', error: e);
    }
  }
}
