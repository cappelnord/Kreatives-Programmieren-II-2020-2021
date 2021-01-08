const express = require('express')
const app = express()
const http = require('http').Server(app);
const io = require('socket.io')(http);
 
io.on('connection', function(socket) {
  console.log('a user connected');

   socket.on('message', function(msg)  {
    console.log(msg);
  });
});

app.use(express.static('public'))
http.listen(13900);

console.log("Listening on: http://localhost:13900/");