import "package:flutter/material.dart";

Widget _resource_card(BuildContext context){
  return Card(
  // Set the shape of the card using a rounded rectangle border with a 8 pixel radius
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  ),
  // Set the clip behavior of the card
  clipBehavior: Clip.antiAliasWithSaveLayer,
  // Define the child widgets of the card
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      // Display an image at the top of the card that fills the width of the card and has a height of 160 pixels
      Image.asset(
        ImgSample.get('relaxing-man.png'),
        height: 160,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
      // Add a container with padding that contains the card's title, text, and buttons
      Container(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Display the card's title using a font size of 24 and a dark grey color
            Text(
              "Cards Title 2",
              style: TextStyle(
                fontSize: 24,
                color: Colors.grey[800],
              ),
            ),
            // Add a space between the title and the text
            Container(height: 10),
            // Display the card's text using a font size of 15 and a light grey color
            Text(
              MyStringsSample.card_text,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
              ),
            ),
            // Add a row with two buttons spaced apart and aligned to the right side of the card
            Row(
              children: <Widget>[
                // Add a spacer to push the buttons to the right side of the card
                const Spacer(),
                // Add a text button labeled "SHARE" with transparent foreground color and an accent color for the text
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.transparent,
                  ),
                  child: const Text(
                    "SHARE",
                    style: TextStyle(color: MyColorsSample.accent),
                  ),
                  onPressed: () {},
                ),
                // Add a text button labeled "EXPLORE" with transparent foreground color and an accent color for the text
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.transparent,
                  ),
                  child: const Text(
                    "EXPLORE",
                    style: TextStyle(color: MyColorsSample.accent),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
      // Add a small space between the card and the next widget
      Container(height: 5),
    ],
  ),
),
}