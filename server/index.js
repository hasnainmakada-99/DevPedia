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
const mongoose = require("mongoose");
const app = express();

app.use(bodyParser.urlencoded({ extended: true }));

app.use(express.static("public"));

app.get("/", (req, res) => {
  res.sendFile(__dirname + "/public/login.html");
});

const port = process.env.PORT || 3000;

mongoose
  .connect(
    "mongodb+srv://hasnainmakada:hasnain123@cluster0.rgffboa.mongodb.net/?retryWrites=true&w=majority"
  )
  .then(() => {
    console.log("Connected to MongoDB");
  })
  .catch((err) => {
    console.error("Error connecting to MongoDB:", err);
  });
const resourceSchema = new mongoose.Schema({
  title: String,
  url: String,
  description: String,
  thumbnail: String,
  publishedDate: String,
  channelName: String,
  toolRelatedTo: String,
});

const Resources = mongoose.model("Resource", resourceSchema);

const userSchema = new mongoose.Schema({
  email: String,
  password: String,
});
const User = mongoose.model("User", userSchema);

app.post("/api/register", async (req, res) => {
  try {
    const email = req.body.email.trim().toLowerCase();
    const password = req.body.password.trim().toLowerCase();
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      
      res.send("<script>alert('User already registered.');</script>");
    } else {
      const user = new User({ email, password });
      await user.save();
      res.json({ message: "User registered successfully" });
      res.sendFile(__dirname + "/public/resource_fill.html");
    }
  } catch (error) {
    console.error(error);
    res.status(500).send("Error registering user.");
  }
});

app.post("/api/login", async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email, password });
    if (user) {
      res.sendFile(__dirname + "/public/resource_fill.html");
    } else {
      res.status(401).send("Invalid credentials.");
    }
  } catch (error) {
    console.error(error);
    res.status(500).send("Error logging in.");
  }
});

app.post("/api/post-resources", async (req, res) => {
  try {
    const formData = req.body;
    console.log(formData);
    
    const user = await User.findOne({ email: req.body.email });
    if (user) {
      await resource.save();
      res.json({ message: "Your Resource has been posted successfully" });
    } else {
      res.status(401).send("Unauthorized");
    }
  } catch (error) {
    console.error(error);
    res.status(500).send("Error saving resource.");
  }
});

app.get("/api/get-resources", async (req, res) => {
  try {
    const resources = await Resources.find(); // This method will retrieve all the reosurces from the mongodb database
    res.json(resources);
  } catch (error) {
    console.error(error);
    res.status(500).send("Error getting resources.");
  }
});

app.post('/api/logout', (req, res) => {
  
});


app.listen(port, (req, res) => {
  console.log(`Server Started at Port ${3000}`);
});
