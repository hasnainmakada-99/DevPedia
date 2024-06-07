// import 'package:devpedia/modals/course_modal.dart';
// import 'package:devpedia/modals/fetch_resources.dart';
// import 'package:devpedia/resources screens/resource_info.dart';
// import 'package:devpedia/utils/resource_card.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter/material.dart';

// class AllResources extends ConsumerStatefulWidget {
//   const AllResources({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _AllResourcesState();
// }

// class _AllResourcesState extends ConsumerState<AllResources> {
//   late Future<List<Courses>> resources;
//   String selectedFilter = '';

//   @override
//   void initState() {
//     super.initState();
//     resources = fetchCourses();
//   }

//   Future<void> refreshVideos() async {
//     setState(() {
//       resources = fetchCourses(filter: selectedFilter);
//     });
//   }

//   void _onFilterChanged(String? newFilter) {
//     setState(() {
//       selectedFilter = newFilter ?? '';
//       resources = fetchCourses(filter: selectedFilter);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         _buildFilterDropdown(),
//         Expanded(
//           child: RefreshIndicator(
//             onRefresh: refreshVideos,
//             child: FutureBuilder<List<Courses>>(
//               future: resources,
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   if (snapshot.data!.isEmpty) {
//                     return const Center(
//                       child: Text("No resources available"),
//                     );
//                   } else {
//                     return ListView.builder(
//                       itemCount: snapshot.data!.length,
//                       itemBuilder: (context, index) {
//                         final snapshotData = snapshot.data![index];
//                         return ResourceCard(
//                           navigateTo: () {
//                             Navigator.pushAndRemoveUntil(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ResourceInfo(
//                                   resourceRelatedTo: snapshotData.toolRelatedTo,
//                                   channelName: snapshotData.channelName,
//                                   publishedDate:
//                                       snapshotData.publishedDate.toString(),
//                                   resourceTitle: snapshotData.title,
//                                   resourceURL: snapshotData.url,
//                                   resourceDescription: snapshotData.description,
//                                 ),
//                               ),
//                               (route) => true,
//                             );
//                           },
//                           imageUrl: snapshotData.thumbnail,
//                           title: snapshotData.title,
//                           description: snapshotData.description,
//                           shareLink: snapshotData.url,
//                         );
//                       },
//                     );
//                   }
//                 } else if (snapshot.hasError) {
//                   return Center(
//                     child: Text(snapshot.error.toString()),
//                   );
//                 } else if (snapshot.connectionState ==
//                     ConnectionState.waiting) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 } else {
//                   return const Center(
//                     child: Text("Some Error Occurred"),
//                   );
//                 }
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildFilterDropdown() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: DropdownButton<String>(
//         value: selectedFilter.isEmpty ? null : selectedFilter,
//         hint: const Text('Select a filter'),
//         onChanged: _onFilterChanged,
//         items: <String>['', 'Jenkins', 'AWS'].map((String value) {
//           return DropdownMenuItem<String>(
//             value: value,
//             child: Text(value.isEmpty ? 'All' : value),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }

import 'package:devpedia/modals/course_modal.dart';
import 'package:devpedia/modals/fetch_resources.dart';
import 'package:devpedia/resources%20screens/resource_info.dart';
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
  String selectedFilter = '';

  @override
  void initState() {
    super.initState();
    resources = fetchCourses();
  }

  Future<void> refreshVideos() async {
    setState(() {
      resources = fetchCourses(filter: selectedFilter);
    });
  }

  void _onFilterChanged(String? newFilter) {
    setState(() {
      selectedFilter = newFilter ?? '';
      resources = fetchCourses(filter: selectedFilter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterDropdown(),
        Expanded(
          child: RefreshIndicator(
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
                                  resourceRelatedTo: snapshotData.toolRelatedTo,
                                  channelName: snapshotData.channelName,
                                  publishedDate:
                                      snapshotData.publishedDate.toString(),
                                  resourceTitle: snapshotData.title,
                                  resourceURL: snapshotData.url,
                                  resourceDescription: snapshotData.description,
                                ),
                              ),
                              (route) => true,
                            );
                          },
                          imageUrl: snapshotData.thumbnail,
                          title: snapshotData.title,
                          description: snapshotData.description,
                          shareLink: snapshotData.url,
                          courseId:
                              snapshotData.courseId, // Pass the courseId here
                        );
                      },
                    );
                  }
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
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
          ),
        ),
      ],
    );
  }

  Widget _buildFilterDropdown() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<String>(
        value: selectedFilter.isEmpty ? null : selectedFilter,
        hint: const Text('Select a filter'),
        onChanged: _onFilterChanged,
        items: <String>['', 'Jenkins', 'AWS'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value.isEmpty ? 'All' : value),
          );
        }).toList(),
      ),
    );
  }
}
