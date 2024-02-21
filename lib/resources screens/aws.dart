import 'package:devpedia/modals/fetch_resources.dart';
import 'package:devpedia/modals/resource_modal.dart';
import 'package:devpedia/others/resource_info.dart';
import 'package:devpedia/utils/resource_card.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class awsresources extends StatefulWidget {
  const awsresources({super.key});

  @override
  State<awsresources> createState() => _awsresourcesState();
}

// ignore: camel_case_types
class _awsresourcesState extends State<awsresources> {
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
                .where(
                    (resource) => resource.tool?.trim().toLowerCase() == 'aws')
                .toList();

            if (jenkinsResources.isNotEmpty) {
              return ListView.builder(
                itemCount: jenkinsResources.length,
                itemBuilder: (context, index) {
                  final snapshotData = jenkinsResources[index];
                  return ResourceCard(
                    navigateTo: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResourceInfo(
                                  channelName:
                                      snapshotData.channelName.toString(),
                                  publishedDate:
                                      snapshotData.publishedDate.toString(),
                                  resourceTitle: snapshotData.title.toString(),
                                  resourceURL: snapshotData.url.toString(),
                                  resourceDescription:
                                      snapshotData.description.toString(),
                                )),
                        (route) => true,
                      );
                    },
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
