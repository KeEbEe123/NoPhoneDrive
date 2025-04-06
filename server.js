const express = require("express");
const mongoose = require("mongoose");

const app = express();
app.use(express.json());

mongoose.connect(
  "mongodb+srv://keertank:tomcatisbad123@cluster0.azk2l.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"
);

const UserSchema = new mongoose.Schema({
  name: String,
  email: String,
  photoUrl: String,
});

const User = mongoose.model("User", UserSchema);

app.post("/api/users", async (req, res) => {
  const { name, email, photoUrl } = req.body;
  await User.updateOne({ email }, { name, photoUrl }, { upsert: true });
  res.send("User saved");
});

const MissedCallSchema = new mongoose.Schema({
  name: String,
  number: String,
  timestamp: Number,
});

const MissedCall = mongoose.model("MissedCall", MissedCallSchema);

app.post("/api/missed-calls", async (req, res) => {
  const { name, number, timestamp } = req.body;
  await new MissedCall({ name, number, timestamp }).save();
  res.send("Missed call logged");
});

app.listen(3000, () => console.log("Server running"));
