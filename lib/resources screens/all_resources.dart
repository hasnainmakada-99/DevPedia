import 'package:devpedia/modals/fetch_resources.dart';
import 'package:devpedia/modals/resource_modal.dart';
import 'package:devpedia/others/resource_info.dart';
import 'package:devpedia/utils/resource_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class AllResources extends ConsumerStatefulWidget {
  const AllResources({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllResourcesState();
}

class _AllResourcesState extends ConsumerState<AllResources> {
  late final Stream<List<ResourceModal>> resources;
  late List<ResourceModal> fetchedResources;

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

  Future<void> shuffleResources() async {
    setState(() {
      fetchedResources.shuffle(Random());
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await refreshVideos();
        await shuffleResources();
      },
      child: StreamBuilder<List<ResourceModal>>(
        stream: resources,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            fetchedResources = snapshot.data!.toList();
            fetchedResources.shuffle(Random());

            if (fetchedResources.isNotEmpty) {
              return ListView.builder(
                itemCount: fetchedResources.length,
                itemBuilder: (context, index) {
                  final snapshotData = fetchedResources[index];
                  return ResourceCard(
                    navigateTo: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResourceInfo(
                            resourceRelatedTo: snapshotData.tool.toString(),
                            channelName: snapshotData.channelName.toString(),
                            publishedDate:
                                snapshotData.publishedDate.toString(),
                            resourceTitle: snapshotData.title.toString(),
                            resourceURL: snapshotData.url.toString(),
                            resourceDescription:
                                snapshotData.description.toString(),
                          ),
                        ),
                        (route) => true,
                      );
                    },
                    imageUrl: snapshotData.thumbnail.toString(),
                    title: snapshotData.title.toString(),
                    description: snapshotData.description.toString(),
                    shareLink: snapshotData.url.toString(),
                  );
                },
              );
            } else {
              return const Center(
                child: Text('No resources available currently'),
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
