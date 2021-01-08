const express = require('express')
const app = express()
const http = require('http').Server(app);
const io = require('socket.io')(http);

var currentID = 0;
 
io.on('connection', function(socket) {
  console.log('a user connected');

  var myID;

  socket.on('soundOn', function(msg)  {
    currentID++;
    myID = currentID;
    msg.id = myID;
    io.emit("soundOn", msg);
  });

  socket.on('soundMove', function(msg)  {
    msg.id = myID;
    io.emit("soundMove", msg);
  });

  socket.on('soundOff', function(msg)  {
    io.emit("soundOff", {id: myID});
  });
});

app.use(express.static('public'))
http.listen(13900);

console.log("Listening on: http://localhost:13900/");