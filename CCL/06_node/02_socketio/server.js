const osc = require('osc');
const express = require('express')

const app = express()
const http = require('http').Server(app);
const io = require('socket.io')(http);
 
function initExpress() {
  app.use(express.static('public'))
	http.listen(3000);
  console.log("Server gestartet!");
}
 
var udpPort = new osc.UDPPort({
    localAddress: "0.0.0.0",
    localPort: 57140,
    metadata: true
});

udpPort.open();

udpPort.on("message", function (oscMsg, timeTag, info) {

});

udpPort.on("ready", function () {
    initExpress();
});

io.on('connection', function(socket) {
  console.log('a user connected');

   socket.on('message', function(msg)  {
    console.log(msg);
  });
});