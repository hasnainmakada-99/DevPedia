import 'package:devpedia/modals/fetch_resources.dart';
import 'package:devpedia/modals/resource_modal.dart';
import 'package:devpedia/utils/resource_card.dart';
import 'package:flutter/material.dart';

class JenkinsResources extends StatefulWidget {
  const JenkinsResources({super.key});

  @override
  State<JenkinsResources> createState() => _JenkinsResourcesState();
}

late Future<List<ResourceModal>> resources;

class _JenkinsResourcesState extends State<JenkinsResources> {
  @override
  void initState() {
    // TODO: implement initState
    resources = fetchVideos();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ResourceModal>>(
      future: resources,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final snapshotData = snapshot.data![index];
              return snapshotData.tool?.toLowerCase() == 'aws'
                  ? ResourceCard(
                      imageUrl: snapshotData.thumbnail.toString(),
                      title: snapshotData.title.toString(),
                      description: snapshotData.description.toString(),
                      shareLink: "No link",
                      exploreLink: 'No Link',
                    )
                  : const Center(child: Text('The End :)'));
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
        return CircularProgressIndicator();
      },
    );
  }
}
