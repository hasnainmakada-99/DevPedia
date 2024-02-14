import 'package:flutter/material.dart';

class ResourceCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String shareLink;
  final String exploreLink;
  final Function navigateTo;

  const ResourceCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.shareLink,
    required this.exploreLink,
    required this.navigateTo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5,
      child: InkWell(
        onTap: () => navigateTo(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.network(
              imageUrl,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Handle image loading errors (e.g., show placeholder)
                return Container(
                  height: 160,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: const Center(
                    child: Text('Error loading image'),
                  ),
                );
              },
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey[800],
                    ),
                  ),
                  Container(height: 10),
                  Text(
                    description.length > 60
                        ? '${description.substring(0, 60)}...'
                        : description,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.transparent,
                        ),
                        child: Text(
                          "SHARE",
                          style: TextStyle(color: Colors.blue),
                        ),
                        onPressed: () {
                          // Handle share action
                          // launchUrl(Uri.parse(shareLink));
                        },
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.transparent,
                        ),
                        child: Text(
                          "EXPLORE",
                          style: TextStyle(color: Colors.blue),
                        ),
                        onPressed: () {
                          // Handle explore action
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(height: 5),
          ],
        ), // This adds the shadow to the card
      ),
    );
  }
}


// class ResourceCard extends StatelessWidget {
//   final String imageUrl;
//   final String title;
//   final String description;
//   final String shareLink;
//   final String exploreLink;

//   const ResourceCard({
//     Key? key,
//     required this.imageUrl,
//     required this.title,
//     required this.description,
//     required this.shareLink,
//     required this.exploreLink,
//   }) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//       ),
//       clipBehavior: Clip.antiAliasWithSaveLayer,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Image.asset(
//             'assets/random_image.webp',
//             height: 160,
//             width: double.infinity,
//             fit: BoxFit.cover,
//           ),
//           Container(
//             padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Text(
//                   "Cards Title ",
//                   style: TextStyle(
//                     fontSize: 24,
//                     color: Colors.grey[800],
//                   ),
//                 ),
//                 Container(height: 10),
//                 Text(
//                   "Card Text",
//                   style: TextStyle(
//                     fontSize: 15,
//                     color: Colors.grey[700],
//                   ),
//                 ),
//                 Row(
//                   children: <Widget>[
//                     const Spacer(),
//                     TextButton(
//                       style: TextButton.styleFrom(
//                         foregroundColor: Colors.transparent,
//                       ),
//                       child: const Text(
//                         "SHARE",
//                         style: TextStyle(color: Colors.blue),
//                       ),
//                       onPressed: () {},
//                     ),
//                     TextButton(
//                       style: TextButton.styleFrom(
//                         foregroundColor: Colors.transparent,
//                       ),
//                       child: const Text(
//                         "EXPLORE",
//                         style: TextStyle(color: Colors.blue),
//                       ),
//                       onPressed: () {},
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Container(height: 5),
//         ],
//       ),
//     );
//   }
// }

// Widget _resource_card(BuildContext context) {
//   return Card(
//     // Set the shape of the card using a rounded rectangle border with a 8 pixel radius
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(8),
//     ),
//     // Set the clip behavior of the card
//     clipBehavior: Clip.antiAliasWithSaveLayer,
//     // Define the child widgets of the card
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         // Display an image at the top of the card that fills the width of the card and has a height of 160 pixels
//         Image.asset(
//           'assets/random_image.webp',
//           height: 160,
//           width: double.infinity,
//           fit: BoxFit.cover,
//         ),
//         // Add a container with padding that contains the card's title, text, and buttons
//         Container(
//           padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               // Display the card's title using a font size of 24 and a dark grey color
//               Text(
//                 "Cards Title 2",
//                 style: TextStyle(
//                   fontSize: 24,
//                   color: Colors.grey[800],
//                 ),
//               ),
//               // Add a space between the title and the text
//               Container(height: 10),
//               // Display the card's text using a font size of 15 and a light grey color
//               Text(
//                 "Card Text",
//                 style: TextStyle(
//                   fontSize: 15,
//                   color: Colors.grey[700],
//                 ),
//               ),
//               // Add a row with two buttons spaced apart and aligned to the right side of the card
//               Row(
//                 children: <Widget>[
//                   // Add a spacer to push the buttons to the right side of the card
//                   const Spacer(),
//                   // Add a text button labeled "SHARE" with transparent foreground color and an accent color for the text
//                   TextButton(
//                     style: TextButton.styleFrom(
//                       foregroundColor: Colors.transparent,
//                     ),
//                     child: const Text(
//                       "SHARE",
//                       style: TextStyle(color: Colors.blue),
//                     ),
//                     onPressed: () {},
//                   ),
//                   // Add a text button labeled "EXPLORE" with transparent foreground color and an accent color for the text
//                   TextButton(
//                     style: TextButton.styleFrom(
//                       foregroundColor: Colors.transparent,
//                     ),
//                     child: const Text(
//                       "EXPLORE",
//                       style: TextStyle(color: Colors.blue),
//                     ),
//                     onPressed: () {},
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         // Add a small space between the card and the next widget
//         Container(height: 5),
//       ],
//     ),
//   );
// }
