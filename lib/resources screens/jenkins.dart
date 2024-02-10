import 'package:devpedia/modals/fetch_resources.dart';
import 'package:devpedia/modals/resource_modal.dart';
import 'package:devpedia/utils/resource_card.dart';
import 'package:flutter/material.dart';

class JenkinsResources extends StatefulWidget {
  const JenkinsResources({super.key});

  @override
  State<JenkinsResources> createState() => _JenkinsResourcesState();
}

class _JenkinsResourcesState extends State<JenkinsResources> {
  late final Stream<List<ResourceModal>> resources;
  @override
  void initState() {
    super.initState();
    resources = fetchVideos();
  }

  Future<void> refreshVideos() async {
    setState(() {
      resources = fetchVideos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshVideos,
      child: StreamBuilder<List<ResourceModal>>(
        stream: resources,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final jenkinsResources = snapshot.data!
                .where((resource) =>
                    resource.tool?.trim().toLowerCase() == 'jenkins')
                .toList();

            if (jenkinsResources.isNotEmpty) {
              return ListView.builder(
                itemCount: jenkinsResources.length,
                itemBuilder: (context, index) {
                  final snapshotData = jenkinsResources[index];
                  return ResourceCard(
                    imageUrl: snapshotData.thumbnail.toString(),
                    title: snapshotData.title.toString(),
                    description: snapshotData.description.toString(),
                    shareLink: "No link",
                    exploreLink: 'No Link',
                  );
                },
              );
            } else {
              return const Center(
                child: Text('No resources found'),
              );
            }
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
