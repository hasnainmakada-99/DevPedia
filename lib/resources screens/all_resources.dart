// import 'package:devpedia/modals/course_modal.dart';
// import 'package:devpedia/modals/fetch_resources.dart';

// import 'package:devpedia/resources screens/resource_info.dart';
// import 'package:devpedia/utils/resource_card.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// class AllResources extends ConsumerStatefulWidget {
//   const AllResources({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _AllResourcesState();
// }

// class _AllResourcesState extends ConsumerState<AllResources> {
//   late Future<List<Courses>> resources;

//   @override
//   void initState() {
//     super.initState();
//     resources = fetchCourses();
//   }

//   Future<void> refreshVideos() async {
//     setState(() {
//       resources = fetchCourses();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return RefreshIndicator(
//       onRefresh: () => refreshVideos(),
//       child: FutureBuilder<List<Courses>>(
//         future: resources,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             if (snapshot.data!.isEmpty) {
//               return const Center(
//                 child: Text("No resources available"),
//               );
//             } else {
//               return ListView.builder(
//                 itemCount: snapshot.data!.length,
//                 itemBuilder: (context, index) {
//                   final snapshotData = snapshot.data![index];
//                   return ResourceCard(
//                     navigateTo: () {
//                       Navigator.pushAndRemoveUntil(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ResourceInfo(
//                             resourceRelatedTo:
//                                 snapshotData.toolRelatedTo?.toString() ?? '',
//                             channelName: snapshotData.channelName.toString(),
//                             publishedDate:
//                                 snapshotData.publishedDate.toString(),
//                             resourceTitle: snapshotData.title.toString(),
//                             resourceURL: snapshotData.url.toString(),
//                             resourceDescription:
//                                 snapshotData.description.toString(),
//                           ),
//                         ),
//                         (route) => true,
//                       );
//                     },
//                     imageUrl: snapshotData.thumbnail.toString(),
//                     title: snapshotData.title.toString(),
//                     description: snapshotData.description.toString(),
//                     shareLink: snapshotData.url.toString(),
//                   );
//                 },
//               );
//             }
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text(snapshot.error.toString()),
//             );
//           } else if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           } else {
//             return const Center(
//               child: Text("Some Error Occurred"),
//             );
//           }

//           // By default, show a loading spinner.
//         },
//       ),
//     );
//   }
// }

import 'package:devpedia/modals/course_modal.dart';
import 'package:devpedia/modals/fetch_resources.dart';
import 'package:devpedia/resources screens/resource_info.dart';
import 'package:devpedia/utils/resource_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class AllResources extends ConsumerStatefulWidget {
  const AllResources({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllResourcesState();
}

class _AllResourcesState extends ConsumerState<AllResources> {
  late Future<List<Courses>> resources;

  @override
  void initState() {
    super.initState();
    resources = fetchCourses();
  }

  Future<void> refreshVideos() async {
    setState(() {
      resources = fetchCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshVideos,
      child: FutureBuilder<List<Courses>>(
        future: resources,
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
                            resourceRelatedTo: snapshotData
                                .toolRelatedTo, // Handle null with null-safety operator
                            channelName: snapshotData
                                .channelName, // Handle null with null-safety operator
                            publishedDate:
                                snapshotData.publishedDate?.toString() ??
                                    " ", // Check for null before toString()
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
            return Center(
              child: Text(snapshot.error.toString()),
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
        },
      ),
    );
  }
}
