/** Fields which will be included inside the Youtube Resources API
 * Resource Title name
 * Resource URL
 * Resource Description
 * Resource Thumbnail link
 * Resource Published Date
 * Resource Channel Name
 * Of which tool this resource is related to
 */

const express = require("express");
const bodyParser = require("body-parser");

const app = express();

app.use(bodyParser.urlencoded({ extended: true }));

app.use(express.static("public"));

const port = process.env.PORT || 3000;

app.post("/api/post-resources", (req, res) => {
  const formData = req.body;
  console.log(formData);

  const apiData = {
    title: formData.title,
    url: formData.url,
    description: formData.description,
    thumbnail: formData.thumbnail,
    publishedDate: formData.publishedDate,
    channelName: formData.channelName,
    tool: formData.toolRelatedTo,
  };

  res.json(apiData);
});

app.listen(port, (req, res) => {
  console.log(`Server Started at Port ${3000}`);
});
