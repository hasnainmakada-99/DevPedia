import 'dart:convert';

import 'package:devpedia/modals/fetch_resources.dart';
import 'package:devpedia/modals/resource_modal.dart';
import 'package:devpedia/resources screens/resource_info.dart';
import 'package:devpedia/utils/resource_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class AllResources extends ConsumerStatefulWidget {
  const AllResources({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllResourcesState();
}

class _AllResourcesState extends ConsumerState<AllResources> {
  late final Stream<List<ResourceModal>> resources;

  @override
  void initState() {
    super.initState();
    resources = loadCachedVideos();
  }

  // Future<void> preloadData() async {
  //   final videos = await fetchVideos().first;

  //   resources = Stream.value(videos);
  // }

  Future<void> refreshVideos() async {
    setState(() {
      resources = fetchVideos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => refreshVideos(),
      child: StreamBuilder<List<ResourceModal>>(
        stream: resources,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text("No resources available"),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final snapshotData = snapshot.data![index];
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
            }
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Some Error Occurred"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const Center(
              child: Text("Some Error Occurred"),
            );
          }

          // By default, show a loading spinner.
        },
      ),
    );
  }
}
