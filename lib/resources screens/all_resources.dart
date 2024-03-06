import 'dart:convert';

import 'package:devpedia/modals/fetch_resources.dart';
import 'package:devpedia/modals/resource_modal.dart';
import 'package:devpedia/others/resource_info.dart';
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
    preloadData();
  }

  Future<void> preloadData() async {
    resources = (await fetchVideos().first) as Stream<List<ResourceModal>>;
    // Save the fetched videos to the cache
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cachedVideos', jsonEncode(resources));
  }

  Future<void> refreshVideos() async {
    setState(() {
      resources = fetchVideos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await refreshVideos();
      },
      child: StreamBuilder<List<ResourceModal>>(
        stream: resources,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
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
                          publishedDate: snapshotData.publishedDate.toString(),
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
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Some Error Occured"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const Center(
              child: Text("Some Error Occured"),
            );
          }

          // By default, show a loading spinner.
        },
      ),
    );
  }
}
