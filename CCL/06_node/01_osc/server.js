const osc = require('osc');
const express = require('express')

const app = express()
 
var message = "Hello World!";

function initExpress() {

	app.get('/pling', function (req, res) {
  		res.send(message);

  		udpPort.send({
        		address: "/pling",
        		args: [{type: "f", value: req.query.freq}]
    	}, "127.0.0.1", 57120);

	});

	app.listen(3000)
}
 
var udpPort = new osc.UDPPort({
    localAddress: "0.0.0.0",
    localPort: 57140,
    metadata: true
});

udpPort.open();

udpPort.on("message", function (oscMsg, timeTag, info) {
	if(oscMsg.address == '/message') {
		message = oscMsg.args[0].value;
	}
});

udpPort.on("ready", function () {
    initExpress();
});
