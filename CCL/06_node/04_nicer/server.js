const express = require('express')
const app = express()
const http = require('http').Server(app);
const io = require('socket.io')(http);

// external IDs start with 1000
var currentID = 1000;

io.on('connection', function(socket) {
  console.log('a user connected ...');

  var socketIDs = {};

  socket.on('soundOn', function(msg)  {
    socketIDs[msg.id] = currentID;
    msg.id = currentID;

    // not handling overflow here .. but well :)
    currentID++;

    socket.broadcast.emit("soundOn", msg);
  });

  socket.on('soundMove', function(msg)  {
    var id = socketIDs[msg.id];
    if(id !== undefined) {
      msg.id = id;
      socket.broadcast.emit("soundMove", msg);
    }
  });

  socket.on('soundOff', function(msg)  {
    var id = socketIDs[msg.id];
    delete socketIDs[msg.id];
    
    if(id !== undefined) {
      socket.broadcast.emit("soundOff", {id: id});
    }
  });

  // remove all sounds from this user on disconnect
  socket.on('disconnect', function(msg) {
    for(id of Object.values(socketIDs)) {
      socket.broadcast.emit("soundOff", {id: id});
    }
    socketIDs = {};
  });

});

app.use(express.static('public'))
http.listen(13900);

console.log("Listening on: http://localhost:13900/");