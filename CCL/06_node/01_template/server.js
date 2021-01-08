const osc = require('osc');
const express = require('express')

const app = express()
 

function initExpress() {
	app.get('/pling', function (req, res) {
  		res.send('Hello World');

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

/*
udpPort.on("message", function (oscMsg, timeTag, info) {
	console.log(oscMsg);
});
*/

udpPort.on("ready", function () {
	/*
    udpPort.send({
        address: "/node",
        args: [{type: "i", value: 1000}]
    }, "127.0.0.1", 57120);
    */
    initExpress();
});
 
// const n = new Client('127.0.0.1', 57120);
// n.send('/node', 123);