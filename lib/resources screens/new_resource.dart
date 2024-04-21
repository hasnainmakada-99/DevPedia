import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:pod_player/pod_player.dart';

class NewResourceInfoScreen extends StatefulWidget {
  const NewResourceInfoScreen({Key? key}) : super(key: key);

  @override
  State<NewResourceInfoScreen> createState() => _NewResourceInfoScreenState();
}

class _NewResourceInfoScreenState extends State<NewResourceInfoScreen> {
  late final PodPlayerController controller;

  @override
  void initState() {
    controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.youtube(
          'https://youtu.be/QR411RsVutc?si=bK9N-voNO-1_NtIC'),
    )..initialise();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          PodVideoPlayer(controller: controller),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like)."),
              ),
            ),
          ),
          const SizedBox(height: 2),
          const Text('Channel: ${"Sony Liv"}'),
          const SizedBox(height: 2),
          const Text("Published Date: ${'Hello'}"),
          const SizedBox(height: 2),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Give Feedback on this Resource'),
          ),
        ],
      ),
    );
  }
}
